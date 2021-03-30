#Individual main

def tick args
	background args
	generateRandomNumber args
	outputNumber args
end

#create background
def background args
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
	
	#roll die button
	#black outline
	args.outputs.solids << [490, 50, 300, 200, 0, 0, 0, 255]
	#white box
	args.outputs.solids << [500, 60, 280, 180, 255, 255, 255, 255]
	
	#outputs "Roll Die" on screen
	args.outputs.labels << [550, 170, "Roll Die", 14]
	args.outputs.labels << [520, 120, "Press space to activate", 1]
end

#creates button
def generateRandomNumber args
	args.state.buttonActivated = false
	
	if args.inputs.keyboard.key_down.space
		args.state.buttonActivated = true
		outputNumber args
	end
	
	return if args.state.buttonActivated
end

def outputNumber args
	randomNumber = (rand.mod(6) + 1)
	args.outputs.labels << [550, 140, "You rolled a #{randomNumber}", 14]
end

