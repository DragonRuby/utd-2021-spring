=begin

 APIs listing that haven't been encountered in previous sample apps:

 - reverse: Returns a new string with the characters from original string in reverse order.
   For example, the command
   "dragonruby".reverse
   would return the string
   "yburnogard".
   Reverse is not only limited to strings, but can be applied to arrays and other collections.

 Reminders:

 - ARRAY#intersect_rect?: Returns true or false depending on if two rectangles intersect.

 - args.outputs.labels: An array. The values generate a label.
   The parameters are [X, Y, TEXT, SIZE, ALIGNMENT, RED, GREEN, BLUE, ALPHA, FONT STYLE]
   For more information about labels, go to mygame/documentation/02-labels.md.

=end

# This code shows a maze and uses input from the keyboard to move the user around the screen.
# The objective is to reach the goal.

# Sets values of tile size and player's movement speed
# Also creates tile or box for player and generates map


def tick args
  args.state.tile_size     = 40
  args.state.filled_squares ||= []
  args.state.tileSelected   ||= 1
  args.state.player.x ||= 390
  args.state.player.y ||= 140
  args.state.player.w ||= 64 
  args.state.player.h ||= 64 
  args.state.player.direction ||= 1
  args.state.player.speed ||=4
  args.state.player.zoom ||= 1
  draw_buttons args
  args.state.barrier ||= []
  args.state.door ||=[]
  args.state.back ||=[]
  args.state.map ||= 1
  args.state.save1 ||= 0
  args.state.save2 ||= 0
  args.state.clr ||= 0
  args.state.deletebarrier ||= []
  args.state.temp1barrier ||= []
  args.state.temp1door ||= []
  args.state.temp1back ||= []
  args.state.temp1filled_squares ||= []
  args.state.temp2barrier ||= []
  args.state.temp2door ||= []
  args.state.temp2back ||= []
  args.state.temp2filled_squares ||= []
  # Adds walls, goal, and player to args.outputs.solids so they appear on screen
    args.outputs.solids << args.state.walls
	args.outputs.solids << args.state.barrier
	args.outputs.sprites << args.state.filled_squares
	args.outputs.labels << [400, 620, args.state.map.to_s]
  #
  
  
  #	
    $x = 0
    while $x < 13  do
    args.outputs.lines  << [80+ ($x * 40), 80, 80+($x * 40), 680]
    $x +=1
    end
	
    $y = 0
    while $y < 16  do
    args.outputs.lines  << [80, 80+ ($y * 40), 560, 80+($y * 40)]
    $y +=1
	end
 
	$order = 1
	$y1 = 0
	while $order < 18  do
	if $order < 8
    args.outputs.sprites << [640+($order * 80), 640, args.state.tile_size, args.state.tile_size, 'sprites/image' + $order.to_s + ".png"]
	end
	if $order > 7 and $order < 15
	args.outputs.sprites << [640+($order  * 80)-560, 640-80, args.state.tile_size, args.state.tile_size, 'sprites/image' + $order.to_s + ".png"]
    end
	if $order > 14
	args.outputs.sprites << [640+($order  * 80)-1120, 640-160, args.state.tile_size, args.state.tile_size, 'sprites/image' + $order.to_s + ".png"]
    end
	$order +=1
	end
   
   box1 = [640+(1 * 80), 640, args.state.tile_size, args.state.tile_size,0,0,0]
   box2 = [640+(2 * 80), 640, args.state.tile_size, args.state.tile_size,0,0,0]
   box3 = [640+(3 * 80), 640, args.state.tile_size, args.state.tile_size,0,0,0]
   box4 = [640+(4 * 80), 640, args.state.tile_size, args.state.tile_size,0,0,0]
   box5 = [640+(5 * 80), 640, args.state.tile_size, args.state.tile_size,0,0,0]
   box6 = [640+(6 * 80), 640, args.state.tile_size, args.state.tile_size,0,0,0]
   box7 = [640+(7 * 80), 640, args.state.tile_size, args.state.tile_size,0,0,0]
   box8 = [640+(1 * 80), 640-80, args.state.tile_size, args.state.tile_size,0,0,0]
   box9 = [640+(2 * 80), 640-80, args.state.tile_size, args.state.tile_size,0,0,0]
   box10 = [640+(3 * 80), 640-80, args.state.tile_size, args.state.tile_size,0,0,0]
   box11 = [640+(4 * 80), 640-80, args.state.tile_size, args.state.tile_size,0,0,0]
   box12 = [640+(5 * 80), 640-80, args.state.tile_size, args.state.tile_size,0,0,0]
   box13 = [640+(6 * 80), 640-80, args.state.tile_size, args.state.tile_size,0,0,0]
   box14 = [640+(7 * 80), 640-80, args.state.tile_size, args.state.tile_size,0,0,0]
   box15 = [640+(1 * 80), 640-160, args.state.tile_size, args.state.tile_size,0,0,0]
   box16 = [640+(2 * 80), 640-160, args.state.tile_size, args.state.tile_size,0,0,0]
   box17 = [640+(3 * 80), 640-160, args.state.tile_size, args.state.tile_size,0,0,0]
   paint_box = [80,80,480,600,0,0,0]

   if args.inputs.mouse.click
    args.state.last_mouse_click = args.inputs.mouse.click
   end

  if args.state.last_mouse_click
	if args.state.last_mouse_click.point.inside_rect? box1
      args.state.tileSelected = 1
    end
    if args.state.last_mouse_click.point.inside_rect? box2
      args.state.tileSelected = 2
    end
	if args.state.last_mouse_click.point.inside_rect? box3
      args.state.tileSelected = 3
    end
	if args.state.last_mouse_click.point.inside_rect? box4
      args.state.tileSelected = 4
    end
	if args.state.last_mouse_click.point.inside_rect? box5
      args.state.tileSelected = 5
    end
	if args.state.last_mouse_click.point.inside_rect? box6
      args.state.tileSelected = 6
    end
	if args.state.last_mouse_click.point.inside_rect? box7
      args.state.tileSelected = 7
    end
	if args.state.last_mouse_click.point.inside_rect? box8
      args.state.tileSelected = 8
    end
	if args.state.last_mouse_click.point.inside_rect? box9
      args.state.tileSelected = 9
    end
	if args.state.last_mouse_click.point.inside_rect? box10
      args.state.tileSelected = 10
    end
	if args.state.last_mouse_click.point.inside_rect? box11
      args.state.tileSelected = 11
    end
	if args.state.last_mouse_click.point.inside_rect? box12
      args.state.tileSelected = 12
    end
	if args.state.last_mouse_click.point.inside_rect? box13
      args.state.tileSelected = 13
    end
	if args.state.last_mouse_click.point.inside_rect? box14
      args.state.tileSelected = 14
    end
	if args.state.last_mouse_click.point.inside_rect? box15
      args.state.tileSelected = 15
    end
	if args.state.last_mouse_click.point.inside_rect? box16
      args.state.tileSelected = 16
    end
	if args.state.last_mouse_click.point.inside_rect? box17
      args.state.tileSelected = 17
    end
	if args.state.last_mouse_click.point.inside_rect? paint_box
	if args.state.tileSelected != 8 and args.state.tileSelected != 16 and args.state.tileSelected != 17
	args.state.barrier << tile(args, args.state.last_mouse_click.point.x.idiv(40), args.state.last_mouse_click.point.y.idiv(40), 255, 255, 255)
	end
	if args.state.tileSelected == 8 and args.state.tileSelected  == 16 and args.state.tileSelected == 17
	args.state.deletebarrier << tile(args, args.state.last_mouse_click.point.x.idiv(40), args.state.last_mouse_click.point.y.idiv(40), 255, 255, 255)
	args.state.barrier = args.state.barrier - args.state.deletebarrier 
	end
	if args.state.tileSelected == 16 
	args.state.door << tile(args, args.state.last_mouse_click.point.x.idiv(40), args.state.last_mouse_click.point.y.idiv(40), 255, 255, 255)
	args.state.deletebarrier << tile(args, args.state.last_mouse_click.point.x.idiv(40), args.state.last_mouse_click.point.y.idiv(40), 255, 255, 255)
	args.state.barrier = args.state.barrier - args.state.deletebarrier 
	end
	if args.state.tileSelected == 17 
	args.state.back << tile(args, args.state.last_mouse_click.point.x.idiv(40), args.state.last_mouse_click.point.y.idiv(40), 255, 255, 255)
	args.state.deletebarrier << tile(args, args.state.last_mouse_click.point.x.idiv(40), args.state.last_mouse_click.point.y.idiv(40), 255, 255, 255)
	args.state.barrier = args.state.barrier - args.state.deletebarrier 
	end
    args.state.filled_squares << [args.state.last_mouse_click.point.x.idiv(40)* args.state.tile_size, args.state.last_mouse_click.point.y.idiv(40)* args.state.tile_size, args.state.tile_size, args.state.tile_size, 'sprites/image' + args.state.tileSelected.to_s + ".png"]	
	end
  end
  args.outputs.labels << [720, 320, "Selected Tile"]
  args.outputs.sprites << [720, 240, args.state.tile_size, args.state.tile_size, 'sprites/image' + args.state.tileSelected.to_s + ".png"]
    
  
  args.outputs.borders << args.state.player.collision_rectleft
  args.outputs.borders << args.state.player.collision_rectright
  args.outputs.borders << args.state.player.collision_rectup
  args.outputs.borders << args.state.player.collision_rectdown
  

  args.state.player.collision_rect = [args.state.player.x,
                                     args.state.player.y,
                                     64, 64]
  args.state.player.collision_rectleft = [args.state.player.x-10,
                                     args.state.player.y,
                                     64, 64]
  args.state.player.collision_rectright= [args.state.player.x+10,
                                     args.state.player.y,
                                     64, 64]
  args.state.player.collision_rectup= [args.state.player.x,
                                     args.state.player.y+10,
                                     64, 64]
  args.state.player.collision_rectdown= [args.state.player.x,
                                     args.state.player.y-10,
                                     64, 64]
  
  # get the keyboard input and set player properties
  if args.inputs.keyboard.right and args.state.player.x < 480 and !args.state.barrier.any_intersect_rect? args.state.player.collision_rectright and !args.state.door.any_intersect_rect? args.state.player.collision_rectright and !args.state.back.any_intersect_rect? args.state.player.collision_rectright
    args.state.player.x += args.state.player.speed
    args.state.player.direction = 1
    args.state.player.started_running_at ||= args.state.tick_count
  end
  
  if args.inputs.keyboard.left and args.state.player.x > 80 and !args.state.barrier.any_intersect_rect? args.state.player.collision_rectleft and !args.state.door.any_intersect_rect? args.state.player.collision_rectleft and !args.state.back.any_intersect_rect? args.state.player.collision_rectleft
    args.state.player.x -= args.state.player.speed
    args.state.player.direction = -1
    args.state.player.started_running_at ||= args.state.tick_count 
  end

  if args.inputs.keyboard.up and args.state.player.y < 600 and !args.state.barrier.any_intersect_rect? args.state.player.collision_rectup
    args.state.player.y += args.state.player.speed
    args.state.player.started_running_at ||= args.state.tick_count
  end

   if args.inputs.keyboard.up and args.state.player.y < 600 and args.state.door.any_intersect_rect? args.state.player.collision_rectdown
      

  if args.state.save1 == 0
  args.state.temp1barrier = args.state.barrier.clone
  args.state.temp1door = args.state.door.clone
  args.state.temp1filled_squares = args.state.filled_squares.clone
  args.state.temp1back = args.state.back.clone
  args.state.save1 = 1
  args.state.filled_squares.clear
  args.state.barrier.clear
  args.state.door.clear
  args.state.back.clear
  end 
  
  
 
  if args.state.save2 == 1
  args.state.barrier = args.state.temp2barrier
  args.state.door = args.state.temp2door
  args.state.filled_squares = args.state.temp2filled_squares
  args.state.back = args.state.temp2back
  save2 = 0
  end
  args.state.player.x = 390
  args.state.player.y = 140
  args.state.map = 2
  end
  
  if args.inputs.keyboard.up and args.state.player.y < 600 and args.state.back.any_intersect_rect? args.state.player.collision_rectdown
        
  
  if args.state.save2 == 0
  args.state.temp2barrier = args.state.barrier.clone
  args.state.temp2door = args.state.door.clone
  args.state.temp2filled_squares =args.state.filled_squares.clone
  args.state.temp2back = args.state.back.clone
  args.state.save2 = 1
  args.state.filled_squares.clear
  args.state.barrier.clear
  args.state.door.clear
  args.state.back.clear
  end 
  

  
  if args.state.save1 == 1
  args.state.barrier = args.state.temp1barrier
  args.state.door = args.state.temp1door
  args.state.filled_squares = args.state.temp1filled_squares
  args.state.back = args.state.temp1back
  save1 = 0
  end
  args.state.player.x = 390
  args.state.player.y = 140
  args.state.map = 1
  end
  if args.inputs.keyboard.down and args.state.player.y > 80 and !args.state.barrier.any_intersect_rect? args.state.player.collision_rectdown and !args.state.door.any_intersect_rect? args.state.player.collision_rectdown and !args.state.back.any_intersect_rect? args.state.player.collision_rectdown
    args.state.player.y -= args.state.player.speed
    args.state.player.started_running_at ||= args.state.tick_count
  end
 
	
  # if no arrow keys are being pressed, set the player as not moving
  if !args.inputs.keyboard.directional_vector
    args.state.player.started_running_at = nil
  end

  # render player as standing or running
  if args.state.player.started_running_at
  args.outputs.primitives << running_sprite(args).sprite
  else
  args.outputs.primitives << standing_sprite(args).sprite
  end
