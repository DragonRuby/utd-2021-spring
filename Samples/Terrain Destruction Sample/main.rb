require 'app/require.rb'

#main runner 
def tick args
  #Running starting here 
  $platformer_physics = PoorManPlatformerPhysics.new

  def tick args
    $platformer_physics.grid    = args.grid
    $platformer_physics.inputs  = args.inputs
    $platformer_physics.state    = args.state
    $platformer_physics.outputs = args.outputs
    $platformer_physics.tick
    tick_instructions args, "Sample app shows platformer collisions. CLICK to place box. ARROW keys to move around. SPACE to jump."
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
end
