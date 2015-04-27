m = 21          # The number of 'space' nodes
n = 401         # The number of 'time' nodes
τ = 10/(n-1)    # Time step size
h = 1/(m-1)     # Space step size

λ = 0.3
α = 0.3+0.1*(1-cos(1))         # Integral of g(x) = 0.3 +0.1sin(x) = 0.3+0.1(1-cos1)
x = vec(linspace(0,1,m))
t = vec(linspace(0,10,n))

α = 0.3+0.1*(1-cos(1))         # Integral of g(x) = 0.3 +0.1sin(x) = 0.3+0.1(1-cos1)
μ = 1./(1-x).^2; μ[1] = 0; μ[m] = 0;
β = zeros(m,m)
γ = (1-λ*τ+h*τ/2)

optv = 0.85 + 0.05cos(2π*t)   # The optimal distribution we are aiming at


## Calcuate A
A = zeros(m,m)

for i=2:m-1
    A[i,i-1] = 1 - τ*μ[i] + τ/h
    A[i,i+1] = 1 - τ*μ[i] - τ/h
end


## Calculate g
g = (0.3+0.1*sin(x))


## Calculate B
β = zeros(n,n)

#println(size(x), " ", size(t), " ", size(g), " ", size(A), " ", size(μ'))

β[1,1] = α
for j=2:n
    for k = 1:j-1
       a = (A^(j-1-k))'*μ
       β[j,k] = dot(μ,g)[1]
    end
       β[j,j] = α
end

B = zeros(n,n)
for j=2:n
    for k=1:j
        B[j,:] += γ^(j-k)*β[k,:]
    end
end

