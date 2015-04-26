## Constants
m = 21          # The number of 'space' nodes
n = 401         # The number of 'time' nodes
tau = 10/(n-1)  # Time step size
h = 1/(m-1)     # Space step size

lamb = 0.3
taubyh = tau/h
x = linrange(0,1,m)
t = linrange(0,10,n)

function mu(y)
    return 1/(1-y)^2
end

function muTau(y)
    return tau*mu(y)
end

function calculateA()
    A = zeros(m,m)
    for i=2:m-1
        A[i,i-1] = 1 - muTau(x[i]) + taubyh
        A[i,i+1] = 1 - muTau(x[i]) - taubyh
    end
   return A
end

A = calculateA()
println(A)
println(eig(A)[1])
