def tick args
  #set background white
  args.outputs.solids << [0, 0, 1280, 720, 255,255,255] 
  #set components
  args.outputs.solids << [0, 0, 1280, 200, 0, 0, 0, 255]
  args.outputs.solids << [10, 10, 1260, 180, 255, 255, 255, 255]
  args.outputs.solids << [980, 0, 300, 200, 0, 0, 0, 255]
  args.outputs.solids << [990, 10, 280, 180, 255, 255, 255, 255]
  
 #args.outputs.sprites<< [200, 200, 200, 200, 'sprites/p1.png']#change the file name and path to change the character image
 #args.outputs.sprites<< [800, 500, 200, 180, 'sprites/p2.png']#change the file name and path to change the enemy image
  
  args.outputs.labels << [1100, 160, "ATTACK",    4]
  args.outputs.labels << [1100, 110, "DEFEND", 4]
  args.outputs.labels << [1100, 60, "ITEM", 4]
  
  #set button position

  attackbox = [1100, 130, 100, 40, 0, 0, 170]
  defendbox = [1100, 80, 100, 40, 0, 0, 170]
  itembox = [1100, 30, 100, 40, 0, 0, 170]
  item1box = [40, 130, 100, 40, 0, 0, 170]
  item2box = [40, 80, 100, 40, 0, 0, 170]
  item3box = [40, 30, 100, 40, 0, 0, 170]

case args.state.button
  when 0
  args.outputs.borders << attackbox
  when 1
  args.outputs.borders << defendbox
  when 2
  args.outputs.borders << itembox
  when 3
  args.outputs.borders << item1box
  when 4
  args.outputs.borders << item2box
  when 5
  args.outputs.borders << item3box
end
 case args.state.select
  when 0
  
  when 1
  args.outputs.borders << [490, 360, 280, 40]
  args.outputs.labels << mylabel(args, 500, 16, "You attacked the enemy")
  opponent_turn args
  
  when 2
  args.outputs.borders << [490, 360, 220, 40]
  args.outputs.labels << mylabel(args, 500, 16, "You choose defend")
  when 3
   args.outputs.borders << [490, 360, 380, 40]	      
   args.outputs.labels << mylabel(args, 500, 16, "Choose the item you want to use")
   args.outputs.labels << [50, 160, "ITEM 1", 4]
   args.outputs.labels << [50, 110, "ITEM 2", 4]
   args.outputs.labels << [50, 60,  "ITEM 3", 4]
end
  pos = args.inputs.mouse.position
  x = 500
  args.state.select ||= 0
  args.state.wait||=0
  args.state.selectitem||=0
  args.state.button||=0 #set it defualt 0 which is attack, by change this, change the position of cursor
  # 0 attack | 1 defend | 2 item | 3 item1 | 4 item2 | 5 item3
  
  #animate cat
  looping_animation_cat args
  looping_animation_jellyfish args
  #keyboard
#  args.state.enter_pressed_at ||= false
# if args.inputs.keyboard.key_down.up and args.state.button > 0
#    args.state.button -=1
#  end
  
#  if args.inputs.keyboard.key_down.up and args.state.button < 2
#    args.state.button +=1
#  end
  
  
#  if args.inputs.keyboard.key_up.enter
#    args.state.enter_pressed_at  = args.state.tick_count
#	args.state.select = 0
#  end
#  if args.state.enter_pressed_at
    
	#attack
#	if args.state.button == 0
#	  args.state.wait += 1
#	  if args.state.wait == 20	
#	  args.state.select = 1       
#	  args.state.enter_pressed_at = false
#	  args.state.wait = 0
#	  end
#	end
	#defend
#	if args.state.button == 1
#	  args.state.select = 2
#	  args.state.wait += 1
#     if args.state.wait == 20	  
#	  args.state.enter_pressed_at = false
#	  args.state.wait = 0
#	  end
#	end
#  end
  #mouse part
