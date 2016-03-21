#! /usr/bin/julia

xmax = parse(Int,ARGS[1])

for x = 3:xmax
  while x > 2
    if iseven(x)
      x = div(x,2)
    else
      x = 3*x+1
    end
   end
end
