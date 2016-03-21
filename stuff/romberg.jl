
function romberg(f::Function, a::Float64, b::Float64; ɛ = 1e-4)
  divs = 32
  itermax = 20 # 32 * 2^20 ≈ 3 10^6 maximum divisions
  R = Array(Float64,itermax,itermax)
  R[1,1] = mapreduce(f,+,[a + k*(b-a)/divs for k = 1:divs-1])*(b-a)/divs + (f(a) + f(b))/(2.0*divs)
  n = 1
  while n < 2 || abs((R[n,n]-R[n-1,n-1])) > ɛ
    if n >= itermax
      warn("Maximum number of iterations reached")
      break
    end
    n += 1
    divs *= 2
    R[n,1] = mapreduce(f,+,[a + k*(b-a)/divs for k = 1:divs-1])*(b-a)/divs  + (f(a) + f(b))/(2.0*divs)
    #R[n,1] = mapreduce(f,+,linspace(a + (b-a)/divs, b, divs÷2))*(b-a)/divs
    #R[n,1] += R[n-1,1]/2.0
    for i = 2:n
      R[n,i] = R[n,i-1] + (R[n,i-1]-R[n-1,i-1])/(4^(i-1)-1)
    end
  end
  return R[n,n]
end
