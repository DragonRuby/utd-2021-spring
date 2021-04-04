#Stephen Duffy (spd170330) 
#Main individual project

#testing function, basic funtionality



def tick args
	#Initiliazes screenSelect and playerTurn
	args.state.screenSelect ||= 1.1
	args.state.playerTurn ||= 1
	args.state.player_turn_temp ||= 2
	args.state.spacesMoved ||= 0
	args.state.player_won ||= 0
	args.state.Toad_board_movement_style ||= 1
	args.state.Cat_board_movement_style ||= 1
	
	#Initializes measurements used for the sprites throuhgout the program
	args.state.size = 180
	
	#Initializes Toad position
	args.state.ToadXCoord ||= 10
	args.state.ToadYCoord ||= 110
	
	#Initializes Cat position
	args.state.CatXCoord ||= 10
	args.state.CatYCoord ||= 110




	screen_select_test = Integer(args.state.screenSelect)
	if (screen_select_test == 1)
		#Initializes board squares
		initializeBoard args
		board_mode args
	elsif (screen_select_test == 2)
		#Ativates board_mode
		initialize_battle args
		battle_mode args
	else
		args.outputs.labels << mylabel(args, 552, 24, "screen_select_test error")
	end



	#Activates battle_mode if certain conditions are met
	#battle_ready args
	#battle_mode args
end




#Selects the appropraite screen for a given position in Board Mode
def board_mode args
	#Selects a specific screen output function
	case args.state.screenSelect
		when 1.1
			SS1_1 args
		when 1.2
			SS1_2 args
		when 1.3
			#Resets randomNumber
			args.state.randomNumber = 0
			args.state.spacesMoved = 0
			SS1_3 args
		when 1.4
			SS1_4 args
	end
end



#Selects the appropriate screen for a given position in Game Mode
def battle_mode args
	#Selects a specific screen output function
	case args.state.screenSelect
		when 2.1
			SS2_1 args
		when 2.2
			SS2_2 args
		when 2.3
			#Resets randomNumber
			args.state.randomNumber = 0
			args.state.spacesMoved = 0
			SS2_3 args
		when 2.4
			SS2_4 args
		when 2.5
			SS2_5 args
		when 2.6
			SS2_6 args
	end
end



