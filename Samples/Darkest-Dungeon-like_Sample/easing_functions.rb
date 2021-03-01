def easeIt args, start_val, end_val, start_time
  # define start time and duration of animation
  args.state.start_animate_at = start_time 
  args.state.duration = 30 

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
  
  #choose animation type
  args.state.animation_type = [:quint]

  # Numeric#ease
  progress = args.state.start_animate_at.ease(args.state.duration, args.state.animation_type)

  # Numeric#ease needs to called:
  # 1. On the number that represents the point in time you want to start, and takes two parameters:
  #   a. The first parameter is how long the animation should take.
  #   b. The second parameter represents the functions that need to be called.
  #
  # For example, if I wanted an animate to start 3 seconds in, and last for 10 seconds,
  # and I want to animation to start fast and end slow, I would do:
  # (60 * 3).ease(60 * 10, :flip, :quint, :flip)

  #calculate current value
  calc_val = start_val + (end_val - start_val) * progress
  
  return calc_val
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
