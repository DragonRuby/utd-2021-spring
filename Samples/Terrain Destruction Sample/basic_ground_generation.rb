def tick args

  i = 0
  j=0

  r = 140
  g = 70
  b = 30

  while j < 6 do 
  while  i < 20 do

  if j == 5 then
  r = 0
  g = 200
  b = 0
  end

  args.outputs.borders << [(64 * i), (64 * j), 64, 64, r, g, b]
  i = i + 1
  end

  i=0
  j = j + 1
  
  end
  
 
end
