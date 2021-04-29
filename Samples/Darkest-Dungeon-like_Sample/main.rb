require 'app/easing_functions.rb'

class DungeonHandler
    attr_accessor :inputs, :state, :outputs, :grid, :args

    def tick 
        # The defaults function intitializes the game.
        defaults        
        # After the game is initialized, render it.
        render
        # After rendering the player should be able to respond to input.
        input
        # After responding to input, the game performs any additional calculations.
        calc
    end 

    def defaults
        # hide the mouse cursor for this game, we are going to render our own cursor
        if state.tick_count == 0
            args.gtk.hide_cursor  
        end
        
        state.click_ripples ||= []
        state.sprite_size = 80

        state.inventory_border.w  = state.sprite_size * 8
        state.inventory_border.h  = state.sprite_size * 2
        state.inventory_border.x  = 600
        state.inventory_border.y  = 200 - state.inventory_border.h

        state.interact_border.x = 760
        state.interact_border.y = 350
        
        state.interact.accept.x = state.interact_border.x + 60
        state.interact.accept.y = state.interact_border.y - 20 

        state.interact.reject.x = state.interact_border.x + 200 
        state.interact.reject.y = state.interact_border.y - 20 

        state.interact.accept_reject_w_h = state.sprite_size - 20
        
        state.interact.start.x = 490 
        state.interact.start.y = 310
        state.interact.start.w = 225
        state.interact.start.h = 50
        
        #set interact borders rects for click detection
        state.interact.accept.rect ||= [state.interact.accept.x, state.interact.accept.y, state.interact.accept_reject_w_h, state.interact.accept_reject_w_h]
        state.interact.reject.rect ||= [state.interact.reject.x, state.interact.reject.y, state.interact.accept_reject_w_h, state.interact.accept_reject_w_h]
        state.interact.start.rect  ||= [state.interact.start.x,  state.interact.start.y,  state.interact.start.w,  state.interact.start.h]
        
        state.rejected ||= false
        state.accepted ||= false
        state.start    ||= false
        state.checked_interact_items ||= false 
        state.render_fire_interact ||= false 
        state.render_fire_interact_end ||= false

        state.click_time ||= 0
        state.interact_items_accepted ||= []
        state.held_item_last_loc ||= :inventory

        state.lastClicked ||= "None"

        # initialize items for the first time if they are nil
        if !state.items
        state.items = [
            {
            id: :torch, 
            quantity: 3,
            path: 'sprites/added/torch.png',
            location: :inventory,
            ordinal_x: 0, ordinal_y: 0
            },
            {
            id: :gold_coin,
            quantity: 10,
            path: 'sprites/added/gold_coin.png',
            location: :inventory,
            ordinal_x: 1, ordinal_y: 0
            },
        ]

        # after initializing the oridinal positions, derive the pixel
        # locations assuming that the width and height are 80
        state.items.each { |item| set_inventory_position item }
        end

        # define all the oridinal positions of the inventory slots
        if !state.inventory_area
            state.inventory_area = [
                { ordinal_x: 0,  ordinal_y: 0 },
                { ordinal_x: 1,  ordinal_y: 0 },
                { ordinal_x: 2,  ordinal_y: 0 },
                { ordinal_x: 3,  ordinal_y: 0 },
                { ordinal_x: 4,  ordinal_y: 0 },
                { ordinal_x: 5,  ordinal_y: 0 },
                { ordinal_x: 6,  ordinal_y: 0 },
                { ordinal_x: 7,  ordinal_y: 0 },
                { ordinal_x: 0,  ordinal_y: 1 },
                { ordinal_x: 1,  ordinal_y: 1 },
                { ordinal_x: 2,  ordinal_y: 1 },
                { ordinal_x: 3,  ordinal_y: 1 },
                { ordinal_x: 4,  ordinal_y: 1 },
                { ordinal_x: 5,  ordinal_y: 1 },
                { ordinal_x: 6,  ordinal_y: 1 },
                { ordinal_x: 7,  ordinal_y: 1 },
            ]

            # after initializing the oridinal positions, derive the pixel
            # locations assuming that the width and height are 80
            state.inventory_area.each { |i| set_inventory_position i }
        end

        # define all the oridinal positions of the interact slots
        if !state.interact_area
            state.interact_area = [
                { ordinal_x: 0, ordinal_y: 0 },
            ]

            # after initializing the oridinal positions, derive the pixel
            # locations assuming that the width and height are 80
            state.interact_area.each { |c| set_interact_position c }
        end
    end


    def render  
        #render the background
        render_background

        #render characters
        state.jester.name = "jester"
        state.skeleton.name = "skeleton"
        renderCharAnim state.jester, 4, 150
        renderCharAnim state.skeleton, 4, 1100

        # The .map function on Array is used instead of any kind of looping.
        # .map returns a new object for every object within an Array.
        outputs.primitives << state.inventory_area.map do |a|
            { x: a.x, y: a.y, w: a.w, h: a.h, path: 'sprites/square/white.png' }
        end

        alpha_transition ||= 255
        #transition the alpha of the interact UI in
        if state.start && !state.rejected && !state.accepted
            renderInteract easeIt(state, 0, 255, state.click_time+10)
        #transition the alpha of the interact UI out
        elsif state.rejected || state.accepted
            alpha_transition = easeIt(state, 255, 0, state.click_time)
            renderInteract alpha_transition

            #check if alpha has hit 0 for all items and if interact items were handled yet
            if alpha_transition == 0 && !state.checked_interact_items
                #handle items in interact area
                state.items.find_all {|item| item[:location] == :interact }.map do |item|
                    #item[:location] = :inventory                   
                    state.interact_items_accepted.push(item)     
                    handle_interact_items   
                end
                #remove all items from the interact area
                state.items.reject! { |i| i[:location] == :interact }
                state.checked_interact_items = true
            elsif alpha_transition == 0
                #remove all items from the interact area
                state.items.reject! { |i| i[:location] == :interact }
            end
        end

        #transition the alpha of the interact button in
        if !state.start
            renderInteractButton easeIt(state, 0, 255, state.click_time)
        #transition the alpha of the interact button out
        else 
            renderInteractButton easeIt(state, 255, 0, state.click_time)
        end 

        #transition the alpha of the fire interact UI in
        flame_size = 160
        flame_x = 1060 
        flame_y = 200
        if state.render_fire_interact
            outputs.sprites << [flame_x, flame_y, flame_size, flame_size, 'sprites/added/Flame.png', 0, easeIt(state, 0, 255, state.click_time+10)]
        #transition the alpha of the fire interact UI out
        elsif state.render_fire_interact_end
            outputs.sprites << [flame_x, flame_y, flame_size, flame_size, 'sprites/added/Flame.png', 0, easeIt(state, 255, 0, state.click_time)]
        end

        # after the borders have been rendered, render the
        # items within those slots (and allow for highlighting)
        # if an item isn't currently being held
        allow_inventory_highlighting = !state.held_item

        # go through each item and render them
        # use Array's find_all method to remove any items that are currently being held
        state.items.find_all { |item| item[:location] != :held }.map do |item|
            # if an item is currently being held, don't render it in it's spot within the
            # inventory or interact area (this is handled via the find_all method).

            # the item_prefab returns a hash containing all the visual components of an item.
            # the main sprite, the black background, the quantity text, and a hover indication
            # if the mouse is currently hovering over the item.
            if item[:location] == :interact
                if state.rejected == true
                    allow_inventory_highlighting = !item
                    outputs.primitives << item_prefab(item, allow_inventory_highlighting, inputs.mouse, alpha_transition)
                    allow_inventory_highlighting = !state.held_item
                else 
                    outputs.primitives << item_prefab(item, allow_inventory_highlighting, inputs.mouse, alpha_transition)
                end 
            else 
                outputs.primitives << item_prefab(item, allow_inventory_highlighting, inputs.mouse, 255)
            end
        end

        # The last thing we want to render is the item currently being held.
        outputs.primitives << item_prefab(state.held_item, allow_inventory_highlighting, inputs.mouse, 255)

        outputs.primitives << state.click_ripples

        # render a mouse cursor since we have the OS cursor hidden
        outputs.primitives << { x: inputs.mouse.x - 5, y: inputs.mouse.y - 5, w: 10, h: 10, path: 'sprites/circle/orange.png', a: 128 }
    end


    #render protag
    def renderCharAnim character, frameMax, x_pos, y_pos=250, width=80, height=160
        character.charAnimframe ||= 0 
        outputs.sprites << [x_pos, y_pos, width, height, "sprites/added/#{character.name}000#{character.charAnimframe}.png"]
        if state.tick_count % 30 == 0
            character.charAnimframe += 1
            if character.charAnimframe >= frameMax
                character.charAnimframe = 0
            end 
        end 
    end 


    #handle rendering of interact UI
    def renderInteract alpha
        outputs.sprites << [state.interact_border.x-30, state.interact_border.y-50, 380, 330, "sprites/added/Interact_UI.png", 0, alpha]

        # for each interact spot, create a sprite
        outputs.primitives << state.interact_area.map do |a|
            { x: a.x, y: a.y, w: a.w, h: a.h, path: 'sprites/square/white.png', a: alpha }
        end

        #draw interact buttons here:
        outputs.sprites << [state.interact.accept.x, state.interact.accept.y, state.interact.accept_reject_w_h, state.interact.accept_reject_w_h, 'sprites/added/green_check.png', 0, alpha]
        outputs.sprites << [state.interact.reject.x, state.interact.reject.y, state.interact.accept_reject_w_h, state.interact.accept_reject_w_h, 'sprites/added/red_x.png', 0, alpha]
    end


    #render the Interact button
    def renderInteractButton alpha
        outputs.sprites << [state.interact.start.x, state.interact.start.y, state.interact.start.w, state.interact.start.h, 'sprites/square/green.png', 0, alpha]
        outputs.labels  << [state.interact.start.x+20, state.interact.start.y+38, "Start Interaction", 1, 0, 0, 0, 0, alpha]
    end 


    #handle scrolling the background 
    def scrolling_background at, path, rate, y = 0 
        [
            [0    - at.*(rate) % 1280, y, 1280, 720, path], 
            [1280 - at.*(rate) % 1280, y, 1280, 720, path] 
        ]
    end


    #render the background with parallax
    def render_background
        outputs.sprites << [0, 0, 1280, 720, 'sprites/added/background03.png']

        #scroll_point_at = state.tick_count
        scroll_point_at ||= 0
        scroll_point_at = 1280 * (easeSpline state, outputs, 30)

        outputs.sprites << scrolling_background(scroll_point_at, 'sprites/added/parallax_back03.png', 0.30)
        outputs.sprites << scrolling_background(scroll_point_at, 'sprites/added/parallax_mid03.png', 0.50)
    end


    #swap items from different locations
    def swap_items item_already_there
        #swap the positions of the items
        temp_loc  = item_already_there[:location]
        temp_ordX = item_already_there[:ordinal_x]
        temp_ordY = item_already_there[:ordinal_y]

        item_already_there[:location]  = state.held_item_last_loc
        item_already_there[:ordinal_x] = state.held_item[:ordinal_x]
        item_already_there[:ordinal_y] = state.held_item[:ordinal_y]

        state.held_item[:location]  = temp_loc
        state.held_item[:ordinal_x] = temp_ordX
        state.held_item[:ordinal_y] = temp_ordY

        # remove the item being held from the items collection (since it's quantity is now 0)
        state.items.reject! { |i| i[:location] == :held }

        # nil out the held_item so a new item can be picked up
        state.held_item = nil
    end 


    #move one item from held count to new location
    def move_one_item item_already_there
        if state.held_item[:quantity] > 1
            item_already_there[:quantity] += 1
            state.held_item[:quantity] -= 1
        else  
            item_already_there[:quantity] += 1
            state.held_item[:quantity] -= 1
            # remove the item being held from the items collection (since it's quantity is now 0)
            state.items.reject! { |i| i[:location] == :held }
            state.held_item = nil
        end
    end 


    #move all items from held to new location area
    def move_all_items new_location, new_area
        #set the location of the held item to the oridinal position of the interact area, 
        #and then nil out the held item state so that a new item can be picked up
        state.held_item[:location] = new_location
        state.held_item[:ordinal_x] = new_area[:ordinal_x]
        state.held_item[:ordinal_y] = new_area[:ordinal_y]

        # remove the item being held from the items collection (since it's quantity is now 0)
        state.items.reject! { |i| i[:location] == :held }
        state.held_item = nil    
    end 


    #move first item from held to new location area 
    def move_first_item new_location, new_area
        new_item = state.held_item.merge(quantity: 1,
            location: new_location,
            ordinal_x: new_area[:ordinal_x],
            ordinal_y: new_area[:ordinal_y])

        #after the item is crated, place it into the state.items collection
        state.items << new_item

        #then subtract one from the held item
        state.held_item[:quantity] -= 1
    end 


    #merge all from held to item stack 
    def merge_items item_already_there
        # then merge the item quantities
        item_already_there[:quantity] += state.held_item[:quantity]
                    
        # remove the item being held from the items collection (since it's quantity is now 0)
        state.items.reject! { |i| i[:location] == :held }

        # nil out the held_item so a new item can be picked up
        state.held_item = nil
    end 


    #handles clicking and moving items within diffent item areas
    def item_area_handler location, area, item_already_there
        if inputs.mouse.button_left
            # if there currently isn't an item there, then put the held item in the slot
            if !item_already_there
                move_all_items location, area  #move all items
            #if an item is there of a different type
            elsif item_already_there[:id] != state.held_item[:id]
                swap_items item_already_there  #swap item locations
            # if there is already an item there, and the item types/id match
            else
                merge_items item_already_there #merge them 
            end     
        elsif inputs.mouse.button_right    
            #if there is not item there and there's more than one left              
            #only drop one count of the item at a time
            if !item_already_there && state.held_item[:quantity] > 1 
                move_first_item location, area #move the first item    
            #if the item clicked is the same id as held        
            elsif item_already_there && state.held_item[:id] == item_already_there[:id]                     
                move_one_item item_already_there #move one item count at a time
            #if there is not item there and there is only one count left of the held item
            elsif !item_already_there
                move_all_items location, area #move all the items
            end   
        end
    end 


    #handle inputs 
    def input  
        if inputs.mouse.click
            #if a click occurred add a ripple to the ripple queue
            state.click_ripples << { x: inputs.mouse.x - 5, y: inputs.mouse.y - 5, w: 10, h: 10, path: 'sprites/circle/gray.png', a: 128 }

            #if left mouse button clicked and no item is currently held
            if !state.held_item && inputs.mouse.button_left
                checkAccept = inputs.mouse.click.point.inside_rect?(state.interact.accept.rect)
                checkReject = inputs.mouse.click.point.inside_rect?(state.interact.reject.rect)
                checkStart  = inputs.mouse.click.point.inside_rect?(state.interact.start.rect)

                #check if accept, reject, or start is clicked
                if state.start && checkAccept
                    #handle accept
                    state.accepted = true
                    state.checked_interact_items = false
                    state.start = false
                    state.lastClicked = "accepted"
                    state.render_fire_interact_end = false
                    state.click_time = state.tick_count
                elsif state.start && checkReject
                    #handle reject
                    state.rejected = true
                    state.start = false
                    state.lastClicked = "rejected"
                    state.render_fire_interact_end = false
                    state.click_time = state.tick_count

                    #Add trauma and make sure not greater than 1
                    acceptTrauma = 0.3
                    state.trauma = (state.trauma+acceptTrauma) < 1 ? state.trauma+acceptTrauma : 1
                elsif checkStart
                    #handle start
                    state.start = true
                    state.rejected = false
                    state.accepted = false
                    if state.render_fire_interact
                        state.render_fire_interact = false
                        state.render_fire_interact_end = true
                    end             
                    state.click_time = state.tick_count
                else 
                    # see if any of the items intersect the pointer using the inside_rect? method
                    # the find method will either return the first object that returns true
                    # for the match clause, or it'll return nil if nothing matches the match clause
                    found = state.items.find do |item|
                        # for each item in state.items, run the following boolean check
                        inputs.mouse.click.point.inside_rect?(item)
                    end

                    # if an item intersects the mouse pointer, then set the item's location to :held and
                    # set state.held_item to the item for later reference
                    if found
                        state.held_item = found
                        state.held_item_last_loc = found[:location]
                        found[:location] = :held
                    end
                end

            # if the mouse is clicked and an item is currently being held
            elsif state.held_item
                # determine if a slot within the interact or inventory area was clicked
                interact_area = state.interact_area.find { |a| inputs.mouse.click.point.inside_rect? a }
                inventory_area = state.inventory_area.find { |a| inputs.mouse.click.point.inside_rect? a }

                # if the click was within a interact area
                if interact_area && !state.rejected
                    # check to see if an item is already there and ignore the click if an item is found
                    # item_at_interact_slot is a helper method that returns an item or nil for a given oridinal position
                    item_already_there = item_at_interact_slot interact_area[:ordinal_x], interact_area[:ordinal_y]
                    #Call item area handler to handle logic for moving items
                    item_area_handler :interact, interact_area, item_already_there   

                # if the selected area is an inventory area (as opposed to within the interact area)
                elsif inventory_area
                    # check to see if there is already an item in that inventory slot
                    # the item_at_inventory_slot helper method returns an item or nil
                    item_already_there = item_at_inventory_slot inventory_area[:ordinal_x], inventory_area[:ordinal_y]
                    #Call item area handler to handle logic for moving items
                    item_area_handler :inventory, inventory_area, item_already_there    
                end
            end
        end 
    end


    # the calc method is executed after input
    def calc
        # make sure that the real position of the inventory
        # items are updated every frame to ensure that they
        # are placed correctly given their location and oridinal positions
        # instead of using .map, here we use .each (since we are not returning a new item and just updating the items in place)
        state.items.each do |item|
            # based on the location of the item, invoke the correct pixel conversion method
            if item[:location] == :inventory
                set_inventory_position item
            elsif item[:location] == :interact
                set_interact_position item
            elsif item[:location] == :held
                # if the item is held, center the item around the mouse pointer
                state.held_item.x = inputs.mouse.x - state.held_item.w.half
                state.held_item.y = inputs.mouse.y - state.held_item.h.half
            end
        end

        # for each hash/sprite in the click ripples queue,
        # expand its size by 20 percent and decrease its alpha
        # by 10.
        state.click_ripples.each do |ripple|
            delta_w = ripple.w * 1.2 - ripple.w
            delta_h = ripple.h * 1.2 - ripple.h
            ripple.x -= delta_w.half
            ripple.y -= delta_h.half
            ripple.w += delta_w
            ripple.h += delta_h
            ripple.a -= 10
        end

        # remove any items from the collection where the alpha value is less than equal to
        # zero using the reject! method (reject with an exclamation point at the end changes the
        # array value in place, while reject without the exclamation point returns a new array).
        state.click_ripples.reject! { |ripple| ripple.a <= 0 }
    end


    # helper function for finding an item at a interact slot
    def item_at_interact_slot ordinal_x, ordinal_y
        state.items.find { |i| i[:location] == :interact && i[:ordinal_x] == ordinal_x && i[:ordinal_y] == ordinal_y }
    end


    # helper function for finding an item at an inventory slot
    def item_at_inventory_slot ordinal_x, ordinal_y
        state.items.find { |i| i[:location] == :inventory && i[:ordinal_x] == ordinal_x && i[:ordinal_y] == ordinal_y }
    end


    # helper function that creates a visual representation of an item
    def item_prefab item, should_highlight, mouse, alpha
        return nil unless item

        overlay = nil

        x = item.x
        y = item.y
        w = item.w
        h = item.h

        if should_highlight && mouse.point.inside_rect?(item)
            overlay = { x: x, y: y, w: w, h: h, path: "sprites/square/blue.png", a: 130, }
        end

        [
            # sprites are hashes with a path property, this is the main sprite
            { x: x,      y: y, w: state.sprite_size, h: state.sprite_size, path: item[:path], a: alpha},

            # this represents the black area in the bottom right corner of the main sprite so that the
            # quantity is visible
            { x: x + 55, y: y, w: 25, h: 25, path: "sprites/square/black.png", a: alpha}, # sprites are hashes with a path property

            # labels are hashes with a text property
            { x: x + 56, y: y + 22, text: "#{item[:quantity]}", r: 255, g: 255, b: 255, a: alpha},

            # this is the mouse overlay, if the overlay isn't applicable, then this value will be nil (nil values will not be rendered)
            overlay
        ]
    end


    # helper function for deriving the position of an item within inventory
    def set_inventory_position item
        item.x = state.inventory_border.x + item[:ordinal_x] * state.sprite_size
        item.y = (state.inventory_border.y + state.inventory_border.h - state.sprite_size) - item[:ordinal_y] * state.sprite_size
        item.w = state.sprite_size
        item.h = state.sprite_size
    end


    # helper function for deriving the position of an item within the interact area
    def set_interact_position item
        item.x = state.interact_border.x+120 + item[:ordinal_x] * state.sprite_size
        item.y = (state.interact_border.y + state.inventory_border.h - state.sprite_size) - item[:ordinal_y] * state.sprite_size
        item.w = state.sprite_size
        item.h = state.sprite_size
    end
        

    #handle item interactions for interaction UI
    def handle_interact_items
        state.interact_items_accepted.each do |item|
            #if there is at least one torch found
            if item[:id] == :torch 
                #set render fire to true 
                state.render_fire_interact = true
                #remove torch from interact 
                state.interact_items_accepted.reject! { |i| i[:id] == :torch }
            elsif item[:id] == :gold_coin
                #Do something here -->
                #remove gold coin from interact 
                state.interact_items_accepted.reject! { |i| i[:id] == :gold_coin }
            end 
        end 
    end 
