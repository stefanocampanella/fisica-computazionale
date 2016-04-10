#! /usr/bin/julia

module DLAProcess

export DLA, Type1DLA, Type1Source, Source, Type2DLA, Type2Source, evolve!

const moves = [(-1,0), (0, 1), (1, 0), (0, -1)]

abstract Source

type Type1Source <: Source
	grid :: Array{Int,2}
	sitelist :: Array{Tuple{Int,Int},1}

	function Type1Source(n,m)
		grid = zeros(Int,2n+1,2m+1)
		grid[n+1,m+1] = 1
		sitelist = [(n+1,m+1)]
		new(grid,sitelist)
	end
end

type Type2Source <: Source
	grid :: Array{Int,2}
	sitelist :: Array{Tuple{Int,Int},1}

	function Type2Source(n,m)
		const seed = [1 1 1 1 1; 1 0 0 0 1; 1 0 0 0 1; 1 0 0 0 1; 1 1 1 1 1]
		grid = zeros(Int,2n+1,2m+1)
		grid[n-2:n+2,m-2:m+2] = seed
		sitelist = fenceTuples(n-1,n+1,m-1,m+1)
		new(grid,sitelist)
	end
end

abstract DLA

type Type1DLA <: DLA
	grid :: Array{Int,2}
	agegrid :: Array{Int,2}
	counter :: Int
	stop :: Bool

	function Type1DLA(n,m)
		grid = zeros(Int,2n+1,2m+1)
		grid[1,:] = grid[:,1] = grid[end,:] = grid[:,end] = 2
		agegrid = zeros(Int,2n+1,2m+1)
		counter = 1
		new(grid,agegrid,counter,false)
	end
end

type Type2DLA <: DLA
	grid :: Array{Int,2}
	agegrid :: Array{Int,2}
	counter :: Int
	stop :: Bool

	function Type2DLA(n,m)
		const seed = [2 2 2; 2 1 2; 2 2 2]
		grid = zeros(Int,2n+1,2m+1)
		grid[n:n+2,m:m+2] = seed
		agegrid = zeros(Int,2n+1,2m+1)
		agegrid[n+1,m+1] = 1
		counter = 2
		new(grid,agegrid,counter,false)
	end
end

function fenceTuples(i::Int,n1,n2,m1,m2)
	Δm = m2-m1+1
	Δn = n2-n1+1
	if i <= Δm
		return (n1,m1+i-1)
	elseif i <= Δm+Δn
		return (n1+i-Δm-1,m2)
	elseif i <= 2Δm+Δn
		return (n2,m2-(i-Δm-Δn-1))
	else
		return (n2-(i-2Δm-Δn-1),m1)
	end
end

function fenceTuples(n1,n2,m1,m2)
ft = Array{Tuple{Int,Int}}(2*(n2-n1+m2-m1))
	for i = 1:2*(n2-n1+m2-m1)
		ft[i] = fenceTuples(i,n1,n2,m1,m2)
	end
	return ft
end

function updateDLA!(dla::DLA,i,j)
	dla.grid[i,j] = 1
	dla.agegrid[i,j] = dla.counter
	dla.counter += 1

	for n in [i-1,i,i+1], k in [j-1,j,j+1]
		if (n,k) != (i,j) && inbound(dla,n,k) && dla.grid[n,k] == 0
			dla.grid[n,k] = 2
		end
	end
end

function inbound(dla::DLA,i,j)
	n, m = size(dla.grid)
	return 0 < i <= n && 0 < j <= m
end

function updateSource!(s::Type1Source,dla::Type1DLA)
end

function updateSource!(s::Type2Source,dla::Type2DLA)
	n, m = size(dla.grid)
	n1 = n2 = div(n,2)
	m1 = m2 = div(m,2)
	for i = 1:n, j = 1:m
		if dla.grid[i,j] == 2
			n1 = i < n1 ? i : n1
			n2 = i > n2 ? i : n2
			m1 = j < m1 ? j : m1
			m2 = j > m2 ? j : m2
		end
	end
	n1, n2 = max(1,n1-1), min(n,n2+1)
	m1, m2 = max(1,m1-1), min(m,m2+1)

	s.grid[:,:] = 0
	s.grid[n1,m1:m2] = s.grid[n2,m1:m2] = 1
	s.grid[n1:n2,m1] = s.grid[n1:n2,m2] = 1
	s.sitelist = fenceTuples(n1,n2,m1,m2)
end

function evolve!(dla::DLA,s::Source)
	# Pick a generation site at random and create there a particle.
	i,j = rand(s.sitelist)
	# Evolve the particle state until it goes on a sticky site.
	while dla.grid[i,j] != 2
		di, dj = rand(moves)
		i += di
		j += dj
		if ~inbound(dla,i,j)
			i, j = rand(s.sitelist)
		end
	end
	# Update the site state (mark them as occupied) and update sticky neighbors.
	updateDLA!(dla,i,j)
	# Eventually move the sources
	updateSource!(s,dla)
	# Return true if the evolution stops
	for (i,j) in s.sitelist
		if dla.grid[i,j] == 2
			dla.stop = true
			break
		end
	end
end

end

using DLAProcess
using PyPlot
using PyCall

@pyimport matplotlib.cm as cm

function draw(dla::DLA,filename::AbstractString)
	rainbow = cm.get_cmap("rainbow")
	rainbow[:set_under]("w")

	axis("off")
	imshow(dla.agegrid,interpolation="none",vmin=0.5,cmap=rainbow)
	savefig(filename)
end

const n = parse(Int,ARGS[1])
const m = parse(Int,ARGS[2])

let src = Type2Source(n,m), dla = Type2DLA(n,m)
	while ~dla.stop
		evolve!(dla,src)
	end
	draw(dla,ARGS[3])
end
