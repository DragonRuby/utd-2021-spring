def tick args
  defaults args
  render args
  calc args
  inputs args
end


def defaults args
  fiddle args

  args.state.layer_1 ||= []
  args.state.layer_2 ||= []
  args.state.player.x  ||= 0              
  args.state.player.y  ||= 0
  args.state.player.w  ||= 64
  args.state.player.h  ||= 64
  args.state.player.dy ||= 0
  args.state.player.dx ||= 0
  
  args.state.light.w ||= 3840
  args.state.light.h ||= 2160

end

def fiddle args

  args.state.player_max_run_speed = 5
  args.state.player_acceleration = 1
  args.state.player_speed_slowdown_rate = 0.9
end

def render args

  layer_1 = [0, 0, 2000, 1000, 255, 255, 255]
  shadow_layer = [0, 0, 2000, 1000, 0, 0, 0, 170]
  light = [args.state.player.x - 570, args.state.player.y - 350, args.state.light.w, args.state.light.h, 'new_light.png']
  vision = shadow_layer - light

  player = [args.state.player.x, args.state.player.y, args.state.player.w, args.state.player.h, 255, 0, 0]
  test_obj = [300, 300, 64, 64, 0, 255, 0]

  args.outputs.solids << layer_1
  args.outputs.solids << test_obj
  args.outputs.solids << player
  args.outputs.solids << shadow_layer
  args.outputs.solids << vision
  args.outputs.sprites << light

end

def calc args

  args.state.player.x += args.state.player.dx
  args.state.player.y += args.state.player.dy

end

def inputs args

  if args.inputs.keyboard.up
    args.state.player.dy += args.state.player_acceleration
    args.state.player.dy = args.state.player.dy.lesser(args.state.player_max_run_speed)
  elsif args.inputs.keyboard.down
    args.state.player.dy -= args.state.player_acceleration
    args.state.player.dy = args.state.player.dy.greater(-args.state.player_max_run_speed)
  elsif args.inputs.keyboard.left
    args.state.player.dx -= args.state.player_acceleration
    args.state.player.dx = args.state.player.dx.greater(-args.state.player_max_run_speed)
  elsif args.inputs.keyboard.right
    args.state.player.dx += args.state.player_acceleration
    args.state.player.dx = args.state.player.dx.lesser(args.state.player_max_run_speed)
  else
    args.state.player.dy *= args.state.player_speed_slowdown_rate
    args.state.player.dx *= args.state.player_speed_slowdown_rate
  end
end
