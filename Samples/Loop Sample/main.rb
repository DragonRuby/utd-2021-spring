

# Calls methods needed for game to run properly
def tick args
  tick_instructions args, "Use LEFT and RIGHT arrow keys to move and SPACE to jump."
  defaults args
  render args
  calc args
  input args
end

# sets default values and creates empty collections
# initialization only happens in the first frame
def defaults args
  fiddle args
  
  args.state.tick_count = args.state.tick_count
  args.state.bridge_top = 128
  args.state.player.x  ||= 0                        # initializes player's properties
  args.state.player.y  ||= args.state.bridge_top
  args.state.player.w  ||= 64
  args.state.player.h  ||= 64
  args.state.player.dy ||= 0
  args.state.player.dx ||= 0
  args.state.player.r  ||= 0
  args.state.game_over_at ||= 0
  args.state.loopy.x   ||= 200
  args.state.loopy.y   ||= 0
  args.state.loopy.h   ||= 400
  args.state.loopy.k   ||= 400
  args.state.loopy.r   ||= 200
  args.state.loopy.hide||= 128
  args.state.tickstart ||= 0
  args.state.inloop    ||= false
  args.state.looptime  ||= 120

  
end

# sets enemy, player, hammer values
def fiddle args
  args.state.gravity                     = -0.3
  args.state.player_jump_power           = 10       # sets player values
  args.state.player_jump_power_duration  = 10
  args.state.player_max_run_speed        = 10
  args.state.player_speed_slowdown_rate  = 0.9
  args.state.player_acceleration         = 1
  args.state.loopy.angle  ||= Math::PI * 1.5
end

# outputs objects onto the screen
def render args
  args.outputs.solids << 20.map_with_index do |i| # uses 20 squares to form bridge
    # sets x by multiplying 64 to index to find pixel value (places all squares side by side)
    # subtracts 64 from bridge_top because position is denoted by bottom left corner
    [i * 64, args.state.bridge_top - 64, 64, 64]
  end
  args.state.loopy.angle = ((2*Math::PI)/args.state.looptime) + args.state.loopy.angle #dictates how quickly the angle changes
  if (args.state.loopy.angle > 2*Math::PI)#keeps angle between 0-360
    args.state.loopy.angle = 0
  end

  #sprites
  loopstart =  [463, args.state.loopy.hide,    64,     64, "sprites/square/gray.png",    0, 0]
  player = [args.state.player.x, args.state.player.y, args.state.player.w, args.state.player.h, "sprites/circle/blue.png", args.state.player.r]
  
  if (player.rect.intersect_rect? loopstart) && (args.state.player.dx > 7)  && (args.state.tick_count > args.state.tickstart + args.state.looptime+20) #loop start
  args.state.tickstart = args.state.tick_count
  args.state.inloop = true
  args.state.loopy.hide = 0
  args.state.loopy.angle  = Math::PI * 1.5
  end
  
  if args.state.tick_count > args.state.tickstart + args.state.looptime + 20 #allows for multiple loops
  args.state.tickstart = 0
  end

  if args.state.inloop #in loop
  if args.state.tick_count < args.state.tickstart + args.state.looptime
  args.state.player.x = (Math.cos(args.state.loopy.angle)*args.state.loopy.r)+400
  args.state.player.y = (Math.sin(args.state.loopy.angle)*args.state.loopy.r)+328 
  args.state.player.r = ((args.state.tick_count-args.state.tickstart) % 360*(360/args.state.looptime))
  else 
  args.state.inloop = false
  args.state.loopy.hide = 128
  args.state.player.r  = 0
  end
  end
  

  

  
  args.outputs.labels << [10, 35.from_top, "  #{args.state.tick_count}"] # test value 
  args.outputs.labels << [10, 50.from_top, "  #{args.state.tickstart}"] # test value 
  args.outputs.sprites << [(Math.cos(args.state.loopy.angle)*args.state.loopy.r)+400,(Math.sin(args.state.loopy.angle)*args.state.loopy.r)+328 , 64, 64, "sprites/square/gray.png", 90+(args.state.tick_count % 360*2), 0]

  #spriterender
  
  args.outputs.sprites << loopstart
  args.outputs.sprites << player


