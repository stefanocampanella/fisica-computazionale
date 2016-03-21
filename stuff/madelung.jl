#! /usr/bin/julia

L = parse(Int,ARGS[1])

M = 8*sum([(iseven(i+j+k) ? 1 : -1 )/sqrt(i^2+j^2+k^2) for i = 1:L, j = 1:L, k = 1:L])-6*log(2)

println("The Madelung constant for NaCl is ",M)
