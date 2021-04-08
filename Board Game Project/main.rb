#Stephen Duffy (spd170330) 
#Main individual project

#testing function, basic funtionality
#Canvas is 1280x720



def tick args
	#Initiliazes screenSelect and playerTurn
	args.state.screenSelect ||= 1.1
	args.state.playerTurn ||= 1
	args.state.player_turn_temp ||= 2
	args.state.spacesMoved ||= 0
	args.state.Toad_board_movement_style ||= 1
	args.state.Cat_board_movement_style ||= 1

	#Holds value of HP for each character
	args.state.total_HP = 10
	args.state.Toad_HP ||= 10
	args.state.Cat_HP ||= 10

	#Counts the number of laps for each player
	args.state.Toad_laps ||= 0
	args.state.Cat_laps ||= 0
	
	#Initializes measurements used for the sprites throuhgout the program
	args.state.size = 180
	
	#Initializes Toad position
	#50 180
	args.state.ToadXCoord ||= 50
	args.state.ToadYCoord ||= 110
	
	#Initializes Cat position
	args.state.CatXCoord ||= 50
	args.state.CatYCoord ||= 110

	#Damage bars
	args.state.damagebox_Player1 ||= 0
	args.state.damagebox_Player2 ||= 0


	
	screen_select_test = Integer(args.state.screenSelect)

	if args.state.screenSelect == 2.1
		screen_select_test = 3
	end
	
	if (screen_select_test == 1)
		#Initializes board squares
		initializeBoard args
		board_mode args
	elsif (screen_select_test == 2)
		#Ativates board_mode
		initialize_battle args
		battle_mode args
	else
		battle_mode args
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
	args.outputs.solids << [0, 0, 1280, 720, 255, 255, 255]

	#board outline	
	#black outline
	#args.outputs.solids << [40, 100, 1280, 200, 0, 0, 0, 255]
	#white box
	#args.outputs.solids << [10, 110, 1260, 180, 255, 255, 255, 255]

	#Spaces

	#Row 1:
	#black outline 1
	args.outputs.solids << [40, 100, 200, 200, 0, 0, 0, 255]
	#white box 1
	args.outputs.solids << [50, 110, 180, 180, 255, 255, 255, 255]
	
	#black outline 2
	args.outputs.solids << [240, 100, 200, 200, 0, 0, 0, 255]
	#white box 2
	args.outputs.solids << [250, 110, 180, 180, 255, 255, 255, 255]
	
	#black outline 3
	args.outputs.solids << [440, 100, 200, 200, 0, 0, 0, 255]
	#white box 3
	args.outputs.solids << [450, 110, 180, 180, 255, 255, 255, 255]
	
	#black outline 4
	args.outputs.solids << [640, 100, 200, 200, 0, 0, 0, 255]
	#white box 4
	args.outputs.solids << [650, 110, 180, 180, 255, 255, 255, 255]
	
	#black outline 5
	args.outputs.solids << [840, 100, 200, 200, 0, 0, 0, 255]
	#white box 5
	args.outputs.solids << [850, 110, 180, 180, 255, 255, 255, 255]
	
	#black outline 6
	args.outputs.solids << [1040, 100, 200, 200, 0, 0, 0, 255]
	#white box 6
	args.outputs.solids << [1050, 110, 180, 180, 255, 255, 255, 255]

	#Row 2:
	#black outline 8
	args.outputs.solids << [1040, 300, 200, 200, 0, 0, 0, 255]
	#white box 8
	args.outputs.solids << [1050, 310, 180, 180, 255, 255, 255, 255]

	#Row 3:
	#black outline 9
	args.outputs.solids << [40, 500, 200, 200, 0, 0, 0, 255]
	#white box 9
	args.outputs.solids << [50, 510, 180, 180, 255, 255, 255, 255]
	
	#black outline 10
	args.outputs.solids << [240, 500, 200, 200, 0, 0, 0, 255]
	#white box 10
	args.outputs.solids << [250, 510, 180, 180, 255, 255, 255, 255]

	#black outline 11
	args.outputs.solids << [440, 500, 200, 200, 0, 0, 0, 255]
	#white box 11
	args.outputs.solids << [450, 510, 180, 180, 255, 255, 255, 255]

	#black outline 12
	args.outputs.solids << [640, 500, 200, 200, 0, 0, 0, 255]
	#white box 12
	args.outputs.solids << [650, 510, 180, 180, 255, 255, 255, 255]

	#black outline 13
	args.outputs.solids << [840, 500, 200, 200, 0, 0, 0, 255]
	#white box 13
	args.outputs.solids << [850, 510, 180, 180, 255, 255, 255, 255]

	#black outline 14
	args.outputs.solids << [1040, 500, 200, 200, 0, 0, 0, 255]
	#white box 14
	args.outputs.solids << [1050, 510, 180, 180, 255, 255, 255, 255]

	#Row 4:
	#black outline 8
	args.outputs.solids << [40, 300, 200, 200, 0, 0, 0, 255]
	#white box 8
	args.outputs.solids << [50, 310, 180, 180, 255, 255, 255, 255]

	#Displays Toad 
	args.outputs.sprites << [args.state.ToadXCoord, args.state.ToadYCoord, args.state.size, args.state.size, "sprites/Toad.png"]

	#Displays Cat
	args.outputs.sprites << [args.state.CatXCoord, args.state.CatYCoord, args.state.size, args.state.size, "sprites/Cat.png"]	
