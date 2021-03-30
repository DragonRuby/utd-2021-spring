#Stephen Duffy (spd170330) 
#Main individual project

#testing function, basic funtionality



def tick args
	#Initializes board squares
	initializeBoard args
	
	#Initiliazes screenSelect and playerTurn
	args.state.screenSelect ||= 1
	args.state.playerTurn ||= 1
	args.state.spacesMoved ||= 0
	
	#Initializes measurements used for the sprites throuhgout the program
	args.state.size = 80
	
	#Initializes Toad position
	args.state.ToadXCoord ||= 10
	args.state.ToadYCoord ||= 310
	
	#Initializes Cat position
	args.state.CatXCoord ||= 10
	args.state.CatYCoord ||= 391

	#Displays Toad 
	args.outputs.sprites << [args.state.ToadXCoord, args.state.ToadYCoord, args.state.size, args.state.size, "sprites/Toad.png"]

	#Displays Cat
	args.outputs.sprites << [args.state.CatXCoord, args.state.CatYCoord, args.state.size, args.state.size, "sprites/Cat.png"]	

	#Selects specific screen output function
	case args.state.screenSelect
		when 1
			screenSelectOne args
		when 2
			screenSelectTwo args
		when 3
			#Resets randomNumber
			args.state.randomNumber = 0
			args.state.spacesMoved = 0
			screenSelectThree args
		when 4
			#black outline
			args.outputs.solids << [560, 50, 150, 100, 0, 0, 0, 255]
			#white box
			args.outputs.solids << [570, 60, 130, 80, 255, 255, 255, 255]
			#Outputs text
			args.outputs.labels << [580, 110, "Game Over",    4]
	end
end




#Initializes board
def initializeBoard args
	#set background white
	args.outputs.solids << [0, 0, 1280, 720, 255, 255, 255]

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
end



#Activates specific display for SS1
#This screen simply contains the "Roll" button, and when pressed, turns to SS2
def screenSelectOne args
	#Outputs text
	args.outputs.labels << [580, 110, "Roll Die",    4]
	
	#Set roll button position
	rollButton = [560, 50, 150, 100, 0, 0, 0, 255]
	args.outputs.borders << rollButton
		
	args.state.select ||= 0
	args.state.button ||= 0 
	args.state.randomNumber = 0

	#Saves last mouse click data
	if args.inputs.mouse.click
		args.state.last_mouse_click = args.inputs.mouse.click
		args.state.pos = args.inputs.mouse.position
	end
	
	#If roll button clicked, transitions to SS2
	if args.state.pos.inside_rect? rollButton
		args.state.screenSelect = 2
	end
end



#Activates specific display for SS2
#This screen displays a random number on screen and then displays the character moving across the board
def screenSelectTwo args
	#If randomNumber is 0 (not yet defined), generate it
	if args.state.randomNumber == 0
		args.state.randomNumber = generateRandom args
		args.state.spacesMoved = 0
	end 
	
	args.outputs.borders << [490, 205, 280, 40]
	args.outputs.labels << mylabel(args, 552, 24, "You rolled a #{args.state.randomNumber}")
	
	#After generating randomNumber, move characters one space per tick run
	case args.state.playerTurn
		when 1
			#Adds to counter
			args.state.spacesMoved += 1
			#Move Toad one space
			shiftCharacter args
			
			#Displays Toad 
			args.outputs.sprites << [args.state.ToadXCoord, args.state.ToadYCoord, args.state.size, args.state.size, "sprites/Toad.png"]
		when 2
			#Adds to counter
			args.state.spacesMoved += 1
			#Move Cat one space
			shiftCharacter args
			
			#Displays Cat
			args.outputs.sprites << [args.state.CatXCoord, args.state.CatYCoord, args.state.size, args.state.size, "sprites/Cat.png"]
	end
	
	#After moving characters finished, transition to SS3
	if args.state.spacesMoved == args.state.randomNumber
		args.state.last_mouse_click = nil
		args.state.pos = nil
		args.state.screenSelect = 3
	end
end



#Activates specific display for SS3
#Once the animation ends, this screen displays a continue button to be clicked: once clicked, turn is changed and 
def screenSelectThree args
	#Outputs text
	args.outputs.labels << [580, 110, "Continue...",    4]
	
	#Set roll button position
	continueButton = [560, 50, 150, 100, 0, 0, 0, 255]
	args.outputs.borders << continueButton
	

	
	#Saves last mouse click data
	if args.inputs.mouse.click
		args.state.last_mouse_click = args.inputs.mouse.click
		#Stores position of mouse
		args.state.pos = args.inputs.mouse.position
	end
	
	#If continue button clicked, transitions to SS1
	if args.state.pos.inside_rect? continueButton
		if args.state.playerTurn == 1
			args.state.playerTurn = 2
		elsif args.state.playerTurn == 2
			args.state.playerTurn = 1
		else
			args.outputs.labels << mylabel(args, 552, 24, "playerTurn transition error")
		end
		
		#Resets mouse position
		args.state.last_mouse_click = nil
		args.state.pos = nil

		#Returns to screen select 1
		args.state.screenSelect = 1
	end
end



#Generates random number
def generateRandom args
	random = (rand(3) + 1)
	random
end



#Shift one space to the right by 
def shiftCharacter args
	case args.state.playerTurn
		when 1
			#x-coord + increment Toad
			args.state.ToadXCoord += 182

			if args.state.ToadXCoord == 1102
				screenSelectFour args
			end
		when 2
			#x-coord + increment Cat
			args.state.CatXCoord += 182	

			
			if args.state.CatXCoord == 1102
				screenSelectFour args
			end
	end
end



def screenSelectFour args
	args.state.screenSelect = 4
end



def font
	[2, 0, 0, 0, 0, 255]
end



#all the code after this line is copy from sample "\samples\02_input_basics\03_mouse_point_to_rect"
def mylabel args, x, row, message
  [x, row_to_px(args, row), message, font]
end






def row_to_px args, row_number
  args.grid.top.shift_down(5).shift_down(20 * row_number)
end



