def tick args
	#set background white
	args.outputs.solids << [0, 0, 1280, 720, 255,255,255]

	#board outline	
	#black outline
	args.outputs.solids << [0, 300, 1280, 200, 0, 0, 0, 255]
	#white box
	args.outputs.solids << [10, 310, 1260, 180, 255, 255, 255, 255]

	#spaces
	#black outline 1
	args.outputs.solids << [0, 300, 182, 200, 0, 0, 0, 255]
	#white box 1
	args.outputs.solids << [10, 310, 162, 180, 255, 255, 255, 255]
	#black outline 2
	args.outputs.solids << [182, 300, 182, 200, 0, 0, 0, 255]
	#white box 2
	args.outputs.solids << [192, 310, 162, 180, 255, 255, 255, 255]
	#black outline 3
	args.outputs.solids << [364, 300, 182, 200, 0, 0, 0, 255]
	#white box 3
	args.outputs.solids << [374, 310, 162, 180, 255, 255, 255, 255]
	#black outline 4
	args.outputs.solids << [546, 300, 182, 200, 0, 0, 0, 255]
	#white box 4
	args.outputs.solids << [556, 310, 162, 180, 255, 255, 255, 255]
	#black outline 5
	args.outputs.solids << [728, 300, 182, 200, 0, 0, 0, 255]
	#white box 5
	args.outputs.solids << [738, 310, 162, 180, 255, 255, 255, 255]
	#black outline 6
	args.outputs.solids << [910, 300, 182, 200, 0, 0, 0, 255]
	#white box 6
	args.outputs.solids << [920, 310, 162, 180, 255, 255, 255, 255]
	#black outline 7
	args.outputs.solids << [1092, 300, 182, 200, 0, 0, 0, 255]
	#white box 7
	args.outputs.solids << [1102, 310, 162, 180, 255, 255, 255, 255]

	args.outputs.labels << [580, 110, "Roll Die",    4]
	
	args.outputs.sprites << [200, 300, 150, 150, "sprites/Toad.png"]

  
  #set button position

  rollButton = [560, 50, 150, 100, 0, 0, 0, 255]

case args.state.button
  when 0
  args.outputs.borders << rollButton
end
 case args.state.select
  when 0
  
  when 1
  args.outputs.borders << [490, 205, 280, 40]
  args.outputs.labels << mylabel(args, 552, 24, "You rolled a #{rand(6) + 1}")

end
  pos = args.inputs.mouse.position
  args.state.select ||= 0
  args.state.wait||=0
  args.state.selectitem||=0
  args.state.button||=0 #set it defualt 0 which is attack, by change this, change the position of cursor
  # 0 attack | 1 defend | 2 item | 3 item1 | 4 item2 | 5 item3
  
  if args.inputs.mouse.click
    args.state.last_mouse_click = args.inputs.mouse.click
  end
  if pos.inside_rect? rollButton
	args.state.button = 0
  end

  #attack
  if args.state.last_mouse_click 
    if args.state.last_mouse_click.point.inside_rect? rollButton
	  args.state.select = 1
    end
  end
end

#Animate distance formula: 
def traveldistance args, roll, currentDistance
	case num
		when 1
		
		when 2
		
		when 3
		
		when 4
		
		when 5
		
		when 6
		
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



