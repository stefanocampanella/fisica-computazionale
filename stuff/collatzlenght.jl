#! /usr/bin/julia
using PyPlot

#const Nmax = parse(Int,ARGS[1])
#const bins = parse(Int,ARGS[2])

const Nmax = 4000
const bins = 20

function collatzLenght(N::Int)
  i = N
  j = 2
  if N == 1
    return 0
  elseif N == 2
    return 1
  else
    while i > 2
      if iseven(i)
        i = div(i,2)
      else
        i = 3*i+1
      end
      j+=1
    end
    return j
  end
end

function collatzLenghtSeq(N::Int)
  collatzLenghtArray = Array(Int,Nmax)

  @simd for i = 1:N
    #@inbounds collatzLenghtArray[i] = collatzLenght(i)
    collatzLenghtArray[i] = ccall((:collatz_lenght,"./collatz.so"),Int,(Int,),i)
  end

  return collatzLenghtArray
end

collatzLenghtSeqData = collatzLenghtSeq(Nmax)

## Plotting Data
figure("collatz_histogram")#,figsize=(15,10))
#axes()
plt[:hist](collatzLenghtSeqData, bins,
               normed=1,
               histtype="bar",
               rwidth=0.9)
grid("on")
xlabel("Collatz Sequence Lenght")
ylabel("Number of counts")
title("Collatz Sequence Lenght Histogram")
savefig("collatz_histogram.pdf")
plt[:close]()

figure("collatz_scatterplot")#,figsize=(15,10))
scatter(1:Nmax,collatzLenghtSeqData)
grid("on")
xlabel("Seed N")
ylabel("Collatz Sequence Lenght")
title("Collatz Sequence Lenght Plot")
savefig("collatz_scatterplot.pdf")
plt[:close]()
