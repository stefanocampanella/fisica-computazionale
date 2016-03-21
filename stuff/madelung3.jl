#! /usr/bin/julia

const L = parse(Int,ARGS[1])

nrm(i::Int,j::Int,k::Int) = 1.0/sqrt(i^2+j^2+k^2)

function madelung(N::Int)
	M = 0.0
	for i = 1:N-1, j = 1:N-1, k = 1:N-1
		if iseven(i+j+k)
			M += nrm(i,j,k)
		else
			M -= nrm(i,j,k)
		end
	end
	return M
end

println("The Madelung constant for NaCl is ", 8*madelung(L)-6*log(2))
