def tick args
  #setbackground white
  args.outputs.solids << [0, 0, 1280, 720, 255,255,255] 
  #setcomponents
  args.outputs.solids << [0, 0, 1280, 200, 0, 0, 0, 255]
  args.outputs.solids << [10, 10, 1260, 180, 255, 255, 255, 255]
  args.outputs.solids << [980, 0, 300, 200, 0, 0, 0, 255]
  args.outputs.solids << [990, 10, 280, 180, 255, 255, 255, 255]
  #animate cat
  looping_animation_cat args
  
  
  
  #Previous code
  #state.sprite_frame = state.tick_count.idiv(6).mod(16)
  #state.sprite_path = “sprites/sprites/cat_sprite_#{state.sprite_frame}.png”
  #args.outputs.labels << [200, 200, “path: #{state.sprite_path}”, 0, 225, 0]
  #args.outputs.sprites << [200, 200, 200, 200, state.sprite_path]

  #args.outputs.sprites<< [200, 200, 200, 200, 'sprites/cat.png']

end

def looping_animation_cat args
  # Here we define a few local variables that will be sent
  # into the magic function that gives us the correct sprite image
  # over time. There are four things we need in order to figure
  # out which sprite to show.

  # 1. When to start the animation.
  start_looping_at = 0

  # 2. The number of pngs that represent the full animation.
  number_of_sprites = 45

  # 3. How long to show each png.
  number_of_frames_to_show_each_sprite = 2

  # 4. Whether the animation should loop once, or forever.
  does_sprite_loop = true

  # With the variables defined above, we can get a number
  # which represents the sprite to show by calling the `frame_index` function.
  # In this case the number will be between 0, and 5 (you can see the sprites
  # in the ./sprites directory).
  sprite_index = start_looping_at.frame_index number_of_sprites, number_of_frames_to_show_each_sprite, does_sprite_loop

  # Now that we have `sprite_index, we can present the correct file.
  args.outputs.sprites << [200, 200, 200, 200, "sprites/cat_sprite/Cat_#{sprite_index}.png"]
end