#  args.outputs.labels << [pos.x + 10, pos.y + 10, "#{pos}"] # outputs label of coordinates
#  args.outputs.solids << [pos.x -  2, pos.y - 2, 5, 5] # outputs small blackk box placed where mouse is

  if args.inputs.mouse.click
    args.state.last_mouse_click = args.inputs.mouse.click
  end
  if pos.inside_rect? attackbox
	args.state.button = 0
  end
  if pos.inside_rect? defendbox
	args.state.button = 1
  end
  if pos.inside_rect? itembox
	args.state.button = 2
  end
  if pos.inside_rect? item1box and args.state.selectitem != 0
	args.state.button = 3
  end
   if pos.inside_rect? item2box and args.state.selectitem != 0
	args.state.button = 4
  end
   if pos.inside_rect? item3box and args.state.selectitem != 0
	args.state.button = 5
  end
  #attack
  if args.state.last_mouse_click 
    if args.state.last_mouse_click.point.inside_rect? attackbox
	  args.state.select = 1
    end
	#defend
	if args.state.last_mouse_click.point.inside_rect? defendbox 
	  args.state.select = 2
	end 
		
	#item
	if args.state.last_mouse_click.point.inside_rect? itembox 
		   args.state.select = 3
		   args.state.selectitem = 1

	end
	  
	  if args.state.last_mouse_click.point.inside_rect? item1box and args.state.selectitem == 1
		 args.outputs.borders << [490, 360, 200, 40]
		 args.outputs.labels << mylabel(args, x, 16, "You use item 1")
		 args.state.wait+=1
		 args.state.select = 0
		 if args.state.wait == 20
		 args.state.selectitem = 0
		 args.state.button = 0
		 args.state.wait = 0
		 end
		end
	   if args.state.last_mouse_click.point.inside_rect? item2box and args.state.selectitem == 1
		 args.outputs.borders << [490, 360, 200, 40]
		 args.outputs.labels << mylabel(args, x, 16, "You use item 2")
		 args.state.wait+=1
		 args.state.select = 0
		 if args.state.wait == 20
		 args.state.selectitem = 0
		 args.state.button = 0
		 args.state.wait = 0
		 end
		end
	   if args.state.last_mouse_click.point.inside_rect? item3box and args.state.selectitem == 1
		 args.outputs.borders << [490, 360, 200, 40]
		 args.outputs.labels << mylabel(args, x, 16, "You use item 3")		 
		 args.state.wait+=1
		 args.state.select = 0
		 if args.state.wait == 20
		 args.state.selectitem = 0
		 args.state.button = 0
		 args.state.wait = 0
		 end
		end
  end
end

#all the code after this line is copy from sample "\samples\02_input_basics\03_mouse_point_to_rect"
def mylabel args, x, row, message
  [x, row_to_px(args, row), message, font]
end

def font
  [2, 0, 0, 0, 0, 255]
end

def row_to_px args, row_number
  args.grid.top.shift_down(5).shift_down(20 * row_number)
end

def tick_instructions args, text, y = 715
  return if args.state.key_event_occurred
  if args.inputs.mouse.click ||
     args.inputs.keyboard.directional_vector ||
     args.inputs.keyboard.key_down.enter ||
     args.inputs.keyboard.key_down.escape
    args.state.key_event_occurred = true
  end

  args.outputs.debug << [0, y - 50, 1280, 60].solid
  args.outputs.debug << [640, y, text, 1, 1, 255, 255, 255].label
  args.outputs.debug << [640, y - 25, "(click to dismiss instructions)" , -2, 1, 255, 255, 255].label
end

def looping_animation_jellyfish args
#Continues to loop the jellyfish animation

  # 1. When to start the animation.
  start_looping_at = 0

  # 2. The number of pngs that represent the full animation.
  number_of_sprites = 8

  # 3. How long to show each png.
  number_of_frames_to_show_each_sprite = 4

  # 4. Whether the animation should loop once, or forever.
  does_sprite_loop = true

  # Sprite index for jellyfish
  sprite_index = start_looping_at.frame_index number_of_sprites, number_of_frames_to_show_each_sprite, does_sprite_loop

  # Now that we have `sprite_index, we can present the correct file.
  args.outputs.sprites << [800, 500, 200, 200, "sprites/jellyfish_sprite/jellyfish_#{sprite_index}.png"]
end

def looping_animation_cat args
#Continues to loop the cat animation

  # 1. When to start the animation.
  start_looping_at = 0

  # 2. The number of pngs that represent the full animation.
  number_of_sprites = 46

  # 3. How long to show each png.
  number_of_frames_to_show_each_sprite = 3

  # 4. Whether the animation should loop once, or forever.
  does_sprite_loop = true

  # Sprite index for cat
  sprite_index = start_looping_at.frame_index number_of_sprites, number_of_frames_to_show_each_sprite, does_sprite_loop

  # Now that we have `sprite_index, we can present the correct file.
  args.outputs.sprites << [200, 200, 200, 200, "sprites/cat_sprite/Cat_#{sprite_index}.png"]
end

def opponent_turn args
	args.outputs.labels << [580, 350, "Continue",    2]
	
	continue_button = [575, 320, 100, 40, 0, 0, 170]
	case args.state.button
		when 0
			args.outputs.borders << continue_button
	end
  #continue button
  
  # render the button
  args.outputs.borders << args.state.continue_button.border
  args.outputs.labels << args.state.continue_button.label

  # determine if the button has been clicked
  if (args.inputs.mouse.click) && (args.inputs.mouse.point.inside_rect? args.state.continue_button.order)
		args.outputs.labels << mylabel(args, 580, 350, "Opponent has attacked")
  end
end