#Initializes board
def initializeBoard args
	#set background white
	args.outputs.solids << [0, 0, 1400, 720, 255, 255, 255]

	#board outline	
	#black outline
	args.outputs.solids << [0, 100, 1280, 200, 0, 0, 0, 255]
	#white box
	args.outputs.solids << [10, 110, 1260, 180, 255, 255, 255, 255]

	#Spaces

	#Row 1:
	#black outline 1
	args.outputs.solids << [0, 100, 200, 200, 0, 0, 0, 255]
	#white box 1
	args.outputs.solids << [10, 110, 180, 180, 255, 255, 255, 255]
	
	#black outline 2
	args.outputs.solids << [200, 100, 200, 200, 0, 0, 0, 255]
	#white box 2
	args.outputs.solids << [210, 110, 180, 180, 255, 255, 255, 255]
	
	#black outline 3
	args.outputs.solids << [400, 100, 200, 200, 0, 0, 0, 255]
	#white box 3
	args.outputs.solids << [410, 110, 180, 180, 255, 255, 255, 255]
	
	#black outline 4
	args.outputs.solids << [600, 100, 200, 200, 0, 0, 0, 255]
	#white box 4
	args.outputs.solids << [610, 110, 180, 180, 255, 255, 255, 255]
	
	#black outline 5
	args.outputs.solids << [800, 100, 200, 200, 0, 0, 0, 255]
	#white box 5
	args.outputs.solids << [810, 110, 180, 180, 255, 255, 255, 255]
	
	#black outline 6
	args.outputs.solids << [1000, 100, 200, 200, 0, 0, 0, 255]
	#white box 6
	args.outputs.solids << [1010, 110, 180, 180, 255, 255, 255, 255]
	
	#black outline 7
	args.outputs.solids << [1200, 100, 200, 200, 0, 0, 0, 255]
	#white box 7
	args.outputs.solids << [1210, 110, 180, 180, 255, 255, 255, 255]

	#Row 2:
	#black outline 8
	args.outputs.solids << [1200, 300, 200, 200, 0, 0, 0, 255]
	#white box 8
	args.outputs.solids << [1210, 310, 180, 180, 255, 255, 255, 255]



	#Row 3:
	#black outline 9
	args.outputs.solids << [0, 500, 200, 200, 0, 0, 0, 255]
	#white box 9
	args.outputs.solids << [10, 510, 180, 180, 255, 255, 255, 255]
	
	#black outline 10
	args.outputs.solids << [200, 500, 200, 200, 0, 0, 0, 255]
	#white box 10
	args.outputs.solids << [210, 510, 180, 180, 255, 255, 255, 255]

	#black outline 11
	args.outputs.solids << [400, 500, 200, 200, 0, 0, 0, 255]
	#white box 11
	args.outputs.solids << [410, 510, 180, 180, 255, 255, 255, 255]

	#black outline 12
	args.outputs.solids << [600, 500, 200, 200, 0, 0, 0, 255]
	#white box 12
	args.outputs.solids << [610, 510, 180, 180, 255, 255, 255, 255]

	#black outline 13
	args.outputs.solids << [800, 500, 200, 200, 0, 0, 0, 255]
	#white box 13
	args.outputs.solids << [810, 510, 180, 180, 255, 255, 255, 255]

	#black outline 14
	args.outputs.solids << [1000, 500, 200, 200, 0, 0, 0, 255]
	#white box 14
	args.outputs.solids << [1010, 510, 180, 180, 255, 255, 255, 255]

	#black outline 15
	args.outputs.solids << [1200, 500, 200, 200, 0, 0, 0, 255]
	#white box 15
	args.outputs.solids << [1210, 510, 180, 180, 255, 255, 255, 255]

	#Row 4:
	#black outline 8
	args.outputs.solids << [0, 300, 200, 200, 0, 0, 0, 255]
	#white box 8
	args.outputs.solids << [10, 310, 180, 180, 255, 255, 255, 255]

	#Displays Toad 
	args.outputs.sprites << [args.state.ToadXCoord, args.state.ToadYCoord, args.state.size, args.state.size, "sprites/Toad.png"]

	#Displays Cat
	args.outputs.sprites << [args.state.CatXCoord, args.state.CatYCoord, args.state.size, args.state.size, "sprites/Cat.png"]	
end




#
def initialize_battle args
	#set background white
	args.outputs.solids << [0, 0, 1400, 720, 255, 255, 255]

	xCoord_player1_battle = 10
	yCoord_player1_battle = 10
	xCoord_player2_battle = 1050
	yCoord_player2_battle = 500

	case args.state.player_turn_temp
	when 1
		#Displays Toad 
		args.outputs.sprites << [xCoord_player1_battle, yCoord_player1_battle, args.state.size, args.state.size, "sprites/Toad.png"]

		#Displays Cat
		args.outputs.sprites << [xCoord_player2_battle, yCoord_player2_battle, args.state.size, args.state.size, "sprites/Cat.png"]	
	when 2
		#Displays Toad 
		args.outputs.sprites << [xCoord_player2_battle, yCoord_player2_battle, args.state.size, args.state.size, "sprites/Toad.png"]

		#Displays Cat
		args.outputs.sprites << [xCoord_player1_battle, yCoord_player1_battle, args.state.size, args.state.size, "sprites/Cat.png"]	
	end
end

#Screen Select Group 1 - Board Mode Screens

#Activates specific display for SS1_1
#This screen simply contains the "Roll" button, and when pressed, turns to SS2
def SS1_1 args
	#Outputs text
	args.outputs.labels << [580, 400, "Roll Die",    4]
	
	#Set roll button position
	rollButton = [560, 340, 150, 100, 0, 0, 0, 255]
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
		args.state.screenSelect = 1.2
	end
