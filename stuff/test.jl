#! /usr/bin/julia

let  M_PI = Float64(pi), divs = Int(1e6)
	sum = 0
	for x in linspace(0,M_PI,divs)
		sum += sin(x)
	end
	println(sum*M_PI/divs)
end
