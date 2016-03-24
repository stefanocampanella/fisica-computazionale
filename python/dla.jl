#! /usr/bin/julia

using PyPlot
using PyCall

@pyimport matplotlib.cm as cm

# const n = 50 #>1
# const m = 50 #>1
const n = parse(Int64,ARGS[1])
const m = parse(Int64,ARGS[2])
const moves = [(-1,0), (0, 1), (1, 0), (0, -1)]

abstract Source

type Type1Source <: Source
  grid :: Array{Int64,2}
  sitelist :: Array{Tuple{Int64,Int64},1}

  function Type1Source()
    grid = zeros(Int64,2n+1,2m+1)
    grid[n+1,m+1] = 1
    sitelist = findSite(grid)

    new(grid,sitelist)
  end
end

type Type2Source <: Source
  grid :: Array{Int64,2}
  sitelist :: Array{Tuple{Int64,Int64},1}

  function Type2Source()
    grid = zeros(Int64,2n+1,2m+1)
    grid[n-2,m-2:m+4] = grid[n+4,m-2:m+4] = 1
    grid[n-1:n+3,m-2] = grid[n-1:n+3,m+4] = 1
    sitelist = findSite(grid)
    new(grid,sitelist)
  end
end

type Particle
   site :: Tuple{Int64,Int64}

   function Particle(s::Source)
     site = rand(s.sitelist)
     new(site)
   end
end

abstract DLA

type Type1DLA <: DLA
  grid :: Array{Int64,2}
  agegrid :: Array{Int64,2}
  counter :: Int64
  stop :: Bool

  function Type1DLA()
    grid = zeros(Int64,2n+1,2m+1)
    grid[1,:] = grid[:,1] = grid[end,:] = grid[:,end] = 2
    agegrid = zeros(Int64,2n+1,2m+1)
    counter = 1
    new(grid,agegrid,counter,false)
  end
end

type Type2DLA <: DLA
  grid :: Array{Int64,2}
  agegrid :: Array{Int64,2}
  counter :: Int64
  stop :: Bool

  function Type2DLA()
    const seed = [2 2 2; 2 1 2; 2 2 2]
    grid = zeros(Int64,2n+1,2m+1)
    grid[n:n+2,m:m+2] = seed
    agegrid = zeros(Int64,2n+1,2m+1)
    agegrid[n+1,m+1] = 1
    counter = 2
    new(grid,agegrid,counter,false)
  end
end

function moveParticle(p::Particle)
   i,j = rand(moves)
   p.site = p.site[1]+i, p.site[2]+j
end


function findSite(grid::Array{Int64,2})
  indices = find(x -> x == 1, grid)
  return map(x -> ind2sub(grid,x),indices)
end

function getSite(dla::DLA,x::Tuple{Int64,Int64})
  i,j = x
  return dla.grid[i,j]
end

function getSite(dla::DLA,p::Particle)
  i,j = p.site
  return dla.grid[i,j]
end

function updateDLA!(dla::DLA,p::Particle)
  i,j = p.site
  dla.grid[i,j] = 1
  dla.agegrid[i,j] = dla.counter
  dla.counter += 1
end

function inbound(i,j)
  return 0 < i <= 2n+1 && 0 < j <= 2m+1
end

function inbound(p::Particle)
  i,j = p.site
  return inbound(i,j)
end

function updateStickyNeighbors!(dla::DLA,p::Particle)
  x,y = p.site
  for i in [x-1,x,x+1], j in [y-1,y,y+1]
#    if (i != x || j != y) && inbound(i,j) && dla.grid[i,j] == 0
    if (i,j) != (x,y) && inbound(i,j) && dla.grid[i,j] == 0
      dla.grid[i,j] = 2
    end
  end
end

function updateSource!(s::Type1Source,dla::Type1DLA)
end

function updateSource!(s::Type2Source,dla::Type2DLA)

  indices = find(x -> x == 2,dla.grid)
  ii = mod(indices,2n+1) != 0 ? mod(indices,2n+1) : 1
  jj = div(indices,2m+1)+1
  imin, imax = max(1,minimum(ii)-3), min(2n+1,maximum(ii)+3)
  jmin, jmax = max(1,minimum(jj)-3), min(2m+1,maximum(jj)+3)

  s.grid[:,:] = 0
  s.grid[imin,jmin:jmax] = s.grid[imax,jmin:jmax] = 1
  s.grid[imin:imax,jmin] = s.grid[imin:imax,jmax] = 1

  s.sitelist = findSite(s.grid)
end

function evolve(dla::DLA,s::Source)
  # Pick a generation site at random and create there a particle.
  p = Particle(s)
  # Evolve the particle state until it goes on a sticky site or leave the grid.
  while getSite(dla,p) != 2
    moveParticle(p)
    # If the particle is inside the grid then it's also on a sticky site
    if ~inbound(p)
      p = Particle(s)
    end
  end
  # Update the site state, mark as occupied
  updateDLA!(dla,p)
  # Update sticky neighbors sites
  updateStickyNeighbors!(dla,p)
  # Eventually move the sources
  updateSource!(s,dla)
  # Return true if the evolution stops
  dla.stop = any(x -> getSite(dla,x) == 2, s.sitelist)
end

let src = Type2Source(), dla = Type2DLA()
  while ~dla.stop
    evolve(dla,src)
  end

  rainbow = cm.get_cmap("rainbow")
  rainbow[:set_under]("w")

  axis("off")
  imshow(dla.agegrid,interpolation="none",vmin=0.5,cmap=rainbow)
  savefig(ARGS[3])
end
