m = 21          # The number of 'space' nodes
n = 401         # The number of 'time' nodes
τ = 10/(n-1)  # Time step size
h = 1/(m-1)     # Space step size

λ = 0.3
τbyh = τ/h
x = linrange(0,1,m)
t = linrange(0,10,n)


α = 0.3+0.1*(1-cos(1))         # Integral of g(x) = 0.3 +0.1sin(x) = 0.3+0.1(1-cos1)
β = #TODO
γ = (1-λ*τ+h*τ/2)
