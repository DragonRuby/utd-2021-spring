require 'app/require.rb'

#main runner 
def tick args
  #Running starting here 
  $platformer_physics = Platform_Physics_And_Destruction.new

  def tick args
    $platformer_physics.grid      = args.grid
    $platformer_physics.inputs    = args.inputs
    $platformer_physics.state     = args.state
    $platformer_physics.outputs   = args.outputs
    $platformer_physics.tick
    tick_instructions args, "Sample app shows platformer collisions and destruction."
  end

  def tick_instructions args, text, y = 715
    return if args.state.key_event_occurred
    if args.inputs.mouse.click ||
        args.inputs.keyboard.directional_vector ||
        args.inputs.keyboard.key_down.enter ||
        args.inputs.keyboard.key_down.escape
      args.state.key_event_occurred = true
    end

    args.outputs.debug << [0, y - 75, 1280, 85].solid
    args.outputs.debug << [640, y, text, 1, 1, 255, 255, 255].label
    args.outputs.debug << [640, y - 25, "ARROW keys to move around. SPACE to jump." , -2, 1, 255, 255, 255].label
    args.outputs.debug << [640, y - 50, "Debug: W,A,S,D or CLICK to place or remove a box" , -2, 1, 255, 255, 255].label
  end
end