end

# Performs calculations to move objects on the screen
def calc args

if !args.state.inloop
args.state.tick_count < args.state.tickstart + 180
  # Since velocity is the change in position, the change in x increases by dx. Same with y and dy.
  args.state.player.x  += args.state.player.dx
  args.state.player.y  += args.state.player.dy

  # Since acceleration is the change in velocity, the change in y (dy) increases every frame
  args.state.player.dy += args.state.gravity

  # player's y position is either current y position or y position of top of
  # bridge, whichever has a greater value
  # ensures that the player never goes below the bridge
  args.state.player.y  = args.state.player.y.greater(args.state.bridge_top)

  # player's x position is either the current x position or 0, whichever has a greater value
  # ensures that the player doesn't go too far left (out of the screen's scope)
  args.state.player.x  = args.state.player.x.greater(0)

  # player is not falling if it is located on the top of the bridge
  args.state.player.falling = false if args.state.player.y == args.state.bridge_top
  #args.state.player.rect = [args.state.player.x, args.state.player.y, args.state.player.h, args.state.player.w] # sets definition for player

  end
  end

  

# Resets the player by changing its properties back to the values they had at initialization
def reset_player args
  args.state.player.x = 0
  args.state.player.y = args.state.bridge_top
  args.state.player.dy = 0
  args.state.player.dx = 0
  args.state.enemy.hammers.clear # empties hammer collection
  args.state.enemy.hammer_queue.clear # empties hammer_queue
  args.state.game_over_at = args.state.tick_count # game_over_at set to current frame (or passage of time)
end

# Processes input from the user to move the player
def input args
  if args.inputs.keyboard.space # if the user presses the space bar
    args.state.player.jumped_at ||= args.state.tick_count # jumped_at is set to current frame

    # if the time that has passed since the jump is less than the player's jump duration and
    # the player is not falling
    if args.state.player.jumped_at.elapsed_time < args.state.player_jump_power_duration && !args.state.player.falling
      args.state.player.dy = args.state.player_jump_power # change in y is set to power of player's jump
    end
  end

  # if the space bar is in the "up" state (or not being pressed down)
  if args.inputs.keyboard.key_up.space
    args.state.player.jumped_at = nil # jumped_at is empty
    args.state.player.falling = true # the player is falling
  end

  if args.inputs.keyboard.left # if left key is pressed
    args.state.player.dx -= args.state.player_acceleration # dx decreases by acceleration (player goes left)
    # dx is either set to current dx or the negative max run speed (which would be -10),
    # whichever has a greater value
    args.state.player.dx = args.state.player.dx.greater(-args.state.player_max_run_speed)
  elsif args.inputs.keyboard.right # if right key is pressed
    args.state.player.dx += args.state.player_acceleration # dx increases by acceleration (player goes right)
    # dx is either set to current dx or max run speed (which would be 10),
    # whichever has a lesser value
    args.state.player.dx = args.state.player.dx.lesser(args.state.player_max_run_speed)
  else
    args.state.player.dx *= args.state.player_speed_slowdown_rate # dx is scaled down
  end
end

def tick_instructions args, text, y = 715
  return if args.state.key_event_occurred
  if args.inputs.mouse.click ||
     args.inputs.keyboard.directional_vector ||
     args.inputs.keyboard.key_down.enter ||
     args.inputs.keyboard.key_down.space ||
     args.inputs.keyboard.key_down.escape
    args.state.key_event_occurred = true
  end

  args.outputs.debug << [0, y - 50, 1280, 60].solid
  args.outputs.debug << [640, y, text, 1, 1, 255, 255, 255].label
  args.outputs.debug << [640, y - 25, "(click to dismiss instructions)" , -2, 1, 255, 255, 255].label
end