end



#Activates specific display for SS1_2
#This screen displays a random number on screen and then displays the character moving across the board
def SS1_2 args
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
			args.state.ToadXCoord, args.state.ToadYCoord, args.state.Toad_board_movement_style = shift_character args, args.state.ToadXCoord, args.state.ToadYCoord, args.state.Toad_board_movement_style

			#Displays Toad 
			args.outputs.sprites << [args.state.ToadXCoord, args.state.ToadYCoord, args.state.size, args.state.size, "sprites/Toad.png"]
		when 2
			#Adds to counter
			args.state.spacesMoved += 1
			#Move Cat one space
			args.state.CatXCoord, args.state.CatYCoord, args.state.Cat_board_movement_style = shift_character args, args.state.CatXCoord, args.state.CatYCoord, args.state.Cat_board_movement_style
			
			#Displays Cat
			args.outputs.sprites << [args.state.CatXCoord, args.state.CatYCoord, args.state.size, args.state.size, "sprites/Cat.png"]
	end

	#After moving characters finished, transition to SS3
	if args.state.spacesMoved == args.state.randomNumber
		args.state.last_mouse_click = nil
		args.state.pos = nil
		args.state.screenSelect = 1.3
	end
end



#Activates specific display for SS1_3
#Once the animation ends, this screen displays a continue button to be clicked: once clicked, turn is changed and 
def SS1_3 args
	#Outputs text
	args.outputs.labels << [580, 400, "Continue",    4]
	
	#Set roll button position
	continueButton = [560, 340, 150, 100, 0, 0, 0, 255]
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
		args.state.screenSelect = 1.1
	end

	#If same position, initiate battle_mode
	battle_ready args, args.state.playerTurn
end



#Activates specific display for SS1_4
#Displays the Game Over screen
def SS1_4 args
	args.state.screenSelect = 1.4
	#black outline
	args.outputs.solids << [560, 50, 150, 100, 0, 0, 0, 255]
	#white box
	args.outputs.solids << [570, 60, 130, 80, 255, 255, 255, 255]
	#Outputs text
	args.outputs.labels << [580, 110, "Game Over",    4]
end



#Screen Select Group 2 - Game Mode Screens

#SS2_1 - If battle initiated, intro animation displayed
def SS2_1 args
	#buffer_countdown
	args.state.screenSelect = 2.2
end



#SS2_2 - Battle Menu displayed 
def SS2_2 args
	#Outputs text
	args.outputs.labels << [445, 110, "Attack",    4]
	args.outputs.labels << [610, 110, "Info",    4]
	args.outputs.labels << [765, 110, "Run",    4]

	#Set roll button position
	attack_button = [410, 50, 150, 100, 0, 0, 0, 255]
	args.outputs.borders << attack_button

	info_button = [560, 50, 150, 100, 0, 0, 0, 255]
	args.outputs.borders << info_button

	run_button = [710, 50, 150, 100, 0, 0, 0, 255]
	args.outputs.borders << run_button

	#Saves last mouse click data
	if args.inputs.mouse.click
		args.state.last_mouse_click = args.inputs.mouse.click
		args.state.pos = args.inputs.mouse.position
	end
	
	#If button clicked, selects certain battle mode menu option
	if args.state.pos.inside_rect? attack_button
		args.state.screenSelect = 2.3
	elsif args.state.pos.inside_rect? info_button
		args.state.screenSelect = 2.4
	elsif args.state.pos.inside_rect? run_button
		args.state.screenSelect = 2.5
	else
	end

	#Resets mouse position
	args.state.last_mouse_click = nil
	args.state.pos = nil
end



#SS2_3 -  Attack option
def SS2_3 args
	randomNumber = (rand(10) + 1)

	if (randomNumber > 7)
		args.state.player_won = 1
	else
		args.state.player_won = 0
	end

	args.state.screenSelect = 2.6
end



