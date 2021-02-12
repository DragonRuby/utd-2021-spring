def tick args
  i = 0
  j = 0
  red = 140
  green = 70
  blue = 30

  while j < 6 do 
    while  i < 20 do
      if j == 5 then
        red = 0
        green = 200
        blue = 0
      end

      args.outputs.borders << [(64 * i), (64 * j), 64, 64, red, green, blue]
      i = i + 1
    end

    i=0
    j = j + 1  
  end  
end
