def tick args
  #set background white
  args.outputs.solids << [0, 0, 1280, 720, 255,255,255] 
  #set components
  args.outputs.solids << [0, 0, 1280, 200, 0, 0, 0, 255]
  args.outputs.solids << [10, 10, 1260, 180, 255, 255, 255, 255]
  args.outputs.solids << [980, 0, 300, 200, 0, 0, 0, 255]
  args.outputs.solids << [990, 10, 280, 180, 255, 255, 255, 255]
  
  args.outputs.sprites<< [200, 200, 200, 200, 'sprites/p1.png']#change the file name and path to change the character image
  args.outputs.sprites<< [800, 500, 200, 180, 'sprites/p2.png']#change the file name and path to change the enemy image
  
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
  
#This part shows where is the box that player can click, you can put # in front of them to hide the blue box in game
  args.outputs.borders << attackbox
  args.outputs.borders << defendbox
  args.outputs.borders << itembox
  args.outputs.borders << item1box
  args.outputs.borders << item2box
  args.outputs.borders << item3box
#This part shows where is the box that player can click, you can put # in front of them to hide the blue box in game

  x = 500
  args.state.selectitem||=0

  if args.inputs.mouse.click
    args.state.last_mouse_click = args.inputs.mouse.click
  end
  
  #attack
  if args.state.last_mouse_click 
    if args.state.last_mouse_click.point.inside_rect? attackbox
	  args.outputs.borders << [490, 360, 280, 40]
      args.outputs.labels << mylabel(args, x, 16, "You attacked the enemy")
	 	
		

    end
	#defend
	 if args.state.last_mouse_click.point.inside_rect? defendbox 
	  args.state.select+=1
	 	  args.outputs.borders << [490, 360, 220, 40]
      args.outputs.labels << mylabel(args, x, 16, "You choose defend")
		
		 
	    end 
		
	#item
	  if args.state.last_mouse_click.point.inside_rect? itembox 
	  	  args.outputs.borders << [490, 360, 380, 40]	      
          args.outputs.labels << mylabel(args, x, 16, "Choose the item you want to use")
		   args.outputs.labels << [50, 160, "ITEM 1", 4]
           args.outputs.labels << [50, 110, "ITEM 2", 4]
           args.outputs.labels << [50, 60,  "ITEM 3", 4]
		   args.state.selectitem+=1
	      
	   end
	  if args.state.last_mouse_click.point.inside_rect? item1box and args.state.selectitem != 0
		 args.outputs.borders << [490, 360, 200, 40]
		 args.outputs.labels << mylabel(args, x, 16, "You use item 1")
		 
		 args.state.selectitem-=1
		end
	   if args.state.last_mouse_click.point.inside_rect? item2box and args.state.selectitem != 0
		 args.outputs.borders << [490, 360, 200, 40]
		 args.outputs.labels << mylabel(args, x, 16, "You use item 2")
		 args.state.selectitem-=1
		end
	   if args.state.last_mouse_click.point.inside_rect? item3box and args.state.selectitem != 0
		 args.outputs.borders << [490, 360, 200, 40]
		 args.outputs.labels << mylabel(args, x, 16, "You use item 3")
		 
		 args.state.selectitem-=1
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