#SS2_4 - Info option
def SS2_4 args
	args.outputs.labels << [580, 110, "Info not available yet",    4]
end



#SS2_5 - Run option
def SS2_5 args
	args.outputs.labels << [580, 300, "Run not available yet",    4]
end

#SS2_6 - Attack helper function
def SS2_6 args
	if (args.state.player_won == 1)
		#Outputs text
		args.outputs.labels << [580, 140, "You defeated the enemy!", 4]
		args.outputs.labels << [580, 110, "Nice work!", 4]
	else
		args.outputs.labels << [580, 110, "You lost",    4]	
	end

	#Outputs text
	args.outputs.labels << [580, 400, "Continue",    4]

	#Set roll button position
	continueButton = [560, 340, 150, 100, 0, 0, 0, 255]
	args.outputs.borders << continueButton
	

	
	#Saves last mouse click data
	if args.inputs.mouse.click
		args.state.last_mouse_click = args.inputs.mouse.click
		#Stores position of mouse
		args.state.pos = args.inputs.mouse.position
	end
	
	#If continue button clicked, transitions to SS1
	if args.state.pos.inside_rect? continueButton
		#Resets mouse position
		args.state.last_mouse_click = nil
		args.state.pos = nil

		#Returns to screen select 1
		args.state.screenSelect = 1.1
	end

end



#Generates random number
def generateRandom args
	random = (rand(3) + 1)
	random
end



#Provides a 3 Second buffer
def buffer args
	has_time_elapsed = false
	args.state.time_ticker ||= 3.seconds - args.state.tick_count

	if (args.state.time_ticker  > 0)
		has_time_elapsed = true
		args.state.time_ticker = nil
	end

	has_time_elapsed
end



#Buffer that displays the numbers 3-1 (inclusively) on screen
def buffer_countdown args
	#Code taken from 01_easing_functions
	count_down = 4.seconds - args.state.tick_count
	if count_down > 1
		#args.outputs.labels << [640, 375, "Running: #{args.state.animation_type} in...", 3, 1]
		args.outputs.labels << [640, 345, "%d" % count_down.fdiv(60), 3, 1]
		return true
	end

	return false
end



#Selects correct turn
def pick_turn args
	case args.state.playerTurn
		when 1
			#x-coord + increment Toad
			args.state.ToadXCoord += 182

			if args.state.ToadXCoord == 1102
				args.state.screenSelect = 1.4
			end
		when 2
			#x-coord + increment Cat
			args.state.CatXCoord += 182	

			if args.state.CatXCoord == 1102
				args.state.screenSelect = 1.4
			end
	end
end



#Shift one space to the right by 
def shift_character args, xCoord, yCoord, board_movement_style
	board_movement_style_temp = board_movement_style
	#Determines direction of movement
	if xCoord == 10 && yCoord == 110
		board_movement_style_temp = 1
	elsif xCoord == 1210 && yCoord == 110
		board_movement_style_temp = 2
	elsif xCoord == 1210 && yCoord == 510
		board_movement_style_temp = 3
	elsif xCoord == 10 && yCoord == 510
		board_movement_style_temp = 4
	else
		args.outputs.labels << mylabel(args, 552, 24, "shift_character transition error")
	end

	#Shifts character coordinates
	case board_movement_style_temp
		when 1
			xCoord += 200
		when 2
			yCoord += 200
		when 3
			xCoord -= 200
		when 4
			yCoord -= 200
	end

	return xCoord, yCoord, board_movement_style_temp
end



#Tests if players are on the same spot
def battle_ready args, player_turn
	if args.state.ToadXCoord == args.state.CatXCoord && args.state.ToadYCoord == args.state.CatYCoord
		#Reverse turn
		if player_turn == 1
			args.state.player_turn_temp = 2
		elsif player_turn == 2
			args.state.player_turn_temp = 1
		else
			args.outputs.labels << mylabel(args, 552, 24, "shift_character transition error")
		end

		args.state.screenSelect = 2.1
	end
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



