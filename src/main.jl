## Constants
tau = 10/400.0
h = 1/20.0
lamb = 0.3
taubyh = tau/h
x = linrange(0,1,20)
t = linrange(0,10,400)

function mu(y)
    return 1/(1-y)^2
end

function muTau(y)
    return tau*mu(y)
end

function calculateA()
    A = zeros(20,20)
    for i=2:20
        A[i-1,i-1] = 1 - muTau(x[i-1]) + taubyh
        if i<20
            A[i-1,i+1] = 1 - muTau(x[i-1]) -taubyh
        end
    end
   return A
end

A = calculateA()
println(A)
println(eig(A)[1])