end




#Initializes battle layout
def initialize_battle args
	#set background white
	args.outputs.solids << [0, 0, 1280, 720, 255, 255, 255]

	xCoord_player1_battle = 70
	yCoord_player1_battle = 150
	xCoord_player2_battle = 970
	yCoord_player2_battle = 500

	case args.state.player_turn_temp
		when 1
			#Character Display --------------
			#Displays Toad 
			args.outputs.sprites << [xCoord_player1_battle, yCoord_player1_battle, args.state.size, args.state.size, "sprites/Toad.png"]
			#Displays Cat
			args.outputs.sprites << [xCoord_player2_battle, yCoord_player2_battle, args.state.size, args.state.size, "sprites/Cat.png"]
			
			#Player 1 healthbar -----------------
			#black outline for healthbar - Player 1
			args.outputs.solids << [70, 120, 210, 20, 0, 0, 0, 255]
			#white box for healthbar - Player 1
			args.outputs.solids << [75, 125, 200, 10, 15, 255, 111, 255]

			#Player 2 healthbar
			#black outline for healthbar - Player 2
			args.outputs.solids << [965, 480, 210, 20, 0, 0, 0, 255]
			#white box for healthbar - Player 2
			args.outputs.solids << [970, 485, 200, 10, 15, 255, 111, 255]

			#Damage dealt multipliers applied
			damage_player1 = 20 * Integer(args.state.damagebox_Player1)
			damage_player2 = 20 * Integer(args.state.damagebox_Player2)

			#Sets a max damage dealt
			if damage_player1 > 200
				damage_player1 = 200
			end

			if damage_player2 > 200
				damage_player2 = 200
			end

			#red box for damagebar - Player 1
			args.outputs.solids << [(275 - damage_player1), 125, damage_player1, 10, 250, 24, 51, 255]
			#red box for damagebar - Player 2
			args.outputs.solids << [(1170 - damage_player2), 485, damage_player2, 10, 250, 24, 51, 255]

			#HP Numbers Output - Player 1
			args.outputs.labels << [10, 140, "#{args.state.Toad_HP}/#{args.state.total_HP}", 0]
			#HP Numbers Output - Player 2
			args.outputs.labels << [900, 500, "#{args.state.Cat_HP}/#{args.state.total_HP}", 0]
		when 2
			#Displays Toad 
			args.outputs.sprites << [xCoord_player2_battle, yCoord_player2_battle, args.state.size, args.state.size, "sprites/Toad.png"]
			#Displays Cat
			args.outputs.sprites << [xCoord_player1_battle, yCoord_player1_battle, args.state.size, args.state.size, "sprites/Cat.png"]	
				
			#Player 1 healthbar
			#black outline for healthbar - Player 1
			args.outputs.solids << [965, 480, 210, 20, 0, 0, 0, 255]
			#white box for healthbar - Player 1
			args.outputs.solids << [970, 485, 200, 10, 15, 255, 111, 255]

			#Player 2 healthbar
			#black outline for healthbar - Player 2
			args.outputs.solids << [70, 120, 210, 20, 0, 0, 0, 255]
			#white box for healthbar - Player 2
			args.outputs.solids << [75, 125, 200, 10, 15, 255, 111, 255]

			#Damage dealt multipliers applied
			damage_player1 = 20 * Integer(args.state.damagebox_Player1)
			damage_player2 = 20 * Integer(args.state.damagebox_Player2)

			#Sets a max damage dealt
			if damage_player1 > 200
				damage_player1 = 200
			end

			if damage_player2 > 200
				damage_player2 = 200
			end

			#red box for damagebar - Player 1
			args.outputs.solids << [(1170 - damage_player1), 485, damage_player1, 10, 250, 24, 51, 255]
			#red box for damagebar - Player 2
			args.outputs.solids << [(275 - damage_player2), 125, damage_player2, 10, 250, 24, 51, 255]

			#HP Numbers Output - Player 2
			args.outputs.labels << [10, 140, "#{args.state.Cat_HP}/#{args.state.total_HP}", 0]
			#HP Numbers Output - Player 1
			args.outputs.labels << [900, 500, "#{args.state.Toad_HP}/#{args.state.total_HP}", 0]
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
	
	args.outputs.borders << [540, 365, 200, 40]
	args.outputs.labels << [547, 397, "You rolled a #{args.state.randomNumber}",    4]
	
	args.state.tick_timer ||= args.state.tick_count

	#Waits two seconds
	if args.state.spacesMoved !=args.state.randomNumber && args.state.tick_count >= (args.state.tick_timer + 30)
		#After generating randomNumber, move characters one space per tick run
		case args.state.playerTurn
			when 1
				#Adds to counter
				args.state.spacesMoved += 1
				#Move Toad one space
				args.state.ToadXCoord, args.state.ToadYCoord, args.state.Toad_board_movement_style = shift_character args, args.state.ToadXCoord, args.state.ToadYCoord, args.state.Toad_board_movement_style, args.state.Toad_laps

				#Displays Toad 
				args.outputs.sprites << [args.state.ToadXCoord, args.state.ToadYCoord, args.state.size, args.state.size, "sprites/Toad.png"]
			when 2
				#Adds to counter
				args.state.spacesMoved += 1
				#Move Cat one space
				args.state.CatXCoord, args.state.CatYCoord, args.state.Cat_board_movement_style = shift_character args, args.state.CatXCoord, args.state.CatYCoord, args.state.Cat_board_movement_style, args.state.Cat_laps
				
				#Displays Cat
				args.outputs.sprites << [args.state.CatXCoord, args.state.CatYCoord, args.state.size, args.state.size, "sprites/Cat.png"]
		end

		args.state.tick_timer = args.state.tick_count
	end

	#After moving characters finished, transition to SS3
	if args.state.spacesMoved == args.state.randomNumber && args.state.tick_count >= (args.state.tick_timer + 60)
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
			args.outputs.labels << mylabel(args, 552, 24, "playerTurn transition")
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
	args.state.tick_timer ||= args.state.tick_count

	if  args.state.tick_count >= (args.state.tick_timer + 20) && args.state.tick_count < (args.state.tick_timer + 40)
		#white screen
		args.outputs.solids << [0, 0, 1280, 720, 255, 255, 255]
		args.outputs.labels << my_red_label(args, 605, 14, "3")
	end
	if args.state.tick_count >= (args.state.tick_timer + 40) && args.state.tick_count < (args.state.tick_timer + 60)
		#black screen
		args.outputs.solids << [0, 0, 1280, 720, 0, 0, 0]
		args.outputs.labels << my_red_label(args, 605, 14, "3")
	end
	if args.state.tick_count >= (args.state.tick_timer + 60) && args.state.tick_count < (args.state.tick_timer + 80)
		#white screen
		args.outputs.solids << [0, 0, 1280, 720, 255, 255, 255]
		args.outputs.labels << my_red_label(args, 605, 14, "3")
	end
	if args.state.tick_count >= (args.state.tick_timer + 80) && args.state.tick_count < (args.state.tick_timer + 100)
		#black screen
		args.outputs.solids << [0, 0, 1280, 720, 0, 0, 0]
		args.outputs.labels << my_red_label(args, 605, 14, "3")
	end
	if args.state.tick_count >= (args.state.tick_timer + 100) && args.state.tick_count < (args.state.tick_timer + 120)
		#white screen
		args.outputs.solids << [0, 0, 1280, 720, 255, 255, 255]
		args.outputs.labels << my_red_label(args, 605, 14, "2")
	end
	if args.state.tick_count >= (args.state.tick_timer + 120) && args.state.tick_count < (args.state.tick_timer + 140)
		#black screen
		args.outputs.solids << [0, 0, 1280, 720, 0, 0, 0]
		args.outputs.labels << my_red_label(args, 605, 14, "2")
	end
	if args.state.tick_count >= (args.state.tick_timer + 140) && args.state.tick_count < (args.state.tick_timer + 160)
		#white screen
		args.outputs.solids << [0, 0, 1280, 720, 255, 255, 255]
		args.outputs.labels << my_red_label(args, 605, 14, "2")
	end
	if args.state.tick_count >= (args.state.tick_timer + 160) && args.state.tick_count < (args.state.tick_timer + 180)
		#black screen
		args.outputs.solids << [0, 0, 1280, 720, 0, 0, 0]
		args.outputs.labels << my_red_label(args, 605, 14, "2")
	end
	if args.state.tick_count >= (args.state.tick_timer + 180) && args.state.tick_count < (args.state.tick_timer + 200)
		#white screen
		args.outputs.solids << [0, 0, 1280, 720, 255, 255, 255]
		args.outputs.labels << my_red_label(args, 605, 14, "1")
	end
	if args.state.tick_count >= (args.state.tick_timer + 200) && args.state.tick_count < (args.state.tick_timer + 220)
		#black screen
		args.outputs.solids << [0, 0, 1280, 720, 0, 0, 0]
		args.outputs.labels << my_red_label(args, 605, 14, "1")
	end
	if args.state.tick_count >= (args.state.tick_timer + 220) && args.state.tick_count < (args.state.tick_timer + 240)
		#white screen
		args.outputs.solids << [0, 0, 1280, 720, 255, 255, 255]
		args.outputs.labels << my_red_label(args, 605, 14, "1")
	end
	if args.state.tick_count >= (args.state.tick_timer + 240) && args.state.tick_count < (args.state.tick_timer + 260)
		#black screen
		args.outputs.solids << [0, 0, 1280, 720, 0, 0, 0]
		args.outputs.labels << my_red_label(args, 605, 14, "1")
	end

	#After moving characters finished, transition to SS2_2
	if args.state.tick_count >= (args.state.tick_timer + 260)
		args.state.tick_timer = nil
		args.state.screenSelect = 2.2
	end
