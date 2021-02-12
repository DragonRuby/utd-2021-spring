=begin
 - numbers.first --> the number 1 will be returned because it is the first element of the numbers array. 
 - num1.idiv(num2): Divides two numbers and returns an integer.
   For example,
   16.idiv(3) = 5, because 16 / 3 is 5.33333 returned as an integer.
   16.idiv(4) = 4, because 16 / 4 is 4 and already has no decimal.

 Info:
 - find_all: Finds all values that satisfy specific requirements.
 - An array with at least four values is considered a rect. 
 - The intersect_rect? function returns true or false depending on if the two rectangles intersect.
 - reject: Removes elements from a collection if they meet certain requirements.
=end


class Platform_Physics_And_Destruction
  attr_accessor :grid, :inputs, :state, :outputs


  # Calls all methods necessary for the app to run successfully.
  def tick
    defaults
    render
    calc
    process_inputs
  end


  # Sets default values for variables.
  # The ||= sign means that the variable will only be set to the value following the = sign if the value has
  # not already been set before. Intialization happens only in the first frame.
  def defaults
    state.tile_size               = 64
    state.gravity                 = -0.2
    state.char_size               = 56
    state.max_horizontal_size     = 1280
    state.max_vertical_size       = 720
    state.previous_tile_size    ||= state.tile_size
    state.x                     ||= 0
    state.y                     ||= 800
    state.dy                    ||= 0
    state.dx                    ||= 0
    state.world                 ||= []
    state.world_lookup          ||= {}
    state.world_collision_rects ||= []
    state.deletedLast           ||= false
    state.deletedTimer          ||= 0
  end


  # Outputs solids and borders of different colors for the world and collision_rects collections.
  def render
    # Sets a black background on the screen (Comment this line out and the background will become white.)
    # Also note that black is the default color for when no color is assigned.
    #outputs.solids << grid.rect

    # The position, size, and color (white) are set for borders given to the world collection.
    # Try changing the color by assigning different numbers (between 0 and 255) to the last three parameters.
    outputs.borders << state.world.map do |x, y|
      [x * state.tile_size,
        y * state.tile_size,
        state.tile_size,
        state.tile_size, 255, 255, 255]
    end

    #Debug output --> Seems issue is that last block is stored in a hash along with the player obj in the collision rects
    if state.deletedLast
      for index in state.world_collision_rects.map
        puts "state.world_collision_rects.map = #{index}"        
      end 
      if state.deletedTimer > 0
        state.deletedTimer -= 1
      end
    elsif state.deletedTimer == 0
      #Sets border colors for collision_rects
      outputs.borders << state.world_collision_rects.map do |e|
        [
          [e[:top],                             196, 98, 16], # top is a shade of green
          [e[:bottom],                          196, 98, 16], # bottom is a shade of greenish-blue
          [e[:left_right],                      196, 98, 16], # left and right are a shade of red
        ]
      end
    end

    
    # Sets the position, size, and color of the borders of only the player's box and outputs it. 
    outputs.solids << [state.x,
                        state.y,
                        state.char_size,
                        state.char_size,  0, 180, 0]
  end


  # Calls methods needed to perform calculations.
  def calc
    calc_world_lookup
    calc_player
  end


  # Performs calculations on world_lookup and sets values.
  def calc_world_lookup 
    # If the tile size isn't equal to the previous tile size,
    # the previous tile size is set to the tile size,
    # and world_lookup hash is set to empty.
    if state.tile_size != state.previous_tile_size
      state.previous_tile_size = state.tile_size
      state.world_lookup = {} # empty hash
    end

    # return if the world_lookup hash has keys (or, in other words, is not empty)
    # return unless the world collection has values inside of it (or is not empty)
    return if state.world_lookup.keys.length > 0
    return unless state.world.length > 0

    # Starts with an empty hash for world_lookup.
    # Searches through the world and finds the coordinates that exist.
    state.world_lookup = {}
    state.world.each { |x, y| state.world_lookup[[x, y]] = true }

    # Assigns world_collision_rects for every sprite drawn.
    state.world_collision_rects =
      state.world_lookup
          .keys
          .map do |coord_x, coord_y|
            s = state.tile_size
            # multiply by tile size so the grid coordinates; sets pixel value
            # don't forget that position is denoted by bottom left corner
            # set x = coord_x or y = coord_y and see what happens!
            x = s * coord_x
            y = s * coord_y
            {
              # The values added to x, y, and s position the world_collision_rects so they all appear
              # stacked (on top of world rects) but don't directly overlap.
              # Remove these added values and mess around with the rect placement!
              args:       [coord_x, coord_y],
              left_right: [x,     y + 4, s,     s - 6], # hash keys and values
              top:        [x + 4, y + 6, s - 8, s - 6],
              bottom:     [x + 1, y - 1, s - 2, s - 8],
            }
          end
  end


  # Performs calculations to change the x and y values of the player's box.
  def calc_player

    # Since acceleration is the change in velocity, the change in y (dy) increases every frame.
    # What goes up must come down because of gravity.
    state.dy += state.gravity

    # Calls the calc_box_collision and calc_edge_collision methods.
    calc_box_collision
    calc_edge_collision

    # Since velocity is the change in position, the change in y increases by dy. Same with x and dx.
    state.y += state.dy
    state.x += state.dx

    # Scales dx down.
    state.dx *= 0.8
  end


  # Calls methods needed to determine collisions between player and world_collision rects.
  def calc_box_collision
    return unless state.world_lookup.keys.length > 0 # return unless hash has atleast 1 key
    collision_floor!
    collision_left!
    collision_right!
    collision_ceiling!
  end


  # Finds collisions between the bottom of the player's rect and the top of a world_collision_rect.
  def collision_floor!
    return unless state.dy <= 0 # return unless player is going down or is as far down as possible
    player_rect = [state.x, state.y - 0.1, state.char_size, state.char_size] # definition of player

    # Goes through world_collision_rects to find all intersections between the bottom of player's rect and
    # the top of a world_collision_rect (hence the "-0.1" above)
    floor_collisions = state.world_collision_rects
                            .find_all { |r| r[:top].intersect_rect?(player_rect, collision_tollerance) }
                            .first

    return unless floor_collisions # return unless collision occurred
    state.y = floor_collisions[:top].top # player's y is set to the y of the top of the collided rect
    state.dy = 0 # if a collision occurred, the player's rect isn't moving because its path is blocked
  end


  # Finds collisions between the player's left side and the right side of a world_collision_rect.
  def collision_left!
    return unless state.dx < 0 # return unless player is moving left
    player_rect = [state.x - 0.1, state.y, state.char_size, state.char_size]

    # Goes through world_collision_rects to find all intersections beween the player's left side and the
    # right side of a world_collision_rect.
    left_side_collisions = state.world_collision_rects
                                .find_all { |r| r[:left_right].intersect_rect?(player_rect, collision_tollerance) }
                                .first

    return unless left_side_collisions # return unless collision occurred

    # player's x is set to the value of the x of the collided rect's right side
    state.x = left_side_collisions[:left_right].right
    state.dx = 0 # player isn't moving left because its path is blocked
  end


  # Finds collisions between the right side of the player and the left side of a world_collision_rect.
  def collision_right!
    return unless state.dx > 0 # return unless player is moving right
    player_rect = [state.x + 0.1, state.y, state.char_size, state.char_size]

    # Goes through world_collision_rects to find all intersections between the player's right side
    # and the left side of a world_collision_rect (hence the "+0.1" above)
    right_side_collisions = state.world_collision_rects
                                .find_all { |r| r[:left_right].intersect_rect?(player_rect, collision_tollerance) }
                                .first

    return unless right_side_collisions # return unless collision occurred

    # player's x is set to the value of the collided rect's left, minus the size of a rect
    # tile size is subtracted because player's position is denoted by bottom left corner
    state.x = right_side_collisions[:left_right].left - state.char_size
    state.dx = 0 # player isn't moving right because its path is blocked
  end


  # Finds collisions between the top of the player's rect and the bottom of a world_collision_rect.
  def collision_ceiling!
    return unless state.dy > 0 # return unless player is moving up
    player_rect = [state.x, state.y + 0.1, state.char_size, state.char_size]

    # Goes through world_collision_rects to find intersections between the bottom of a
    # world_collision_rect and the top of the player's rect (hence the "+0.1" above)
    ceil_collisions = state.world_collision_rects
                          .find_all { |r| r[:bottom].intersect_rect?(player_rect, collision_tollerance) }
                          .first

    return unless ceil_collisions # return unless collision occurred

    # player's y is set to the bottom y of the rect it collided with, minus the size of a rect
    state.y = ceil_collisions[:bottom].y - state.char_size
    state.dy = 0 # if a collision occurred, the player isn't moving up because its path is blocked
  end


  # Makes sure the player remains within the screen's dimensions.
  def calc_edge_collision
    #Ensures that the player doesn't fall below the map.
    if state.y < 0
      state.y = 0
      state.dy = 0

    #Ensures that the player doesn't go too high.
    # Position of player is denoted by bottom left hand corner, which is why we have to subtract the
    # size of the player's box (so it remains visible on the screen)
    elsif state.y > state.max_vertical_size - state.char_size # if the player's y position exceeds the height of screen
      state.y = state.max_vertical_size - state.char_size # the player will remain as high as possible while staying on screen
      state.dy = 0
    end

    # Ensures that the player remains in the horizontal range that it is supposed to.
    if state.x >= state.max_horizontal_size - state.char_size && state.dx > 0 # if player moves too far right
      state.x = state.max_horizontal_size - state.char_size # player will remain as right as possible while staying on screen
      state.dx = 0
    elsif state.x <= 0 && state.dx < 0 # if player moves too far left
      state.x = 0 # player will remain as left as possible while remaining on screen
      state.dx = 0
    end
  end


  # Processes input from the user on the keyboard.
  def process_inputs    
    #display current player position - DEBUG
    gridx = ((state.x)/64).round
    gridy = ((state.y)/64).round
    if inputs.keyboard.key_held.r
      outputs.labels << [grid.left.shift_right(5), grid.top.shift_down(5), "x is #{gridx} and y is #{gridy}",0, 0, 255,   0,   0]
    end

    #enable clicking for placing or destroying blocks - DEBUG
    if inputs.mouse.down
      state.world_lookup = {}
      x, y = to_coord inputs.mouse.down.point  # gets x, y coordinates for the grid --> Determines where boxes are placed

      if state.world.any? { |loc| loc == [x, y] }  # checks if coordinates duplicate
        state.world = state.world.reject { |loc| loc == [x, y] }  # erases tile space
        if state.world == []
          state.deletedLast = true;
          state.deletedTimer = 15
        end
      else
        state.world << [x, y] # If no duplicates, adds to world collection
        state.deletedLast = false;
      end
    end

    #remove or place block above character  
    if inputs.keyboard.key_down.up
      state.world_lookup = {}
      x, y = gridx, gridy+1  # gets x, y coordinates for the grid      
      
      if state.world.any? { |loc| loc == [x, y] }  # checks if coordinates duplicate
        state.world = state.world.reject { |loc| loc == [x, y] }  # erases tile space
        if state.world == []
          state.deletedLast = true;
          state.deletedTimer = 15
        end
      elsif y < (state.max_vertical_size / 64)
        state.world << [x, y] # If no duplicates, adds to world collection
        state.deletedLast = false;
      end
    end

    #remove or place block below character 
    if inputs.keyboard.key_down.down
      state.world_lookup = {}
      x, y = gridx, gridy-1  # gets x, y coordinates for the grid      
      
      if state.world.any? { |loc| loc == [x, y] }  # checks if coordinates duplicate
        state.world = state.world.reject { |loc| loc == [x, y] }  # erases tile space
        if state.world == []
          state.deletedLast = true;
          state.deletedTimer = 15
        end
      elsif y >= 0
        state.world << [x, y] # If no duplicates, adds to world collection     
        state.deletedLast = false;   
      end
    end

    #remove or place block to the left of the character 
    if inputs.keyboard.key_down.left
      state.world_lookup = {}
      x, y = gridx-1, gridy  # gets x, y coordinates for the grid      
      
      if state.world.any? { |loc| loc == [x, y] }  # checks if coordinates duplicate
        state.world = state.world.reject { |loc| loc == [x, y] }  # erases tile space
        if state.world == []
          state.deletedLast = true;
          state.deletedTimer = 15
        end
      elsif x >= 0
        state.world << [x, y] # If no duplicates, adds to world collection
        state.deletedLast = false;
      end
    end

    #remove or place block to the right of the character 
    if inputs.keyboard.key_down.right
      state.world_lookup = {}
      x, y = gridx+1, gridy  # gets x, y coordinates for the grid      
      
      if state.world.any? { |loc| loc == [x, y] }  # checks if coordinates duplicate
        state.world = state.world.reject { |loc| loc == [x, y] }  # erases tile space
        if state.world == []
          state.deletedLast = true;
          state.deletedTimer = 15
        end
      elsif x < (state.max_horizontal_size / 64)
        state.world << [x, y] # If no duplicates, adds to world collection
        state.deletedLast = false;
      end
    end 

    # Sets dx to 0 if the player lets go of arrow keys.
    if inputs.keyboard.key_up.d
      state.dx = 0
    elsif inputs.keyboard.key_up.a
      state.dx = 0
    end

    # Sets dx to 3 in whatever direction the player chooses.
    if inputs.keyboard.key_held.d # if d key is pressed
      state.dx =  3
    elsif inputs.keyboard.key_held.a # if a key is pressed
      state.dx = -3
    end

    #Sets dy to 5 to make the player ~fly~ when they press the space bar
    if inputs.keyboard.key_held.space || inputs.keyboard.key_held.w
      state.dy = 3
    end
  end


  def to_coord point
    # Integer divides (idiv) point.x to turn into grid
    # Then, you can just multiply each integer by state.tile_size later so the grid coordinates.
    [point.x.idiv(state.tile_size), point.y.idiv(state.tile_size)]
  end


  # Represents the tolerance for a collision between the player's rect and another rect.
  def collision_tollerance
    0.0
  end
end
