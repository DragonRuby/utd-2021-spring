def defaults args
    # hide the mouse cursor for this game, we are going to render our own cursor
    if args.state.tick_count == 0
        #args.gtk.hide_cursor   #TURN BACK ON!!!!!!!!!!!!!!!!!
    end

    args.state.click_ripples ||= []

    # define the borders for where the inventory is located
    # args.state is a data structure that accepts any arbitrary parameters
    # so you can create an object graph without having to create any classes.

    # Bottom left is 0, 0. Top right is 1280, 720.
    # The inventory area is at the top of the screen
    # the number 80 is the size of all the sprites, so that is what is being
    # used to decide the with and height
    args.state.sprite_size = 80

    args.state.inventory_border.w  = args.state.sprite_size * 8
    args.state.inventory_border.h  = args.state.sprite_size * 2
    args.state.inventory_border.x  = 600
    args.state.inventory_border.y  = 200 - args.state.inventory_border.h

    # define the borders for where the interacting area is located
    # the interacting area is below the inventory area
    # the number 80 is the size of all the sprites, so that is what is being
    # used to decide the with and height
    args.state.interact_border.x =  760
    args.state.interact_border.y = 350
    args.state.interact_border.w = args.state.sprite_size * 4
    args.state.interact_border.h = args.state.sprite_size * 1
    
    args.state.interact.accept.x = args.state.interact_border.x + 60
    args.state.interact.accept.y = args.state.interact_border.y - 20 
    args.state.interact.accept.w = args.state.sprite_size - 20
    args.state.interact.accept.h = args.state.sprite_size - 20

    args.state.interact.reject.x = args.state.interact_border.x + 200 
    args.state.interact.reject.y = args.state.interact_border.y - 20 
    args.state.interact.reject.w = args.state.sprite_size - 20
    args.state.interact.reject.h = args.state.sprite_size - 20

    args.state.interact.start.x = 440
    args.state.interact.start.y = 310
    args.state.interact.start.w = 225
    args.state.interact.start.h = 50

    #set interact borders rects for click detection
    args.state.interact.accept.rect ||= [args.state.interact.accept.x, args.state.interact.accept.y, args.state.interact.accept.w, args.state.interact.accept.h]
    args.state.interact.reject.rect ||= [args.state.interact.reject.x, args.state.interact.reject.y, args.state.interact.reject.w, args.state.interact.reject.h]
    args.state.interact.start.rect  ||= [args.state.interact.start.x,  args.state.interact.start.y,  args.state.interact.start.w,  args.state.interact.start.h]

    args.state.rejected ||= false
    args.state.accepted ||= false
    args.state.start    ||= false
    args.state.checked_interact_items ||= false 
    args.state.render_fire_interact ||= false 
    args.state.render_fire_interact_end ||= false

    args.state.click_time ||= 0
    args.state.interact_items_accepted ||= []

    # initialize items for the first time if they are nil
    # Ruby has built in syntax for dictionaries (they look a lot like json objects).
    # Ruby also has a special type called a Symbol denoted with a : followed by a word.
    # Symbols are nice because they remove the need for magic strings.
    if !args.state.items
    args.state.items = [
        {
        id: :torch, # :orange is a Symbol, this is better than using "orange" for the id
        quantity: 3,
        path: 'sprites/added/torch.png',
        location: :inventory,
        ordinal_x: 0, ordinal_y: 0
        },
        {
        id: :indigo,
        quantity: 3,
        path: 'sprites/square/indigo.png',
        location: :inventory,
        ordinal_x: 1, ordinal_y: 0
        },
        {
        id: :yellow,
        quantity: 3,
        path: 'sprites/square/yellow.png',
        location: :inventory,
        ordinal_x: 2, ordinal_y: 0
        },
    ]

    # after initializing the oridinal positions, derive the pixel
    # locations assuming that the width and height are 80
    args.state.items.each { |item| set_inventory_position args, item }
    end

    # define all the oridinal positions of the inventory slots
    if !args.state.inventory_area
        args.state.inventory_area = [
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
        args.state.inventory_area.each { |i| set_inventory_position args, i }
    end

    # define all the oridinal positions of the interact slots
    if !args.state.interact_area
        args.state.interact_area = [
            { ordinal_x: 0, ordinal_y: 0 },
            { ordinal_x: 1, ordinal_y: 0 },
            { ordinal_x: 2, ordinal_y: 0 },
            { ordinal_x: 3, ordinal_y: 0 },
        ]

        # after initializing the oridinal positions, derive the pixel
        # locations assuming that the width and height are 80
        args.state.interact_area.each { |c| set_interact_position args, c }
    end
end


def render args  
    # for each inventory spot, create a sprite
    # args.outputs.primitives is how DragonRuby performs a render.
    # Adding a single hash or multiple hashes to this array will tell
    # DragonRuby to render those primitives on that frame.

    # The .map function on Array is used instead of any kind of looping.
    # .map returns a new object for every object within an Array.
    args.outputs.primitives << args.state.inventory_area.map do |a|
        { x: a.x, y: a.y, w: a.w, h: a.h, path: 'sprites/square/white.png' }
    end

    alpha_transition ||= 255
    #transition the alpha of the interact UI in
    if args.state.start && !args.state.rejected && !args.state.accepted
        renderInteract args, easeIt(args, 0, 255, args.state.click_time+10)
    #transition the alpha of the interact UI out
    elsif args.state.rejected || args.state.accept
        alpha_transition = easeIt(args, 255, 0, args.state.click_time)
        renderInteract args, alpha_transition

        #check if alpha has hit 0 for all items and if interact items were handled yet
        if(alpha_transition == 0 && !args.state.checked_interact_items)
            #handle items in interact area
            args.state.items.find_all {|item| item[:location] == :interact }.map do |item|
                #item[:location] = :inventory                   
                args.state.interact_items_accepted.push(item)     
                handle_interact_items args   
            end
            #remove all items from the interact area
            args.state.items.reject! { |i| i[:location] == :interact }
            args.state.checked_interact_items = true
        end
    end

    #transition the alpha of the interact button in
    if !args.state.start
        renderInteractButton args, easeIt(args, 0, 255, args.state.click_time)
    #transition the alpha of the interact button out
    else 
        renderInteractButton args, easeIt(args, 255, 0, args.state.click_time)
    end 

    #transition the alpha of the fire interact UI in
    if args.state.render_fire_interact
        args.outputs.sprites << [args.state.interact_border.x-30, args.state.interact_border.y-50, 380, 330, 'sprites/added/Fire_Interact_Screen.png', 0, easeIt(args, 0, 255, args.state.click_time+10)]
    #transition the alpha of the fire interact UI out
    elsif args.state.render_fire_interact_end
        args.outputs.sprites << [args.state.interact_border.x-30, args.state.interact_border.y-50, 380, 330, 'sprites/added/Fire_Interact_Screen.png', 0, easeIt(args, 255, 0, args.state.click_time)]
    end

    # after the borders have been rendered, render the
    # items within those slots (and allow for highlighting)
    # if an item isn't currently being held
    allow_inventory_highlighting = !args.state.held_item

    # go through each item and render them
    # use Array's find_all method to remove any items that are currently being held
    args.state.items.find_all { |item| item[:location] != :held }.map do |item|
        # if an item is currently being held, don't render it in it's spot within the
        # inventory or interact area (this is handled via the find_all method).

        # the item_prefab returns a hash containing all the visual components of an item.
        # the main sprite, the black background, the quantity text, and a hover indication
        # if the mouse is currently hovering over the item.
        if item[:location] == :interact
            if args.state.rejected == true
                allow_inventory_highlighting = !item
                args.outputs.primitives << item_prefab(args, item, allow_inventory_highlighting, args.inputs.mouse, alpha_transition)
                allow_inventory_highlighting = !args.state.held_item
            else 
                args.outputs.primitives << item_prefab(args, item, allow_inventory_highlighting, args.inputs.mouse, alpha_transition)
            end 
        else 
            args.outputs.primitives << item_prefab(args, item, allow_inventory_highlighting, args.inputs.mouse, 255)
        end
    end

    # The last thing we want to render is the item currently being held.
    args.outputs.primitives << item_prefab(args, args.state.held_item, allow_inventory_highlighting, args.inputs.mouse, 255)

    args.outputs.primitives << args.state.click_ripples

    # render a mouse cursor since we have the OS cursor hidden
    args.outputs.primitives << { x: args.inputs.mouse.x - 5, y: args.inputs.mouse.y - 5, w: 10, h: 10, path: 'sprites/circle/gray.png', a: 128 }
end


#handle rendering of interact UI
def renderInteract args, alpha
    args.outputs.solids << [args.state.interact_border.x-30, args.state.interact_border.y-50, 380, 330, 150, 150, 150, alpha]

    #[ X ,  Y,    TEXT,   SIZE, ALIGN, RED, GREEN, BLUE, ALPHA, FONT STYLE]
    args.outputs.labels << [args.state.interact_border.x+160, args.state.interact_border.y+240, "Interaction", 3, 1, 0, 0, 0, alpha]

    # for each interact spot, create a sprite
    args.outputs.primitives << args.state.interact_area.map do |a|
        { x: a.x, y: a.y, w: a.w, h: a.h, path: 'sprites/square/white.png', a: alpha }
    end

    #draw interact buttons here:
    args.outputs.sprites << [args.state.interact.accept.x, args.state.interact.accept.y, args.state.interact.accept.w, args.state.interact.accept.h, 'sprites/added/green_check.png', 0, alpha]
    args.outputs.sprites << [args.state.interact.reject.x, args.state.interact.reject.y, args.state.interact.reject.w, args.state.interact.reject.h, 'sprites/added/red_x.png', 0, alpha]
end


#render the Interact button
def renderInteractButton args, alpha
    args.outputs.sprites << [args.state.interact.start.x, args.state.interact.start.y, args.state.interact.start.w, args.state.interact.start.h, 'sprites/square/green.png', 0, alpha]
    args.outputs.labels  << [460, 350, "Start Interaction", 1, 0, 0, 0, 0, alpha]
end 


def input args
    # if the mouse is clicked and not item is currently being held
    # args.state.held_item is nil when the game starts.
    # If the player clicks, the property args.inputs.mouse.click will
    # be a non nil value, we don't want to process any of the code here
    # if the mouse hasn't been clicked
    return if !args.inputs.mouse.click

    # if a click occurred, add a ripple to the ripple queue
    args.state.click_ripples << { x: args.inputs.mouse.x - 5, y: args.inputs.mouse.y - 5, w: 10, h: 10, path: 'sprites/circle/gray.png', a: 128 }

    # if the mouse has been clicked, and no item is currently held...
    if !args.state.held_item
        checkAccept = args.inputs.mouse.click.point.inside_rect?(args.state.interact.accept.rect)
        checkReject = args.inputs.mouse.click.point.inside_rect?(args.state.interact.reject.rect)
        checkStart  = args.inputs.mouse.click.point.inside_rect?(args.state.interact.start.rect)

        #Check if accept, reject, or start is clicked
        if args.state.start && checkAccept
            #handle accept
            puts "Accept"
            args.state.accept = true
            args.state.start = false
            args.state.checked_interact_items = false
            args.state.render_fire_interact_end = false
            args.state.click_time = args.state.tick_count
        elsif args.state.start && checkReject
            #handle reject
            puts "Reject"
            args.state.rejected = true
            args.state.start = false
            args.state.render_fire_interact_end = false
            args.state.click_time = args.state.tick_count
        elsif checkStart
            #handle start
            puts "Start"
            args.state.start = true
            args.state.rejected = false
            if args.state.render_fire_interact
                args.state.render_fire_interact = false
                args.state.render_fire_interact_end = true
            end             
            args.state.click_time = args.state.tick_count
        else 
            # see if any of the items intersect the pointer using the inside_rect? method
            # the find method will either return the first object that returns true
            # for the match clause, or it'll return nil if nothing matches the match clause
            found = args.state.items.find do |item|
                # for each item in args.state.items, run the following boolean check
                args.inputs.mouse.click.point.inside_rect?(item)
            end

            # if an item intersects the mouse pointer, then set the item's location to :held and
            # set args.state.held_item to the item for later reference
            if found
                args.state.held_item = found
                found[:location] = :held
            end
        end

    # if the mouse is clicked and an item is currently beign held....
    elsif args.state.held_item
        # determine if a slot within the interact area was clicked
        interact_area = args.state.interact_area.find { |a| args.inputs.mouse.click.point.inside_rect? a }

        # also determine if a slot within the inventory area was clicked
        inventory_area = args.state.inventory_area.find { |a| args.inputs.mouse.click.point.inside_rect? a }

        # if the click was within a interact area
        if interact_area && args.state.rejected == false
            # check to see if an item is already there and ignore the click if an item is found
            # item_at_interact_slot is a helper method that returns an item or nil for a given oridinal position
            item_already_there = item_at_interact_slot args, interact_area[:ordinal_x], interact_area[:ordinal_y]

            # if an item *doesn't* exist in the interact area
            if !item_already_there
                # if the quantity they are currently holding is greater than 1
                if args.state.held_item[:quantity] > 1
                    # remove one item (creating a seperate item of the same type), and place it
                    # at the oridinal position and location of the interact area
                    # the .merge method on Hash creates a new Hash, but updates any values
                    # passed as arguments to merge
                    new_item = args.state.held_item.merge(quantity: 1,
                                                        location: :interact,
                                                        ordinal_x: interact_area[:ordinal_x],
                                                        ordinal_y: interact_area[:ordinal_y])

                    # after the item is crated, place it into the args.state.items collection
                    args.state.items << new_item

                    # then subtract one from the held item
                    args.state.held_item[:quantity] -= 1

                # if the interact area is available and there is only one item being held
                elsif args.state.held_item[:quantity] == 1
                    # instead of creating any new items just set the location of the held item
                    # to the oridinal position of the interact area, and then nil out the
                    # held item state so that a new item can be picked up
                    args.state.held_item[:location] = :interact
                    args.state.held_item[:ordinal_x] = interact_area[:ordinal_x]
                    args.state.held_item[:ordinal_y] = interact_area[:ordinal_y]
                    args.state.held_item = nil
                end
            end

        # if the selected area is an inventory area (as opposed to within the interact area)
        elsif inventory_area
            # check to see if there is already an item in that inventory slot
            # the item_at_inventory_slot helper method returns an item or nil
            item_already_there = item_at_inventory_slot args, inventory_area[:ordinal_x], inventory_area[:ordinal_y]

            # if there is already an item there, and the item types/id match
            if item_already_there && item_already_there[:id] == args.state.held_item[:id]
                # then merge the item quantities
                held_quantity = args.state.held_item[:quantity]
                item_already_there[:quantity] += held_quantity

                # remove the item being held from the items collection (since it's quantity is now 0)
                args.state.items.reject! { |i| i[:location] == :held }

                # nil out the held_item so a new item can be picked up
                args.state.held_item = nil

            # if there currently isn't an item there, then put the held item in the slot
            elsif !item_already_there
                args.state.held_item[:location] = :inventory
                args.state.held_item[:ordinal_x] = inventory_area[:ordinal_x]
                args.state.held_item[:ordinal_y] = inventory_area[:ordinal_y]

                # nil out the held_item so a new item can be picked up
                args.state.held_item = nil
            end
        end
    end
end


# the calc method is executed after input
def calc args
    # make sure that the real position of the inventory
    # items are updated every frame to ensure that they
    # are placed correctly given their location and oridinal positions
    # instead of using .map, here we use .each (since we are not returning a new item and just updating the items in place)
    args.state.items.each do |item|
        # based on the location of the item, invoke the correct pixel conversion method
        if item[:location] == :inventory
            set_inventory_position args, item
        elsif item[:location] == :interact
            set_interact_position args, item
        elsif item[:location] == :held
            # if the item is held, center the item around the mouse pointer
            args.state.held_item.x = args.inputs.mouse.x - args.state.held_item.w.half
            args.state.held_item.y = args.inputs.mouse.y - args.state.held_item.h.half
        end
    end

    # for each hash/sprite in the click ripples queue,
    # expand its size by 20 percent and decrease its alpha
    # by 10.
    args.state.click_ripples.each do |ripple|
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
    args.state.click_ripples.reject! { |ripple| ripple.a <= 0 }
end

# helper function for finding an item at a interact slot
def item_at_interact_slot args, ordinal_x, ordinal_y
    args.state.items.find { |i| i[:location] == :interact && i[:ordinal_x] == ordinal_x && i[:ordinal_y] == ordinal_y }
end

# helper function for finding an item at an inventory slot
def item_at_inventory_slot args, ordinal_x, ordinal_y
    args.state.items.find { |i| i[:location] == :inventory && i[:ordinal_x] == ordinal_x && i[:ordinal_y] == ordinal_y }
end

# helper function that creates a visual representation of an item
def item_prefab args, item, should_highlight, mouse, alpha
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
        { x: x,      y: y, w: args.state.sprite_size, h: args.state.sprite_size, path: item[:path], a: alpha},

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
def set_inventory_position args, item
    item.x = args.state.inventory_border.x + item[:ordinal_x] * 80
    item.y = (args.state.inventory_border.y + args.state.inventory_border.h - 80) - item[:ordinal_y] * 80
    item.w = 80
    item.h = 80
end

# helper function for deriving the position of an item within the interact area
def set_interact_position args, item
    item.x = args.state.interact_border.x + item[:ordinal_x] * 80
    item.y = (args.state.interact_border.y + args.state.inventory_border.h - 80) - item[:ordinal_y] * 80
    item.w = 80
    item.h = 80
end
    

def handle_interact_items args
    args.state.interact_items_accepted.each do |item|
        if item[:id] == :torch 
            puts "TORCH ACCEPTED!"
            args.state.render_fire_interact = true
        end 
    end 
    args.state.interact_items_accepted.reject! { |i| i[:id] == :torch }
end 