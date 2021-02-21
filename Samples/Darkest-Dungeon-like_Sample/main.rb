require 'app/require.rb'

#main runner 
def tick args
  # The defaults function intitializes the game.
  defaults args

  # After the game is initialized, render it.
  render args

  # After rendering the player should be able to respond to input.
  input args

  # After responding to input, the game performs any additional calculations.
  calc args
end