end
def standing_sprite args
  {
    x: args.state.player.x,
    y: args.state.player.y,
    w: args.state.player.w* args.state.player.zoom,
    h: args.state.player.h* args.state.player.zoom,
    path: "sprites/horizontal-stand.png",
    flip_horizontally: args.state.player.direction > 0
  }
end

def running_sprite args
  if !args.state.player.started_running_at
    tile_index = 0
  else
    how_many_frames_in_sprite_sheet = 6
    how_many_ticks_to_hold_each_frame = 3
    should_the_index_repeat = true
    tile_index = args.state
                     .player
                     .started_running_at
                     .frame_index(how_many_frames_in_sprite_sheet,
                                  how_many_ticks_to_hold_each_frame,
                                  should_the_index_repeat)
  end

  {
    x: args.state.player.x,
    y: args.state.player.y,
    w: args.state.player.w,
    h: args.state.player.h,
    path: 'sprites/horizontal-run.png',
    tile_x: 0 + (tile_index * args.state.player.w),
    tile_y: 0,
    tile_w: args.state.player.w,
    tile_h: args.state.player.h,
    flip_horizontally: args.state.player.direction > 0,
  }
end

# Sets position, size, and color of the tile
def tile args, x, y, *color
  [x * args.state.tile_size, # sets definition for array using method parameters
   y * args.state.tile_size, # multiplying by tile_size sets x and y to correct position using pixel values
   args.state.tile_size,
   args.state.tile_size,
   *color]
