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

function calculateg(x)
    return (0.3+0.1*sin(x))
end