end 

$dungeon_handler = DungeonHandler.new

def render_and_zoom dungeon, state, outputs, x_shift, y_shift, w_shift, h_shift, click_time, zoom_duration 
    state.firstStart ||= false

=begin 
    #Camera Shake: 
    For 2D --> Translational is best but added rotational is better 
    Truama --> 0 to 1 --> add per action and always reduce over time 
    Shake --> 0 to 1 --> square or cube of truama
    #Use Perlin Noise instead of Random Float add 1 to seed, and give time
    angle   = maxAngle  * shake * GetRandomFloatNegOneToOne(); 
    offsetX = maxOffset * shake * GetRandomFloatNegOneToOne();
    offsetY = maxOffset * shake * GetRandomFloatNegOneToOne();

    #shaky camera is a seperate camera to keep main camera clean 
    shakyCamera.angle = camera.angle + angle;
    shakyCamera.center = camera.center + Vec2(offsetX, offsetY);
=end

    #Truama --> 0 to 1 --> add per action and always reduce over time 
    state.trauma ||= 0
    if state.trauma > 0
        state.trauma -= 0.001
    end 
    #Shake --> 0 to 1 --> square or cube of truama
    state.shake = state.trauma ** 2

    #max angle and offset for camera shake 
    state.maxAngle  = 10
    state.maxOffset = 80
    state.cameraShakeDuration = 0.5

    #Set angle, and x and y offsets using a max, the shake, and a random float from -1 to 1
    state.angle   = state.maxAngle  * state.shake * ((rand() * 2)-1)
    state.offsetX = state.maxOffset * state.shake * ((rand() * 2)-1)
    state.offsetY = state.maxOffset * state.shake * ((rand() * 2)-1)

    #set defaults for camera angle and center 
    state.camera.angle  ||= 0
    state.camera.center ||= [1280/2, 720/2]

    #shaky camera is a seperate camera to keep main camera clean 
    state.shakyCamera.angle  = state.camera.angle  + state.angle
    state.shakeCamera.center = state.camera.center + [state.offsetX, state.offsetY] 


    #if interact UI accept button clicked then zoom in
    if state.accepted 
        outputs.sprites << [easeIt(state, 0,    x_shift,    click_time, zoom_duration), 
                            easeIt(state, 0,    y_shift,    click_time, zoom_duration), 
                            easeIt(state, 1280, w_shift,    click_time, zoom_duration), 
                            easeIt(state, 720,  h_shift,    click_time, zoom_duration), 
                            dungeon] #zoom in
        state.firstStart = true

    elsif state.rejected
        outputs.sprites << [easeIt(state, 0,    state.offsetX,    click_time, state.cameraShakeDuration), 
                            easeIt(state, 0,    state.offsetY,    click_time, state.cameraShakeDuration), 
                            1280,
                            720,  
                            dungeon,
                            state.shakyCamera.angle] #camera shake
        state.firstStart = true

    elsif state.start && state.firstStart && state.lastClicked == "accepted"
        outputs.sprites << [easeIt(state, x_shift, 0,    click_time, zoom_duration), 
                            easeIt(state, y_shift, 0,    click_time, zoom_duration), 
                            easeIt(state, w_shift, 1280, click_time, zoom_duration), 
                            easeIt(state, h_shift, 720,  click_time, zoom_duration), 
                            dungeon] #zoom out
    
    elsif state.start && state.firstStart && state.lastClicked == "rejected"
        outputs.sprites << [easeIt(state, state.offsetX, 0,    click_time, state.cameraShakeDuration), 
                            easeIt(state, state.offsetY, 0,    click_time, state.cameraShakeDuration), 
                            1280, 
                            720, 
                            dungeon,
                            state.shakyCamera.angle] #camera shake
    else 
        outputs.sprites << [0, 0, 1280, 720, dungeon] #normal render 
    end
end 

#main runner
def tick args
    $dungeon_handler.inputs   = args.inputs
    $dungeon_handler.state    = args.state
    $dungeon_handler.grid     = args.grid
    $dungeon_handler.args     = args
    $dungeon_handler.outputs  = args.render_target(:dungeon)
    $dungeon_handler.tick

    args.outputs.solids  << [-100, -100, 1380, 820, 0, 0, 0]
    render_and_zoom :dungeon, args.state, args.outputs, -800, -300, 2120, 1193, args.state.click_time, 0.5
end