end
		
# Allows the player to move their box around the screen


 def draw_buttons args
    x, y, w, h = 720, 80, 240, 50
    args.state.clear_button        ||= args.state.new_entity(:button_with_fade)

    # The x and y positions are set to display the label in the center of the button.
    # Try changing the first two parameters to simply x, y and see what happens to the text placement!
    args.state.clear_button.label  ||= [x + w.half, y + h.half + 10, "Clear", 0, 1] # placed in center of border
    args.state.clear_button.border ||= [x, y, w, h]

    # If the mouse is clicked inside the borders of the clear button,
    # the filled_squares collection is emptied and the squares are cleared.
    if args.inputs.mouse.click && args.inputs.mouse.click.point.inside_rect?(args.state.clear_button.border)
      args.state.clear_button.clicked_at = args.inputs.mouse.click.created_at # time (frame) the click occurred
      args.state.filled_squares.clear
	  args.state.barrier.clear
	  args.state.door.clear
	  args.state.back.clear
	  if args.state.map == 1
	  args.state.temp1barrier.clear
	  args.state.temp1door.clear
      args.state.temp1filled_squares.clear
      args.state.temp1back.clear
	  end
	  if args.state.map == 2
	  args.state.temp2barrier.clear
	  args.state.temp2door.clear
      args.state.temp2filled_squares.clear
      args.state.temp2back.clear
	  end
      args.inputs.mouse.previous_click = nil
    end

    args.outputs.labels << args.state.clear_button.label
    args.outputs.borders << args.state.clear_button.border

    # When the clear button is clicked, the color of the button changes
    # and the transparency changes, as well. If you change the time from
    # 0.25.seconds to 1.25.seconds or more, the change will last longer.
    if args.state.clear_button.clicked_at
      args.outputs.solids << [x, y, w, h, 0, 180, 80, 255 * args.state.clear_button.clicked_at.ease(0.25.seconds, :flip)]
    end
 end
 

