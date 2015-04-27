m = 21          # The number of 'space' nodes
n = 401         # The number of 'time' nodes
τ = 10/(n-1)    # Time step size
h = 1/(m-1)     # Space step size

λ = 0.3
α = 0.3+0.1*(1-cos(1))         # Integral of g(x) = 0.3 +0.1sin(x) = 0.3+0.1(1-cos1)
x = linrange(0,1,m)'
t = linrange(0,10,n)'

α = 0.3+0.1*(1-cos(1))         # Integral of g(x) = 0.3 +0.1sin(x) = 0.3+0.1(1-cos1)
u = μ(x); u[1] = 0; u = u';    # Vector form of mu
β = zeros(m,m)
γ = (1-λ*τ+h*τ/2)

optv = 0.85 + 0.05cos(2π*t)   # The optimal distribution we are aiming at


## Calcuate A
A = zeros(m,m)

for i=2:m-1
    A[i,i-1] = 1 - τ*μ(x[i]) + τ/h
    A[i,i+1] = 1 - τ*μ(x[i]) - τ/h
end


## Calculate g
g = (0.3+0.1*sin(x))


## Calculate B
β = zeros(m,m)

for j=1:m
    for k = 0:j-1
       β[j,k+1] = u'*A^(j-1-k)*g
    end
end
