function μ(y)
    return 1/(1-y)^2
end

function calculateA()
    A = zeros(m,m)
    for i=2:m-1
        A[i,i-1] = 1 - τ*μ(x[i]) + τ/h
        A[i,i+1] = 1 - τ*μ(x[i]) - τ/h
    end
   return A
end

function g(x)
    return (0.3+0.1*sin(x))
end

function calculateB(A)
 
    β =  
    for j=1:m
        for k = 0:j-1
           β[j,k+1] = u'*A^(j-1-k)*g
        end
    end
