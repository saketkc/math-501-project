## Constants
tau = 10/400.0
h = 1/20.0
lamb = 0.3
taubyh = tau/h
x = linrange(0,1,20)
t = linrange(0,10,400)
function mu(x)
    return 1/abs2(1-x)
end
function muTau(x)
    return tau*mu(x)
end
A = zeros(20,20)
for i=1:19
    A[i,i] = 1 - muTau(x[i]) + taubyh
    if i+2<=20
        A[i,i+2] = 1 - muTau(x[i]) -taubyh
    end
end
println(max(eig(A)[1]...))
