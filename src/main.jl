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

## Quadrature
function mu(x)
    return 1/(1-x)^2
end

function f(x)
    ## Use just the x part
    ## Remaining cos(πt) should be multiplied later
    return 0.1*sin(1-x)*sin(1-x)
end

function fmu(x)
    return f(x)mu(x)
end

weights = [(18+√30)/36,(18-√30)/36]
point1 = √(3-2(√6)/(√5))/√7
point2 = √(3+2(√6)/(√5))/√7

## Integrate wrt x
fx = weights[1]*fmu((point1+1)/2)+weights[1]*fmu((-point1+1)/2)+weights[2]*fmu((point2+1)/2)+weights[2]*fmu((-point2+1)/2)
fx = fx/2
## Multiply by time vector
fxt = fx*cos(π*t)

## Calculate β
β = zeros(n,n)
β[1,1] = α
for j=2:n
    for k = 1:j-1
       a = (A^(j-1-k))'*μ
       β[j,k] = dot(μ,g)[1]
    end
       β[j,j] = α
end

B = zeros(n,n)
B[1,1] = α
for j=2:n
    for k=1:j
        B[j,:] += γ^(j-k)*β[k,:]
    end
end
B = τ*B
d = zeros(n,1)
for i=1:n
  d[i] = γ^(i-1)*0.9
end

estb = pinv(B)*vec(d-optv)
estv = -B*estb + d
errv = norm(estv-optv,2);
c = estb + fxt - 0.3optv


w = zeros(m,n)
w[1,:] = λ*estv
w[1,1] = 0
for i=2:n
    w[:,i] = A*w[:,i]-τ*estb[i]*g
end
M = ones(m)
p1hat = M'*w*h


#Pkg.add("Gadfly")
#Pkg.add("Cairo")
using Gadfly
using Cairo
draw(PDF("estv.pdf",6inch, 3inch), plot(x=t, y=estv, Guide.XLabel("Time"), Guide.YLabel("Estimated p0"),Guide.XTicks(ticks=[0:1:10])))
draw(PDF("error.pdf",6inch, 3inch), plot(x=t, y=abs(estv-optv), Guide.XLabel("Time"), Guide.YLabel("Absolute Error"),Guide.XTicks(ticks=[0:1:10])))
draw(PDF("estb.pdf",6inch, 3inch), plot(x=t,y=estb, Guide.XLabel("Time"), Guide.YLabel("b(t)"),Guide.XTicks(ticks=[0:1:10])))
draw(PDF("p1hat.pdf",6inch, 3inch), plot(x=t,y=p1hat, Guide.XLabel("Time"), Guide.YLabel("p1hat(t)"), Guide.YTicks(ticks=[0:0.0025:0.0225]), Guide.XTicks(ticks=[0:1:10])))
