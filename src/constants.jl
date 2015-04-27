m = 21          # The number of 'space' nodes
n = 401         # The number of 'time' nodes
τ = 10/(n-1)  # Time step size
h = 1/(m-1)     # Space step size

λ = 0.3
π = 3.14159265359
x = linrange(0,1,m)'
t = linrange(0,10,n)'

α = 0.3+0.1*(1-cos(1))         # Integral of g(x) = 0.3 +0.1sin(x) = 0.3+0.1(1-cos1)
β = zeros(m,m)
γ = (1-λ*τ+h*τ/2)

optv = 0.85 + 0.05cos(2π*t)   # The optimal distribution we are aiming at