end



#SS2_2 - Battle Menu displayed 
def SS2_2 args
	#Outputs text
	args.outputs.labels << [450, 110, "Attack",    4]
	args.outputs.labels << [615, 110, "Info",    4]
	args.outputs.labels << [770, 110, "Run",    4]

	#Set roll button position
	attack_button = [415, 50, 150, 100, 0, 0, 0, 255]
	args.outputs.borders << attack_button

	info_button = [565, 50, 150, 100, 0, 0, 0, 255]
	args.outputs.borders << info_button

	run_button = [715, 50, 150, 100, 0, 0, 0, 255]
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
	#Resets time ticker for buffers
	args.state.tick_timer = nil
	#Resets random number
	args.state.randomNumber = 0
end



#SS2_3 -  Attack option
def SS2_3 args
	#Generates random number	
	if args.state.randomNumber == 0
		args.state.randomNumber = rand(10) + 1
	end

	#Time ticker for buffer
	args.state.tick_timer ||= args.state.tick_count

	if (args.state.randomNumber > 2)
		if args.state.player_turn_temp == 1
			args.state.damage_calculation_temp ||= (rand(3)+2)
			args.outputs.labels << [490, 300, "Player 1 dealt #{args.state.damage_calculation_temp} damage!",    4]
			
			if args.state.tick_count >= (args.state.tick_timer + 120)
				args.state.damagebox_Player2 += args.state.damage_calculation_temp
				args.state.Cat_HP -= args.state.damage_calculation_temp
				args.state.tick_timer = nil
				args.state.randomNumber = nil
				args.state.damage_calculation_temp = nil
				args.state.screenSelect = 2.6
			end
		elsif args.state.player_turn_temp == 2
			args.state.damage_calculation_temp ||= (rand(3)+2)
			args.outputs.labels << [490, 300, "Player 2 dealt #{args.state.damage_calculation_temp} damage!",    4]
			
			if args.state.tick_count >= (args.state.tick_timer + 120)
				args.state.damagebox_Player1 += args.state.damage_calculation_temp
				args.state.Toad_HP -= args.state.damage_calculation_temp
				args.state.tick_timer = nil
				args.state.randomNumber = nil
				args.state.damage_calculation_temp = nil
				args.state.screenSelect = 2.6
			end
		end
	else
		if args.state.player_turn_temp == 1
			args.outputs.labels << [535, 300, "Player 1 missed!",    4]
		elsif args.state.player_turn_temp == 2
			args.outputs.labels << [535, 300, "Player 2 missed!",    4]
		end

		if args.state.tick_count >= (args.state.tick_timer + 120)
			args.state.tick_timer = nil
			
			args.state.randomNumber = nil
			args.state.damage_calculation_temp = nil

			if args.state.player_turn_temp == 1
				args.state.player_turn_temp = 2
			elsif args.state.player_turn_temp == 2
				args.state.player_turn_temp = 1
			else
			end

			args.state.screenSelect = 2.2
		end
	end
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
	#Starts buffer for timer
	args.state.tick_timer ||= args.state.tick_count

	#If one player wins
	if (args.state.Cat_HP < 1)
		#Toad wins
		#Outputs text
		args.outputs.labels << [550, 300, "Player 1 wins!", 4]

		#Outputs continue button
		if args.state.tick_count >= (args.state.tick_timer + 120)
			#Outputs text
			args.outputs.labels << [590, 110, "Continue",    4]

			#Set roll button position
			continueButton = [565, 50, 150, 100, 0, 0, 0, 255]
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
				args.state.Toad_HP = 10
				args.state.Cat_HP = 10
				args.state.damagebox_Player1 = 0
				args.state.damagebox_Player2 = 0
	
				args.state.playerTurn = 1

				#Returns to screen select 1
				args.state.screenSelect = 1.1
			end
		end
	elsif (args.state.Toad_HP < 1)
		#Cat wins
		#Outputs text
		args.outputs.labels << [550, 300, "Player 2 wins!", 4]

		#Outputs continue button
		if args.state.tick_count >= (args.state.tick_timer + 120)
			#Outputs text
			args.outputs.labels << [590, 110, "Continue",    4]

			#Set roll button position
			continueButton = [565, 50, 150, 100, 0, 0, 0, 255]
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
				args.state.Toad_HP = 10
				args.state.Cat_HP = 10
				args.state.damagebox_Player1 = 0
				args.state.damagebox_Player2 = 0
	
				args.state.playerTurn = 2

				#Returns to screen select 1
				args.state.screenSelect = 1.1
			end
		end
	else
		#Neither has died yet, continue to game menu
		#Outputs text
		args.outputs.labels << [590, 110, "Continue",    4]

		#Set roll button position
		continueButton = [565, 50, 150, 100, 0, 0, 0, 255]
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

			if args.state.player_turn_temp == 1
				args.state.player_turn_temp = 2
			elsif args.state.player_turn_temp == 2
				args.state.player_turn_temp = 1
			else
				args.outputs.labels << mylabel(args, 552, 24, "playerTurn transition in SS2_6")
			end

			#Returns to screen select 1
			args.state.screenSelect = 2.2
		end
	end


