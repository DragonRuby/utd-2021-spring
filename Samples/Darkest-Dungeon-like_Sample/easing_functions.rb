def easeIt state, start_val, end_val, start_time, duration=0.5, anim_type=[:quint]
  # define start time and duration of animation
  state.start_animate_at = start_time 
  state.duration = duration.seconds
  state.animation_type = anim_type #choose animation type

  # define type of animations
  # :identity, :quad, :cube, :quart, :quint, :flip

  # Linear is defined as:
  # [:identity]
  
  # Smooth start variations are:
  # [:quad]
  # [:cube]
  # [:quart]
  # [:quint]

  # Linear reversed, and smooth stop are the same as the animations defined above, but reversed:
  # [:flip, :identity]
  # [:flip, :quad, :flip]
  # [:flip, :cube, :flip]
  # [:flip, :quart, :flip]
  # [:flip, :quint, :flip]

  #custom definitions
  # [:smoothest_start]
  # [:smoothest_stop] 
  
  # Numeric#ease
  progress = state.start_animate_at.ease(state.duration, state.animation_type)

  # Ex: animate to start 3 seconds in, and last for 10 seconds,
  # and want animation to start fast and end slow then do:
  # (60 * 3).ease(60 * 10, :flip, :quint, :flip)

  #calculate current value
  calc_val = start_val + (end_val - start_val) * progress
  
  return calc_val
end


def easeSpline state, outputs, duration
  state.duration_spline = duration.seconds
  state.spline = [
    [0.0, 0.33, 0.66, 1.0],
    [1.0, 1.33, 1.66, 2.0],
    [2.0, 2.33, 2.66, 3.0],
    [3.0, 3.33, 3.66, 4.0],
  ]

  state.simulation_tick = state.tick_count % state.duration_spline
  progress = 0.ease_spline_extended state.simulation_tick, state.duration_spline, state.spline
  
  return progress
end 


# you can make own variations of animations using this
module Easing
  # you have access to all the built in functions: identity, flip, quad, cube, quart, quint
  def self.smoothest_start x
    quad(quint(x))
  end

  def self.smoothest_stop x
    flip(quad(quint(flip(x))))
  end

  # this is the source for the existing easing functions
  def self.identity x
    x
  end

  def self.flip x
    1 - x
  end

  def self.quad x
    x * x
  end

  def self.cube x
    x * x * x
  end

  def self.quart x
    x * x * x * x * x
  end

  def self.quint x
    x * x * x * x * x * x
  end
end
