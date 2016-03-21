#! /usr/bin/julia

L = parse(Int,ARGS[1])
M = 0
for i = 1:L-1, j = 1:L-1, k = 1:L-1
#  iseven(i+j+k) ? M += 1/sqrt(i^2+j^2+k^2) : M -= 1/sqrt(i^2+j^2+k^2)
  if iseven(i+j+k)
    M += 1/sqrt(i^2+j^2+k^2)
  else
    M -= 1/sqrt(i^2+j^2+k^2)
  end
end

M = 8*M-6*log(2)

println("The Madelung constant for NaCl is ",M)