end



#Generates random number
def generateRandom args
	random = (rand(6) + 1)
	random
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
def shift_character args, xCoord, yCoord, board_movement_style, total_laps
	board_movement_style_temp = board_movement_style
	#Determines direction of movement
	if xCoord == 50 && yCoord == 110
		board_movement_style_temp = 1
		total_HP += 1
	elsif xCoord == 1050 && yCoord == 110
		board_movement_style_temp = 2
	elsif xCoord == 1050 && yCoord == 510
		board_movement_style_temp = 3
	elsif xCoord == 50 && yCoord == 510
		board_movement_style_temp = 4
	else
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

	return xCoord, yCoord, board_movement_style_temp, total_laps
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

		args.state.tick_timer = nil
		args.state.screenSelect = 2.1
	end
end



def font
	[2, 0, 0, 0, 0, 255]
end


def red_font
	[70, 70, 255, 78, 40, 255]
end


#all the code after this line is copy from sample "\samples\02_input_basics\03_mouse_point_to_rect"
def mylabel args, x, row, message
  [x, row_to_px(args, row), message, font]
end



def my_red_label args, x, row, message
	[x, row_to_px(args, row), message, red_font]
end



def row_to_px args, row_number
  args.grid.top.shift_down(5).shift_down(20 * row_number)
end
