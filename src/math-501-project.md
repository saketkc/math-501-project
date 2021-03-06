
# Introduction
Model of a two state reparable system:
$$
\begin{equation}
\frac{dp_0}{dt} = -\lambda_0 p_0(t) + \int_0^1 \mu_1(x)p_1(x,t)dx + \int_0^1u^{*}(x,t)dx
\end{equation}
$$

$$
\begin{equation}
\frac{\partial p_1(x,t)}{\partial t} + \frac{\partial p_1(x,t)}{\partial x} = -\mu_1(x)p_1(x,t) - u^{*}(x,t)
\end{equation}
$$

where:

$p_0(t)$: Probability that the device is in good mode 0 at time $t$.

$p_1(x,t)$: Probability density (with respect to repair time $x$) that the failed device is in failure mode 1 at time $t$ and has an elapsed repair time of $x$

$\mu_1(x)$: Time-dependent nonnegative repair rate when the device is in failure state and has an elapsed repair time of $x$.

Carefully provide a mathematical description of the problem discussed in this report. 
$$
\begin{equation}
\frac{dp_0}{dt} = -\lambda_0 p_0(t) + \int_0^1 \mu_1(x)p_1(x,t)dx + \int_0^1u^{*}(x,t)dx
\end{equation}
$$

$$
\begin{equation}
\frac{\partial p_1(x,t)}{\partial t} + \frac{\partial p_1(x,t)}{\partial x} = -\mu_1(x)p_1(x,t) - u^{*}(x,t)
\end{equation}
$$

#### Given Initial Conditions

$$
\begin{eqnarray}
p_1(x,0) &=& 0\\
p_0(0) &=& 1
\end{eqnarray}
$$

#### Given Boundary Conditions:

$$
\begin{eqnarray}
p_1(0,t) &=& \lambda_0 p_0(t)\\
p_1(1,t) &=& 0
\end{eqnarray}
$$

The function $u^*$ is given by
$$
\begin{eqnarray}
u^{*}(x,t) &=& (0.3+0.1 sin(x))b(t) 
\end{eqnarray}
$$

The function $b(t)$ represents the input. It is related to the cost constraint function
$c(t)$ as given below.

$$
\begin{eqnarray}
b(t)+\int_0^1\mu_1(x)f(x,t)dx -0.3p_0^{*}(t) = c(t)\\
f(x,t) = 0.1\cos(\pi t)\sin^2(1-x)
\end{eqnarray}
$$

Our objective is to find the input $b(t)$ such that the resulting distribution $p_0(t)$ is
closest (as measured by the 2-norm) to the optimal distribution $p_0^*(t)$ given below.
$$
\begin{equation}
p_0^{*}(t) = 0.85+0.05\cos(2\pi t)
\end{equation}
$$

### Methodology

We make couple of substitutions, following the notation that
$z_i^j$ refers to the value of $z$ evaluated at time point $i$ and at position $j$. The
repair time is divided into $m$ subintervals, while the system running time is divided
into $n$ subintervals. For the purposes of numerical implementation, we chose $m$ and $n$
to be $20$ and $400$ respectively.

$$
\begin{align}p_0(t_j) &= v_j \quad 0 \le j \le n\\
p_1(x_i,t_j) &= w_j^i \quad 0 \le i \le m, \, 0\le j \le n\\
\mu_1(x_i) &= \mu^i \quad 0 \le i \le m\\
\lambda &= \lambda_0 \\ 
\end{align}$$ 


Using the new notation, the boundary conditions and initial conditions may be written as
follows.


Initial conditions:
$$\begin{eqnarray}
w_0^{i} &=& 0 \quad \forall 0\le i \le m\\
v_0 &=& 1
\end{eqnarray}$$

Boundary Conditions:

$$\begin{eqnarray}
w_j^{20} &=& 0 \quad \forall 0\le j\le n\\
w_j^0 &=&  \lambda v_j
\end{eqnarray}$$

Also condensing,


$$\begin{eqnarray}
	I_j^{*}=u^{*}(x_i,t_j) &=& g^ib_j \\
\int_0^1 u^{*}(x,t_j)dx = \alpha b_j\\
where\ g^i = (0.3+0.1sin(x^i)) \nonumber
\end{eqnarray}$$

And,

$$\begin{eqnarray}
b(t)+\int_0^1\mu_1(x)f(x,t)dx -0.3p_0^{*}(t) = c(t) \nonumber \\
b_j = c_j - f_j \\
where\ f_j = \int_0^1\mu_1(x)f(x,t_j)dx -0.3p_0^{*}(t_j)
\end{eqnarray}$$



Discretizing

$$\begin{align}
\frac{v_{j+1}-v_j}{\tau} &= -\lambda v_j + I_j + I_j^{*} \\
I_j &= h[\frac{\mu^0 w_j^0}{2} + \sum_{k=1}^{19} \mu^k w_j^k + \frac{\mu^{20} w_j^{20}}{2} ] \\
    &=  h[\frac{\mu^0 w_j^0}{2} + \sum_{k=1}^{19} \mu^k w_j^k ] \nonumber \\
I_j^{*} &= \alpha b_j
\end{align}$$


Discretizing
$$
\begin{align}
\frac{w_{j+1}^i-w_{j}^i}{\tau} + \frac{w_j^{i+1}-w_j^{i-1}}{2h} = -\mu^iw_j^i - g^ib_j \nonumber\\
w_{j+1}^i=w_{j}^i-\frac{\tau}{2h}(w_j^{i+1}-w_j^{i-1})-\tau\mu^i w_j^i - \tau g^i b_j
\end{align}
$$

Applying LAX scheme $$w_j^i = \frac{w_j^{i-1} + w_j^{i+1}}{2}$$ we get,

$$
\begin{align*}
	w^i_{j+1} =& \left( \frac{w_j^{i+1} + w_j^{i-1}}{2} \right)
	-\frac{\tau}{2h}(w_j^{i+1}-w_j^{i-1}) \\
		&-\tau\mu^i\left( \frac{w_j^{i+1} + w_j^{i-1}}{2} \right)  \\
		&- \tau g^i b_j\\
	w^i_{j+1} =& \frac{1}{2}\left( 1-\mu^i\tau + \frac{\tau}{h} \right) w^{i-1}_j + \\
	           & \frac{1}{2}\left( 1-\mu^i\tau - \frac{\tau}{h} \right) w^{i+1}_j - \\
		   & \tau g^i b_j
\end{align*}
$$

Under an appropriately defined matrix $A$, we can re-write the above equation to read

$$
\begin{align}
	\vec{w}_{j+1} =& A\vec{w}_j - b_j\tau\vec{g} + \vec{e_1}v_{j+1} \\
	=& (A)^{j+1} \vec{w}_0 - \left[ \sum_{k=0}^j b_k (A)^{j-k} \right]\vec{g}\tau \\
	&+ \left[ \sum_{k=0}^j v_{k+1}(A)^{j-k} \right]\vec{e_1} \nonumber
\end{align}
$$
where $\vec{e_1}$ is an $m\times1$ matrix given by

$$
\begin{align}
	\vec{e_1} = \left[ \lambda,0,\dots,0 \right]^T
\end{align}
$$


Matrix A has the form:

$$
\begin{align}
 %\[ 
 \begin{pmatrix} w^0_{j+1} \\ w^1_{j+1} \\ \cdots \\ w^{n-2}_{j+1} \\ w^{n-1}_{j+1} \\ w^{n}_{j+1}  \end{pmatrix} &= \left( \begin{matrix}
0 & 0 & 0 & \cdots & 0 & 0 \\
%1 & 
a_{1} & 0 & a_{3} & \cdots & 0 & 0\\
0 & a_{2} & 0 & a_{4} & \cdots & 0\\
0 & 0 & a_{3} & 0 & a_5 & 0\\
\vdots \\
0 & 0 & \cdots &  0 & 0 & 0  \end{matrix} \right) \begin{pmatrix} w^0_j \\ w^1_j \\ \cdots \\ w^{n-2}_j \\ w^{n-1}_j \\ w^{n}_j\end{pmatrix}  \\
&+ b\tau \begin{pmatrix} g^0 \\ g^1 \\ \vdots \\ g^{n-2} \\ g^{n-1} \\ g^{n} \end{pmatrix} + v_{j+1} \begin{pmatrix}
\lambda \\ 0  \\ 0  \\ \vdots \\ 0 \\ 0 \\ 0
\end{pmatrix}
\end{align}
$$

From 
$$
\begin{align}
v_{j+1} &= (1-\lambda \tau)v_j + \tau I_j + \tau I_j^{*} \\
&= (1-\lambda \tau + \frac{h\tau}{2})v_j + h\tau\vec{\mu}^T\vec{w}_j + \alpha b_j\tau
%v_{j+1} = av_j + \tau I_j + \tau I_j^{*}\\
%v_{j} = av_{j-1} + \tau I_{j-1} + \tau I_{j-1}^{*}\\
%v_{j+1} = a^2v_{j-1} + \tau I_j + a\tau I_{j-1} + \tau I_{j}^{*} + a\tau I_{j-1}^{*} 
\end{align}$$
Substitute the expression for the time evolution for $\vec{w}$ in the above to obtain,
$$\begin{align*}
v_{j+1} =& (1-\lambda \tau+ \frac{h\tau}{2})v_j \\
         & + h\tau\vec{\mu}^T(A)^{j}\vec{w}_0 \\
	 & - \vec{\mu}^T\left[ \sum_{k=0}^{j-1} b_{k}(A)^{j-1-k} \right]\vec{g}\tau\\
	 & + \alpha b_j\tau
\end{align*}$$
Let's define 
$$\begin{align}
	\beta_{j,k}  &= \vec{\mu}^T (A)^{j-1-k}\vec{g} \\
        \omega_j &=\vec{\mu}^T(A)^{j}\vec{w}_0 \\
        \gamma   &=(1-\lambda \tau+ \frac{h\tau}{2})
\end{align}
$$

$$
\begin{align}
\vec{\beta_0} = \begin{pmatrix} \alpha \\ 0 \\ 0 \\ \vdots \\ 0 \end{pmatrix} \\
\end{align}
$$


$$
\begin{align} 
v_{j+1} &= \gamma v_j + h\tau\omega_j - \tau\sum_{k=0}^{j-1}\beta_{j,k}b_k
	   + \alpha b_j\tau \\
	   &= \gamma v_j + h\tau\omega_j - \tau \vec{\beta}_j^T \vec{b}\\
	   &= \gamma^{j+1}v_0 
	   + h\tau\sum_{k=0}^{j} \gamma^{j-k}\omega_k
	   - \left(\sum_{k=0}^{j} \gamma^{j-k} \vec{\beta}_k\right)^T \vec{b}
\end{align}
$$
Under appropriately defined strictly lower triangular matrices $G$ and $B$,
$$
\begin{align}
	\vec{v} = - B\vec{b}+\vec{d} + h\tau G\vec{\omega}  \\
	\vec{d}=\begin{pmatrix} 1 \\ \gamma \\  \gamma^2 \\ \gamma^3 \\ \vdots \\ \gamma^{n} \end{pmatrix}v_0
\end{align}
$$
where row $j+1$ of matrix $B$ is given by
$$\begin{equation}
\left(\sum_{k=0}^{j} \gamma^{j-k} \vec{\beta}_k\right)^T
\end{equation}$$

From the initial conditions, we have $\vec{w_0} = \vec{0}$ Thus $\vec{\omega} =
\vec{0}$. Consequently, we have,
$$
\begin{align}
	\vec{v} &= -B\vec{b} + \vec{d}
\end{align}
$$
Note that $\vec{d}$ is a known quantity.
Hence our optimization problem reduces to finding $\vec{b}$ that best fits the equation
$$
\begin{align}
	B\vec{b} = \vec{d}-\vec{v}^*
\end{align}
$$
The matrix $B$ is invertible in this case and hence our estimate of $\vec{v}$ is given by 
$$
\begin{align}
	\hat{\vec{b}} &= B^{-1} \left( \vec{d} - \vec{v}^* \right)\\
	\vec{v} &= -B\hat{\vec{b}} + \vec{d} \\
	        &= \vec{v}^*
\end{align}
$$



We approximate the integral using:
$$
\begin{equation}
\int_{-1}^{1}f(x,t)dx = \sum_{i=1}^{n} \rho_if(x_i,t)
\end{equation}
$$
We used Gauss-Legendre quadrature with $n=4$.
Thus,
$$
\begin{align}
	\int_{0}^{1}f(x,t)dx &= \frac{1}{2}\sum_{i=1}^{n} \rho_if\left(\frac{x_i}{2} +
	\frac{1}{2},t\right)\\
	\therefore c_j &= b_j + f_j
\end{align}
$$

## Observation and Conclusions

The inversion of matrix $B$ does present some difficulties. It is easily seen from the
definition of $B$ that it is lower triangular. In addition,
$$
\begin{equation}
	(B)_{ii} = \alpha\tau \quad \forall 0\le i \le n
\end{equation}
$$
As $B$ is lower triangular, its determinant is the product of the main diagonal terms.
$$
\begin{equation}
	|B| = (\alpha\tau)^{n+1}
\end{equation}
$$
We have $\alpha \approx 0.354$, $\tau = 0.025$ and $n=401$. Thus,
$$
\begin{equation}
	|B| \approx 10^{-802}
\end{equation}
$$
which makes $B$ dangerously close to being singular. In fact, taking a direct inverse in Julia results in
multiple entries going to $$\texttt{NaN}$$. We resolve this issue by computing the
Moore-Penrose pseudoinverse $B^+$ of $B$. For an invertible matrix $B$, $B^- = B^+$




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
    
    using Gadfly



    plot(x=t, y=estv, Guide.XLabel("Time"), Guide.YLabel("Estimated p0"),Guide.XTicks(ticks=[0:1:10]))





<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg"
     xmlns:xlink="http://www.w3.org/1999/xlink"
     xmlns:gadfly="http://www.gadflyjl.org/ns"
     version="1.2"
     width="141.42mm" height="100mm" viewBox="0 0 141.42 100"
     stroke="none"
     fill="#000000"
     stroke-width="0.3"
     font-size="3.88"

     id="fig-c22dfd48538b4aa0ba3f8e349406edc7">
<g class="plotroot xscalable yscalable" id="fig-c22dfd48538b4aa0ba3f8e349406edc7-element-1">
  <g font-size="3.88" font-family="'PT Sans','Helvetica Neue','Helvetica',sans-serif" fill="#564A55" stroke="none" id="fig-c22dfd48538b4aa0ba3f8e349406edc7-element-2">
    <text x="78.36" y="92" text-anchor="middle">Time</text>
  </g>
  <g class="guide xlabels" font-size="2.82" font-family="'PT Sans Caption','Helvetica Neue','Helvetica',sans-serif" fill="#6C606B" id="fig-c22dfd48538b4aa0ba3f8e349406edc7-element-3">
    <text x="22.31" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">0</text>
    <text x="33.52" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">1</text>
    <text x="44.73" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">2</text>
    <text x="55.94" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">3</text>
    <text x="67.15" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">4</text>
    <text x="78.36" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">5</text>
    <text x="89.57" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">6</text>
    <text x="100.79" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">7</text>
    <text x="112" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">8</text>
    <text x="123.21" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">9</text>
    <text x="134.42" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">10</text>
  </g>
  <g clip-path="url(#fig-c22dfd48538b4aa0ba3f8e349406edc7-element-5)" id="fig-c22dfd48538b4aa0ba3f8e349406edc7-element-4">
    <g pointer-events="visible" opacity="1" fill="none" stroke="none" class="guide background" id="fig-c22dfd48538b4aa0ba3f8e349406edc7-element-6">
      <rect x="20.31" y="5" width="116.12" height="75.72"/>
    </g>
    <g class="guide ygridlines xfixed" stroke-dasharray="0.5,0.5" stroke-width="0.2" stroke="#D0D0E0" id="fig-c22dfd48538b4aa0ba3f8e349406edc7-element-7">
      <path fill="none" d="M20.31,168.36 L 136.42 168.36" gadfly:scale="1.0" visibility="hidden"/>
      <path fill="none" d="M20.31,150.43 L 136.42 150.43" gadfly:scale="1.0" visibility="hidden"/>
      <path fill="none" d="M20.31,132.5 L 136.42 132.5" gadfly:scale="1.0" visibility="hidden"/>
      <path fill="none" d="M20.31,114.57 L 136.42 114.57" gadfly:scale="1.0" visibility="hidden"/>
      <path fill="none" d="M20.31,96.64 L 136.42 96.64" gadfly:scale="1.0" visibility="hidden"/>
      <path fill="none" d="M20.31,78.72 L 136.42 78.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M20.31,60.79 L 136.42 60.79" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M20.31,42.86 L 136.42 42.86" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M20.31,24.93 L 136.42 24.93" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M20.31,7 L 136.42 7" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M20.31,-10.93 L 136.42 -10.93" gadfly:scale="1.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-28.86 L 136.42 -28.86" gadfly:scale="1.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-46.79 L 136.42 -46.79" gadfly:scale="1.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-64.71 L 136.42 -64.71" gadfly:scale="1.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-82.64 L 136.42 -82.64" gadfly:scale="1.0" visibility="hidden"/>
      <path fill="none" d="M20.31,154.02 L 136.42 154.02" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,150.43 L 136.42 150.43" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,146.84 L 136.42 146.84" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,143.26 L 136.42 143.26" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,139.67 L 136.42 139.67" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,136.09 L 136.42 136.09" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,132.5 L 136.42 132.5" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,128.92 L 136.42 128.92" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,125.33 L 136.42 125.33" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,121.74 L 136.42 121.74" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,118.16 L 136.42 118.16" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,114.57 L 136.42 114.57" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,110.99 L 136.42 110.99" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,107.4 L 136.42 107.4" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,103.82 L 136.42 103.82" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,100.23 L 136.42 100.23" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,96.64 L 136.42 96.64" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,93.06 L 136.42 93.06" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,89.47 L 136.42 89.47" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,85.89 L 136.42 85.89" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,82.3 L 136.42 82.3" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,78.72 L 136.42 78.72" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,75.13 L 136.42 75.13" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,71.54 L 136.42 71.54" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,67.96 L 136.42 67.96" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,64.37 L 136.42 64.37" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,60.79 L 136.42 60.79" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,57.2 L 136.42 57.2" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,53.61 L 136.42 53.61" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,50.03 L 136.42 50.03" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,46.44 L 136.42 46.44" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,42.86 L 136.42 42.86" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,39.27 L 136.42 39.27" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,35.69 L 136.42 35.69" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,32.1 L 136.42 32.1" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,28.51 L 136.42 28.51" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,24.93 L 136.42 24.93" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,21.34 L 136.42 21.34" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,17.76 L 136.42 17.76" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,14.17 L 136.42 14.17" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,10.59 L 136.42 10.59" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,7 L 136.42 7" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,3.41 L 136.42 3.41" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-0.17 L 136.42 -0.17" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-3.76 L 136.42 -3.76" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-7.34 L 136.42 -7.34" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-10.93 L 136.42 -10.93" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-14.51 L 136.42 -14.51" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-18.1 L 136.42 -18.1" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-21.69 L 136.42 -21.69" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-25.27 L 136.42 -25.27" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-28.86 L 136.42 -28.86" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-32.44 L 136.42 -32.44" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-36.03 L 136.42 -36.03" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-39.61 L 136.42 -39.61" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-43.2 L 136.42 -43.2" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-46.79 L 136.42 -46.79" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-50.37 L 136.42 -50.37" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-53.96 L 136.42 -53.96" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-57.54 L 136.42 -57.54" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-61.13 L 136.42 -61.13" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-64.71 L 136.42 -64.71" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-68.3 L 136.42 -68.3" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M20.31,204.22 L 136.42 204.22" gadfly:scale="0.5" visibility="hidden"/>
      <path fill="none" d="M20.31,132.5 L 136.42 132.5" gadfly:scale="0.5" visibility="hidden"/>
      <path fill="none" d="M20.31,60.79 L 136.42 60.79" gadfly:scale="0.5" visibility="hidden"/>
      <path fill="none" d="M20.31,-10.93 L 136.42 -10.93" gadfly:scale="0.5" visibility="hidden"/>
      <path fill="none" d="M20.31,-82.64 L 136.42 -82.64" gadfly:scale="0.5" visibility="hidden"/>
      <path fill="none" d="M20.31,154.02 L 136.42 154.02" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M20.31,146.84 L 136.42 146.84" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M20.31,139.67 L 136.42 139.67" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M20.31,132.5 L 136.42 132.5" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M20.31,125.33 L 136.42 125.33" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M20.31,118.16 L 136.42 118.16" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M20.31,110.99 L 136.42 110.99" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M20.31,103.82 L 136.42 103.82" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M20.31,96.64 L 136.42 96.64" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M20.31,89.47 L 136.42 89.47" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M20.31,82.3 L 136.42 82.3" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M20.31,75.13 L 136.42 75.13" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M20.31,67.96 L 136.42 67.96" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M20.31,60.79 L 136.42 60.79" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M20.31,53.61 L 136.42 53.61" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M20.31,46.44 L 136.42 46.44" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M20.31,39.27 L 136.42 39.27" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M20.31,32.1 L 136.42 32.1" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M20.31,24.93 L 136.42 24.93" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M20.31,17.76 L 136.42 17.76" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M20.31,10.59 L 136.42 10.59" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M20.31,3.41 L 136.42 3.41" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-3.76 L 136.42 -3.76" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-10.93 L 136.42 -10.93" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-18.1 L 136.42 -18.1" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-25.27 L 136.42 -25.27" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-32.44 L 136.42 -32.44" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-39.61 L 136.42 -39.61" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-46.79 L 136.42 -46.79" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-53.96 L 136.42 -53.96" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-61.13 L 136.42 -61.13" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M20.31,-68.3 L 136.42 -68.3" gadfly:scale="5.0" visibility="hidden"/>
    </g>
    <g class="guide xgridlines yfixed" stroke-dasharray="0.5,0.5" stroke-width="0.2" stroke="#D0D0E0" id="fig-c22dfd48538b4aa0ba3f8e349406edc7-element-8">
      <path fill="none" d="M22.31,5 L 22.31 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M33.52,5 L 33.52 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M44.73,5 L 44.73 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M55.94,5 L 55.94 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M67.15,5 L 67.15 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M78.36,5 L 78.36 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M89.57,5 L 89.57 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M100.79,5 L 100.79 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M112,5 L 112 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M123.21,5 L 123.21 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M134.42,5 L 134.42 80.72" gadfly:scale="1.0" visibility="visible"/>
    </g>
    <g class="plotpanel" id="fig-c22dfd48538b4aa0ba3f8e349406edc7-element-9">
      <g class="geometry" id="fig-c22dfd48538b4aa0ba3f8e349406edc7-element-10">
        <g class="color_RGB{Float32}(0.0f0,0.74736935f0,1.0f0)" stroke="#FFFFFF" stroke-width="0.3" fill="#00BFFF" id="fig-c22dfd48538b4aa0ba3f8e349406edc7-element-11">
          <circle cx="22.31" cy="24.93" r="0.9"/>
          <circle cx="22.59" cy="25.15" r="0.9"/>
          <circle cx="22.87" cy="25.81" r="0.9"/>
          <circle cx="23.15" cy="26.88" r="0.9"/>
          <circle cx="23.43" cy="28.35" r="0.9"/>
          <circle cx="23.71" cy="30.18" r="0.9"/>
          <circle cx="23.99" cy="32.32" r="0.9"/>
          <circle cx="24.27" cy="34.72" r="0.9"/>
          <circle cx="24.55" cy="37.32" r="0.9"/>
          <circle cx="24.83" cy="40.05" r="0.9"/>
          <circle cx="25.11" cy="42.86" r="0.9"/>
          <circle cx="25.39" cy="45.66" r="0.9"/>
          <circle cx="25.67" cy="48.4" r="0.9"/>
          <circle cx="25.95" cy="51" r="0.9"/>
          <circle cx="26.23" cy="53.4" r="0.9"/>
          <circle cx="26.51" cy="55.54" r="0.9"/>
          <circle cx="26.79" cy="57.36" r="0.9"/>
          <circle cx="27.07" cy="58.83" r="0.9"/>
          <circle cx="27.35" cy="59.91" r="0.9"/>
          <circle cx="27.63" cy="60.57" r="0.9"/>
          <circle cx="27.91" cy="60.79" r="0.9"/>
          <circle cx="28.19" cy="60.57" r="0.9"/>
          <circle cx="28.47" cy="59.91" r="0.9"/>
          <circle cx="28.75" cy="58.83" r="0.9"/>
          <circle cx="29.03" cy="57.36" r="0.9"/>
          <circle cx="29.31" cy="55.54" r="0.9"/>
          <circle cx="29.59" cy="53.4" r="0.9"/>
          <circle cx="29.87" cy="51" r="0.9"/>
          <circle cx="30.15" cy="48.4" r="0.9"/>
          <circle cx="30.43" cy="45.66" r="0.9"/>
          <circle cx="30.71" cy="42.86" r="0.9"/>
          <circle cx="30.99" cy="40.05" r="0.9"/>
          <circle cx="31.27" cy="37.32" r="0.9"/>
          <circle cx="31.55" cy="34.72" r="0.9"/>
          <circle cx="31.83" cy="32.32" r="0.9"/>
          <circle cx="32.12" cy="30.18" r="0.9"/>
          <circle cx="32.4" cy="28.35" r="0.9"/>
          <circle cx="32.68" cy="26.88" r="0.9"/>
          <circle cx="32.96" cy="25.81" r="0.9"/>
          <circle cx="33.24" cy="25.15" r="0.9"/>
          <circle cx="33.52" cy="24.93" r="0.9"/>
          <circle cx="33.8" cy="25.15" r="0.9"/>
          <circle cx="34.08" cy="25.81" r="0.9"/>
          <circle cx="34.36" cy="26.88" r="0.9"/>
          <circle cx="34.64" cy="28.35" r="0.9"/>
          <circle cx="34.92" cy="30.18" r="0.9"/>
          <circle cx="35.2" cy="32.32" r="0.9"/>
          <circle cx="35.48" cy="34.72" r="0.9"/>
          <circle cx="35.76" cy="37.32" r="0.9"/>
          <circle cx="36.04" cy="40.05" r="0.9"/>
          <circle cx="36.32" cy="42.86" r="0.9"/>
          <circle cx="36.6" cy="45.66" r="0.9"/>
          <circle cx="36.88" cy="48.4" r="0.9"/>
          <circle cx="37.16" cy="51" r="0.9"/>
          <circle cx="37.44" cy="53.4" r="0.9"/>
          <circle cx="37.72" cy="55.54" r="0.9"/>
          <circle cx="38" cy="57.36" r="0.9"/>
          <circle cx="38.28" cy="58.83" r="0.9"/>
          <circle cx="38.56" cy="59.91" r="0.9"/>
          <circle cx="38.84" cy="60.57" r="0.9"/>
          <circle cx="39.12" cy="60.79" r="0.9"/>
          <circle cx="39.4" cy="60.57" r="0.9"/>
          <circle cx="39.68" cy="59.91" r="0.9"/>
          <circle cx="39.96" cy="58.83" r="0.9"/>
          <circle cx="40.24" cy="57.36" r="0.9"/>
          <circle cx="40.52" cy="55.54" r="0.9"/>
          <circle cx="40.8" cy="53.4" r="0.9"/>
          <circle cx="41.08" cy="51" r="0.9"/>
          <circle cx="41.36" cy="48.4" r="0.9"/>
          <circle cx="41.65" cy="45.66" r="0.9"/>
          <circle cx="41.93" cy="42.86" r="0.9"/>
          <circle cx="42.21" cy="40.05" r="0.9"/>
          <circle cx="42.49" cy="37.32" r="0.9"/>
          <circle cx="42.77" cy="34.72" r="0.9"/>
          <circle cx="43.05" cy="32.32" r="0.9"/>
          <circle cx="43.33" cy="30.18" r="0.9"/>
          <circle cx="43.61" cy="28.35" r="0.9"/>
          <circle cx="43.89" cy="26.88" r="0.9"/>
          <circle cx="44.17" cy="25.81" r="0.9"/>
          <circle cx="44.45" cy="25.15" r="0.9"/>
          <circle cx="44.73" cy="24.93" r="0.9"/>
          <circle cx="45.01" cy="25.15" r="0.9"/>
          <circle cx="45.29" cy="25.81" r="0.9"/>
          <circle cx="45.57" cy="26.88" r="0.9"/>
          <circle cx="45.85" cy="28.35" r="0.9"/>
          <circle cx="46.13" cy="30.18" r="0.9"/>
          <circle cx="46.41" cy="32.32" r="0.9"/>
          <circle cx="46.69" cy="34.72" r="0.9"/>
          <circle cx="46.97" cy="37.32" r="0.9"/>
          <circle cx="47.25" cy="40.05" r="0.9"/>
          <circle cx="47.53" cy="42.86" r="0.9"/>
          <circle cx="47.81" cy="45.66" r="0.9"/>
          <circle cx="48.09" cy="48.4" r="0.9"/>
          <circle cx="48.37" cy="51" r="0.9"/>
          <circle cx="48.65" cy="53.4" r="0.9"/>
          <circle cx="48.93" cy="55.54" r="0.9"/>
          <circle cx="49.21" cy="57.36" r="0.9"/>
          <circle cx="49.49" cy="58.83" r="0.9"/>
          <circle cx="49.77" cy="59.91" r="0.9"/>
          <circle cx="50.05" cy="60.57" r="0.9"/>
          <circle cx="50.33" cy="60.79" r="0.9"/>
          <circle cx="50.61" cy="60.57" r="0.9"/>
          <circle cx="50.89" cy="59.91" r="0.9"/>
          <circle cx="51.17" cy="58.83" r="0.9"/>
          <circle cx="51.46" cy="57.36" r="0.9"/>
          <circle cx="51.74" cy="55.54" r="0.9"/>
          <circle cx="52.02" cy="53.4" r="0.9"/>
          <circle cx="52.3" cy="51" r="0.9"/>
          <circle cx="52.58" cy="48.4" r="0.9"/>
          <circle cx="52.86" cy="45.66" r="0.9"/>
          <circle cx="53.14" cy="42.86" r="0.9"/>
          <circle cx="53.42" cy="40.05" r="0.9"/>
          <circle cx="53.7" cy="37.32" r="0.9"/>
          <circle cx="53.98" cy="34.72" r="0.9"/>
          <circle cx="54.26" cy="32.32" r="0.9"/>
          <circle cx="54.54" cy="30.18" r="0.9"/>
          <circle cx="54.82" cy="28.35" r="0.9"/>
          <circle cx="55.1" cy="26.88" r="0.9"/>
          <circle cx="55.38" cy="25.81" r="0.9"/>
          <circle cx="55.66" cy="25.15" r="0.9"/>
          <circle cx="55.94" cy="24.93" r="0.9"/>
          <circle cx="56.22" cy="25.15" r="0.9"/>
          <circle cx="56.5" cy="25.81" r="0.9"/>
          <circle cx="56.78" cy="26.88" r="0.9"/>
          <circle cx="57.06" cy="28.35" r="0.9"/>
          <circle cx="57.34" cy="30.18" r="0.9"/>
          <circle cx="57.62" cy="32.32" r="0.9"/>
          <circle cx="57.9" cy="34.72" r="0.9"/>
          <circle cx="58.18" cy="37.32" r="0.9"/>
          <circle cx="58.46" cy="40.05" r="0.9"/>
          <circle cx="58.74" cy="42.86" r="0.9"/>
          <circle cx="59.02" cy="45.66" r="0.9"/>
          <circle cx="59.3" cy="48.4" r="0.9"/>
          <circle cx="59.58" cy="51" r="0.9"/>
          <circle cx="59.86" cy="53.4" r="0.9"/>
          <circle cx="60.14" cy="55.54" r="0.9"/>
          <circle cx="60.42" cy="57.36" r="0.9"/>
          <circle cx="60.7" cy="58.83" r="0.9"/>
          <circle cx="60.99" cy="59.91" r="0.9"/>
          <circle cx="61.27" cy="60.57" r="0.9"/>
          <circle cx="61.55" cy="60.79" r="0.9"/>
          <circle cx="61.83" cy="60.57" r="0.9"/>
          <circle cx="62.11" cy="59.91" r="0.9"/>
          <circle cx="62.39" cy="58.83" r="0.9"/>
          <circle cx="62.67" cy="57.36" r="0.9"/>
          <circle cx="62.95" cy="55.54" r="0.9"/>
          <circle cx="63.23" cy="53.4" r="0.9"/>
          <circle cx="63.51" cy="51" r="0.9"/>
          <circle cx="63.79" cy="48.4" r="0.9"/>
          <circle cx="64.07" cy="45.66" r="0.9"/>
          <circle cx="64.35" cy="42.86" r="0.9"/>
          <circle cx="64.63" cy="40.05" r="0.9"/>
          <circle cx="64.91" cy="37.32" r="0.9"/>
          <circle cx="65.19" cy="34.72" r="0.9"/>
          <circle cx="65.47" cy="32.32" r="0.9"/>
          <circle cx="65.75" cy="30.18" r="0.9"/>
          <circle cx="66.03" cy="28.35" r="0.9"/>
          <circle cx="66.31" cy="26.88" r="0.9"/>
          <circle cx="66.59" cy="25.81" r="0.9"/>
          <circle cx="66.87" cy="25.15" r="0.9"/>
          <circle cx="67.15" cy="24.93" r="0.9"/>
          <circle cx="67.43" cy="25.15" r="0.9"/>
          <circle cx="67.71" cy="25.81" r="0.9"/>
          <circle cx="67.99" cy="26.88" r="0.9"/>
          <circle cx="68.27" cy="28.35" r="0.9"/>
          <circle cx="68.55" cy="30.18" r="0.9"/>
          <circle cx="68.83" cy="32.32" r="0.9"/>
          <circle cx="69.11" cy="34.72" r="0.9"/>
          <circle cx="69.39" cy="37.32" r="0.9"/>
          <circle cx="69.67" cy="40.05" r="0.9"/>
          <circle cx="69.95" cy="42.86" r="0.9"/>
          <circle cx="70.23" cy="45.66" r="0.9"/>
          <circle cx="70.52" cy="48.4" r="0.9"/>
          <circle cx="70.8" cy="51" r="0.9"/>
          <circle cx="71.08" cy="53.4" r="0.9"/>
          <circle cx="71.36" cy="55.54" r="0.9"/>
          <circle cx="71.64" cy="57.36" r="0.9"/>
          <circle cx="71.92" cy="58.83" r="0.9"/>
          <circle cx="72.2" cy="59.91" r="0.9"/>
          <circle cx="72.48" cy="60.57" r="0.9"/>
          <circle cx="72.76" cy="60.79" r="0.9"/>
          <circle cx="73.04" cy="60.57" r="0.9"/>
          <circle cx="73.32" cy="59.91" r="0.9"/>
          <circle cx="73.6" cy="58.83" r="0.9"/>
          <circle cx="73.88" cy="57.36" r="0.9"/>
          <circle cx="74.16" cy="55.54" r="0.9"/>
          <circle cx="74.44" cy="53.4" r="0.9"/>
          <circle cx="74.72" cy="51" r="0.9"/>
          <circle cx="75" cy="48.4" r="0.9"/>
          <circle cx="75.28" cy="45.66" r="0.9"/>
          <circle cx="75.56" cy="42.86" r="0.9"/>
          <circle cx="75.84" cy="40.05" r="0.9"/>
          <circle cx="76.12" cy="37.32" r="0.9"/>
          <circle cx="76.4" cy="34.72" r="0.9"/>
          <circle cx="76.68" cy="32.32" r="0.9"/>
          <circle cx="76.96" cy="30.18" r="0.9"/>
          <circle cx="77.24" cy="28.35" r="0.9"/>
          <circle cx="77.52" cy="26.88" r="0.9"/>
          <circle cx="77.8" cy="25.81" r="0.9"/>
          <circle cx="78.08" cy="25.15" r="0.9"/>
          <circle cx="78.36" cy="24.93" r="0.9"/>
          <circle cx="78.64" cy="25.15" r="0.9"/>
          <circle cx="78.92" cy="25.81" r="0.9"/>
          <circle cx="79.2" cy="26.88" r="0.9"/>
          <circle cx="79.48" cy="28.35" r="0.9"/>
          <circle cx="79.76" cy="30.18" r="0.9"/>
          <circle cx="80.04" cy="32.32" r="0.9"/>
          <circle cx="80.33" cy="34.72" r="0.9"/>
          <circle cx="80.61" cy="37.32" r="0.9"/>
          <circle cx="80.89" cy="40.05" r="0.9"/>
          <circle cx="81.17" cy="42.86" r="0.9"/>
          <circle cx="81.45" cy="45.66" r="0.9"/>
          <circle cx="81.73" cy="48.4" r="0.9"/>
          <circle cx="82.01" cy="51" r="0.9"/>
          <circle cx="82.29" cy="53.4" r="0.9"/>
          <circle cx="82.57" cy="55.54" r="0.9"/>
          <circle cx="82.85" cy="57.36" r="0.9"/>
          <circle cx="83.13" cy="58.83" r="0.9"/>
          <circle cx="83.41" cy="59.91" r="0.9"/>
          <circle cx="83.69" cy="60.57" r="0.9"/>
          <circle cx="83.97" cy="60.79" r="0.9"/>
          <circle cx="84.25" cy="60.57" r="0.9"/>
          <circle cx="84.53" cy="59.91" r="0.9"/>
          <circle cx="84.81" cy="58.83" r="0.9"/>
          <circle cx="85.09" cy="57.36" r="0.9"/>
          <circle cx="85.37" cy="55.54" r="0.9"/>
          <circle cx="85.65" cy="53.4" r="0.9"/>
          <circle cx="85.93" cy="51" r="0.9"/>
          <circle cx="86.21" cy="48.4" r="0.9"/>
          <circle cx="86.49" cy="45.66" r="0.9"/>
          <circle cx="86.77" cy="42.86" r="0.9"/>
          <circle cx="87.05" cy="40.05" r="0.9"/>
          <circle cx="87.33" cy="37.32" r="0.9"/>
          <circle cx="87.61" cy="34.72" r="0.9"/>
          <circle cx="87.89" cy="32.32" r="0.9"/>
          <circle cx="88.17" cy="30.18" r="0.9"/>
          <circle cx="88.45" cy="28.35" r="0.9"/>
          <circle cx="88.73" cy="26.88" r="0.9"/>
          <circle cx="89.01" cy="25.81" r="0.9"/>
          <circle cx="89.29" cy="25.15" r="0.9"/>
          <circle cx="89.57" cy="24.93" r="0.9"/>
          <circle cx="89.86" cy="25.15" r="0.9"/>
          <circle cx="90.14" cy="25.81" r="0.9"/>
          <circle cx="90.42" cy="26.88" r="0.9"/>
          <circle cx="90.7" cy="28.35" r="0.9"/>
          <circle cx="90.98" cy="30.18" r="0.9"/>
          <circle cx="91.26" cy="32.32" r="0.9"/>
          <circle cx="91.54" cy="34.72" r="0.9"/>
          <circle cx="91.82" cy="37.32" r="0.9"/>
          <circle cx="92.1" cy="40.05" r="0.9"/>
          <circle cx="92.38" cy="42.86" r="0.9"/>
          <circle cx="92.66" cy="45.66" r="0.9"/>
          <circle cx="92.94" cy="48.4" r="0.9"/>
          <circle cx="93.22" cy="51" r="0.9"/>
          <circle cx="93.5" cy="53.4" r="0.9"/>
          <circle cx="93.78" cy="55.54" r="0.9"/>
          <circle cx="94.06" cy="57.36" r="0.9"/>
          <circle cx="94.34" cy="58.83" r="0.9"/>
          <circle cx="94.62" cy="59.91" r="0.9"/>
          <circle cx="94.9" cy="60.57" r="0.9"/>
          <circle cx="95.18" cy="60.79" r="0.9"/>
          <circle cx="95.46" cy="60.57" r="0.9"/>
          <circle cx="95.74" cy="59.91" r="0.9"/>
          <circle cx="96.02" cy="58.83" r="0.9"/>
          <circle cx="96.3" cy="57.36" r="0.9"/>
          <circle cx="96.58" cy="55.54" r="0.9"/>
          <circle cx="96.86" cy="53.4" r="0.9"/>
          <circle cx="97.14" cy="51" r="0.9"/>
          <circle cx="97.42" cy="48.4" r="0.9"/>
          <circle cx="97.7" cy="45.66" r="0.9"/>
          <circle cx="97.98" cy="42.86" r="0.9"/>
          <circle cx="98.26" cy="40.05" r="0.9"/>
          <circle cx="98.54" cy="37.32" r="0.9"/>
          <circle cx="98.82" cy="34.72" r="0.9"/>
          <circle cx="99.1" cy="32.32" r="0.9"/>
          <circle cx="99.38" cy="30.18" r="0.9"/>
          <circle cx="99.67" cy="28.35" r="0.9"/>
          <circle cx="99.95" cy="26.88" r="0.9"/>
          <circle cx="100.23" cy="25.81" r="0.9"/>
          <circle cx="100.51" cy="25.15" r="0.9"/>
          <circle cx="100.79" cy="24.93" r="0.9"/>
          <circle cx="101.07" cy="25.15" r="0.9"/>
          <circle cx="101.35" cy="25.81" r="0.9"/>
          <circle cx="101.63" cy="26.88" r="0.9"/>
          <circle cx="101.91" cy="28.35" r="0.9"/>
          <circle cx="102.19" cy="30.18" r="0.9"/>
          <circle cx="102.47" cy="32.32" r="0.9"/>
          <circle cx="102.75" cy="34.72" r="0.9"/>
          <circle cx="103.03" cy="37.32" r="0.9"/>
          <circle cx="103.31" cy="40.05" r="0.9"/>
          <circle cx="103.59" cy="42.86" r="0.9"/>
          <circle cx="103.87" cy="45.66" r="0.9"/>
          <circle cx="104.15" cy="48.4" r="0.9"/>
          <circle cx="104.43" cy="51" r="0.9"/>
          <circle cx="104.71" cy="53.4" r="0.9"/>
          <circle cx="104.99" cy="55.54" r="0.9"/>
          <circle cx="105.27" cy="57.36" r="0.9"/>
          <circle cx="105.55" cy="58.83" r="0.9"/>
          <circle cx="105.83" cy="59.91" r="0.9"/>
          <circle cx="106.11" cy="60.57" r="0.9"/>
          <circle cx="106.39" cy="60.79" r="0.9"/>
          <circle cx="106.67" cy="60.57" r="0.9"/>
          <circle cx="106.95" cy="59.91" r="0.9"/>
          <circle cx="107.23" cy="58.83" r="0.9"/>
          <circle cx="107.51" cy="57.36" r="0.9"/>
          <circle cx="107.79" cy="55.54" r="0.9"/>
          <circle cx="108.07" cy="53.4" r="0.9"/>
          <circle cx="108.35" cy="51" r="0.9"/>
          <circle cx="108.63" cy="48.4" r="0.9"/>
          <circle cx="108.91" cy="45.66" r="0.9"/>
          <circle cx="109.2" cy="42.86" r="0.9"/>
          <circle cx="109.48" cy="40.05" r="0.9"/>
          <circle cx="109.76" cy="37.32" r="0.9"/>
          <circle cx="110.04" cy="34.72" r="0.9"/>
          <circle cx="110.32" cy="32.32" r="0.9"/>
          <circle cx="110.6" cy="30.18" r="0.9"/>
          <circle cx="110.88" cy="28.35" r="0.9"/>
          <circle cx="111.16" cy="26.88" r="0.9"/>
          <circle cx="111.44" cy="25.81" r="0.9"/>
          <circle cx="111.72" cy="25.15" r="0.9"/>
          <circle cx="112" cy="24.93" r="0.9"/>
          <circle cx="112.28" cy="25.15" r="0.9"/>
          <circle cx="112.56" cy="25.81" r="0.9"/>
          <circle cx="112.84" cy="26.88" r="0.9"/>
          <circle cx="113.12" cy="28.35" r="0.9"/>
          <circle cx="113.4" cy="30.18" r="0.9"/>
          <circle cx="113.68" cy="32.32" r="0.9"/>
          <circle cx="113.96" cy="34.72" r="0.9"/>
          <circle cx="114.24" cy="37.32" r="0.9"/>
          <circle cx="114.52" cy="40.05" r="0.9"/>
          <circle cx="114.8" cy="42.86" r="0.9"/>
          <circle cx="115.08" cy="45.66" r="0.9"/>
          <circle cx="115.36" cy="48.4" r="0.9"/>
          <circle cx="115.64" cy="51" r="0.9"/>
          <circle cx="115.92" cy="53.4" r="0.9"/>
          <circle cx="116.2" cy="55.54" r="0.9"/>
          <circle cx="116.48" cy="57.36" r="0.9"/>
          <circle cx="116.76" cy="58.83" r="0.9"/>
          <circle cx="117.04" cy="59.91" r="0.9"/>
          <circle cx="117.32" cy="60.57" r="0.9"/>
          <circle cx="117.6" cy="60.79" r="0.9"/>
          <circle cx="117.88" cy="60.57" r="0.9"/>
          <circle cx="118.16" cy="59.91" r="0.9"/>
          <circle cx="118.44" cy="58.83" r="0.9"/>
          <circle cx="118.73" cy="57.36" r="0.9"/>
          <circle cx="119.01" cy="55.54" r="0.9"/>
          <circle cx="119.29" cy="53.4" r="0.9"/>
          <circle cx="119.57" cy="51" r="0.9"/>
          <circle cx="119.85" cy="48.4" r="0.9"/>
          <circle cx="120.13" cy="45.66" r="0.9"/>
          <circle cx="120.41" cy="42.86" r="0.9"/>
          <circle cx="120.69" cy="40.05" r="0.9"/>
          <circle cx="120.97" cy="37.32" r="0.9"/>
          <circle cx="121.25" cy="34.72" r="0.9"/>
          <circle cx="121.53" cy="32.32" r="0.9"/>
          <circle cx="121.81" cy="30.18" r="0.9"/>
          <circle cx="122.09" cy="28.35" r="0.9"/>
          <circle cx="122.37" cy="26.88" r="0.9"/>
          <circle cx="122.65" cy="25.81" r="0.9"/>
          <circle cx="122.93" cy="25.15" r="0.9"/>
          <circle cx="123.21" cy="24.93" r="0.9"/>
          <circle cx="123.49" cy="25.15" r="0.9"/>
          <circle cx="123.77" cy="25.81" r="0.9"/>
          <circle cx="124.05" cy="26.88" r="0.9"/>
          <circle cx="124.33" cy="28.35" r="0.9"/>
          <circle cx="124.61" cy="30.18" r="0.9"/>
          <circle cx="124.89" cy="32.32" r="0.9"/>
          <circle cx="125.17" cy="34.72" r="0.9"/>
          <circle cx="125.45" cy="37.32" r="0.9"/>
          <circle cx="125.73" cy="40.05" r="0.9"/>
          <circle cx="126.01" cy="42.86" r="0.9"/>
          <circle cx="126.29" cy="45.66" r="0.9"/>
          <circle cx="126.57" cy="48.4" r="0.9"/>
          <circle cx="126.85" cy="51" r="0.9"/>
          <circle cx="127.13" cy="53.4" r="0.9"/>
          <circle cx="127.41" cy="55.54" r="0.9"/>
          <circle cx="127.69" cy="57.36" r="0.9"/>
          <circle cx="127.97" cy="58.83" r="0.9"/>
          <circle cx="128.25" cy="59.91" r="0.9"/>
          <circle cx="128.54" cy="60.57" r="0.9"/>
          <circle cx="128.82" cy="60.79" r="0.9"/>
          <circle cx="129.1" cy="60.57" r="0.9"/>
          <circle cx="129.38" cy="59.91" r="0.9"/>
          <circle cx="129.66" cy="58.83" r="0.9"/>
          <circle cx="129.94" cy="57.36" r="0.9"/>
          <circle cx="130.22" cy="55.54" r="0.9"/>
          <circle cx="130.5" cy="53.4" r="0.9"/>
          <circle cx="130.78" cy="51" r="0.9"/>
          <circle cx="131.06" cy="48.4" r="0.9"/>
          <circle cx="131.34" cy="45.66" r="0.9"/>
          <circle cx="131.62" cy="42.86" r="0.9"/>
          <circle cx="131.9" cy="40.05" r="0.9"/>
          <circle cx="132.18" cy="37.32" r="0.9"/>
          <circle cx="132.46" cy="34.72" r="0.9"/>
          <circle cx="132.74" cy="32.32" r="0.9"/>
          <circle cx="133.02" cy="30.18" r="0.9"/>
          <circle cx="133.3" cy="28.35" r="0.9"/>
          <circle cx="133.58" cy="26.88" r="0.9"/>
          <circle cx="133.86" cy="25.81" r="0.9"/>
          <circle cx="134.14" cy="25.15" r="0.9"/>
          <circle cx="134.42" cy="24.93" r="0.9"/>
        </g>
      </g>
    </g>
    <g opacity="0" class="guide zoomslider" stroke="none" id="fig-c22dfd48538b4aa0ba3f8e349406edc7-element-12">
      <g fill="#EAEAEA" stroke-width="0.3" stroke-opacity="0" stroke="#6A6A6A" id="fig-c22dfd48538b4aa0ba3f8e349406edc7-element-13">
        <rect x="129.42" y="8" width="4" height="4"/>
        <g class="button_logo" fill="#6A6A6A" id="fig-c22dfd48538b4aa0ba3f8e349406edc7-element-14">
          <path d="M130.22,9.6 L 131.02 9.6 131.02 8.8 131.82 8.8 131.82 9.6 132.62 9.6 132.62 10.4 131.82 10.4 131.82 11.2 131.02 11.2 131.02 10.4 130.22 10.4 z"/>
        </g>
      </g>
      <g fill="#EAEAEA" id="fig-c22dfd48538b4aa0ba3f8e349406edc7-element-15">
        <rect x="109.92" y="8" width="19" height="4"/>
      </g>
      <g class="zoomslider_thumb" fill="#6A6A6A" id="fig-c22dfd48538b4aa0ba3f8e349406edc7-element-16">
        <rect x="118.42" y="8" width="2" height="4"/>
      </g>
      <g fill="#EAEAEA" stroke-width="0.3" stroke-opacity="0" stroke="#6A6A6A" id="fig-c22dfd48538b4aa0ba3f8e349406edc7-element-17">
        <rect x="105.42" y="8" width="4" height="4"/>
        <g class="button_logo" fill="#6A6A6A" id="fig-c22dfd48538b4aa0ba3f8e349406edc7-element-18">
          <path d="M106.22,9.6 L 108.62 9.6 108.62 10.4 106.22 10.4 z"/>
        </g>
      </g>
    </g>
  </g>
  <g class="guide ylabels" font-size="2.82" font-family="'PT Sans Caption','Helvetica Neue','Helvetica',sans-serif" fill="#6C606B" id="fig-c22dfd48538b4aa0ba3f8e349406edc7-element-19">
    <text x="19.31" y="168.36" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="hidden">0.50</text>
    <text x="19.31" y="150.43" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="hidden">0.55</text>
    <text x="19.31" y="132.5" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="hidden">0.60</text>
    <text x="19.31" y="114.57" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="hidden">0.65</text>
    <text x="19.31" y="96.64" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="hidden">0.70</text>
    <text x="19.31" y="78.72" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="visible">0.75</text>
    <text x="19.31" y="60.79" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="visible">0.80</text>
    <text x="19.31" y="42.86" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="visible">0.85</text>
    <text x="19.31" y="24.93" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="visible">0.90</text>
    <text x="19.31" y="7" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="visible">0.95</text>
    <text x="19.31" y="-10.93" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="hidden">1.00</text>
    <text x="19.31" y="-28.86" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="hidden">1.05</text>
    <text x="19.31" y="-46.79" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="hidden">1.10</text>
    <text x="19.31" y="-64.71" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="hidden">1.15</text>
    <text x="19.31" y="-82.64" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="hidden">1.20</text>
    <text x="19.31" y="154.02" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.54</text>
    <text x="19.31" y="150.43" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.55</text>
    <text x="19.31" y="146.84" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.56</text>
    <text x="19.31" y="143.26" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.57</text>
    <text x="19.31" y="139.67" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.58</text>
    <text x="19.31" y="136.09" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.59</text>
    <text x="19.31" y="132.5" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.60</text>
    <text x="19.31" y="128.92" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.61</text>
    <text x="19.31" y="125.33" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.62</text>
    <text x="19.31" y="121.74" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.63</text>
    <text x="19.31" y="118.16" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.64</text>
    <text x="19.31" y="114.57" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.65</text>
    <text x="19.31" y="110.99" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.66</text>
    <text x="19.31" y="107.4" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.67</text>
    <text x="19.31" y="103.82" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.68</text>
    <text x="19.31" y="100.23" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.69</text>
    <text x="19.31" y="96.64" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.70</text>
    <text x="19.31" y="93.06" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.71</text>
    <text x="19.31" y="89.47" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.72</text>
    <text x="19.31" y="85.89" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.73</text>
    <text x="19.31" y="82.3" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.74</text>
    <text x="19.31" y="78.72" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.75</text>
    <text x="19.31" y="75.13" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.76</text>
    <text x="19.31" y="71.54" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.77</text>
    <text x="19.31" y="67.96" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.78</text>
    <text x="19.31" y="64.37" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.79</text>
    <text x="19.31" y="60.79" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.80</text>
    <text x="19.31" y="57.2" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.81</text>
    <text x="19.31" y="53.61" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.82</text>
    <text x="19.31" y="50.03" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.83</text>
    <text x="19.31" y="46.44" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.84</text>
    <text x="19.31" y="42.86" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.85</text>
    <text x="19.31" y="39.27" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.86</text>
    <text x="19.31" y="35.69" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.87</text>
    <text x="19.31" y="32.1" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.88</text>
    <text x="19.31" y="28.51" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.89</text>
    <text x="19.31" y="24.93" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.90</text>
    <text x="19.31" y="21.34" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.91</text>
    <text x="19.31" y="17.76" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.92</text>
    <text x="19.31" y="14.17" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.93</text>
    <text x="19.31" y="10.59" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.94</text>
    <text x="19.31" y="7" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.95</text>
    <text x="19.31" y="3.41" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.96</text>
    <text x="19.31" y="-0.17" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.97</text>
    <text x="19.31" y="-3.76" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.98</text>
    <text x="19.31" y="-7.34" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.99</text>
    <text x="19.31" y="-10.93" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.00</text>
    <text x="19.31" y="-14.51" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.01</text>
    <text x="19.31" y="-18.1" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.02</text>
    <text x="19.31" y="-21.69" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.03</text>
    <text x="19.31" y="-25.27" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.04</text>
    <text x="19.31" y="-28.86" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.05</text>
    <text x="19.31" y="-32.44" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.06</text>
    <text x="19.31" y="-36.03" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.07</text>
    <text x="19.31" y="-39.61" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.08</text>
    <text x="19.31" y="-43.2" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.09</text>
    <text x="19.31" y="-46.79" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.10</text>
    <text x="19.31" y="-50.37" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.11</text>
    <text x="19.31" y="-53.96" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.12</text>
    <text x="19.31" y="-57.54" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.13</text>
    <text x="19.31" y="-61.13" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.14</text>
    <text x="19.31" y="-64.71" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.15</text>
    <text x="19.31" y="-68.3" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.16</text>
    <text x="19.31" y="204.22" text-anchor="end" dy="0.35em" gadfly:scale="0.5" visibility="hidden">0.4</text>
    <text x="19.31" y="132.5" text-anchor="end" dy="0.35em" gadfly:scale="0.5" visibility="hidden">0.6</text>
    <text x="19.31" y="60.79" text-anchor="end" dy="0.35em" gadfly:scale="0.5" visibility="hidden">0.8</text>
    <text x="19.31" y="-10.93" text-anchor="end" dy="0.35em" gadfly:scale="0.5" visibility="hidden">1.0</text>
    <text x="19.31" y="-82.64" text-anchor="end" dy="0.35em" gadfly:scale="0.5" visibility="hidden">1.2</text>
    <text x="19.31" y="154.02" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.54</text>
    <text x="19.31" y="146.84" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.56</text>
    <text x="19.31" y="139.67" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.58</text>
    <text x="19.31" y="132.5" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.60</text>
    <text x="19.31" y="125.33" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.62</text>
    <text x="19.31" y="118.16" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.64</text>
    <text x="19.31" y="110.99" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.66</text>
    <text x="19.31" y="103.82" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.68</text>
    <text x="19.31" y="96.64" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.70</text>
    <text x="19.31" y="89.47" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.72</text>
    <text x="19.31" y="82.3" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.74</text>
    <text x="19.31" y="75.13" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.76</text>
    <text x="19.31" y="67.96" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.78</text>
    <text x="19.31" y="60.79" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.80</text>
    <text x="19.31" y="53.61" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.82</text>
    <text x="19.31" y="46.44" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.84</text>
    <text x="19.31" y="39.27" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.86</text>
    <text x="19.31" y="32.1" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.88</text>
    <text x="19.31" y="24.93" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.90</text>
    <text x="19.31" y="17.76" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.92</text>
    <text x="19.31" y="10.59" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.94</text>
    <text x="19.31" y="3.41" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.96</text>
    <text x="19.31" y="-3.76" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.98</text>
    <text x="19.31" y="-10.93" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">1.00</text>
    <text x="19.31" y="-18.1" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">1.02</text>
    <text x="19.31" y="-25.27" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">1.04</text>
    <text x="19.31" y="-32.44" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">1.06</text>
    <text x="19.31" y="-39.61" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">1.08</text>
    <text x="19.31" y="-46.79" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">1.10</text>
    <text x="19.31" y="-53.96" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">1.12</text>
    <text x="19.31" y="-61.13" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">1.14</text>
    <text x="19.31" y="-68.3" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">1.16</text>
  </g>
  <g font-size="3.88" font-family="'PT Sans','Helvetica Neue','Helvetica',sans-serif" fill="#564A55" stroke="none" id="fig-c22dfd48538b4aa0ba3f8e349406edc7-element-20">
    <text x="8.81" y="40.86" text-anchor="middle" dy="0.35em" transform="rotate(-90, 8.81, 42.86)">Estimated p0</text>
  </g>
</g>
<defs>
<clipPath id="fig-c22dfd48538b4aa0ba3f8e349406edc7-element-5">
  <path d="M20.31,5 L 136.42 5 136.42 80.72 20.31 80.72" />
</clipPath
></defs>
<script> <![CDATA[
(function(N){var k=/[\.\/]/,L=/\s*,\s*/,C=function(a,d){return a-d},a,v,y={n:{}},M=function(){for(var a=0,d=this.length;a<d;a++)if("undefined"!=typeof this[a])return this[a]},A=function(){for(var a=this.length;--a;)if("undefined"!=typeof this[a])return this[a]},w=function(k,d){k=String(k);var f=v,n=Array.prototype.slice.call(arguments,2),u=w.listeners(k),p=0,b,q=[],e={},l=[],r=a;l.firstDefined=M;l.lastDefined=A;a=k;for(var s=v=0,x=u.length;s<x;s++)"zIndex"in u[s]&&(q.push(u[s].zIndex),0>u[s].zIndex&&
(e[u[s].zIndex]=u[s]));for(q.sort(C);0>q[p];)if(b=e[q[p++] ],l.push(b.apply(d,n)),v)return v=f,l;for(s=0;s<x;s++)if(b=u[s],"zIndex"in b)if(b.zIndex==q[p]){l.push(b.apply(d,n));if(v)break;do if(p++,(b=e[q[p] ])&&l.push(b.apply(d,n)),v)break;while(b)}else e[b.zIndex]=b;else if(l.push(b.apply(d,n)),v)break;v=f;a=r;return l};w._events=y;w.listeners=function(a){a=a.split(k);var d=y,f,n,u,p,b,q,e,l=[d],r=[];u=0;for(p=a.length;u<p;u++){e=[];b=0;for(q=l.length;b<q;b++)for(d=l[b].n,f=[d[a[u] ],d["*"] ],n=2;n--;)if(d=
f[n])e.push(d),r=r.concat(d.f||[]);l=e}return r};w.on=function(a,d){a=String(a);if("function"!=typeof d)return function(){};for(var f=a.split(L),n=0,u=f.length;n<u;n++)(function(a){a=a.split(k);for(var b=y,f,e=0,l=a.length;e<l;e++)b=b.n,b=b.hasOwnProperty(a[e])&&b[a[e] ]||(b[a[e] ]={n:{}});b.f=b.f||[];e=0;for(l=b.f.length;e<l;e++)if(b.f[e]==d){f=!0;break}!f&&b.f.push(d)})(f[n]);return function(a){+a==+a&&(d.zIndex=+a)}};w.f=function(a){var d=[].slice.call(arguments,1);return function(){w.apply(null,
[a,null].concat(d).concat([].slice.call(arguments,0)))}};w.stop=function(){v=1};w.nt=function(k){return k?(new RegExp("(?:\\.|\\/|^)"+k+"(?:\\.|\\/|$)")).test(a):a};w.nts=function(){return a.split(k)};w.off=w.unbind=function(a,d){if(a){var f=a.split(L);if(1<f.length)for(var n=0,u=f.length;n<u;n++)w.off(f[n],d);else{for(var f=a.split(k),p,b,q,e,l=[y],n=0,u=f.length;n<u;n++)for(e=0;e<l.length;e+=q.length-2){q=[e,1];p=l[e].n;if("*"!=f[n])p[f[n] ]&&q.push(p[f[n] ]);else for(b in p)p.hasOwnProperty(b)&&
q.push(p[b]);l.splice.apply(l,q)}n=0;for(u=l.length;n<u;n++)for(p=l[n];p.n;){if(d){if(p.f){e=0;for(f=p.f.length;e<f;e++)if(p.f[e]==d){p.f.splice(e,1);break}!p.f.length&&delete p.f}for(b in p.n)if(p.n.hasOwnProperty(b)&&p.n[b].f){q=p.n[b].f;e=0;for(f=q.length;e<f;e++)if(q[e]==d){q.splice(e,1);break}!q.length&&delete p.n[b].f}}else for(b in delete p.f,p.n)p.n.hasOwnProperty(b)&&p.n[b].f&&delete p.n[b].f;p=p.n}}}else w._events=y={n:{}}};w.once=function(a,d){var f=function(){w.unbind(a,f);return d.apply(this,
arguments)};return w.on(a,f)};w.version="0.4.2";w.toString=function(){return"You are running Eve 0.4.2"};"undefined"!=typeof module&&module.exports?module.exports=w:"function"===typeof define&&define.amd?define("eve",[],function(){return w}):N.eve=w})(this);
(function(N,k){"function"===typeof define&&define.amd?define("Snap.svg",["eve"],function(L){return k(N,L)}):k(N,N.eve)})(this,function(N,k){var L=function(a){var k={},y=N.requestAnimationFrame||N.webkitRequestAnimationFrame||N.mozRequestAnimationFrame||N.oRequestAnimationFrame||N.msRequestAnimationFrame||function(a){setTimeout(a,16)},M=Array.isArray||function(a){return a instanceof Array||"[object Array]"==Object.prototype.toString.call(a)},A=0,w="M"+(+new Date).toString(36),z=function(a){if(null==
a)return this.s;var b=this.s-a;this.b+=this.dur*b;this.B+=this.dur*b;this.s=a},d=function(a){if(null==a)return this.spd;this.spd=a},f=function(a){if(null==a)return this.dur;this.s=this.s*a/this.dur;this.dur=a},n=function(){delete k[this.id];this.update();a("mina.stop."+this.id,this)},u=function(){this.pdif||(delete k[this.id],this.update(),this.pdif=this.get()-this.b)},p=function(){this.pdif&&(this.b=this.get()-this.pdif,delete this.pdif,k[this.id]=this)},b=function(){var a;if(M(this.start)){a=[];
for(var b=0,e=this.start.length;b<e;b++)a[b]=+this.start[b]+(this.end[b]-this.start[b])*this.easing(this.s)}else a=+this.start+(this.end-this.start)*this.easing(this.s);this.set(a)},q=function(){var l=0,b;for(b in k)if(k.hasOwnProperty(b)){var e=k[b],f=e.get();l++;e.s=(f-e.b)/(e.dur/e.spd);1<=e.s&&(delete k[b],e.s=1,l--,function(b){setTimeout(function(){a("mina.finish."+b.id,b)})}(e));e.update()}l&&y(q)},e=function(a,r,s,x,G,h,J){a={id:w+(A++).toString(36),start:a,end:r,b:s,s:0,dur:x-s,spd:1,get:G,
set:h,easing:J||e.linear,status:z,speed:d,duration:f,stop:n,pause:u,resume:p,update:b};k[a.id]=a;r=0;for(var K in k)if(k.hasOwnProperty(K)&&(r++,2==r))break;1==r&&y(q);return a};e.time=Date.now||function(){return+new Date};e.getById=function(a){return k[a]||null};e.linear=function(a){return a};e.easeout=function(a){return Math.pow(a,1.7)};e.easein=function(a){return Math.pow(a,0.48)};e.easeinout=function(a){if(1==a)return 1;if(0==a)return 0;var b=0.48-a/1.04,e=Math.sqrt(0.1734+b*b);a=e-b;a=Math.pow(Math.abs(a),
1/3)*(0>a?-1:1);b=-e-b;b=Math.pow(Math.abs(b),1/3)*(0>b?-1:1);a=a+b+0.5;return 3*(1-a)*a*a+a*a*a};e.backin=function(a){return 1==a?1:a*a*(2.70158*a-1.70158)};e.backout=function(a){if(0==a)return 0;a-=1;return a*a*(2.70158*a+1.70158)+1};e.elastic=function(a){return a==!!a?a:Math.pow(2,-10*a)*Math.sin(2*(a-0.075)*Math.PI/0.3)+1};e.bounce=function(a){a<1/2.75?a*=7.5625*a:a<2/2.75?(a-=1.5/2.75,a=7.5625*a*a+0.75):a<2.5/2.75?(a-=2.25/2.75,a=7.5625*a*a+0.9375):(a-=2.625/2.75,a=7.5625*a*a+0.984375);return a};
return N.mina=e}("undefined"==typeof k?function(){}:k),C=function(){function a(c,t){if(c){if(c.tagName)return x(c);if(y(c,"array")&&a.set)return a.set.apply(a,c);if(c instanceof e)return c;if(null==t)return c=G.doc.querySelector(c),x(c)}return new s(null==c?"100%":c,null==t?"100%":t)}function v(c,a){if(a){"#text"==c&&(c=G.doc.createTextNode(a.text||""));"string"==typeof c&&(c=v(c));if("string"==typeof a)return"xlink:"==a.substring(0,6)?c.getAttributeNS(m,a.substring(6)):"xml:"==a.substring(0,4)?c.getAttributeNS(la,
a.substring(4)):c.getAttribute(a);for(var da in a)if(a[h](da)){var b=J(a[da]);b?"xlink:"==da.substring(0,6)?c.setAttributeNS(m,da.substring(6),b):"xml:"==da.substring(0,4)?c.setAttributeNS(la,da.substring(4),b):c.setAttribute(da,b):c.removeAttribute(da)}}else c=G.doc.createElementNS(la,c);return c}function y(c,a){a=J.prototype.toLowerCase.call(a);return"finite"==a?isFinite(c):"array"==a&&(c instanceof Array||Array.isArray&&Array.isArray(c))?!0:"null"==a&&null===c||a==typeof c&&null!==c||"object"==
a&&c===Object(c)||$.call(c).slice(8,-1).toLowerCase()==a}function M(c){if("function"==typeof c||Object(c)!==c)return c;var a=new c.constructor,b;for(b in c)c[h](b)&&(a[b]=M(c[b]));return a}function A(c,a,b){function m(){var e=Array.prototype.slice.call(arguments,0),f=e.join("\u2400"),d=m.cache=m.cache||{},l=m.count=m.count||[];if(d[h](f)){a:for(var e=l,l=f,B=0,H=e.length;B<H;B++)if(e[B]===l){e.push(e.splice(B,1)[0]);break a}return b?b(d[f]):d[f]}1E3<=l.length&&delete d[l.shift()];l.push(f);d[f]=c.apply(a,
e);return b?b(d[f]):d[f]}return m}function w(c,a,b,m,e,f){return null==e?(c-=b,a-=m,c||a?(180*I.atan2(-a,-c)/C+540)%360:0):w(c,a,e,f)-w(b,m,e,f)}function z(c){return c%360*C/180}function d(c){var a=[];c=c.replace(/(?:^|\s)(\w+)\(([^)]+)\)/g,function(c,b,m){m=m.split(/\s*,\s*|\s+/);"rotate"==b&&1==m.length&&m.push(0,0);"scale"==b&&(2<m.length?m=m.slice(0,2):2==m.length&&m.push(0,0),1==m.length&&m.push(m[0],0,0));"skewX"==b?a.push(["m",1,0,I.tan(z(m[0])),1,0,0]):"skewY"==b?a.push(["m",1,I.tan(z(m[0])),
0,1,0,0]):a.push([b.charAt(0)].concat(m));return c});return a}function f(c,t){var b=O(c),m=new a.Matrix;if(b)for(var e=0,f=b.length;e<f;e++){var h=b[e],d=h.length,B=J(h[0]).toLowerCase(),H=h[0]!=B,l=H?m.invert():0,E;"t"==B&&2==d?m.translate(h[1],0):"t"==B&&3==d?H?(d=l.x(0,0),B=l.y(0,0),H=l.x(h[1],h[2]),l=l.y(h[1],h[2]),m.translate(H-d,l-B)):m.translate(h[1],h[2]):"r"==B?2==d?(E=E||t,m.rotate(h[1],E.x+E.width/2,E.y+E.height/2)):4==d&&(H?(H=l.x(h[2],h[3]),l=l.y(h[2],h[3]),m.rotate(h[1],H,l)):m.rotate(h[1],
h[2],h[3])):"s"==B?2==d||3==d?(E=E||t,m.scale(h[1],h[d-1],E.x+E.width/2,E.y+E.height/2)):4==d?H?(H=l.x(h[2],h[3]),l=l.y(h[2],h[3]),m.scale(h[1],h[1],H,l)):m.scale(h[1],h[1],h[2],h[3]):5==d&&(H?(H=l.x(h[3],h[4]),l=l.y(h[3],h[4]),m.scale(h[1],h[2],H,l)):m.scale(h[1],h[2],h[3],h[4])):"m"==B&&7==d&&m.add(h[1],h[2],h[3],h[4],h[5],h[6])}return m}function n(c,t){if(null==t){var m=!0;t="linearGradient"==c.type||"radialGradient"==c.type?c.node.getAttribute("gradientTransform"):"pattern"==c.type?c.node.getAttribute("patternTransform"):
c.node.getAttribute("transform");if(!t)return new a.Matrix;t=d(t)}else t=a._.rgTransform.test(t)?J(t).replace(/\.{3}|\u2026/g,c._.transform||aa):d(t),y(t,"array")&&(t=a.path?a.path.toString.call(t):J(t)),c._.transform=t;var b=f(t,c.getBBox(1));if(m)return b;c.matrix=b}function u(c){c=c.node.ownerSVGElement&&x(c.node.ownerSVGElement)||c.node.parentNode&&x(c.node.parentNode)||a.select("svg")||a(0,0);var t=c.select("defs"),t=null==t?!1:t.node;t||(t=r("defs",c.node).node);return t}function p(c){return c.node.ownerSVGElement&&
x(c.node.ownerSVGElement)||a.select("svg")}function b(c,a,m){function b(c){if(null==c)return aa;if(c==+c)return c;v(B,{width:c});try{return B.getBBox().width}catch(a){return 0}}function h(c){if(null==c)return aa;if(c==+c)return c;v(B,{height:c});try{return B.getBBox().height}catch(a){return 0}}function e(b,B){null==a?d[b]=B(c.attr(b)||0):b==a&&(d=B(null==m?c.attr(b)||0:m))}var f=p(c).node,d={},B=f.querySelector(".svg---mgr");B||(B=v("rect"),v(B,{x:-9E9,y:-9E9,width:10,height:10,"class":"svg---mgr",
fill:"none"}),f.appendChild(B));switch(c.type){case "rect":e("rx",b),e("ry",h);case "image":e("width",b),e("height",h);case "text":e("x",b);e("y",h);break;case "circle":e("cx",b);e("cy",h);e("r",b);break;case "ellipse":e("cx",b);e("cy",h);e("rx",b);e("ry",h);break;case "line":e("x1",b);e("x2",b);e("y1",h);e("y2",h);break;case "marker":e("refX",b);e("markerWidth",b);e("refY",h);e("markerHeight",h);break;case "radialGradient":e("fx",b);e("fy",h);break;case "tspan":e("dx",b);e("dy",h);break;default:e(a,
b)}f.removeChild(B);return d}function q(c){y(c,"array")||(c=Array.prototype.slice.call(arguments,0));for(var a=0,b=0,m=this.node;this[a];)delete this[a++];for(a=0;a<c.length;a++)"set"==c[a].type?c[a].forEach(function(c){m.appendChild(c.node)}):m.appendChild(c[a].node);for(var h=m.childNodes,a=0;a<h.length;a++)this[b++]=x(h[a]);return this}function e(c){if(c.snap in E)return E[c.snap];var a=this.id=V(),b;try{b=c.ownerSVGElement}catch(m){}this.node=c;b&&(this.paper=new s(b));this.type=c.tagName;this.anims=
{};this._={transform:[]};c.snap=a;E[a]=this;"g"==this.type&&(this.add=q);if(this.type in{g:1,mask:1,pattern:1})for(var e in s.prototype)s.prototype[h](e)&&(this[e]=s.prototype[e])}function l(c){this.node=c}function r(c,a){var b=v(c);a.appendChild(b);return x(b)}function s(c,a){var b,m,f,d=s.prototype;if(c&&"svg"==c.tagName){if(c.snap in E)return E[c.snap];var l=c.ownerDocument;b=new e(c);m=c.getElementsByTagName("desc")[0];f=c.getElementsByTagName("defs")[0];m||(m=v("desc"),m.appendChild(l.createTextNode("Created with Snap")),
b.node.appendChild(m));f||(f=v("defs"),b.node.appendChild(f));b.defs=f;for(var ca in d)d[h](ca)&&(b[ca]=d[ca]);b.paper=b.root=b}else b=r("svg",G.doc.body),v(b.node,{height:a,version:1.1,width:c,xmlns:la});return b}function x(c){return!c||c instanceof e||c instanceof l?c:c.tagName&&"svg"==c.tagName.toLowerCase()?new s(c):c.tagName&&"object"==c.tagName.toLowerCase()&&"image/svg+xml"==c.type?new s(c.contentDocument.getElementsByTagName("svg")[0]):new e(c)}a.version="0.3.0";a.toString=function(){return"Snap v"+
this.version};a._={};var G={win:N,doc:N.document};a._.glob=G;var h="hasOwnProperty",J=String,K=parseFloat,U=parseInt,I=Math,P=I.max,Q=I.min,Y=I.abs,C=I.PI,aa="",$=Object.prototype.toString,F=/^\s*((#[a-f\d]{6})|(#[a-f\d]{3})|rgba?\(\s*([\d\.]+%?\s*,\s*[\d\.]+%?\s*,\s*[\d\.]+%?(?:\s*,\s*[\d\.]+%?)?)\s*\)|hsba?\(\s*([\d\.]+(?:deg|\xb0|%)?\s*,\s*[\d\.]+%?\s*,\s*[\d\.]+(?:%?\s*,\s*[\d\.]+)?%?)\s*\)|hsla?\(\s*([\d\.]+(?:deg|\xb0|%)?\s*,\s*[\d\.]+%?\s*,\s*[\d\.]+(?:%?\s*,\s*[\d\.]+)?%?)\s*\))\s*$/i;a._.separator=
RegExp("[,\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]+");var S=RegExp("[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*"),X={hs:1,rg:1},W=RegExp("([a-z])[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029,]*((-?\\d*\\.?\\d*(?:e[\\-+]?\\d+)?[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,?[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*)+)",
"ig"),ma=RegExp("([rstm])[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029,]*((-?\\d*\\.?\\d*(?:e[\\-+]?\\d+)?[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,?[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*)+)","ig"),Z=RegExp("(-?\\d*\\.?\\d*(?:e[\\-+]?\\d+)?)[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,?[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*",
"ig"),na=0,ba="S"+(+new Date).toString(36),V=function(){return ba+(na++).toString(36)},m="http://www.w3.org/1999/xlink",la="http://www.w3.org/2000/svg",E={},ca=a.url=function(c){return"url('#"+c+"')"};a._.$=v;a._.id=V;a.format=function(){var c=/\{([^\}]+)\}/g,a=/(?:(?:^|\.)(.+?)(?=\[|\.|$|\()|\[('|")(.+?)\2\])(\(\))?/g,b=function(c,b,m){var h=m;b.replace(a,function(c,a,b,m,t){a=a||m;h&&(a in h&&(h=h[a]),"function"==typeof h&&t&&(h=h()))});return h=(null==h||h==m?c:h)+""};return function(a,m){return J(a).replace(c,
function(c,a){return b(c,a,m)})}}();a._.clone=M;a._.cacher=A;a.rad=z;a.deg=function(c){return 180*c/C%360};a.angle=w;a.is=y;a.snapTo=function(c,a,b){b=y(b,"finite")?b:10;if(y(c,"array"))for(var m=c.length;m--;){if(Y(c[m]-a)<=b)return c[m]}else{c=+c;m=a%c;if(m<b)return a-m;if(m>c-b)return a-m+c}return a};a.getRGB=A(function(c){if(!c||(c=J(c)).indexOf("-")+1)return{r:-1,g:-1,b:-1,hex:"none",error:1,toString:ka};if("none"==c)return{r:-1,g:-1,b:-1,hex:"none",toString:ka};!X[h](c.toLowerCase().substring(0,
2))&&"#"!=c.charAt()&&(c=T(c));if(!c)return{r:-1,g:-1,b:-1,hex:"none",error:1,toString:ka};var b,m,e,f,d;if(c=c.match(F)){c[2]&&(e=U(c[2].substring(5),16),m=U(c[2].substring(3,5),16),b=U(c[2].substring(1,3),16));c[3]&&(e=U((d=c[3].charAt(3))+d,16),m=U((d=c[3].charAt(2))+d,16),b=U((d=c[3].charAt(1))+d,16));c[4]&&(d=c[4].split(S),b=K(d[0]),"%"==d[0].slice(-1)&&(b*=2.55),m=K(d[1]),"%"==d[1].slice(-1)&&(m*=2.55),e=K(d[2]),"%"==d[2].slice(-1)&&(e*=2.55),"rgba"==c[1].toLowerCase().slice(0,4)&&(f=K(d[3])),
d[3]&&"%"==d[3].slice(-1)&&(f/=100));if(c[5])return d=c[5].split(S),b=K(d[0]),"%"==d[0].slice(-1)&&(b/=100),m=K(d[1]),"%"==d[1].slice(-1)&&(m/=100),e=K(d[2]),"%"==d[2].slice(-1)&&(e/=100),"deg"!=d[0].slice(-3)&&"\u00b0"!=d[0].slice(-1)||(b/=360),"hsba"==c[1].toLowerCase().slice(0,4)&&(f=K(d[3])),d[3]&&"%"==d[3].slice(-1)&&(f/=100),a.hsb2rgb(b,m,e,f);if(c[6])return d=c[6].split(S),b=K(d[0]),"%"==d[0].slice(-1)&&(b/=100),m=K(d[1]),"%"==d[1].slice(-1)&&(m/=100),e=K(d[2]),"%"==d[2].slice(-1)&&(e/=100),
"deg"!=d[0].slice(-3)&&"\u00b0"!=d[0].slice(-1)||(b/=360),"hsla"==c[1].toLowerCase().slice(0,4)&&(f=K(d[3])),d[3]&&"%"==d[3].slice(-1)&&(f/=100),a.hsl2rgb(b,m,e,f);b=Q(I.round(b),255);m=Q(I.round(m),255);e=Q(I.round(e),255);f=Q(P(f,0),1);c={r:b,g:m,b:e,toString:ka};c.hex="#"+(16777216|e|m<<8|b<<16).toString(16).slice(1);c.opacity=y(f,"finite")?f:1;return c}return{r:-1,g:-1,b:-1,hex:"none",error:1,toString:ka}},a);a.hsb=A(function(c,b,m){return a.hsb2rgb(c,b,m).hex});a.hsl=A(function(c,b,m){return a.hsl2rgb(c,
b,m).hex});a.rgb=A(function(c,a,b,m){if(y(m,"finite")){var e=I.round;return"rgba("+[e(c),e(a),e(b),+m.toFixed(2)]+")"}return"#"+(16777216|b|a<<8|c<<16).toString(16).slice(1)});var T=function(c){var a=G.doc.getElementsByTagName("head")[0]||G.doc.getElementsByTagName("svg")[0];T=A(function(c){if("red"==c.toLowerCase())return"rgb(255, 0, 0)";a.style.color="rgb(255, 0, 0)";a.style.color=c;c=G.doc.defaultView.getComputedStyle(a,aa).getPropertyValue("color");return"rgb(255, 0, 0)"==c?null:c});return T(c)},
qa=function(){return"hsb("+[this.h,this.s,this.b]+")"},ra=function(){return"hsl("+[this.h,this.s,this.l]+")"},ka=function(){return 1==this.opacity||null==this.opacity?this.hex:"rgba("+[this.r,this.g,this.b,this.opacity]+")"},D=function(c,b,m){null==b&&y(c,"object")&&"r"in c&&"g"in c&&"b"in c&&(m=c.b,b=c.g,c=c.r);null==b&&y(c,string)&&(m=a.getRGB(c),c=m.r,b=m.g,m=m.b);if(1<c||1<b||1<m)c/=255,b/=255,m/=255;return[c,b,m]},oa=function(c,b,m,e){c=I.round(255*c);b=I.round(255*b);m=I.round(255*m);c={r:c,
g:b,b:m,opacity:y(e,"finite")?e:1,hex:a.rgb(c,b,m),toString:ka};y(e,"finite")&&(c.opacity=e);return c};a.color=function(c){var b;y(c,"object")&&"h"in c&&"s"in c&&"b"in c?(b=a.hsb2rgb(c),c.r=b.r,c.g=b.g,c.b=b.b,c.opacity=1,c.hex=b.hex):y(c,"object")&&"h"in c&&"s"in c&&"l"in c?(b=a.hsl2rgb(c),c.r=b.r,c.g=b.g,c.b=b.b,c.opacity=1,c.hex=b.hex):(y(c,"string")&&(c=a.getRGB(c)),y(c,"object")&&"r"in c&&"g"in c&&"b"in c&&!("error"in c)?(b=a.rgb2hsl(c),c.h=b.h,c.s=b.s,c.l=b.l,b=a.rgb2hsb(c),c.v=b.b):(c={hex:"none"},
c.r=c.g=c.b=c.h=c.s=c.v=c.l=-1,c.error=1));c.toString=ka;return c};a.hsb2rgb=function(c,a,b,m){y(c,"object")&&"h"in c&&"s"in c&&"b"in c&&(b=c.b,a=c.s,c=c.h,m=c.o);var e,h,d;c=360*c%360/60;d=b*a;a=d*(1-Y(c%2-1));b=e=h=b-d;c=~~c;b+=[d,a,0,0,a,d][c];e+=[a,d,d,a,0,0][c];h+=[0,0,a,d,d,a][c];return oa(b,e,h,m)};a.hsl2rgb=function(c,a,b,m){y(c,"object")&&"h"in c&&"s"in c&&"l"in c&&(b=c.l,a=c.s,c=c.h);if(1<c||1<a||1<b)c/=360,a/=100,b/=100;var e,h,d;c=360*c%360/60;d=2*a*(0.5>b?b:1-b);a=d*(1-Y(c%2-1));b=e=
h=b-d/2;c=~~c;b+=[d,a,0,0,a,d][c];e+=[a,d,d,a,0,0][c];h+=[0,0,a,d,d,a][c];return oa(b,e,h,m)};a.rgb2hsb=function(c,a,b){b=D(c,a,b);c=b[0];a=b[1];b=b[2];var m,e;m=P(c,a,b);e=m-Q(c,a,b);c=((0==e?0:m==c?(a-b)/e:m==a?(b-c)/e+2:(c-a)/e+4)+360)%6*60/360;return{h:c,s:0==e?0:e/m,b:m,toString:qa}};a.rgb2hsl=function(c,a,b){b=D(c,a,b);c=b[0];a=b[1];b=b[2];var m,e,h;m=P(c,a,b);e=Q(c,a,b);h=m-e;c=((0==h?0:m==c?(a-b)/h:m==a?(b-c)/h+2:(c-a)/h+4)+360)%6*60/360;m=(m+e)/2;return{h:c,s:0==h?0:0.5>m?h/(2*m):h/(2-2*
m),l:m,toString:ra}};a.parsePathString=function(c){if(!c)return null;var b=a.path(c);if(b.arr)return a.path.clone(b.arr);var m={a:7,c:6,o:2,h:1,l:2,m:2,r:4,q:4,s:4,t:2,v:1,u:3,z:0},e=[];y(c,"array")&&y(c[0],"array")&&(e=a.path.clone(c));e.length||J(c).replace(W,function(c,a,b){var h=[];c=a.toLowerCase();b.replace(Z,function(c,a){a&&h.push(+a)});"m"==c&&2<h.length&&(e.push([a].concat(h.splice(0,2))),c="l",a="m"==a?"l":"L");"o"==c&&1==h.length&&e.push([a,h[0] ]);if("r"==c)e.push([a].concat(h));else for(;h.length>=
m[c]&&(e.push([a].concat(h.splice(0,m[c]))),m[c]););});e.toString=a.path.toString;b.arr=a.path.clone(e);return e};var O=a.parseTransformString=function(c){if(!c)return null;var b=[];y(c,"array")&&y(c[0],"array")&&(b=a.path.clone(c));b.length||J(c).replace(ma,function(c,a,m){var e=[];a.toLowerCase();m.replace(Z,function(c,a){a&&e.push(+a)});b.push([a].concat(e))});b.toString=a.path.toString;return b};a._.svgTransform2string=d;a._.rgTransform=RegExp("^[a-z][\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*-?\\.?\\d",
"i");a._.transform2matrix=f;a._unit2px=b;a._.getSomeDefs=u;a._.getSomeSVG=p;a.select=function(c){return x(G.doc.querySelector(c))};a.selectAll=function(c){c=G.doc.querySelectorAll(c);for(var b=(a.set||Array)(),m=0;m<c.length;m++)b.push(x(c[m]));return b};setInterval(function(){for(var c in E)if(E[h](c)){var a=E[c],b=a.node;("svg"!=a.type&&!b.ownerSVGElement||"svg"==a.type&&(!b.parentNode||"ownerSVGElement"in b.parentNode&&!b.ownerSVGElement))&&delete E[c]}},1E4);(function(c){function m(c){function a(c,
b){var m=v(c.node,b);(m=(m=m&&m.match(d))&&m[2])&&"#"==m.charAt()&&(m=m.substring(1))&&(f[m]=(f[m]||[]).concat(function(a){var m={};m[b]=ca(a);v(c.node,m)}))}function b(c){var a=v(c.node,"xlink:href");a&&"#"==a.charAt()&&(a=a.substring(1))&&(f[a]=(f[a]||[]).concat(function(a){c.attr("xlink:href","#"+a)}))}var e=c.selectAll("*"),h,d=/^\s*url\(("|'|)(.*)\1\)\s*$/;c=[];for(var f={},l=0,E=e.length;l<E;l++){h=e[l];a(h,"fill");a(h,"stroke");a(h,"filter");a(h,"mask");a(h,"clip-path");b(h);var t=v(h.node,
"id");t&&(v(h.node,{id:h.id}),c.push({old:t,id:h.id}))}l=0;for(E=c.length;l<E;l++)if(e=f[c[l].old])for(h=0,t=e.length;h<t;h++)e[h](c[l].id)}function e(c,a,b){return function(m){m=m.slice(c,a);1==m.length&&(m=m[0]);return b?b(m):m}}function d(c){return function(){var a=c?"<"+this.type:"",b=this.node.attributes,m=this.node.childNodes;if(c)for(var e=0,h=b.length;e<h;e++)a+=" "+b[e].name+'="'+b[e].value.replace(/"/g,'\\"')+'"';if(m.length){c&&(a+=">");e=0;for(h=m.length;e<h;e++)3==m[e].nodeType?a+=m[e].nodeValue:
1==m[e].nodeType&&(a+=x(m[e]).toString());c&&(a+="</"+this.type+">")}else c&&(a+="/>");return a}}c.attr=function(c,a){if(!c)return this;if(y(c,"string"))if(1<arguments.length){var b={};b[c]=a;c=b}else return k("snap.util.getattr."+c,this).firstDefined();for(var m in c)c[h](m)&&k("snap.util.attr."+m,this,c[m]);return this};c.getBBox=function(c){if(!a.Matrix||!a.path)return this.node.getBBox();var b=this,m=new a.Matrix;if(b.removed)return a._.box();for(;"use"==b.type;)if(c||(m=m.add(b.transform().localMatrix.translate(b.attr("x")||
0,b.attr("y")||0))),b.original)b=b.original;else var e=b.attr("xlink:href"),b=b.original=b.node.ownerDocument.getElementById(e.substring(e.indexOf("#")+1));var e=b._,h=a.path.get[b.type]||a.path.get.deflt;try{if(c)return e.bboxwt=h?a.path.getBBox(b.realPath=h(b)):a._.box(b.node.getBBox()),a._.box(e.bboxwt);b.realPath=h(b);b.matrix=b.transform().localMatrix;e.bbox=a.path.getBBox(a.path.map(b.realPath,m.add(b.matrix)));return a._.box(e.bbox)}catch(d){return a._.box()}};var f=function(){return this.string};
c.transform=function(c){var b=this._;if(null==c){var m=this;c=new a.Matrix(this.node.getCTM());for(var e=n(this),h=[e],d=new a.Matrix,l=e.toTransformString(),b=J(e)==J(this.matrix)?J(b.transform):l;"svg"!=m.type&&(m=m.parent());)h.push(n(m));for(m=h.length;m--;)d.add(h[m]);return{string:b,globalMatrix:c,totalMatrix:d,localMatrix:e,diffMatrix:c.clone().add(e.invert()),global:c.toTransformString(),total:d.toTransformString(),local:l,toString:f}}c instanceof a.Matrix?this.matrix=c:n(this,c);this.node&&
("linearGradient"==this.type||"radialGradient"==this.type?v(this.node,{gradientTransform:this.matrix}):"pattern"==this.type?v(this.node,{patternTransform:this.matrix}):v(this.node,{transform:this.matrix}));return this};c.parent=function(){return x(this.node.parentNode)};c.append=c.add=function(c){if(c){if("set"==c.type){var a=this;c.forEach(function(c){a.add(c)});return this}c=x(c);this.node.appendChild(c.node);c.paper=this.paper}return this};c.appendTo=function(c){c&&(c=x(c),c.append(this));return this};
c.prepend=function(c){if(c){if("set"==c.type){var a=this,b;c.forEach(function(c){b?b.after(c):a.prepend(c);b=c});return this}c=x(c);var m=c.parent();this.node.insertBefore(c.node,this.node.firstChild);this.add&&this.add();c.paper=this.paper;this.parent()&&this.parent().add();m&&m.add()}return this};c.prependTo=function(c){c=x(c);c.prepend(this);return this};c.before=function(c){if("set"==c.type){var a=this;c.forEach(function(c){var b=c.parent();a.node.parentNode.insertBefore(c.node,a.node);b&&b.add()});
this.parent().add();return this}c=x(c);var b=c.parent();this.node.parentNode.insertBefore(c.node,this.node);this.parent()&&this.parent().add();b&&b.add();c.paper=this.paper;return this};c.after=function(c){c=x(c);var a=c.parent();this.node.nextSibling?this.node.parentNode.insertBefore(c.node,this.node.nextSibling):this.node.parentNode.appendChild(c.node);this.parent()&&this.parent().add();a&&a.add();c.paper=this.paper;return this};c.insertBefore=function(c){c=x(c);var a=this.parent();c.node.parentNode.insertBefore(this.node,
c.node);this.paper=c.paper;a&&a.add();c.parent()&&c.parent().add();return this};c.insertAfter=function(c){c=x(c);var a=this.parent();c.node.parentNode.insertBefore(this.node,c.node.nextSibling);this.paper=c.paper;a&&a.add();c.parent()&&c.parent().add();return this};c.remove=function(){var c=this.parent();this.node.parentNode&&this.node.parentNode.removeChild(this.node);delete this.paper;this.removed=!0;c&&c.add();return this};c.select=function(c){return x(this.node.querySelector(c))};c.selectAll=
function(c){c=this.node.querySelectorAll(c);for(var b=(a.set||Array)(),m=0;m<c.length;m++)b.push(x(c[m]));return b};c.asPX=function(c,a){null==a&&(a=this.attr(c));return+b(this,c,a)};c.use=function(){var c,a=this.node.id;a||(a=this.id,v(this.node,{id:a}));c="linearGradient"==this.type||"radialGradient"==this.type||"pattern"==this.type?r(this.type,this.node.parentNode):r("use",this.node.parentNode);v(c.node,{"xlink:href":"#"+a});c.original=this;return c};var l=/\S+/g;c.addClass=function(c){var a=(c||
"").match(l)||[];c=this.node;var b=c.className.baseVal,m=b.match(l)||[],e,h,d;if(a.length){for(e=0;d=a[e++];)h=m.indexOf(d),~h||m.push(d);a=m.join(" ");b!=a&&(c.className.baseVal=a)}return this};c.removeClass=function(c){var a=(c||"").match(l)||[];c=this.node;var b=c.className.baseVal,m=b.match(l)||[],e,h;if(m.length){for(e=0;h=a[e++];)h=m.indexOf(h),~h&&m.splice(h,1);a=m.join(" ");b!=a&&(c.className.baseVal=a)}return this};c.hasClass=function(c){return!!~(this.node.className.baseVal.match(l)||[]).indexOf(c)};
c.toggleClass=function(c,a){if(null!=a)return a?this.addClass(c):this.removeClass(c);var b=(c||"").match(l)||[],m=this.node,e=m.className.baseVal,h=e.match(l)||[],d,f,E;for(d=0;E=b[d++];)f=h.indexOf(E),~f?h.splice(f,1):h.push(E);b=h.join(" ");e!=b&&(m.className.baseVal=b);return this};c.clone=function(){var c=x(this.node.cloneNode(!0));v(c.node,"id")&&v(c.node,{id:c.id});m(c);c.insertAfter(this);return c};c.toDefs=function(){u(this).appendChild(this.node);return this};c.pattern=c.toPattern=function(c,
a,b,m){var e=r("pattern",u(this));null==c&&(c=this.getBBox());y(c,"object")&&"x"in c&&(a=c.y,b=c.width,m=c.height,c=c.x);v(e.node,{x:c,y:a,width:b,height:m,patternUnits:"userSpaceOnUse",id:e.id,viewBox:[c,a,b,m].join(" ")});e.node.appendChild(this.node);return e};c.marker=function(c,a,b,m,e,h){var d=r("marker",u(this));null==c&&(c=this.getBBox());y(c,"object")&&"x"in c&&(a=c.y,b=c.width,m=c.height,e=c.refX||c.cx,h=c.refY||c.cy,c=c.x);v(d.node,{viewBox:[c,a,b,m].join(" "),markerWidth:b,markerHeight:m,
orient:"auto",refX:e||0,refY:h||0,id:d.id});d.node.appendChild(this.node);return d};var E=function(c,a,b,m){"function"!=typeof b||b.length||(m=b,b=L.linear);this.attr=c;this.dur=a;b&&(this.easing=b);m&&(this.callback=m)};a._.Animation=E;a.animation=function(c,a,b,m){return new E(c,a,b,m)};c.inAnim=function(){var c=[],a;for(a in this.anims)this.anims[h](a)&&function(a){c.push({anim:new E(a._attrs,a.dur,a.easing,a._callback),mina:a,curStatus:a.status(),status:function(c){return a.status(c)},stop:function(){a.stop()}})}(this.anims[a]);
return c};a.animate=function(c,a,b,m,e,h){"function"!=typeof e||e.length||(h=e,e=L.linear);var d=L.time();c=L(c,a,d,d+m,L.time,b,e);h&&k.once("mina.finish."+c.id,h);return c};c.stop=function(){for(var c=this.inAnim(),a=0,b=c.length;a<b;a++)c[a].stop();return this};c.animate=function(c,a,b,m){"function"!=typeof b||b.length||(m=b,b=L.linear);c instanceof E&&(m=c.callback,b=c.easing,a=b.dur,c=c.attr);var d=[],f=[],l={},t,ca,n,T=this,q;for(q in c)if(c[h](q)){T.equal?(n=T.equal(q,J(c[q])),t=n.from,ca=
n.to,n=n.f):(t=+T.attr(q),ca=+c[q]);var la=y(t,"array")?t.length:1;l[q]=e(d.length,d.length+la,n);d=d.concat(t);f=f.concat(ca)}t=L.time();var p=L(d,f,t,t+a,L.time,function(c){var a={},b;for(b in l)l[h](b)&&(a[b]=l[b](c));T.attr(a)},b);T.anims[p.id]=p;p._attrs=c;p._callback=m;k("snap.animcreated."+T.id,p);k.once("mina.finish."+p.id,function(){delete T.anims[p.id];m&&m.call(T)});k.once("mina.stop."+p.id,function(){delete T.anims[p.id]});return T};var T={};c.data=function(c,b){var m=T[this.id]=T[this.id]||
{};if(0==arguments.length)return k("snap.data.get."+this.id,this,m,null),m;if(1==arguments.length){if(a.is(c,"object")){for(var e in c)c[h](e)&&this.data(e,c[e]);return this}k("snap.data.get."+this.id,this,m[c],c);return m[c]}m[c]=b;k("snap.data.set."+this.id,this,b,c);return this};c.removeData=function(c){null==c?T[this.id]={}:T[this.id]&&delete T[this.id][c];return this};c.outerSVG=c.toString=d(1);c.innerSVG=d()})(e.prototype);a.parse=function(c){var a=G.doc.createDocumentFragment(),b=!0,m=G.doc.createElement("div");
c=J(c);c.match(/^\s*<\s*svg(?:\s|>)/)||(c="<svg>"+c+"</svg>",b=!1);m.innerHTML=c;if(c=m.getElementsByTagName("svg")[0])if(b)a=c;else for(;c.firstChild;)a.appendChild(c.firstChild);m.innerHTML=aa;return new l(a)};l.prototype.select=e.prototype.select;l.prototype.selectAll=e.prototype.selectAll;a.fragment=function(){for(var c=Array.prototype.slice.call(arguments,0),b=G.doc.createDocumentFragment(),m=0,e=c.length;m<e;m++){var h=c[m];h.node&&h.node.nodeType&&b.appendChild(h.node);h.nodeType&&b.appendChild(h);
"string"==typeof h&&b.appendChild(a.parse(h).node)}return new l(b)};a._.make=r;a._.wrap=x;s.prototype.el=function(c,a){var b=r(c,this.node);a&&b.attr(a);return b};k.on("snap.util.getattr",function(){var c=k.nt(),c=c.substring(c.lastIndexOf(".")+1),a=c.replace(/[A-Z]/g,function(c){return"-"+c.toLowerCase()});return pa[h](a)?this.node.ownerDocument.defaultView.getComputedStyle(this.node,null).getPropertyValue(a):v(this.node,c)});var pa={"alignment-baseline":0,"baseline-shift":0,clip:0,"clip-path":0,
"clip-rule":0,color:0,"color-interpolation":0,"color-interpolation-filters":0,"color-profile":0,"color-rendering":0,cursor:0,direction:0,display:0,"dominant-baseline":0,"enable-background":0,fill:0,"fill-opacity":0,"fill-rule":0,filter:0,"flood-color":0,"flood-opacity":0,font:0,"font-family":0,"font-size":0,"font-size-adjust":0,"font-stretch":0,"font-style":0,"font-variant":0,"font-weight":0,"glyph-orientation-horizontal":0,"glyph-orientation-vertical":0,"image-rendering":0,kerning:0,"letter-spacing":0,
"lighting-color":0,marker:0,"marker-end":0,"marker-mid":0,"marker-start":0,mask:0,opacity:0,overflow:0,"pointer-events":0,"shape-rendering":0,"stop-color":0,"stop-opacity":0,stroke:0,"stroke-dasharray":0,"stroke-dashoffset":0,"stroke-linecap":0,"stroke-linejoin":0,"stroke-miterlimit":0,"stroke-opacity":0,"stroke-width":0,"text-anchor":0,"text-decoration":0,"text-rendering":0,"unicode-bidi":0,visibility:0,"word-spacing":0,"writing-mode":0};k.on("snap.util.attr",function(c){var a=k.nt(),b={},a=a.substring(a.lastIndexOf(".")+
1);b[a]=c;var m=a.replace(/-(\w)/gi,function(c,a){return a.toUpperCase()}),a=a.replace(/[A-Z]/g,function(c){return"-"+c.toLowerCase()});pa[h](a)?this.node.style[m]=null==c?aa:c:v(this.node,b)});a.ajax=function(c,a,b,m){var e=new XMLHttpRequest,h=V();if(e){if(y(a,"function"))m=b,b=a,a=null;else if(y(a,"object")){var d=[],f;for(f in a)a.hasOwnProperty(f)&&d.push(encodeURIComponent(f)+"="+encodeURIComponent(a[f]));a=d.join("&")}e.open(a?"POST":"GET",c,!0);a&&(e.setRequestHeader("X-Requested-With","XMLHttpRequest"),
e.setRequestHeader("Content-type","application/x-www-form-urlencoded"));b&&(k.once("snap.ajax."+h+".0",b),k.once("snap.ajax."+h+".200",b),k.once("snap.ajax."+h+".304",b));e.onreadystatechange=function(){4==e.readyState&&k("snap.ajax."+h+"."+e.status,m,e)};if(4==e.readyState)return e;e.send(a);return e}};a.load=function(c,b,m){a.ajax(c,function(c){c=a.parse(c.responseText);m?b.call(m,c):b(c)})};a.getElementByPoint=function(c,a){var b,m,e=G.doc.elementFromPoint(c,a);if(G.win.opera&&"svg"==e.tagName){b=
e;m=b.getBoundingClientRect();b=b.ownerDocument;var h=b.body,d=b.documentElement;b=m.top+(g.win.pageYOffset||d.scrollTop||h.scrollTop)-(d.clientTop||h.clientTop||0);m=m.left+(g.win.pageXOffset||d.scrollLeft||h.scrollLeft)-(d.clientLeft||h.clientLeft||0);h=e.createSVGRect();h.x=c-m;h.y=a-b;h.width=h.height=1;b=e.getIntersectionList(h,null);b.length&&(e=b[b.length-1])}return e?x(e):null};a.plugin=function(c){c(a,e,s,G,l)};return G.win.Snap=a}();C.plugin(function(a,k,y,M,A){function w(a,d,f,b,q,e){null==
d&&"[object SVGMatrix]"==z.call(a)?(this.a=a.a,this.b=a.b,this.c=a.c,this.d=a.d,this.e=a.e,this.f=a.f):null!=a?(this.a=+a,this.b=+d,this.c=+f,this.d=+b,this.e=+q,this.f=+e):(this.a=1,this.c=this.b=0,this.d=1,this.f=this.e=0)}var z=Object.prototype.toString,d=String,f=Math;(function(n){function k(a){return a[0]*a[0]+a[1]*a[1]}function p(a){var d=f.sqrt(k(a));a[0]&&(a[0]/=d);a[1]&&(a[1]/=d)}n.add=function(a,d,e,f,n,p){var k=[[],[],[] ],u=[[this.a,this.c,this.e],[this.b,this.d,this.f],[0,0,1] ];d=[[a,
e,n],[d,f,p],[0,0,1] ];a&&a instanceof w&&(d=[[a.a,a.c,a.e],[a.b,a.d,a.f],[0,0,1] ]);for(a=0;3>a;a++)for(e=0;3>e;e++){for(f=n=0;3>f;f++)n+=u[a][f]*d[f][e];k[a][e]=n}this.a=k[0][0];this.b=k[1][0];this.c=k[0][1];this.d=k[1][1];this.e=k[0][2];this.f=k[1][2];return this};n.invert=function(){var a=this.a*this.d-this.b*this.c;return new w(this.d/a,-this.b/a,-this.c/a,this.a/a,(this.c*this.f-this.d*this.e)/a,(this.b*this.e-this.a*this.f)/a)};n.clone=function(){return new w(this.a,this.b,this.c,this.d,this.e,
this.f)};n.translate=function(a,d){return this.add(1,0,0,1,a,d)};n.scale=function(a,d,e,f){null==d&&(d=a);(e||f)&&this.add(1,0,0,1,e,f);this.add(a,0,0,d,0,0);(e||f)&&this.add(1,0,0,1,-e,-f);return this};n.rotate=function(b,d,e){b=a.rad(b);d=d||0;e=e||0;var l=+f.cos(b).toFixed(9);b=+f.sin(b).toFixed(9);this.add(l,b,-b,l,d,e);return this.add(1,0,0,1,-d,-e)};n.x=function(a,d){return a*this.a+d*this.c+this.e};n.y=function(a,d){return a*this.b+d*this.d+this.f};n.get=function(a){return+this[d.fromCharCode(97+
a)].toFixed(4)};n.toString=function(){return"matrix("+[this.get(0),this.get(1),this.get(2),this.get(3),this.get(4),this.get(5)].join()+")"};n.offset=function(){return[this.e.toFixed(4),this.f.toFixed(4)]};n.determinant=function(){return this.a*this.d-this.b*this.c};n.split=function(){var b={};b.dx=this.e;b.dy=this.f;var d=[[this.a,this.c],[this.b,this.d] ];b.scalex=f.sqrt(k(d[0]));p(d[0]);b.shear=d[0][0]*d[1][0]+d[0][1]*d[1][1];d[1]=[d[1][0]-d[0][0]*b.shear,d[1][1]-d[0][1]*b.shear];b.scaley=f.sqrt(k(d[1]));
p(d[1]);b.shear/=b.scaley;0>this.determinant()&&(b.scalex=-b.scalex);var e=-d[0][1],d=d[1][1];0>d?(b.rotate=a.deg(f.acos(d)),0>e&&(b.rotate=360-b.rotate)):b.rotate=a.deg(f.asin(e));b.isSimple=!+b.shear.toFixed(9)&&(b.scalex.toFixed(9)==b.scaley.toFixed(9)||!b.rotate);b.isSuperSimple=!+b.shear.toFixed(9)&&b.scalex.toFixed(9)==b.scaley.toFixed(9)&&!b.rotate;b.noRotation=!+b.shear.toFixed(9)&&!b.rotate;return b};n.toTransformString=function(a){a=a||this.split();if(+a.shear.toFixed(9))return"m"+[this.get(0),
this.get(1),this.get(2),this.get(3),this.get(4),this.get(5)];a.scalex=+a.scalex.toFixed(4);a.scaley=+a.scaley.toFixed(4);a.rotate=+a.rotate.toFixed(4);return(a.dx||a.dy?"t"+[+a.dx.toFixed(4),+a.dy.toFixed(4)]:"")+(1!=a.scalex||1!=a.scaley?"s"+[a.scalex,a.scaley,0,0]:"")+(a.rotate?"r"+[+a.rotate.toFixed(4),0,0]:"")}})(w.prototype);a.Matrix=w;a.matrix=function(a,d,f,b,k,e){return new w(a,d,f,b,k,e)}});C.plugin(function(a,v,y,M,A){function w(h){return function(d){k.stop();d instanceof A&&1==d.node.childNodes.length&&
("radialGradient"==d.node.firstChild.tagName||"linearGradient"==d.node.firstChild.tagName||"pattern"==d.node.firstChild.tagName)&&(d=d.node.firstChild,b(this).appendChild(d),d=u(d));if(d instanceof v)if("radialGradient"==d.type||"linearGradient"==d.type||"pattern"==d.type){d.node.id||e(d.node,{id:d.id});var f=l(d.node.id)}else f=d.attr(h);else f=a.color(d),f.error?(f=a(b(this).ownerSVGElement).gradient(d))?(f.node.id||e(f.node,{id:f.id}),f=l(f.node.id)):f=d:f=r(f);d={};d[h]=f;e(this.node,d);this.node.style[h]=
x}}function z(a){k.stop();a==+a&&(a+="px");this.node.style.fontSize=a}function d(a){var b=[];a=a.childNodes;for(var e=0,f=a.length;e<f;e++){var l=a[e];3==l.nodeType&&b.push(l.nodeValue);"tspan"==l.tagName&&(1==l.childNodes.length&&3==l.firstChild.nodeType?b.push(l.firstChild.nodeValue):b.push(d(l)))}return b}function f(){k.stop();return this.node.style.fontSize}var n=a._.make,u=a._.wrap,p=a.is,b=a._.getSomeDefs,q=/^url\(#?([^)]+)\)$/,e=a._.$,l=a.url,r=String,s=a._.separator,x="";k.on("snap.util.attr.mask",
function(a){if(a instanceof v||a instanceof A){k.stop();a instanceof A&&1==a.node.childNodes.length&&(a=a.node.firstChild,b(this).appendChild(a),a=u(a));if("mask"==a.type)var d=a;else d=n("mask",b(this)),d.node.appendChild(a.node);!d.node.id&&e(d.node,{id:d.id});e(this.node,{mask:l(d.id)})}});(function(a){k.on("snap.util.attr.clip",a);k.on("snap.util.attr.clip-path",a);k.on("snap.util.attr.clipPath",a)})(function(a){if(a instanceof v||a instanceof A){k.stop();if("clipPath"==a.type)var d=a;else d=
n("clipPath",b(this)),d.node.appendChild(a.node),!d.node.id&&e(d.node,{id:d.id});e(this.node,{"clip-path":l(d.id)})}});k.on("snap.util.attr.fill",w("fill"));k.on("snap.util.attr.stroke",w("stroke"));var G=/^([lr])(?:\(([^)]*)\))?(.*)$/i;k.on("snap.util.grad.parse",function(a){a=r(a);var b=a.match(G);if(!b)return null;a=b[1];var e=b[2],b=b[3],e=e.split(/\s*,\s*/).map(function(a){return+a==a?+a:a});1==e.length&&0==e[0]&&(e=[]);b=b.split("-");b=b.map(function(a){a=a.split(":");var b={color:a[0]};a[1]&&
(b.offset=parseFloat(a[1]));return b});return{type:a,params:e,stops:b}});k.on("snap.util.attr.d",function(b){k.stop();p(b,"array")&&p(b[0],"array")&&(b=a.path.toString.call(b));b=r(b);b.match(/[ruo]/i)&&(b=a.path.toAbsolute(b));e(this.node,{d:b})})(-1);k.on("snap.util.attr.#text",function(a){k.stop();a=r(a);for(a=M.doc.createTextNode(a);this.node.firstChild;)this.node.removeChild(this.node.firstChild);this.node.appendChild(a)})(-1);k.on("snap.util.attr.path",function(a){k.stop();this.attr({d:a})})(-1);
k.on("snap.util.attr.class",function(a){k.stop();this.node.className.baseVal=a})(-1);k.on("snap.util.attr.viewBox",function(a){a=p(a,"object")&&"x"in a?[a.x,a.y,a.width,a.height].join(" "):p(a,"array")?a.join(" "):a;e(this.node,{viewBox:a});k.stop()})(-1);k.on("snap.util.attr.transform",function(a){this.transform(a);k.stop()})(-1);k.on("snap.util.attr.r",function(a){"rect"==this.type&&(k.stop(),e(this.node,{rx:a,ry:a}))})(-1);k.on("snap.util.attr.textpath",function(a){k.stop();if("text"==this.type){var d,
f;if(!a&&this.textPath){for(a=this.textPath;a.node.firstChild;)this.node.appendChild(a.node.firstChild);a.remove();delete this.textPath}else if(p(a,"string")?(d=b(this),a=u(d.parentNode).path(a),d.appendChild(a.node),d=a.id,a.attr({id:d})):(a=u(a),a instanceof v&&(d=a.attr("id"),d||(d=a.id,a.attr({id:d})))),d)if(a=this.textPath,f=this.node,a)a.attr({"xlink:href":"#"+d});else{for(a=e("textPath",{"xlink:href":"#"+d});f.firstChild;)a.appendChild(f.firstChild);f.appendChild(a);this.textPath=u(a)}}})(-1);
k.on("snap.util.attr.text",function(a){if("text"==this.type){for(var b=this.node,d=function(a){var b=e("tspan");if(p(a,"array"))for(var f=0;f<a.length;f++)b.appendChild(d(a[f]));else b.appendChild(M.doc.createTextNode(a));b.normalize&&b.normalize();return b};b.firstChild;)b.removeChild(b.firstChild);for(a=d(a);a.firstChild;)b.appendChild(a.firstChild)}k.stop()})(-1);k.on("snap.util.attr.fontSize",z)(-1);k.on("snap.util.attr.font-size",z)(-1);k.on("snap.util.getattr.transform",function(){k.stop();
return this.transform()})(-1);k.on("snap.util.getattr.textpath",function(){k.stop();return this.textPath})(-1);(function(){function b(d){return function(){k.stop();var b=M.doc.defaultView.getComputedStyle(this.node,null).getPropertyValue("marker-"+d);return"none"==b?b:a(M.doc.getElementById(b.match(q)[1]))}}function d(a){return function(b){k.stop();var d="marker"+a.charAt(0).toUpperCase()+a.substring(1);if(""==b||!b)this.node.style[d]="none";else if("marker"==b.type){var f=b.node.id;f||e(b.node,{id:b.id});
this.node.style[d]=l(f)}}}k.on("snap.util.getattr.marker-end",b("end"))(-1);k.on("snap.util.getattr.markerEnd",b("end"))(-1);k.on("snap.util.getattr.marker-start",b("start"))(-1);k.on("snap.util.getattr.markerStart",b("start"))(-1);k.on("snap.util.getattr.marker-mid",b("mid"))(-1);k.on("snap.util.getattr.markerMid",b("mid"))(-1);k.on("snap.util.attr.marker-end",d("end"))(-1);k.on("snap.util.attr.markerEnd",d("end"))(-1);k.on("snap.util.attr.marker-start",d("start"))(-1);k.on("snap.util.attr.markerStart",
d("start"))(-1);k.on("snap.util.attr.marker-mid",d("mid"))(-1);k.on("snap.util.attr.markerMid",d("mid"))(-1)})();k.on("snap.util.getattr.r",function(){if("rect"==this.type&&e(this.node,"rx")==e(this.node,"ry"))return k.stop(),e(this.node,"rx")})(-1);k.on("snap.util.getattr.text",function(){if("text"==this.type||"tspan"==this.type){k.stop();var a=d(this.node);return 1==a.length?a[0]:a}})(-1);k.on("snap.util.getattr.#text",function(){return this.node.textContent})(-1);k.on("snap.util.getattr.viewBox",
function(){k.stop();var b=e(this.node,"viewBox");if(b)return b=b.split(s),a._.box(+b[0],+b[1],+b[2],+b[3])})(-1);k.on("snap.util.getattr.points",function(){var a=e(this.node,"points");k.stop();if(a)return a.split(s)})(-1);k.on("snap.util.getattr.path",function(){var a=e(this.node,"d");k.stop();return a})(-1);k.on("snap.util.getattr.class",function(){return this.node.className.baseVal})(-1);k.on("snap.util.getattr.fontSize",f)(-1);k.on("snap.util.getattr.font-size",f)(-1)});C.plugin(function(a,v,y,
M,A){function w(a){return a}function z(a){return function(b){return+b.toFixed(3)+a}}var d={"+":function(a,b){return a+b},"-":function(a,b){return a-b},"/":function(a,b){return a/b},"*":function(a,b){return a*b}},f=String,n=/[a-z]+$/i,u=/^\s*([+\-\/*])\s*=\s*([\d.eE+\-]+)\s*([^\d\s]+)?\s*$/;k.on("snap.util.attr",function(a){if(a=f(a).match(u)){var b=k.nt(),b=b.substring(b.lastIndexOf(".")+1),q=this.attr(b),e={};k.stop();var l=a[3]||"",r=q.match(n),s=d[a[1] ];r&&r==l?a=s(parseFloat(q),+a[2]):(q=this.asPX(b),
a=s(this.asPX(b),this.asPX(b,a[2]+l)));isNaN(q)||isNaN(a)||(e[b]=a,this.attr(e))}})(-10);k.on("snap.util.equal",function(a,b){var q=f(this.attr(a)||""),e=f(b).match(u);if(e){k.stop();var l=e[3]||"",r=q.match(n),s=d[e[1] ];if(r&&r==l)return{from:parseFloat(q),to:s(parseFloat(q),+e[2]),f:z(r)};q=this.asPX(a);return{from:q,to:s(q,this.asPX(a,e[2]+l)),f:w}}})(-10)});C.plugin(function(a,v,y,M,A){var w=y.prototype,z=a.is;w.rect=function(a,d,k,p,b,q){var e;null==q&&(q=b);z(a,"object")&&"[object Object]"==
a?e=a:null!=a&&(e={x:a,y:d,width:k,height:p},null!=b&&(e.rx=b,e.ry=q));return this.el("rect",e)};w.circle=function(a,d,k){var p;z(a,"object")&&"[object Object]"==a?p=a:null!=a&&(p={cx:a,cy:d,r:k});return this.el("circle",p)};var d=function(){function a(){this.parentNode.removeChild(this)}return function(d,k){var p=M.doc.createElement("img"),b=M.doc.body;p.style.cssText="position:absolute;left:-9999em;top:-9999em";p.onload=function(){k.call(p);p.onload=p.onerror=null;b.removeChild(p)};p.onerror=a;
b.appendChild(p);p.src=d}}();w.image=function(f,n,k,p,b){var q=this.el("image");if(z(f,"object")&&"src"in f)q.attr(f);else if(null!=f){var e={"xlink:href":f,preserveAspectRatio:"none"};null!=n&&null!=k&&(e.x=n,e.y=k);null!=p&&null!=b?(e.width=p,e.height=b):d(f,function(){a._.$(q.node,{width:this.offsetWidth,height:this.offsetHeight})});a._.$(q.node,e)}return q};w.ellipse=function(a,d,k,p){var b;z(a,"object")&&"[object Object]"==a?b=a:null!=a&&(b={cx:a,cy:d,rx:k,ry:p});return this.el("ellipse",b)};
w.path=function(a){var d;z(a,"object")&&!z(a,"array")?d=a:a&&(d={d:a});return this.el("path",d)};w.group=w.g=function(a){var d=this.el("g");1==arguments.length&&a&&!a.type?d.attr(a):arguments.length&&d.add(Array.prototype.slice.call(arguments,0));return d};w.svg=function(a,d,k,p,b,q,e,l){var r={};z(a,"object")&&null==d?r=a:(null!=a&&(r.x=a),null!=d&&(r.y=d),null!=k&&(r.width=k),null!=p&&(r.height=p),null!=b&&null!=q&&null!=e&&null!=l&&(r.viewBox=[b,q,e,l]));return this.el("svg",r)};w.mask=function(a){var d=
this.el("mask");1==arguments.length&&a&&!a.type?d.attr(a):arguments.length&&d.add(Array.prototype.slice.call(arguments,0));return d};w.ptrn=function(a,d,k,p,b,q,e,l){if(z(a,"object"))var r=a;else arguments.length?(r={},null!=a&&(r.x=a),null!=d&&(r.y=d),null!=k&&(r.width=k),null!=p&&(r.height=p),null!=b&&null!=q&&null!=e&&null!=l&&(r.viewBox=[b,q,e,l])):r={patternUnits:"userSpaceOnUse"};return this.el("pattern",r)};w.use=function(a){return null!=a?(make("use",this.node),a instanceof v&&(a.attr("id")||
a.attr({id:ID()}),a=a.attr("id")),this.el("use",{"xlink:href":a})):v.prototype.use.call(this)};w.text=function(a,d,k){var p={};z(a,"object")?p=a:null!=a&&(p={x:a,y:d,text:k||""});return this.el("text",p)};w.line=function(a,d,k,p){var b={};z(a,"object")?b=a:null!=a&&(b={x1:a,x2:k,y1:d,y2:p});return this.el("line",b)};w.polyline=function(a){1<arguments.length&&(a=Array.prototype.slice.call(arguments,0));var d={};z(a,"object")&&!z(a,"array")?d=a:null!=a&&(d={points:a});return this.el("polyline",d)};
w.polygon=function(a){1<arguments.length&&(a=Array.prototype.slice.call(arguments,0));var d={};z(a,"object")&&!z(a,"array")?d=a:null!=a&&(d={points:a});return this.el("polygon",d)};(function(){function d(){return this.selectAll("stop")}function n(b,d){var f=e("stop"),k={offset:+d+"%"};b=a.color(b);k["stop-color"]=b.hex;1>b.opacity&&(k["stop-opacity"]=b.opacity);e(f,k);this.node.appendChild(f);return this}function u(){if("linearGradient"==this.type){var b=e(this.node,"x1")||0,d=e(this.node,"x2")||
1,f=e(this.node,"y1")||0,k=e(this.node,"y2")||0;return a._.box(b,f,math.abs(d-b),math.abs(k-f))}b=this.node.r||0;return a._.box((this.node.cx||0.5)-b,(this.node.cy||0.5)-b,2*b,2*b)}function p(a,d){function f(a,b){for(var d=(b-u)/(a-w),e=w;e<a;e++)h[e].offset=+(+u+d*(e-w)).toFixed(2);w=a;u=b}var n=k("snap.util.grad.parse",null,d).firstDefined(),p;if(!n)return null;n.params.unshift(a);p="l"==n.type.toLowerCase()?b.apply(0,n.params):q.apply(0,n.params);n.type!=n.type.toLowerCase()&&e(p.node,{gradientUnits:"userSpaceOnUse"});
var h=n.stops,n=h.length,u=0,w=0;n--;for(var v=0;v<n;v++)"offset"in h[v]&&f(v,h[v].offset);h[n].offset=h[n].offset||100;f(n,h[n].offset);for(v=0;v<=n;v++){var y=h[v];p.addStop(y.color,y.offset)}return p}function b(b,k,p,q,w){b=a._.make("linearGradient",b);b.stops=d;b.addStop=n;b.getBBox=u;null!=k&&e(b.node,{x1:k,y1:p,x2:q,y2:w});return b}function q(b,k,p,q,w,h){b=a._.make("radialGradient",b);b.stops=d;b.addStop=n;b.getBBox=u;null!=k&&e(b.node,{cx:k,cy:p,r:q});null!=w&&null!=h&&e(b.node,{fx:w,fy:h});
return b}var e=a._.$;w.gradient=function(a){return p(this.defs,a)};w.gradientLinear=function(a,d,e,f){return b(this.defs,a,d,e,f)};w.gradientRadial=function(a,b,d,e,f){return q(this.defs,a,b,d,e,f)};w.toString=function(){var b=this.node.ownerDocument,d=b.createDocumentFragment(),b=b.createElement("div"),e=this.node.cloneNode(!0);d.appendChild(b);b.appendChild(e);a._.$(e,{xmlns:"http://www.w3.org/2000/svg"});b=b.innerHTML;d.removeChild(d.firstChild);return b};w.clear=function(){for(var a=this.node.firstChild,
b;a;)b=a.nextSibling,"defs"!=a.tagName?a.parentNode.removeChild(a):w.clear.call({node:a}),a=b}})()});C.plugin(function(a,k,y,M){function A(a){var b=A.ps=A.ps||{};b[a]?b[a].sleep=100:b[a]={sleep:100};setTimeout(function(){for(var d in b)b[L](d)&&d!=a&&(b[d].sleep--,!b[d].sleep&&delete b[d])});return b[a]}function w(a,b,d,e){null==a&&(a=b=d=e=0);null==b&&(b=a.y,d=a.width,e=a.height,a=a.x);return{x:a,y:b,width:d,w:d,height:e,h:e,x2:a+d,y2:b+e,cx:a+d/2,cy:b+e/2,r1:F.min(d,e)/2,r2:F.max(d,e)/2,r0:F.sqrt(d*
d+e*e)/2,path:s(a,b,d,e),vb:[a,b,d,e].join(" ")}}function z(){return this.join(",").replace(N,"$1")}function d(a){a=C(a);a.toString=z;return a}function f(a,b,d,h,f,k,l,n,p){if(null==p)return e(a,b,d,h,f,k,l,n);if(0>p||e(a,b,d,h,f,k,l,n)<p)p=void 0;else{var q=0.5,O=1-q,s;for(s=e(a,b,d,h,f,k,l,n,O);0.01<Z(s-p);)q/=2,O+=(s<p?1:-1)*q,s=e(a,b,d,h,f,k,l,n,O);p=O}return u(a,b,d,h,f,k,l,n,p)}function n(b,d){function e(a){return+(+a).toFixed(3)}return a._.cacher(function(a,h,l){a instanceof k&&(a=a.attr("d"));
a=I(a);for(var n,p,D,q,O="",s={},c=0,t=0,r=a.length;t<r;t++){D=a[t];if("M"==D[0])n=+D[1],p=+D[2];else{q=f(n,p,D[1],D[2],D[3],D[4],D[5],D[6]);if(c+q>h){if(d&&!s.start){n=f(n,p,D[1],D[2],D[3],D[4],D[5],D[6],h-c);O+=["C"+e(n.start.x),e(n.start.y),e(n.m.x),e(n.m.y),e(n.x),e(n.y)];if(l)return O;s.start=O;O=["M"+e(n.x),e(n.y)+"C"+e(n.n.x),e(n.n.y),e(n.end.x),e(n.end.y),e(D[5]),e(D[6])].join();c+=q;n=+D[5];p=+D[6];continue}if(!b&&!d)return n=f(n,p,D[1],D[2],D[3],D[4],D[5],D[6],h-c)}c+=q;n=+D[5];p=+D[6]}O+=
D.shift()+D}s.end=O;return n=b?c:d?s:u(n,p,D[0],D[1],D[2],D[3],D[4],D[5],1)},null,a._.clone)}function u(a,b,d,e,h,f,k,l,n){var p=1-n,q=ma(p,3),s=ma(p,2),c=n*n,t=c*n,r=q*a+3*s*n*d+3*p*n*n*h+t*k,q=q*b+3*s*n*e+3*p*n*n*f+t*l,s=a+2*n*(d-a)+c*(h-2*d+a),t=b+2*n*(e-b)+c*(f-2*e+b),x=d+2*n*(h-d)+c*(k-2*h+d),c=e+2*n*(f-e)+c*(l-2*f+e);a=p*a+n*d;b=p*b+n*e;h=p*h+n*k;f=p*f+n*l;l=90-180*F.atan2(s-x,t-c)/S;return{x:r,y:q,m:{x:s,y:t},n:{x:x,y:c},start:{x:a,y:b},end:{x:h,y:f},alpha:l}}function p(b,d,e,h,f,n,k,l){a.is(b,
"array")||(b=[b,d,e,h,f,n,k,l]);b=U.apply(null,b);return w(b.min.x,b.min.y,b.max.x-b.min.x,b.max.y-b.min.y)}function b(a,b,d){return b>=a.x&&b<=a.x+a.width&&d>=a.y&&d<=a.y+a.height}function q(a,d){a=w(a);d=w(d);return b(d,a.x,a.y)||b(d,a.x2,a.y)||b(d,a.x,a.y2)||b(d,a.x2,a.y2)||b(a,d.x,d.y)||b(a,d.x2,d.y)||b(a,d.x,d.y2)||b(a,d.x2,d.y2)||(a.x<d.x2&&a.x>d.x||d.x<a.x2&&d.x>a.x)&&(a.y<d.y2&&a.y>d.y||d.y<a.y2&&d.y>a.y)}function e(a,b,d,e,h,f,n,k,l){null==l&&(l=1);l=(1<l?1:0>l?0:l)/2;for(var p=[-0.1252,
0.1252,-0.3678,0.3678,-0.5873,0.5873,-0.7699,0.7699,-0.9041,0.9041,-0.9816,0.9816],q=[0.2491,0.2491,0.2335,0.2335,0.2032,0.2032,0.1601,0.1601,0.1069,0.1069,0.0472,0.0472],s=0,c=0;12>c;c++)var t=l*p[c]+l,r=t*(t*(-3*a+9*d-9*h+3*n)+6*a-12*d+6*h)-3*a+3*d,t=t*(t*(-3*b+9*e-9*f+3*k)+6*b-12*e+6*f)-3*b+3*e,s=s+q[c]*F.sqrt(r*r+t*t);return l*s}function l(a,b,d){a=I(a);b=I(b);for(var h,f,l,n,k,s,r,O,x,c,t=d?0:[],w=0,v=a.length;w<v;w++)if(x=a[w],"M"==x[0])h=k=x[1],f=s=x[2];else{"C"==x[0]?(x=[h,f].concat(x.slice(1)),
h=x[6],f=x[7]):(x=[h,f,h,f,k,s,k,s],h=k,f=s);for(var G=0,y=b.length;G<y;G++)if(c=b[G],"M"==c[0])l=r=c[1],n=O=c[2];else{"C"==c[0]?(c=[l,n].concat(c.slice(1)),l=c[6],n=c[7]):(c=[l,n,l,n,r,O,r,O],l=r,n=O);var z;var K=x,B=c;z=d;var H=p(K),J=p(B);if(q(H,J)){for(var H=e.apply(0,K),J=e.apply(0,B),H=~~(H/8),J=~~(J/8),U=[],A=[],F={},M=z?0:[],P=0;P<H+1;P++){var C=u.apply(0,K.concat(P/H));U.push({x:C.x,y:C.y,t:P/H})}for(P=0;P<J+1;P++)C=u.apply(0,B.concat(P/J)),A.push({x:C.x,y:C.y,t:P/J});for(P=0;P<H;P++)for(K=
0;K<J;K++){var Q=U[P],L=U[P+1],B=A[K],C=A[K+1],N=0.001>Z(L.x-Q.x)?"y":"x",S=0.001>Z(C.x-B.x)?"y":"x",R;R=Q.x;var Y=Q.y,V=L.x,ea=L.y,fa=B.x,ga=B.y,ha=C.x,ia=C.y;if(W(R,V)<X(fa,ha)||X(R,V)>W(fa,ha)||W(Y,ea)<X(ga,ia)||X(Y,ea)>W(ga,ia))R=void 0;else{var $=(R*ea-Y*V)*(fa-ha)-(R-V)*(fa*ia-ga*ha),aa=(R*ea-Y*V)*(ga-ia)-(Y-ea)*(fa*ia-ga*ha),ja=(R-V)*(ga-ia)-(Y-ea)*(fa-ha);if(ja){var $=$/ja,aa=aa/ja,ja=+$.toFixed(2),ba=+aa.toFixed(2);R=ja<+X(R,V).toFixed(2)||ja>+W(R,V).toFixed(2)||ja<+X(fa,ha).toFixed(2)||
ja>+W(fa,ha).toFixed(2)||ba<+X(Y,ea).toFixed(2)||ba>+W(Y,ea).toFixed(2)||ba<+X(ga,ia).toFixed(2)||ba>+W(ga,ia).toFixed(2)?void 0:{x:$,y:aa}}else R=void 0}R&&F[R.x.toFixed(4)]!=R.y.toFixed(4)&&(F[R.x.toFixed(4)]=R.y.toFixed(4),Q=Q.t+Z((R[N]-Q[N])/(L[N]-Q[N]))*(L.t-Q.t),B=B.t+Z((R[S]-B[S])/(C[S]-B[S]))*(C.t-B.t),0<=Q&&1>=Q&&0<=B&&1>=B&&(z?M++:M.push({x:R.x,y:R.y,t1:Q,t2:B})))}z=M}else z=z?0:[];if(d)t+=z;else{H=0;for(J=z.length;H<J;H++)z[H].segment1=w,z[H].segment2=G,z[H].bez1=x,z[H].bez2=c;t=t.concat(z)}}}return t}
function r(a){var b=A(a);if(b.bbox)return C(b.bbox);if(!a)return w();a=I(a);for(var d=0,e=0,h=[],f=[],l,n=0,k=a.length;n<k;n++)l=a[n],"M"==l[0]?(d=l[1],e=l[2],h.push(d),f.push(e)):(d=U(d,e,l[1],l[2],l[3],l[4],l[5],l[6]),h=h.concat(d.min.x,d.max.x),f=f.concat(d.min.y,d.max.y),d=l[5],e=l[6]);a=X.apply(0,h);l=X.apply(0,f);h=W.apply(0,h);f=W.apply(0,f);f=w(a,l,h-a,f-l);b.bbox=C(f);return f}function s(a,b,d,e,h){if(h)return[["M",+a+ +h,b],["l",d-2*h,0],["a",h,h,0,0,1,h,h],["l",0,e-2*h],["a",h,h,0,0,1,
-h,h],["l",2*h-d,0],["a",h,h,0,0,1,-h,-h],["l",0,2*h-e],["a",h,h,0,0,1,h,-h],["z"] ];a=[["M",a,b],["l",d,0],["l",0,e],["l",-d,0],["z"] ];a.toString=z;return a}function x(a,b,d,e,h){null==h&&null==e&&(e=d);a=+a;b=+b;d=+d;e=+e;if(null!=h){var f=Math.PI/180,l=a+d*Math.cos(-e*f);a+=d*Math.cos(-h*f);var n=b+d*Math.sin(-e*f);b+=d*Math.sin(-h*f);d=[["M",l,n],["A",d,d,0,+(180<h-e),0,a,b] ]}else d=[["M",a,b],["m",0,-e],["a",d,e,0,1,1,0,2*e],["a",d,e,0,1,1,0,-2*e],["z"] ];d.toString=z;return d}function G(b){var e=
A(b);if(e.abs)return d(e.abs);Q(b,"array")&&Q(b&&b[0],"array")||(b=a.parsePathString(b));if(!b||!b.length)return[["M",0,0] ];var h=[],f=0,l=0,n=0,k=0,p=0;"M"==b[0][0]&&(f=+b[0][1],l=+b[0][2],n=f,k=l,p++,h[0]=["M",f,l]);for(var q=3==b.length&&"M"==b[0][0]&&"R"==b[1][0].toUpperCase()&&"Z"==b[2][0].toUpperCase(),s,r,w=p,c=b.length;w<c;w++){h.push(s=[]);r=b[w];p=r[0];if(p!=p.toUpperCase())switch(s[0]=p.toUpperCase(),s[0]){case "A":s[1]=r[1];s[2]=r[2];s[3]=r[3];s[4]=r[4];s[5]=r[5];s[6]=+r[6]+f;s[7]=+r[7]+
l;break;case "V":s[1]=+r[1]+l;break;case "H":s[1]=+r[1]+f;break;case "R":for(var t=[f,l].concat(r.slice(1)),u=2,v=t.length;u<v;u++)t[u]=+t[u]+f,t[++u]=+t[u]+l;h.pop();h=h.concat(P(t,q));break;case "O":h.pop();t=x(f,l,r[1],r[2]);t.push(t[0]);h=h.concat(t);break;case "U":h.pop();h=h.concat(x(f,l,r[1],r[2],r[3]));s=["U"].concat(h[h.length-1].slice(-2));break;case "M":n=+r[1]+f,k=+r[2]+l;default:for(u=1,v=r.length;u<v;u++)s[u]=+r[u]+(u%2?f:l)}else if("R"==p)t=[f,l].concat(r.slice(1)),h.pop(),h=h.concat(P(t,
q)),s=["R"].concat(r.slice(-2));else if("O"==p)h.pop(),t=x(f,l,r[1],r[2]),t.push(t[0]),h=h.concat(t);else if("U"==p)h.pop(),h=h.concat(x(f,l,r[1],r[2],r[3])),s=["U"].concat(h[h.length-1].slice(-2));else for(t=0,u=r.length;t<u;t++)s[t]=r[t];p=p.toUpperCase();if("O"!=p)switch(s[0]){case "Z":f=+n;l=+k;break;case "H":f=s[1];break;case "V":l=s[1];break;case "M":n=s[s.length-2],k=s[s.length-1];default:f=s[s.length-2],l=s[s.length-1]}}h.toString=z;e.abs=d(h);return h}function h(a,b,d,e){return[a,b,d,e,d,
e]}function J(a,b,d,e,h,f){var l=1/3,n=2/3;return[l*a+n*d,l*b+n*e,l*h+n*d,l*f+n*e,h,f]}function K(b,d,e,h,f,l,n,k,p,s){var r=120*S/180,q=S/180*(+f||0),c=[],t,x=a._.cacher(function(a,b,c){var d=a*F.cos(c)-b*F.sin(c);a=a*F.sin(c)+b*F.cos(c);return{x:d,y:a}});if(s)v=s[0],t=s[1],l=s[2],u=s[3];else{t=x(b,d,-q);b=t.x;d=t.y;t=x(k,p,-q);k=t.x;p=t.y;F.cos(S/180*f);F.sin(S/180*f);t=(b-k)/2;v=(d-p)/2;u=t*t/(e*e)+v*v/(h*h);1<u&&(u=F.sqrt(u),e*=u,h*=u);var u=e*e,w=h*h,u=(l==n?-1:1)*F.sqrt(Z((u*w-u*v*v-w*t*t)/
(u*v*v+w*t*t)));l=u*e*v/h+(b+k)/2;var u=u*-h*t/e+(d+p)/2,v=F.asin(((d-u)/h).toFixed(9));t=F.asin(((p-u)/h).toFixed(9));v=b<l?S-v:v;t=k<l?S-t:t;0>v&&(v=2*S+v);0>t&&(t=2*S+t);n&&v>t&&(v-=2*S);!n&&t>v&&(t-=2*S)}if(Z(t-v)>r){var c=t,w=k,G=p;t=v+r*(n&&t>v?1:-1);k=l+e*F.cos(t);p=u+h*F.sin(t);c=K(k,p,e,h,f,0,n,w,G,[t,c,l,u])}l=t-v;f=F.cos(v);r=F.sin(v);n=F.cos(t);t=F.sin(t);l=F.tan(l/4);e=4/3*e*l;l*=4/3*h;h=[b,d];b=[b+e*r,d-l*f];d=[k+e*t,p-l*n];k=[k,p];b[0]=2*h[0]-b[0];b[1]=2*h[1]-b[1];if(s)return[b,d,k].concat(c);
c=[b,d,k].concat(c).join().split(",");s=[];k=0;for(p=c.length;k<p;k++)s[k]=k%2?x(c[k-1],c[k],q).y:x(c[k],c[k+1],q).x;return s}function U(a,b,d,e,h,f,l,k){for(var n=[],p=[[],[] ],s,r,c,t,q=0;2>q;++q)0==q?(r=6*a-12*d+6*h,s=-3*a+9*d-9*h+3*l,c=3*d-3*a):(r=6*b-12*e+6*f,s=-3*b+9*e-9*f+3*k,c=3*e-3*b),1E-12>Z(s)?1E-12>Z(r)||(s=-c/r,0<s&&1>s&&n.push(s)):(t=r*r-4*c*s,c=F.sqrt(t),0>t||(t=(-r+c)/(2*s),0<t&&1>t&&n.push(t),s=(-r-c)/(2*s),0<s&&1>s&&n.push(s)));for(r=q=n.length;q--;)s=n[q],c=1-s,p[0][q]=c*c*c*a+3*
c*c*s*d+3*c*s*s*h+s*s*s*l,p[1][q]=c*c*c*b+3*c*c*s*e+3*c*s*s*f+s*s*s*k;p[0][r]=a;p[1][r]=b;p[0][r+1]=l;p[1][r+1]=k;p[0].length=p[1].length=r+2;return{min:{x:X.apply(0,p[0]),y:X.apply(0,p[1])},max:{x:W.apply(0,p[0]),y:W.apply(0,p[1])}}}function I(a,b){var e=!b&&A(a);if(!b&&e.curve)return d(e.curve);var f=G(a),l=b&&G(b),n={x:0,y:0,bx:0,by:0,X:0,Y:0,qx:null,qy:null},k={x:0,y:0,bx:0,by:0,X:0,Y:0,qx:null,qy:null},p=function(a,b,c){if(!a)return["C",b.x,b.y,b.x,b.y,b.x,b.y];a[0]in{T:1,Q:1}||(b.qx=b.qy=null);
switch(a[0]){case "M":b.X=a[1];b.Y=a[2];break;case "A":a=["C"].concat(K.apply(0,[b.x,b.y].concat(a.slice(1))));break;case "S":"C"==c||"S"==c?(c=2*b.x-b.bx,b=2*b.y-b.by):(c=b.x,b=b.y);a=["C",c,b].concat(a.slice(1));break;case "T":"Q"==c||"T"==c?(b.qx=2*b.x-b.qx,b.qy=2*b.y-b.qy):(b.qx=b.x,b.qy=b.y);a=["C"].concat(J(b.x,b.y,b.qx,b.qy,a[1],a[2]));break;case "Q":b.qx=a[1];b.qy=a[2];a=["C"].concat(J(b.x,b.y,a[1],a[2],a[3],a[4]));break;case "L":a=["C"].concat(h(b.x,b.y,a[1],a[2]));break;case "H":a=["C"].concat(h(b.x,
b.y,a[1],b.y));break;case "V":a=["C"].concat(h(b.x,b.y,b.x,a[1]));break;case "Z":a=["C"].concat(h(b.x,b.y,b.X,b.Y))}return a},s=function(a,b){if(7<a[b].length){a[b].shift();for(var c=a[b];c.length;)q[b]="A",l&&(u[b]="A"),a.splice(b++,0,["C"].concat(c.splice(0,6)));a.splice(b,1);v=W(f.length,l&&l.length||0)}},r=function(a,b,c,d,e){a&&b&&"M"==a[e][0]&&"M"!=b[e][0]&&(b.splice(e,0,["M",d.x,d.y]),c.bx=0,c.by=0,c.x=a[e][1],c.y=a[e][2],v=W(f.length,l&&l.length||0))},q=[],u=[],c="",t="",x=0,v=W(f.length,
l&&l.length||0);for(;x<v;x++){f[x]&&(c=f[x][0]);"C"!=c&&(q[x]=c,x&&(t=q[x-1]));f[x]=p(f[x],n,t);"A"!=q[x]&&"C"==c&&(q[x]="C");s(f,x);l&&(l[x]&&(c=l[x][0]),"C"!=c&&(u[x]=c,x&&(t=u[x-1])),l[x]=p(l[x],k,t),"A"!=u[x]&&"C"==c&&(u[x]="C"),s(l,x));r(f,l,n,k,x);r(l,f,k,n,x);var w=f[x],z=l&&l[x],y=w.length,U=l&&z.length;n.x=w[y-2];n.y=w[y-1];n.bx=$(w[y-4])||n.x;n.by=$(w[y-3])||n.y;k.bx=l&&($(z[U-4])||k.x);k.by=l&&($(z[U-3])||k.y);k.x=l&&z[U-2];k.y=l&&z[U-1]}l||(e.curve=d(f));return l?[f,l]:f}function P(a,
b){for(var d=[],e=0,h=a.length;h-2*!b>e;e+=2){var f=[{x:+a[e-2],y:+a[e-1]},{x:+a[e],y:+a[e+1]},{x:+a[e+2],y:+a[e+3]},{x:+a[e+4],y:+a[e+5]}];b?e?h-4==e?f[3]={x:+a[0],y:+a[1]}:h-2==e&&(f[2]={x:+a[0],y:+a[1]},f[3]={x:+a[2],y:+a[3]}):f[0]={x:+a[h-2],y:+a[h-1]}:h-4==e?f[3]=f[2]:e||(f[0]={x:+a[e],y:+a[e+1]});d.push(["C",(-f[0].x+6*f[1].x+f[2].x)/6,(-f[0].y+6*f[1].y+f[2].y)/6,(f[1].x+6*f[2].x-f[3].x)/6,(f[1].y+6*f[2].y-f[3].y)/6,f[2].x,f[2].y])}return d}y=k.prototype;var Q=a.is,C=a._.clone,L="hasOwnProperty",
N=/,?([a-z]),?/gi,$=parseFloat,F=Math,S=F.PI,X=F.min,W=F.max,ma=F.pow,Z=F.abs;M=n(1);var na=n(),ba=n(0,1),V=a._unit2px;a.path=A;a.path.getTotalLength=M;a.path.getPointAtLength=na;a.path.getSubpath=function(a,b,d){if(1E-6>this.getTotalLength(a)-d)return ba(a,b).end;a=ba(a,d,1);return b?ba(a,b).end:a};y.getTotalLength=function(){if(this.node.getTotalLength)return this.node.getTotalLength()};y.getPointAtLength=function(a){return na(this.attr("d"),a)};y.getSubpath=function(b,d){return a.path.getSubpath(this.attr("d"),
b,d)};a._.box=w;a.path.findDotsAtSegment=u;a.path.bezierBBox=p;a.path.isPointInsideBBox=b;a.path.isBBoxIntersect=q;a.path.intersection=function(a,b){return l(a,b)};a.path.intersectionNumber=function(a,b){return l(a,b,1)};a.path.isPointInside=function(a,d,e){var h=r(a);return b(h,d,e)&&1==l(a,[["M",d,e],["H",h.x2+10] ],1)%2};a.path.getBBox=r;a.path.get={path:function(a){return a.attr("path")},circle:function(a){a=V(a);return x(a.cx,a.cy,a.r)},ellipse:function(a){a=V(a);return x(a.cx||0,a.cy||0,a.rx,
a.ry)},rect:function(a){a=V(a);return s(a.x||0,a.y||0,a.width,a.height,a.rx,a.ry)},image:function(a){a=V(a);return s(a.x||0,a.y||0,a.width,a.height)},line:function(a){return"M"+[a.attr("x1")||0,a.attr("y1")||0,a.attr("x2"),a.attr("y2")]},polyline:function(a){return"M"+a.attr("points")},polygon:function(a){return"M"+a.attr("points")+"z"},deflt:function(a){a=a.node.getBBox();return s(a.x,a.y,a.width,a.height)}};a.path.toRelative=function(b){var e=A(b),h=String.prototype.toLowerCase;if(e.rel)return d(e.rel);
a.is(b,"array")&&a.is(b&&b[0],"array")||(b=a.parsePathString(b));var f=[],l=0,n=0,k=0,p=0,s=0;"M"==b[0][0]&&(l=b[0][1],n=b[0][2],k=l,p=n,s++,f.push(["M",l,n]));for(var r=b.length;s<r;s++){var q=f[s]=[],x=b[s];if(x[0]!=h.call(x[0]))switch(q[0]=h.call(x[0]),q[0]){case "a":q[1]=x[1];q[2]=x[2];q[3]=x[3];q[4]=x[4];q[5]=x[5];q[6]=+(x[6]-l).toFixed(3);q[7]=+(x[7]-n).toFixed(3);break;case "v":q[1]=+(x[1]-n).toFixed(3);break;case "m":k=x[1],p=x[2];default:for(var c=1,t=x.length;c<t;c++)q[c]=+(x[c]-(c%2?l:
n)).toFixed(3)}else for(f[s]=[],"m"==x[0]&&(k=x[1]+l,p=x[2]+n),q=0,c=x.length;q<c;q++)f[s][q]=x[q];x=f[s].length;switch(f[s][0]){case "z":l=k;n=p;break;case "h":l+=+f[s][x-1];break;case "v":n+=+f[s][x-1];break;default:l+=+f[s][x-2],n+=+f[s][x-1]}}f.toString=z;e.rel=d(f);return f};a.path.toAbsolute=G;a.path.toCubic=I;a.path.map=function(a,b){if(!b)return a;var d,e,h,f,l,n,k;a=I(a);h=0;for(l=a.length;h<l;h++)for(k=a[h],f=1,n=k.length;f<n;f+=2)d=b.x(k[f],k[f+1]),e=b.y(k[f],k[f+1]),k[f]=d,k[f+1]=e;return a};
a.path.toString=z;a.path.clone=d});C.plugin(function(a,v,y,C){var A=Math.max,w=Math.min,z=function(a){this.items=[];this.bindings={};this.length=0;this.type="set";if(a)for(var f=0,n=a.length;f<n;f++)a[f]&&(this[this.items.length]=this.items[this.items.length]=a[f],this.length++)};v=z.prototype;v.push=function(){for(var a,f,n=0,k=arguments.length;n<k;n++)if(a=arguments[n])f=this.items.length,this[f]=this.items[f]=a,this.length++;return this};v.pop=function(){this.length&&delete this[this.length--];
return this.items.pop()};v.forEach=function(a,f){for(var n=0,k=this.items.length;n<k&&!1!==a.call(f,this.items[n],n);n++);return this};v.animate=function(d,f,n,u){"function"!=typeof n||n.length||(u=n,n=L.linear);d instanceof a._.Animation&&(u=d.callback,n=d.easing,f=n.dur,d=d.attr);var p=arguments;if(a.is(d,"array")&&a.is(p[p.length-1],"array"))var b=!0;var q,e=function(){q?this.b=q:q=this.b},l=0,r=u&&function(){l++==this.length&&u.call(this)};return this.forEach(function(a,l){k.once("snap.animcreated."+
a.id,e);b?p[l]&&a.animate.apply(a,p[l]):a.animate(d,f,n,r)})};v.remove=function(){for(;this.length;)this.pop().remove();return this};v.bind=function(a,f,k){var u={};if("function"==typeof f)this.bindings[a]=f;else{var p=k||a;this.bindings[a]=function(a){u[p]=a;f.attr(u)}}return this};v.attr=function(a){var f={},k;for(k in a)if(this.bindings[k])this.bindings[k](a[k]);else f[k]=a[k];a=0;for(k=this.items.length;a<k;a++)this.items[a].attr(f);return this};v.clear=function(){for(;this.length;)this.pop()};
v.splice=function(a,f,k){a=0>a?A(this.length+a,0):a;f=A(0,w(this.length-a,f));var u=[],p=[],b=[],q;for(q=2;q<arguments.length;q++)b.push(arguments[q]);for(q=0;q<f;q++)p.push(this[a+q]);for(;q<this.length-a;q++)u.push(this[a+q]);var e=b.length;for(q=0;q<e+u.length;q++)this.items[a+q]=this[a+q]=q<e?b[q]:u[q-e];for(q=this.items.length=this.length-=f-e;this[q];)delete this[q++];return new z(p)};v.exclude=function(a){for(var f=0,k=this.length;f<k;f++)if(this[f]==a)return this.splice(f,1),!0;return!1};
v.insertAfter=function(a){for(var f=this.items.length;f--;)this.items[f].insertAfter(a);return this};v.getBBox=function(){for(var a=[],f=[],k=[],u=[],p=this.items.length;p--;)if(!this.items[p].removed){var b=this.items[p].getBBox();a.push(b.x);f.push(b.y);k.push(b.x+b.width);u.push(b.y+b.height)}a=w.apply(0,a);f=w.apply(0,f);k=A.apply(0,k);u=A.apply(0,u);return{x:a,y:f,x2:k,y2:u,width:k-a,height:u-f,cx:a+(k-a)/2,cy:f+(u-f)/2}};v.clone=function(a){a=new z;for(var f=0,k=this.items.length;f<k;f++)a.push(this.items[f].clone());
return a};v.toString=function(){return"Snap\u2018s set"};v.type="set";a.set=function(){var a=new z;arguments.length&&a.push.apply(a,Array.prototype.slice.call(arguments,0));return a}});C.plugin(function(a,v,y,C){function A(a){var b=a[0];switch(b.toLowerCase()){case "t":return[b,0,0];case "m":return[b,1,0,0,1,0,0];case "r":return 4==a.length?[b,0,a[2],a[3] ]:[b,0];case "s":return 5==a.length?[b,1,1,a[3],a[4] ]:3==a.length?[b,1,1]:[b,1]}}function w(b,d,f){d=q(d).replace(/\.{3}|\u2026/g,b);b=a.parseTransformString(b)||
[];d=a.parseTransformString(d)||[];for(var k=Math.max(b.length,d.length),p=[],v=[],h=0,w,z,y,I;h<k;h++){y=b[h]||A(d[h]);I=d[h]||A(y);if(y[0]!=I[0]||"r"==y[0].toLowerCase()&&(y[2]!=I[2]||y[3]!=I[3])||"s"==y[0].toLowerCase()&&(y[3]!=I[3]||y[4]!=I[4])){b=a._.transform2matrix(b,f());d=a._.transform2matrix(d,f());p=[["m",b.a,b.b,b.c,b.d,b.e,b.f] ];v=[["m",d.a,d.b,d.c,d.d,d.e,d.f] ];break}p[h]=[];v[h]=[];w=0;for(z=Math.max(y.length,I.length);w<z;w++)w in y&&(p[h][w]=y[w]),w in I&&(v[h][w]=I[w])}return{from:u(p),
to:u(v),f:n(p)}}function z(a){return a}function d(a){return function(b){return+b.toFixed(3)+a}}function f(b){return a.rgb(b[0],b[1],b[2])}function n(a){var b=0,d,f,k,n,h,p,q=[];d=0;for(f=a.length;d<f;d++){h="[";p=['"'+a[d][0]+'"'];k=1;for(n=a[d].length;k<n;k++)p[k]="val["+b++ +"]";h+=p+"]";q[d]=h}return Function("val","return Snap.path.toString.call(["+q+"])")}function u(a){for(var b=[],d=0,f=a.length;d<f;d++)for(var k=1,n=a[d].length;k<n;k++)b.push(a[d][k]);return b}var p={},b=/[a-z]+$/i,q=String;
p.stroke=p.fill="colour";v.prototype.equal=function(a,b){return k("snap.util.equal",this,a,b).firstDefined()};k.on("snap.util.equal",function(e,k){var r,s;r=q(this.attr(e)||"");var x=this;if(r==+r&&k==+k)return{from:+r,to:+k,f:z};if("colour"==p[e])return r=a.color(r),s=a.color(k),{from:[r.r,r.g,r.b,r.opacity],to:[s.r,s.g,s.b,s.opacity],f:f};if("transform"==e||"gradientTransform"==e||"patternTransform"==e)return k instanceof a.Matrix&&(k=k.toTransformString()),a._.rgTransform.test(k)||(k=a._.svgTransform2string(k)),
w(r,k,function(){return x.getBBox(1)});if("d"==e||"path"==e)return r=a.path.toCubic(r,k),{from:u(r[0]),to:u(r[1]),f:n(r[0])};if("points"==e)return r=q(r).split(a._.separator),s=q(k).split(a._.separator),{from:r,to:s,f:function(a){return a}};aUnit=r.match(b);s=q(k).match(b);return aUnit&&aUnit==s?{from:parseFloat(r),to:parseFloat(k),f:d(aUnit)}:{from:this.asPX(e),to:this.asPX(e,k),f:z}})});C.plugin(function(a,v,y,C){var A=v.prototype,w="createTouch"in C.doc;v="click dblclick mousedown mousemove mouseout mouseover mouseup touchstart touchmove touchend touchcancel".split(" ");
var z={mousedown:"touchstart",mousemove:"touchmove",mouseup:"touchend"},d=function(a,b){var d="y"==a?"scrollTop":"scrollLeft",e=b&&b.node?b.node.ownerDocument:C.doc;return e[d in e.documentElement?"documentElement":"body"][d]},f=function(){this.returnValue=!1},n=function(){return this.originalEvent.preventDefault()},u=function(){this.cancelBubble=!0},p=function(){return this.originalEvent.stopPropagation()},b=function(){if(C.doc.addEventListener)return function(a,b,e,f){var k=w&&z[b]?z[b]:b,l=function(k){var l=
d("y",f),q=d("x",f);if(w&&z.hasOwnProperty(b))for(var r=0,u=k.targetTouches&&k.targetTouches.length;r<u;r++)if(k.targetTouches[r].target==a||a.contains(k.targetTouches[r].target)){u=k;k=k.targetTouches[r];k.originalEvent=u;k.preventDefault=n;k.stopPropagation=p;break}return e.call(f,k,k.clientX+q,k.clientY+l)};b!==k&&a.addEventListener(b,l,!1);a.addEventListener(k,l,!1);return function(){b!==k&&a.removeEventListener(b,l,!1);a.removeEventListener(k,l,!1);return!0}};if(C.doc.attachEvent)return function(a,
b,e,h){var k=function(a){a=a||h.node.ownerDocument.window.event;var b=d("y",h),k=d("x",h),k=a.clientX+k,b=a.clientY+b;a.preventDefault=a.preventDefault||f;a.stopPropagation=a.stopPropagation||u;return e.call(h,a,k,b)};a.attachEvent("on"+b,k);return function(){a.detachEvent("on"+b,k);return!0}}}(),q=[],e=function(a){for(var b=a.clientX,e=a.clientY,f=d("y"),l=d("x"),n,p=q.length;p--;){n=q[p];if(w)for(var r=a.touches&&a.touches.length,u;r--;){if(u=a.touches[r],u.identifier==n.el._drag.id||n.el.node.contains(u.target)){b=
u.clientX;e=u.clientY;(a.originalEvent?a.originalEvent:a).preventDefault();break}}else a.preventDefault();b+=l;e+=f;k("snap.drag.move."+n.el.id,n.move_scope||n.el,b-n.el._drag.x,e-n.el._drag.y,b,e,a)}},l=function(b){a.unmousemove(e).unmouseup(l);for(var d=q.length,f;d--;)f=q[d],f.el._drag={},k("snap.drag.end."+f.el.id,f.end_scope||f.start_scope||f.move_scope||f.el,b);q=[]};for(y=v.length;y--;)(function(d){a[d]=A[d]=function(e,f){a.is(e,"function")&&(this.events=this.events||[],this.events.push({name:d,
f:e,unbind:b(this.node||document,d,e,f||this)}));return this};a["un"+d]=A["un"+d]=function(a){for(var b=this.events||[],e=b.length;e--;)if(b[e].name==d&&(b[e].f==a||!a)){b[e].unbind();b.splice(e,1);!b.length&&delete this.events;break}return this}})(v[y]);A.hover=function(a,b,d,e){return this.mouseover(a,d).mouseout(b,e||d)};A.unhover=function(a,b){return this.unmouseover(a).unmouseout(b)};var r=[];A.drag=function(b,d,f,h,n,p){function u(r,v,w){(r.originalEvent||r).preventDefault();this._drag.x=v;
this._drag.y=w;this._drag.id=r.identifier;!q.length&&a.mousemove(e).mouseup(l);q.push({el:this,move_scope:h,start_scope:n,end_scope:p});d&&k.on("snap.drag.start."+this.id,d);b&&k.on("snap.drag.move."+this.id,b);f&&k.on("snap.drag.end."+this.id,f);k("snap.drag.start."+this.id,n||h||this,v,w,r)}if(!arguments.length){var v;return this.drag(function(a,b){this.attr({transform:v+(v?"T":"t")+[a,b]})},function(){v=this.transform().local})}this._drag={};r.push({el:this,start:u});this.mousedown(u);return this};
A.undrag=function(){for(var b=r.length;b--;)r[b].el==this&&(this.unmousedown(r[b].start),r.splice(b,1),k.unbind("snap.drag.*."+this.id));!r.length&&a.unmousemove(e).unmouseup(l);return this}});C.plugin(function(a,v,y,C){y=y.prototype;var A=/^\s*url\((.+)\)/,w=String,z=a._.$;a.filter={};y.filter=function(d){var f=this;"svg"!=f.type&&(f=f.paper);d=a.parse(w(d));var k=a._.id(),u=z("filter");z(u,{id:k,filterUnits:"userSpaceOnUse"});u.appendChild(d.node);f.defs.appendChild(u);return new v(u)};k.on("snap.util.getattr.filter",
function(){k.stop();var d=z(this.node,"filter");if(d)return(d=w(d).match(A))&&a.select(d[1])});k.on("snap.util.attr.filter",function(d){if(d instanceof v&&"filter"==d.type){k.stop();var f=d.node.id;f||(z(d.node,{id:d.id}),f=d.id);z(this.node,{filter:a.url(f)})}d&&"none"!=d||(k.stop(),this.node.removeAttribute("filter"))});a.filter.blur=function(d,f){null==d&&(d=2);return a.format('<feGaussianBlur stdDeviation="{def}"/>',{def:null==f?d:[d,f]})};a.filter.blur.toString=function(){return this()};a.filter.shadow=
function(d,f,k,u,p){"string"==typeof k&&(p=u=k,k=4);"string"!=typeof u&&(p=u,u="#000");null==k&&(k=4);null==p&&(p=1);null==d&&(d=0,f=2);null==f&&(f=d);u=a.color(u||"#000");return a.format('<feGaussianBlur in="SourceAlpha" stdDeviation="{blur}"/><feOffset dx="{dx}" dy="{dy}" result="offsetblur"/><feFlood flood-color="{color}"/><feComposite in2="offsetblur" operator="in"/><feComponentTransfer><feFuncA type="linear" slope="{opacity}"/></feComponentTransfer><feMerge><feMergeNode/><feMergeNode in="SourceGraphic"/></feMerge>',
{color:u,dx:d,dy:f,blur:k,opacity:p})};a.filter.shadow.toString=function(){return this()};a.filter.grayscale=function(d){null==d&&(d=1);return a.format('<feColorMatrix type="matrix" values="{a} {b} {c} 0 0 {d} {e} {f} 0 0 {g} {b} {h} 0 0 0 0 0 1 0"/>',{a:0.2126+0.7874*(1-d),b:0.7152-0.7152*(1-d),c:0.0722-0.0722*(1-d),d:0.2126-0.2126*(1-d),e:0.7152+0.2848*(1-d),f:0.0722-0.0722*(1-d),g:0.2126-0.2126*(1-d),h:0.0722+0.9278*(1-d)})};a.filter.grayscale.toString=function(){return this()};a.filter.sepia=
function(d){null==d&&(d=1);return a.format('<feColorMatrix type="matrix" values="{a} {b} {c} 0 0 {d} {e} {f} 0 0 {g} {h} {i} 0 0 0 0 0 1 0"/>',{a:0.393+0.607*(1-d),b:0.769-0.769*(1-d),c:0.189-0.189*(1-d),d:0.349-0.349*(1-d),e:0.686+0.314*(1-d),f:0.168-0.168*(1-d),g:0.272-0.272*(1-d),h:0.534-0.534*(1-d),i:0.131+0.869*(1-d)})};a.filter.sepia.toString=function(){return this()};a.filter.saturate=function(d){null==d&&(d=1);return a.format('<feColorMatrix type="saturate" values="{amount}"/>',{amount:1-
d})};a.filter.saturate.toString=function(){return this()};a.filter.hueRotate=function(d){return a.format('<feColorMatrix type="hueRotate" values="{angle}"/>',{angle:d||0})};a.filter.hueRotate.toString=function(){return this()};a.filter.invert=function(d){null==d&&(d=1);return a.format('<feComponentTransfer><feFuncR type="table" tableValues="{amount} {amount2}"/><feFuncG type="table" tableValues="{amount} {amount2}"/><feFuncB type="table" tableValues="{amount} {amount2}"/></feComponentTransfer>',{amount:d,
amount2:1-d})};a.filter.invert.toString=function(){return this()};a.filter.brightness=function(d){null==d&&(d=1);return a.format('<feComponentTransfer><feFuncR type="linear" slope="{amount}"/><feFuncG type="linear" slope="{amount}"/><feFuncB type="linear" slope="{amount}"/></feComponentTransfer>',{amount:d})};a.filter.brightness.toString=function(){return this()};a.filter.contrast=function(d){null==d&&(d=1);return a.format('<feComponentTransfer><feFuncR type="linear" slope="{amount}" intercept="{amount2}"/><feFuncG type="linear" slope="{amount}" intercept="{amount2}"/><feFuncB type="linear" slope="{amount}" intercept="{amount2}"/></feComponentTransfer>',
{amount:d,amount2:0.5-d/2})};a.filter.contrast.toString=function(){return this()}});return C});

]]> </script>
<script> <![CDATA[

(function (glob, factory) {
    // AMD support
    if (typeof define === "function" && define.amd) {
        // Define as an anonymous module
        define("Gadfly", ["Snap.svg"], function (Snap) {
            return factory(Snap);
        });
    } else {
        // Browser globals (glob is window)
        // Snap adds itself to window
        glob.Gadfly = factory(glob.Snap);
    }
}(this, function (Snap) {

var Gadfly = {};

// Get an x/y coordinate value in pixels
var xPX = function(fig, x) {
    var client_box = fig.node.getBoundingClientRect();
    return x * fig.node.viewBox.baseVal.width / client_box.width;
};

var yPX = function(fig, y) {
    var client_box = fig.node.getBoundingClientRect();
    return y * fig.node.viewBox.baseVal.height / client_box.height;
};


Snap.plugin(function (Snap, Element, Paper, global) {
    // Traverse upwards from a snap element to find and return the first
    // note with the "plotroot" class.
    Element.prototype.plotroot = function () {
        var element = this;
        while (!element.hasClass("plotroot") && element.parent() != null) {
            element = element.parent();
        }
        return element;
    };

    Element.prototype.svgroot = function () {
        var element = this;
        while (element.node.nodeName != "svg" && element.parent() != null) {
            element = element.parent();
        }
        return element;
    };

    Element.prototype.plotbounds = function () {
        var root = this.plotroot()
        var bbox = root.select(".guide.background").node.getBBox();
        return {
            x0: bbox.x,
            x1: bbox.x + bbox.width,
            y0: bbox.y,
            y1: bbox.y + bbox.height
        };
    };

    Element.prototype.plotcenter = function () {
        var root = this.plotroot()
        var bbox = root.select(".guide.background").node.getBBox();
        return {
            x: bbox.x + bbox.width / 2,
            y: bbox.y + bbox.height / 2
        };
    };

    // Emulate IE style mouseenter/mouseleave events, since Microsoft always
    // does everything right.
    // See: http://www.dynamic-tools.net/toolbox/isMouseLeaveOrEnter/
    var events = ["mouseenter", "mouseleave"];

    for (i in events) {
        (function (event_name) {
            var event_name = events[i];
            Element.prototype[event_name] = function (fn, scope) {
                if (Snap.is(fn, "function")) {
                    var fn2 = function (event) {
                        if (event.type != "mouseover" && event.type != "mouseout") {
                            return;
                        }

                        var reltg = event.relatedTarget ? event.relatedTarget :
                            event.type == "mouseout" ? event.toElement : event.fromElement;
                        while (reltg && reltg != this.node) reltg = reltg.parentNode;

                        if (reltg != this.node) {
                            return fn.apply(this, event);
                        }
                    };

                    if (event_name == "mouseenter") {
                        this.mouseover(fn2, scope);
                    } else {
                        this.mouseout(fn2, scope);
                    }
                }
                return this;
            };
        })(events[i]);
    }


    Element.prototype.mousewheel = function (fn, scope) {
        if (Snap.is(fn, "function")) {
            var el = this;
            var fn2 = function (event) {
                fn.apply(el, [event]);
            };
        }

        this.node.addEventListener(
            /Firefox/i.test(navigator.userAgent) ? "DOMMouseScroll" : "mousewheel",
            fn2);

        return this;
    };


    // Snap's attr function can be too slow for things like panning/zooming.
    // This is a function to directly update element attributes without going
    // through eve.
    Element.prototype.attribute = function(key, val) {
        if (val === undefined) {
            return this.node.getAttribute(key, val);
        } else {
            return this.node.setAttribute(key, val);
        }
    };
});


// When the plot is moused over, emphasize the grid lines.
Gadfly.plot_mouseover = function(event) {
    var root = this.plotroot();
    init_pan_zoom(root);

    var xgridlines = root.select(".xgridlines"),
        ygridlines = root.select(".ygridlines");

    xgridlines.data("unfocused_strokedash",
                    xgridlines.attr("stroke-dasharray").replace(/px/g, "mm"))
    ygridlines.data("unfocused_strokedash",
                    ygridlines.attr("stroke-dasharray").replace(/px/g, "mm"))

    // emphasize grid lines
    var destcolor = root.data("focused_xgrid_color");
    xgridlines.attr("stroke-dasharray", "none")
              .selectAll("path")
              .animate({stroke: destcolor}, 250);

    destcolor = root.data("focused_ygrid_color");
    ygridlines.attr("stroke-dasharray", "none")
              .selectAll("path")
              .animate({stroke: destcolor}, 250);

    // reveal zoom slider
    root.select(".zoomslider")
        .animate({opacity: 1.0}, 250);
};


// Unemphasize grid lines on mouse out.
Gadfly.plot_mouseout = function(event) {
    var root = this.plotroot();
    var xgridlines = root.select(".xgridlines"),
        ygridlines = root.select(".ygridlines");

    var destcolor = root.data("unfocused_xgrid_color");

    xgridlines.attr("stroke-dasharray", xgridlines.data("unfocused_strokedash"))
              .selectAll("path")
              .animate({stroke: destcolor}, 250);

    destcolor = root.data("unfocused_ygrid_color");
    ygridlines.attr("stroke-dasharray", ygridlines.data("unfocused_strokedash"))
              .selectAll("path")
              .animate({stroke: destcolor}, 250);

    // hide zoom slider
    root.select(".zoomslider")
        .animate({opacity: 0.0}, 250);
};


var set_geometry_transform = function(root, tx, ty, scale) {
    var xscalable = root.hasClass("xscalable"),
        yscalable = root.hasClass("yscalable");

    var old_scale = root.data("scale");

    var xscale = xscalable ? scale : 1.0,
        yscale = yscalable ? scale : 1.0;

    tx = xscalable ? tx : 0.0;
    ty = yscalable ? ty : 0.0;

    var t = new Snap.Matrix().translate(tx, ty).scale(xscale, yscale);

    root.selectAll(".geometry, image")
        .forEach(function (element, i) {
            element.transform(t);
        });

    bounds = root.plotbounds();

    if (yscalable) {
        var xfixed_t = new Snap.Matrix().translate(0, ty).scale(1.0, yscale);
        root.selectAll(".xfixed")
            .forEach(function (element, i) {
                element.transform(xfixed_t);
            });

        root.select(".ylabels")
            .transform(xfixed_t)
            .selectAll("text")
            .forEach(function (element, i) {
                if (element.attribute("gadfly:inscale") == "true") {
                    var cx = element.asPX("x"),
                        cy = element.asPX("y");
                    var st = element.data("static_transform");
                    unscale_t = new Snap.Matrix();
                    unscale_t.scale(1, 1/scale, cx, cy).add(st);
                    element.transform(unscale_t);

                    var y = cy * scale + ty;
                    element.attr("visibility",
                        bounds.y0 <= y && y <= bounds.y1 ? "visible" : "hidden");
                }
            });
    }

    if (xscalable) {
        var yfixed_t = new Snap.Matrix().translate(tx, 0).scale(xscale, 1.0);
        var xtrans = new Snap.Matrix().translate(tx, 0);
        root.selectAll(".yfixed")
            .forEach(function (element, i) {
                element.transform(yfixed_t);
            });

        root.select(".xlabels")
            .transform(yfixed_t)
            .selectAll("text")
            .forEach(function (element, i) {
                if (element.attribute("gadfly:inscale") == "true") {
                    var cx = element.asPX("x"),
                        cy = element.asPX("y");
                    var st = element.data("static_transform");
                    unscale_t = new Snap.Matrix();
                    unscale_t.scale(1/scale, 1, cx, cy).add(st);

                    element.transform(unscale_t);

                    var x = cx * scale + tx;
                    element.attr("visibility",
                        bounds.x0 <= x && x <= bounds.x1 ? "visible" : "hidden");
                    }
            });
    }

    // we must unscale anything that is scale invariance: widths, raiduses, etc.
    var size_attribs = ["font-size"];
    var unscaled_selection = ".geometry, .geometry *";
    if (xscalable) {
        size_attribs.push("rx");
        unscaled_selection += ", .xgridlines";
    }
    if (yscalable) {
        size_attribs.push("ry");
        unscaled_selection += ", .ygridlines";
    }

    root.selectAll(unscaled_selection)
        .forEach(function (element, i) {
            // circle need special help
            if (element.node.nodeName == "circle") {
                var cx = element.attribute("cx"),
                    cy = element.attribute("cy");
                unscale_t = new Snap.Matrix().scale(1/xscale, 1/yscale,
                                                        cx, cy);
                element.transform(unscale_t);
                return;
            }

            for (i in size_attribs) {
                var key = size_attribs[i];
                var val = parseFloat(element.attribute(key));
                if (val !== undefined && val != 0 && !isNaN(val)) {
                    element.attribute(key, val * old_scale / scale);
                }
            }
        });
};


// Find the most appropriate tick scale and update label visibility.
var update_tickscale = function(root, scale, axis) {
    if (!root.hasClass(axis + "scalable")) return;

    var tickscales = root.data(axis + "tickscales");
    var best_tickscale = 1.0;
    var best_tickscale_dist = Infinity;
    for (tickscale in tickscales) {
        var dist = Math.abs(Math.log(tickscale) - Math.log(scale));
        if (dist < best_tickscale_dist) {
            best_tickscale_dist = dist;
            best_tickscale = tickscale;
        }
    }

    if (best_tickscale != root.data(axis + "tickscale")) {
        root.data(axis + "tickscale", best_tickscale);
        var mark_inscale_gridlines = function (element, i) {
            var inscale = element.attr("gadfly:scale") == best_tickscale;
            element.attribute("gadfly:inscale", inscale);
            element.attr("visibility", inscale ? "visible" : "hidden");
        };

        var mark_inscale_labels = function (element, i) {
            var inscale = element.attr("gadfly:scale") == best_tickscale;
            element.attribute("gadfly:inscale", inscale);
            element.attr("visibility", inscale ? "visible" : "hidden");
        };

        root.select("." + axis + "gridlines").selectAll("path").forEach(mark_inscale_gridlines);
        root.select("." + axis + "labels").selectAll("text").forEach(mark_inscale_labels);
    }
};


var set_plot_pan_zoom = function(root, tx, ty, scale) {
    var old_scale = root.data("scale");
    var bounds = root.plotbounds();

    var width = bounds.x1 - bounds.x0,
        height = bounds.y1 - bounds.y0;

    // compute the viewport derived from tx, ty, and scale
    var x_min = -width * scale - (scale * width - width),
        x_max = width * scale,
        y_min = -height * scale - (scale * height - height),
        y_max = height * scale;

    var x0 = bounds.x0 - scale * bounds.x0,
        y0 = bounds.y0 - scale * bounds.y0;

    var tx = Math.max(Math.min(tx - x0, x_max), x_min),
        ty = Math.max(Math.min(ty - y0, y_max), y_min);

    tx += x0;
    ty += y0;

    // when the scale change, we may need to alter which set of
    // ticks is being displayed
    if (scale != old_scale) {
        update_tickscale(root, scale, "x");
        update_tickscale(root, scale, "y");
    }

    set_geometry_transform(root, tx, ty, scale);

    root.data("scale", scale);
    root.data("tx", tx);
    root.data("ty", ty);
};


var scale_centered_translation = function(root, scale) {
    var bounds = root.plotbounds();

    var width = bounds.x1 - bounds.x0,
        height = bounds.y1 - bounds.y0;

    var tx0 = root.data("tx"),
        ty0 = root.data("ty");

    var scale0 = root.data("scale");

    // how off from center the current view is
    var xoff = tx0 - (bounds.x0 * (1 - scale0) + (width * (1 - scale0)) / 2),
        yoff = ty0 - (bounds.y0 * (1 - scale0) + (height * (1 - scale0)) / 2);

    // rescale offsets
    xoff = xoff * scale / scale0;
    yoff = yoff * scale / scale0;

    // adjust for the panel position being scaled
    var x_edge_adjust = bounds.x0 * (1 - scale),
        y_edge_adjust = bounds.y0 * (1 - scale);

    return {
        x: xoff + x_edge_adjust + (width - width * scale) / 2,
        y: yoff + y_edge_adjust + (height - height * scale) / 2
    };
};


// Initialize data for panning zooming if it isn't already.
var init_pan_zoom = function(root) {
    if (root.data("zoompan-ready")) {
        return;
    }

    // The non-scaling-stroke trick. Rather than try to correct for the
    // stroke-width when zooming, we force it to a fixed value.
    var px_per_mm = root.node.getCTM().a;

    // Drag events report deltas in pixels, which we'd like to convert to
    // millimeters.
    root.data("px_per_mm", px_per_mm);

    root.selectAll("path")
        .forEach(function (element, i) {
        sw = element.asPX("stroke-width") * px_per_mm;
        if (sw > 0) {
            element.attribute("stroke-width", sw);
            element.attribute("vector-effect", "non-scaling-stroke");
        }
    });

    // Store ticks labels original tranformation
    root.selectAll(".xlabels > text, .ylabels > text")
        .forEach(function (element, i) {
            var lm = element.transform().localMatrix;
            element.data("static_transform",
                new Snap.Matrix(lm.a, lm.b, lm.c, lm.d, lm.e, lm.f));
        });

    if (root.data("tx") === undefined) root.data("tx", 0);
    if (root.data("ty") === undefined) root.data("ty", 0);
    if (root.data("scale") === undefined) root.data("scale", 1.0);
    if (root.data("xtickscales") === undefined) {

        // index all the tick scales that are listed
        var xtickscales = {};
        var ytickscales = {};
        var add_x_tick_scales = function (element, i) {
            xtickscales[element.attribute("gadfly:scale")] = true;
        };
        var add_y_tick_scales = function (element, i) {
            ytickscales[element.attribute("gadfly:scale")] = true;
        };

        root.select(".xgridlines").selectAll("path").forEach(add_x_tick_scales);
        root.select(".ygridlines").selectAll("path").forEach(add_y_tick_scales);
        root.select(".xlabels").selectAll("text").forEach(add_x_tick_scales);
        root.select(".ylabels").selectAll("text").forEach(add_y_tick_scales);

        root.data("xtickscales", xtickscales);
        root.data("ytickscales", ytickscales);
        root.data("xtickscale", 1.0);
    }

    var min_scale = 1.0, max_scale = 1.0;
    for (scale in xtickscales) {
        min_scale = Math.min(min_scale, scale);
        max_scale = Math.max(max_scale, scale);
    }
    for (scale in ytickscales) {
        min_scale = Math.min(min_scale, scale);
        max_scale = Math.max(max_scale, scale);
    }
    root.data("min_scale", min_scale);
    root.data("max_scale", max_scale);

    // store the original positions of labels
    root.select(".xlabels")
        .selectAll("text")
        .forEach(function (element, i) {
            element.data("x", element.asPX("x"));
        });

    root.select(".ylabels")
        .selectAll("text")
        .forEach(function (element, i) {
            element.data("y", element.asPX("y"));
        });

    // mark grid lines and ticks as in or out of scale.
    var mark_inscale = function (element, i) {
        element.attribute("gadfly:inscale", element.attribute("gadfly:scale") == 1.0);
    };

    root.select(".xgridlines").selectAll("path").forEach(mark_inscale);
    root.select(".ygridlines").selectAll("path").forEach(mark_inscale);
    root.select(".xlabels").selectAll("text").forEach(mark_inscale);
    root.select(".ylabels").selectAll("text").forEach(mark_inscale);

    // figure out the upper ond lower bounds on panning using the maximum
    // and minum grid lines
    var bounds = root.plotbounds();
    var pan_bounds = {
        x0: 0.0,
        y0: 0.0,
        x1: 0.0,
        y1: 0.0
    };

    root.select(".xgridlines")
        .selectAll("path")
        .forEach(function (element, i) {
            if (element.attribute("gadfly:inscale") == "true") {
                var bbox = element.node.getBBox();
                if (bounds.x1 - bbox.x < pan_bounds.x0) {
                    pan_bounds.x0 = bounds.x1 - bbox.x;
                }
                if (bounds.x0 - bbox.x > pan_bounds.x1) {
                    pan_bounds.x1 = bounds.x0 - bbox.x;
                }
            }
        });

    root.select(".ygridlines")
        .selectAll("path")
        .forEach(function (element, i) {
            if (element.attribute("gadfly:inscale") == "true") {
                var bbox = element.node.getBBox();
                if (bounds.y1 - bbox.y < pan_bounds.y0) {
                    pan_bounds.y0 = bounds.y1 - bbox.y;
                }
                if (bounds.y0 - bbox.y > pan_bounds.y1) {
                    pan_bounds.y1 = bounds.y0 - bbox.y;
                }
            }
        });

    // nudge these values a little
    pan_bounds.x0 -= 5;
    pan_bounds.x1 += 5;
    pan_bounds.y0 -= 5;
    pan_bounds.y1 += 5;
    root.data("pan_bounds", pan_bounds);

    // Set all grid lines at scale 1.0 to visible. Out of bounds lines
    // will be clipped.
    root.select(".xgridlines")
        .selectAll("path")
        .forEach(function (element, i) {
            if (element.attribute("gadfly:inscale") == "true") {
                element.attr("visibility", "visible");
            }
        });

    root.select(".ygridlines")
        .selectAll("path")
        .forEach(function (element, i) {
            if (element.attribute("gadfly:inscale") == "true") {
                element.attr("visibility", "visible");
            }
        });

    root.data("zoompan-ready", true)
};


// Panning
Gadfly.guide_background_drag_onmove = function(dx, dy, x, y, event) {
    var root = this.plotroot();
    var px_per_mm = root.data("px_per_mm");
    dx /= px_per_mm;
    dy /= px_per_mm;

    var tx0 = root.data("tx"),
        ty0 = root.data("ty");

    var dx0 = root.data("dx"),
        dy0 = root.data("dy");

    root.data("dx", dx);
    root.data("dy", dy);

    dx = dx - dx0;
    dy = dy - dy0;

    var tx = tx0 + dx,
        ty = ty0 + dy;

    set_plot_pan_zoom(root, tx, ty, root.data("scale"));
};


Gadfly.guide_background_drag_onstart = function(x, y, event) {
    var root = this.plotroot();
    root.data("dx", 0);
    root.data("dy", 0);
    init_pan_zoom(root);
};


Gadfly.guide_background_drag_onend = function(event) {
    var root = this.plotroot();
};


Gadfly.guide_background_scroll = function(event) {
    if (event.shiftKey) {
        var root = this.plotroot();
        init_pan_zoom(root);
        var new_scale = root.data("scale") * Math.pow(2, 0.002 * event.wheelDelta);
        new_scale = Math.max(
            root.data("min_scale"),
            Math.min(root.data("max_scale"), new_scale))
        update_plot_scale(root, new_scale);
        event.stopPropagation();
    }
};


Gadfly.zoomslider_button_mouseover = function(event) {
    this.select(".button_logo")
         .animate({fill: this.data("mouseover_color")}, 100);
};


Gadfly.zoomslider_button_mouseout = function(event) {
     this.select(".button_logo")
         .animate({fill: this.data("mouseout_color")}, 100);
};


Gadfly.zoomslider_zoomout_click = function(event) {
    var root = this.plotroot();
    init_pan_zoom(root);
    var min_scale = root.data("min_scale"),
        scale = root.data("scale");
    Snap.animate(
        scale,
        Math.max(min_scale, scale / 1.5),
        function (new_scale) {
            update_plot_scale(root, new_scale);
        },
        200);
};


Gadfly.zoomslider_zoomin_click = function(event) {
    var root = this.plotroot();
    init_pan_zoom(root);
    var max_scale = root.data("max_scale"),
        scale = root.data("scale");

    Snap.animate(
        scale,
        Math.min(max_scale, scale * 1.5),
        function (new_scale) {
            update_plot_scale(root, new_scale);
        },
        200);
};


Gadfly.zoomslider_track_click = function(event) {
    // TODO
};


Gadfly.zoomslider_thumb_mousedown = function(event) {
    this.animate({fill: this.data("mouseover_color")}, 100);
};


Gadfly.zoomslider_thumb_mouseup = function(event) {
    this.animate({fill: this.data("mouseout_color")}, 100);
};


// compute the position in [0, 1] of the zoom slider thumb from the current scale
var slider_position_from_scale = function(scale, min_scale, max_scale) {
    if (scale >= 1.0) {
        return 0.5 + 0.5 * (Math.log(scale) / Math.log(max_scale));
    }
    else {
        return 0.5 * (Math.log(scale) - Math.log(min_scale)) / (0 - Math.log(min_scale));
    }
}


var update_plot_scale = function(root, new_scale) {
    var trans = scale_centered_translation(root, new_scale);
    set_plot_pan_zoom(root, trans.x, trans.y, new_scale);

    root.selectAll(".zoomslider_thumb")
        .forEach(function (element, i) {
            var min_pos = element.data("min_pos"),
                max_pos = element.data("max_pos"),
                min_scale = root.data("min_scale"),
                max_scale = root.data("max_scale");
            var xmid = (min_pos + max_pos) / 2;
            var xpos = slider_position_from_scale(new_scale, min_scale, max_scale);
            element.transform(new Snap.Matrix().translate(
                Math.max(min_pos, Math.min(
                         max_pos, min_pos + (max_pos - min_pos) * xpos)) - xmid, 0));
    });
};


Gadfly.zoomslider_thumb_dragmove = function(dx, dy, x, y) {
    var root = this.plotroot();
    var min_pos = this.data("min_pos"),
        max_pos = this.data("max_pos"),
        min_scale = root.data("min_scale"),
        max_scale = root.data("max_scale"),
        old_scale = root.data("old_scale");

    var px_per_mm = root.data("px_per_mm");
    dx /= px_per_mm;
    dy /= px_per_mm;

    var xmid = (min_pos + max_pos) / 2;
    var xpos = slider_position_from_scale(old_scale, min_scale, max_scale) +
                   dx / (max_pos - min_pos);

    // compute the new scale
    var new_scale;
    if (xpos >= 0.5) {
        new_scale = Math.exp(2.0 * (xpos - 0.5) * Math.log(max_scale));
    }
    else {
        new_scale = Math.exp(2.0 * xpos * (0 - Math.log(min_scale)) +
                        Math.log(min_scale));
    }
    new_scale = Math.min(max_scale, Math.max(min_scale, new_scale));

    update_plot_scale(root, new_scale);
};


Gadfly.zoomslider_thumb_dragstart = function(event) {
    var root = this.plotroot();
    init_pan_zoom(root);

    // keep track of what the scale was when we started dragging
    root.data("old_scale", root.data("scale"));
};


Gadfly.zoomslider_thumb_dragend = function(event) {
};


var toggle_color_class = function(root, color_class, ison) {
    var guides = root.selectAll(".guide." + color_class + ",.guide ." + color_class);
    var geoms = root.selectAll(".geometry." + color_class + ",.geometry ." + color_class);
    if (ison) {
        guides.animate({opacity: 0.5}, 250);
        geoms.animate({opacity: 0.0}, 250);
    } else {
        guides.animate({opacity: 1.0}, 250);
        geoms.animate({opacity: 1.0}, 250);
    }
};


Gadfly.colorkey_swatch_click = function(event) {
    var root = this.plotroot();
    var color_class = this.data("color_class");

    if (event.shiftKey) {
        root.selectAll(".colorkey text")
            .forEach(function (element) {
                var other_color_class = element.data("color_class");
                if (other_color_class != color_class) {
                    toggle_color_class(root, other_color_class,
                                       element.attr("opacity") == 1.0);
                }
            });
    } else {
        toggle_color_class(root, color_class, this.attr("opacity") == 1.0);
    }
};


return Gadfly;

}));


//@ sourceURL=gadfly.js

(function (glob, factory) {
    // AMD support
      if (typeof require === "function" && typeof define === "function" && define.amd) {
        require(["Snap.svg", "Gadfly"], function (Snap, Gadfly) {
            factory(Snap, Gadfly);
        });
      } else {
          factory(glob.Snap, glob.Gadfly);
      }
})(window, function (Snap, Gadfly) {
    var fig = Snap("#fig-c22dfd48538b4aa0ba3f8e349406edc7");
fig.select("#fig-c22dfd48538b4aa0ba3f8e349406edc7-element-4")
   .mouseenter(Gadfly.plot_mouseover)
.mouseleave(Gadfly.plot_mouseout)
.mousewheel(Gadfly.guide_background_scroll)
.drag(Gadfly.guide_background_drag_onmove,
      Gadfly.guide_background_drag_onstart,
      Gadfly.guide_background_drag_onend)
;
fig.select("#fig-c22dfd48538b4aa0ba3f8e349406edc7-element-7")
   .plotroot().data("unfocused_ygrid_color", "#D0D0E0")
;
fig.select("#fig-c22dfd48538b4aa0ba3f8e349406edc7-element-7")
   .plotroot().data("focused_ygrid_color", "#A0A0A0")
;
fig.select("#fig-c22dfd48538b4aa0ba3f8e349406edc7-element-8")
   .plotroot().data("unfocused_xgrid_color", "#D0D0E0")
;
fig.select("#fig-c22dfd48538b4aa0ba3f8e349406edc7-element-8")
   .plotroot().data("focused_xgrid_color", "#A0A0A0")
;
fig.select("#fig-c22dfd48538b4aa0ba3f8e349406edc7-element-13")
   .data("mouseover_color", "#cd5c5c")
;
fig.select("#fig-c22dfd48538b4aa0ba3f8e349406edc7-element-13")
   .data("mouseout_color", "#6a6a6a")
;
fig.select("#fig-c22dfd48538b4aa0ba3f8e349406edc7-element-13")
   .click(Gadfly.zoomslider_zoomin_click)
.mouseenter(Gadfly.zoomslider_button_mouseover)
.mouseleave(Gadfly.zoomslider_button_mouseout)
;
fig.select("#fig-c22dfd48538b4aa0ba3f8e349406edc7-element-15")
   .data("max_pos", 120.42)
;
fig.select("#fig-c22dfd48538b4aa0ba3f8e349406edc7-element-15")
   .data("min_pos", 103.42)
;
fig.select("#fig-c22dfd48538b4aa0ba3f8e349406edc7-element-15")
   .click(Gadfly.zoomslider_track_click);
fig.select("#fig-c22dfd48538b4aa0ba3f8e349406edc7-element-16")
   .data("max_pos", 120.42)
;
fig.select("#fig-c22dfd48538b4aa0ba3f8e349406edc7-element-16")
   .data("min_pos", 103.42)
;
fig.select("#fig-c22dfd48538b4aa0ba3f8e349406edc7-element-16")
   .data("mouseover_color", "#cd5c5c")
;
fig.select("#fig-c22dfd48538b4aa0ba3f8e349406edc7-element-16")
   .data("mouseout_color", "#6a6a6a")
;
fig.select("#fig-c22dfd48538b4aa0ba3f8e349406edc7-element-16")
   .drag(Gadfly.zoomslider_thumb_dragmove,
     Gadfly.zoomslider_thumb_dragstart,
     Gadfly.zoomslider_thumb_dragend)
.mousedown(Gadfly.zoomslider_thumb_mousedown)
.mouseup(Gadfly.zoomslider_thumb_mouseup)
;
fig.select("#fig-c22dfd48538b4aa0ba3f8e349406edc7-element-17")
   .data("mouseover_color", "#cd5c5c")
;
fig.select("#fig-c22dfd48538b4aa0ba3f8e349406edc7-element-17")
   .data("mouseout_color", "#6a6a6a")
;
fig.select("#fig-c22dfd48538b4aa0ba3f8e349406edc7-element-17")
   .click(Gadfly.zoomslider_zoomout_click)
.mouseenter(Gadfly.zoomslider_button_mouseover)
.mouseleave(Gadfly.zoomslider_button_mouseout)
;
    });
]]> </script>
</svg>





    plot(x=t, y=abs(estv-optv), Guide.XLabel("Time"), Guide.YLabel("Absolute Error"),Guide.XTicks(ticks=[0:1:10]))





<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg"
     xmlns:xlink="http://www.w3.org/1999/xlink"
     xmlns:gadfly="http://www.gadflyjl.org/ns"
     version="1.2"
     width="141.42mm" height="100mm" viewBox="0 0 141.42 100"
     stroke="none"
     fill="#000000"
     stroke-width="0.3"
     font-size="3.88"

     id="fig-a9ec3c81e95b4f6b839742ba6960be33">
<g class="plotroot xscalable yscalable" id="fig-a9ec3c81e95b4f6b839742ba6960be33-element-1">
  <g font-size="3.88" font-family="'PT Sans','Helvetica Neue','Helvetica',sans-serif" fill="#564A55" stroke="none" id="fig-a9ec3c81e95b4f6b839742ba6960be33-element-2">
    <text x="82.76" y="92" text-anchor="middle">Time</text>
  </g>
  <g class="guide xlabels" font-size="2.82" font-family="'PT Sans Caption','Helvetica Neue','Helvetica',sans-serif" fill="#6C606B" id="fig-a9ec3c81e95b4f6b839742ba6960be33-element-3">
    <text x="31.1" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">0</text>
    <text x="41.43" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">1</text>
    <text x="51.76" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">2</text>
    <text x="62.1" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">3</text>
    <text x="72.43" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">4</text>
    <text x="82.76" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">5</text>
    <text x="93.09" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">6</text>
    <text x="103.42" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">7</text>
    <text x="113.76" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">8</text>
    <text x="124.09" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">9</text>
    <text x="134.42" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">10</text>
  </g>
  <g clip-path="url(#fig-a9ec3c81e95b4f6b839742ba6960be33-element-5)" id="fig-a9ec3c81e95b4f6b839742ba6960be33-element-4">
    <g pointer-events="visible" opacity="1" fill="none" stroke="none" class="guide background" id="fig-a9ec3c81e95b4f6b839742ba6960be33-element-6">
      <rect x="29.1" y="5" width="107.32" height="75.72"/>
    </g>
    <g class="guide ygridlines xfixed" stroke-dasharray="0.5,0.5" stroke-width="0.2" stroke="#D0D0E0" id="fig-a9ec3c81e95b4f6b839742ba6960be33-element-7">
      <path fill="none" d="M29.1,164.77 L 136.42 164.77" gadfly:scale="1.0" visibility="hidden"/>
      <path fill="none" d="M29.1,150.43 L 136.42 150.43" gadfly:scale="1.0" visibility="hidden"/>
      <path fill="none" d="M29.1,136.09 L 136.42 136.09" gadfly:scale="1.0" visibility="hidden"/>
      <path fill="none" d="M29.1,121.74 L 136.42 121.74" gadfly:scale="1.0" visibility="hidden"/>
      <path fill="none" d="M29.1,107.4 L 136.42 107.4" gadfly:scale="1.0" visibility="hidden"/>
      <path fill="none" d="M29.1,93.06 L 136.42 93.06" gadfly:scale="1.0" visibility="hidden"/>
      <path fill="none" d="M29.1,78.72 L 136.42 78.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M29.1,64.37 L 136.42 64.37" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M29.1,50.03 L 136.42 50.03" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M29.1,35.69 L 136.42 35.69" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M29.1,21.34 L 136.42 21.34" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M29.1,7 L 136.42 7" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M29.1,-7.34 L 136.42 -7.34" gadfly:scale="1.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-21.69 L 136.42 -21.69" gadfly:scale="1.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-36.03 L 136.42 -36.03" gadfly:scale="1.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-50.37 L 136.42 -50.37" gadfly:scale="1.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-64.72 L 136.42 -64.72" gadfly:scale="1.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-79.06 L 136.42 -79.06" gadfly:scale="1.0" visibility="hidden"/>
      <path fill="none" d="M29.1,150.43 L 136.42 150.43" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,146.84 L 136.42 146.84" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,143.26 L 136.42 143.26" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,139.67 L 136.42 139.67" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,136.09 L 136.42 136.09" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,132.5 L 136.42 132.5" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,128.92 L 136.42 128.92" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,125.33 L 136.42 125.33" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,121.74 L 136.42 121.74" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,118.16 L 136.42 118.16" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,114.57 L 136.42 114.57" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,110.99 L 136.42 110.99" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,107.4 L 136.42 107.4" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,103.82 L 136.42 103.82" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,100.23 L 136.42 100.23" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,96.64 L 136.42 96.64" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,93.06 L 136.42 93.06" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,89.47 L 136.42 89.47" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,85.89 L 136.42 85.89" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,82.3 L 136.42 82.3" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,78.72 L 136.42 78.72" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,75.13 L 136.42 75.13" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,71.54 L 136.42 71.54" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,67.96 L 136.42 67.96" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,64.37 L 136.42 64.37" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,60.79 L 136.42 60.79" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,57.2 L 136.42 57.2" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,53.61 L 136.42 53.61" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,50.03 L 136.42 50.03" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,46.44 L 136.42 46.44" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,42.86 L 136.42 42.86" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,39.27 L 136.42 39.27" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,35.69 L 136.42 35.69" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,32.1 L 136.42 32.1" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,28.51 L 136.42 28.51" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,24.93 L 136.42 24.93" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,21.34 L 136.42 21.34" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,17.76 L 136.42 17.76" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,14.17 L 136.42 14.17" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,10.59 L 136.42 10.59" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,7 L 136.42 7" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,3.41 L 136.42 3.41" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-0.17 L 136.42 -0.17" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-3.76 L 136.42 -3.76" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-7.34 L 136.42 -7.34" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-10.93 L 136.42 -10.93" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-14.51 L 136.42 -14.51" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-18.1 L 136.42 -18.1" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-21.69 L 136.42 -21.69" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-25.27 L 136.42 -25.27" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-28.86 L 136.42 -28.86" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-32.44 L 136.42 -32.44" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-36.03 L 136.42 -36.03" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-39.61 L 136.42 -39.61" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-43.2 L 136.42 -43.2" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-46.79 L 136.42 -46.79" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-50.37 L 136.42 -50.37" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-53.96 L 136.42 -53.96" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-57.54 L 136.42 -57.54" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-61.13 L 136.42 -61.13" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-64.72 L 136.42 -64.72" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M29.1,150.43 L 136.42 150.43" gadfly:scale="0.5" visibility="hidden"/>
      <path fill="none" d="M29.1,78.72 L 136.42 78.72" gadfly:scale="0.5" visibility="hidden"/>
      <path fill="none" d="M29.1,7 L 136.42 7" gadfly:scale="0.5" visibility="hidden"/>
      <path fill="none" d="M29.1,-64.72 L 136.42 -64.72" gadfly:scale="0.5" visibility="hidden"/>
      <path fill="none" d="M29.1,150.43 L 136.42 150.43" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M29.1,143.26 L 136.42 143.26" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M29.1,136.09 L 136.42 136.09" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M29.1,128.92 L 136.42 128.92" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M29.1,121.74 L 136.42 121.74" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M29.1,114.57 L 136.42 114.57" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M29.1,107.4 L 136.42 107.4" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M29.1,100.23 L 136.42 100.23" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M29.1,93.06 L 136.42 93.06" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M29.1,85.89 L 136.42 85.89" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M29.1,78.72 L 136.42 78.72" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M29.1,71.54 L 136.42 71.54" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M29.1,64.37 L 136.42 64.37" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M29.1,57.2 L 136.42 57.2" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M29.1,50.03 L 136.42 50.03" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M29.1,42.86 L 136.42 42.86" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M29.1,35.69 L 136.42 35.69" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M29.1,28.51 L 136.42 28.51" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M29.1,21.34 L 136.42 21.34" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M29.1,14.17 L 136.42 14.17" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M29.1,7 L 136.42 7" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-0.17 L 136.42 -0.17" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-7.34 L 136.42 -7.34" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-14.51 L 136.42 -14.51" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-21.69 L 136.42 -21.69" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-28.86 L 136.42 -28.86" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-36.03 L 136.42 -36.03" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-43.2 L 136.42 -43.2" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-50.37 L 136.42 -50.37" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-57.54 L 136.42 -57.54" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M29.1,-64.72 L 136.42 -64.72" gadfly:scale="5.0" visibility="hidden"/>
    </g>
    <g class="guide xgridlines yfixed" stroke-dasharray="0.5,0.5" stroke-width="0.2" stroke="#D0D0E0" id="fig-a9ec3c81e95b4f6b839742ba6960be33-element-8">
      <path fill="none" d="M31.1,5 L 31.1 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M41.43,5 L 41.43 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M51.76,5 L 51.76 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M62.1,5 L 62.1 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M72.43,5 L 72.43 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M82.76,5 L 82.76 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M93.09,5 L 93.09 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M103.42,5 L 103.42 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M113.76,5 L 113.76 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M124.09,5 L 124.09 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M134.42,5 L 134.42 80.72" gadfly:scale="1.0" visibility="visible"/>
    </g>
    <g class="plotpanel" id="fig-a9ec3c81e95b4f6b839742ba6960be33-element-9">
      <g class="geometry" id="fig-a9ec3c81e95b4f6b839742ba6960be33-element-10">
        <g class="color_RGB{Float32}(0.0f0,0.74736935f0,1.0f0)" stroke="#FFFFFF" stroke-width="0.3" fill="#00BFFF" id="fig-a9ec3c81e95b4f6b839742ba6960be33-element-11">
          <circle cx="31.1" cy="21.26" r="0.9"/>
          <circle cx="31.36" cy="78.63" r="0.9"/>
          <circle cx="31.61" cy="78.71" r="0.9"/>
          <circle cx="31.87" cy="78.71" r="0.9"/>
          <circle cx="32.13" cy="78.71" r="0.9"/>
          <circle cx="32.39" cy="78.71" r="0.9"/>
          <circle cx="32.65" cy="78.71" r="0.9"/>
          <circle cx="32.91" cy="78.71" r="0.9"/>
          <circle cx="33.16" cy="78.71" r="0.9"/>
          <circle cx="33.42" cy="78.71" r="0.9"/>
          <circle cx="33.68" cy="78.71" r="0.9"/>
          <circle cx="33.94" cy="78.71" r="0.9"/>
          <circle cx="34.2" cy="78.71" r="0.9"/>
          <circle cx="34.46" cy="78.71" r="0.9"/>
          <circle cx="34.71" cy="78.71" r="0.9"/>
          <circle cx="34.97" cy="78.71" r="0.9"/>
          <circle cx="35.23" cy="78.71" r="0.9"/>
          <circle cx="35.49" cy="78.71" r="0.9"/>
          <circle cx="35.75" cy="78.71" r="0.9"/>
          <circle cx="36.01" cy="78.71" r="0.9"/>
          <circle cx="36.26" cy="78.71" r="0.9"/>
          <circle cx="36.52" cy="78.71" r="0.9"/>
          <circle cx="36.78" cy="78.71" r="0.9"/>
          <circle cx="37.04" cy="78.71" r="0.9"/>
          <circle cx="37.3" cy="78.71" r="0.9"/>
          <circle cx="37.56" cy="78.71" r="0.9"/>
          <circle cx="37.81" cy="78.71" r="0.9"/>
          <circle cx="38.07" cy="78.71" r="0.9"/>
          <circle cx="38.33" cy="78.71" r="0.9"/>
          <circle cx="38.59" cy="78.71" r="0.9"/>
          <circle cx="38.85" cy="78.71" r="0.9"/>
          <circle cx="39.11" cy="78.71" r="0.9"/>
          <circle cx="39.36" cy="78.71" r="0.9"/>
          <circle cx="39.62" cy="78.71" r="0.9"/>
          <circle cx="39.88" cy="78.71" r="0.9"/>
          <circle cx="40.14" cy="78.71" r="0.9"/>
          <circle cx="40.4" cy="78.71" r="0.9"/>
          <circle cx="40.66" cy="78.71" r="0.9"/>
          <circle cx="40.91" cy="78.71" r="0.9"/>
          <circle cx="41.17" cy="78.71" r="0.9"/>
          <circle cx="41.43" cy="78.71" r="0.9"/>
          <circle cx="41.69" cy="78.71" r="0.9"/>
          <circle cx="41.95" cy="78.71" r="0.9"/>
          <circle cx="42.21" cy="78.71" r="0.9"/>
          <circle cx="42.46" cy="78.71" r="0.9"/>
          <circle cx="42.72" cy="78.71" r="0.9"/>
          <circle cx="42.98" cy="78.71" r="0.9"/>
          <circle cx="43.24" cy="78.71" r="0.9"/>
          <circle cx="43.5" cy="78.71" r="0.9"/>
          <circle cx="43.76" cy="78.71" r="0.9"/>
          <circle cx="44.01" cy="78.71" r="0.9"/>
          <circle cx="44.27" cy="78.71" r="0.9"/>
          <circle cx="44.53" cy="78.71" r="0.9"/>
          <circle cx="44.79" cy="78.71" r="0.9"/>
          <circle cx="45.05" cy="78.71" r="0.9"/>
          <circle cx="45.31" cy="78.71" r="0.9"/>
          <circle cx="45.56" cy="78.71" r="0.9"/>
          <circle cx="45.82" cy="78.71" r="0.9"/>
          <circle cx="46.08" cy="78.71" r="0.9"/>
          <circle cx="46.34" cy="78.71" r="0.9"/>
          <circle cx="46.6" cy="78.71" r="0.9"/>
          <circle cx="46.86" cy="78.71" r="0.9"/>
          <circle cx="47.11" cy="78.71" r="0.9"/>
          <circle cx="47.37" cy="78.71" r="0.9"/>
          <circle cx="47.63" cy="78.71" r="0.9"/>
          <circle cx="47.89" cy="78.71" r="0.9"/>
          <circle cx="48.15" cy="78.71" r="0.9"/>
          <circle cx="48.4" cy="78.71" r="0.9"/>
          <circle cx="48.66" cy="78.71" r="0.9"/>
          <circle cx="48.92" cy="78.71" r="0.9"/>
          <circle cx="49.18" cy="78.71" r="0.9"/>
          <circle cx="49.44" cy="78.71" r="0.9"/>
          <circle cx="49.7" cy="78.71" r="0.9"/>
          <circle cx="49.95" cy="78.71" r="0.9"/>
          <circle cx="50.21" cy="78.71" r="0.9"/>
          <circle cx="50.47" cy="78.71" r="0.9"/>
          <circle cx="50.73" cy="78.71" r="0.9"/>
          <circle cx="50.99" cy="78.71" r="0.9"/>
          <circle cx="51.25" cy="78.71" r="0.9"/>
          <circle cx="51.5" cy="78.71" r="0.9"/>
          <circle cx="51.76" cy="78.71" r="0.9"/>
          <circle cx="52.02" cy="78.71" r="0.9"/>
          <circle cx="52.28" cy="78.71" r="0.9"/>
          <circle cx="52.54" cy="78.71" r="0.9"/>
          <circle cx="52.8" cy="78.71" r="0.9"/>
          <circle cx="53.05" cy="78.71" r="0.9"/>
          <circle cx="53.31" cy="78.71" r="0.9"/>
          <circle cx="53.57" cy="78.71" r="0.9"/>
          <circle cx="53.83" cy="78.71" r="0.9"/>
          <circle cx="54.09" cy="78.71" r="0.9"/>
          <circle cx="54.35" cy="78.71" r="0.9"/>
          <circle cx="54.6" cy="78.71" r="0.9"/>
          <circle cx="54.86" cy="78.71" r="0.9"/>
          <circle cx="55.12" cy="78.71" r="0.9"/>
          <circle cx="55.38" cy="78.71" r="0.9"/>
          <circle cx="55.64" cy="78.71" r="0.9"/>
          <circle cx="55.9" cy="78.71" r="0.9"/>
          <circle cx="56.15" cy="78.71" r="0.9"/>
          <circle cx="56.41" cy="78.71" r="0.9"/>
          <circle cx="56.67" cy="78.71" r="0.9"/>
          <circle cx="56.93" cy="78.71" r="0.9"/>
          <circle cx="57.19" cy="78.71" r="0.9"/>
          <circle cx="57.45" cy="78.71" r="0.9"/>
          <circle cx="57.7" cy="78.71" r="0.9"/>
          <circle cx="57.96" cy="78.71" r="0.9"/>
          <circle cx="58.22" cy="78.71" r="0.9"/>
          <circle cx="58.48" cy="78.71" r="0.9"/>
          <circle cx="58.74" cy="78.71" r="0.9"/>
          <circle cx="59" cy="78.71" r="0.9"/>
          <circle cx="59.25" cy="78.71" r="0.9"/>
          <circle cx="59.51" cy="78.71" r="0.9"/>
          <circle cx="59.77" cy="78.71" r="0.9"/>
          <circle cx="60.03" cy="78.71" r="0.9"/>
          <circle cx="60.29" cy="78.71" r="0.9"/>
          <circle cx="60.55" cy="78.71" r="0.9"/>
          <circle cx="60.8" cy="78.71" r="0.9"/>
          <circle cx="61.06" cy="78.71" r="0.9"/>
          <circle cx="61.32" cy="78.71" r="0.9"/>
          <circle cx="61.58" cy="78.71" r="0.9"/>
          <circle cx="61.84" cy="78.71" r="0.9"/>
          <circle cx="62.1" cy="78.71" r="0.9"/>
          <circle cx="62.35" cy="78.71" r="0.9"/>
          <circle cx="62.61" cy="78.71" r="0.9"/>
          <circle cx="62.87" cy="78.71" r="0.9"/>
          <circle cx="63.13" cy="78.71" r="0.9"/>
          <circle cx="63.39" cy="78.71" r="0.9"/>
          <circle cx="63.65" cy="78.71" r="0.9"/>
          <circle cx="63.9" cy="78.71" r="0.9"/>
          <circle cx="64.16" cy="78.71" r="0.9"/>
          <circle cx="64.42" cy="78.71" r="0.9"/>
          <circle cx="64.68" cy="78.71" r="0.9"/>
          <circle cx="64.94" cy="78.71" r="0.9"/>
          <circle cx="65.19" cy="78.71" r="0.9"/>
          <circle cx="65.45" cy="78.71" r="0.9"/>
          <circle cx="65.71" cy="78.71" r="0.9"/>
          <circle cx="65.97" cy="78.71" r="0.9"/>
          <circle cx="66.23" cy="78.71" r="0.9"/>
          <circle cx="66.49" cy="78.71" r="0.9"/>
          <circle cx="66.74" cy="78.71" r="0.9"/>
          <circle cx="67" cy="78.71" r="0.9"/>
          <circle cx="67.26" cy="78.71" r="0.9"/>
          <circle cx="67.52" cy="78.71" r="0.9"/>
          <circle cx="67.78" cy="78.71" r="0.9"/>
          <circle cx="68.04" cy="78.71" r="0.9"/>
          <circle cx="68.29" cy="78.71" r="0.9"/>
          <circle cx="68.55" cy="78.71" r="0.9"/>
          <circle cx="68.81" cy="78.71" r="0.9"/>
          <circle cx="69.07" cy="78.71" r="0.9"/>
          <circle cx="69.33" cy="78.71" r="0.9"/>
          <circle cx="69.59" cy="78.71" r="0.9"/>
          <circle cx="69.84" cy="78.71" r="0.9"/>
          <circle cx="70.1" cy="78.71" r="0.9"/>
          <circle cx="70.36" cy="78.71" r="0.9"/>
          <circle cx="70.62" cy="78.71" r="0.9"/>
          <circle cx="70.88" cy="78.71" r="0.9"/>
          <circle cx="71.14" cy="78.71" r="0.9"/>
          <circle cx="71.39" cy="78.71" r="0.9"/>
          <circle cx="71.65" cy="78.71" r="0.9"/>
          <circle cx="71.91" cy="78.71" r="0.9"/>
          <circle cx="72.17" cy="78.71" r="0.9"/>
          <circle cx="72.43" cy="78.71" r="0.9"/>
          <circle cx="72.69" cy="78.71" r="0.9"/>
          <circle cx="72.94" cy="78.71" r="0.9"/>
          <circle cx="73.2" cy="78.71" r="0.9"/>
          <circle cx="73.46" cy="78.71" r="0.9"/>
          <circle cx="73.72" cy="78.71" r="0.9"/>
          <circle cx="73.98" cy="78.71" r="0.9"/>
          <circle cx="74.24" cy="78.71" r="0.9"/>
          <circle cx="74.49" cy="78.71" r="0.9"/>
          <circle cx="74.75" cy="78.71" r="0.9"/>
          <circle cx="75.01" cy="78.71" r="0.9"/>
          <circle cx="75.27" cy="78.71" r="0.9"/>
          <circle cx="75.53" cy="78.71" r="0.9"/>
          <circle cx="75.79" cy="78.71" r="0.9"/>
          <circle cx="76.04" cy="78.71" r="0.9"/>
          <circle cx="76.3" cy="78.71" r="0.9"/>
          <circle cx="76.56" cy="78.71" r="0.9"/>
          <circle cx="76.82" cy="78.71" r="0.9"/>
          <circle cx="77.08" cy="78.71" r="0.9"/>
          <circle cx="77.34" cy="78.71" r="0.9"/>
          <circle cx="77.59" cy="78.71" r="0.9"/>
          <circle cx="77.85" cy="78.71" r="0.9"/>
          <circle cx="78.11" cy="78.71" r="0.9"/>
          <circle cx="78.37" cy="78.71" r="0.9"/>
          <circle cx="78.63" cy="78.71" r="0.9"/>
          <circle cx="78.89" cy="78.71" r="0.9"/>
          <circle cx="79.14" cy="78.71" r="0.9"/>
          <circle cx="79.4" cy="78.71" r="0.9"/>
          <circle cx="79.66" cy="78.71" r="0.9"/>
          <circle cx="79.92" cy="78.71" r="0.9"/>
          <circle cx="80.18" cy="78.71" r="0.9"/>
          <circle cx="80.44" cy="78.71" r="0.9"/>
          <circle cx="80.69" cy="78.71" r="0.9"/>
          <circle cx="80.95" cy="78.71" r="0.9"/>
          <circle cx="81.21" cy="78.71" r="0.9"/>
          <circle cx="81.47" cy="78.71" r="0.9"/>
          <circle cx="81.73" cy="78.71" r="0.9"/>
          <circle cx="81.98" cy="78.71" r="0.9"/>
          <circle cx="82.24" cy="78.71" r="0.9"/>
          <circle cx="82.5" cy="78.71" r="0.9"/>
          <circle cx="82.76" cy="78.71" r="0.9"/>
          <circle cx="83.02" cy="78.71" r="0.9"/>
          <circle cx="83.28" cy="78.71" r="0.9"/>
          <circle cx="83.53" cy="78.71" r="0.9"/>
          <circle cx="83.79" cy="78.71" r="0.9"/>
          <circle cx="84.05" cy="78.71" r="0.9"/>
          <circle cx="84.31" cy="78.71" r="0.9"/>
          <circle cx="84.57" cy="78.71" r="0.9"/>
          <circle cx="84.83" cy="78.71" r="0.9"/>
          <circle cx="85.08" cy="78.71" r="0.9"/>
          <circle cx="85.34" cy="78.71" r="0.9"/>
          <circle cx="85.6" cy="78.71" r="0.9"/>
          <circle cx="85.86" cy="78.71" r="0.9"/>
          <circle cx="86.12" cy="78.71" r="0.9"/>
          <circle cx="86.38" cy="78.71" r="0.9"/>
          <circle cx="86.63" cy="78.71" r="0.9"/>
          <circle cx="86.89" cy="78.71" r="0.9"/>
          <circle cx="87.15" cy="78.71" r="0.9"/>
          <circle cx="87.41" cy="78.71" r="0.9"/>
          <circle cx="87.67" cy="78.71" r="0.9"/>
          <circle cx="87.93" cy="78.71" r="0.9"/>
          <circle cx="88.18" cy="78.71" r="0.9"/>
          <circle cx="88.44" cy="78.71" r="0.9"/>
          <circle cx="88.7" cy="78.71" r="0.9"/>
          <circle cx="88.96" cy="78.71" r="0.9"/>
          <circle cx="89.22" cy="78.71" r="0.9"/>
          <circle cx="89.48" cy="78.71" r="0.9"/>
          <circle cx="89.73" cy="78.71" r="0.9"/>
          <circle cx="89.99" cy="78.71" r="0.9"/>
          <circle cx="90.25" cy="78.71" r="0.9"/>
          <circle cx="90.51" cy="78.71" r="0.9"/>
          <circle cx="90.77" cy="78.71" r="0.9"/>
          <circle cx="91.03" cy="78.71" r="0.9"/>
          <circle cx="91.28" cy="78.71" r="0.9"/>
          <circle cx="91.54" cy="78.71" r="0.9"/>
          <circle cx="91.8" cy="78.71" r="0.9"/>
          <circle cx="92.06" cy="78.71" r="0.9"/>
          <circle cx="92.32" cy="78.71" r="0.9"/>
          <circle cx="92.58" cy="78.71" r="0.9"/>
          <circle cx="92.83" cy="78.71" r="0.9"/>
          <circle cx="93.09" cy="78.71" r="0.9"/>
          <circle cx="93.35" cy="78.71" r="0.9"/>
          <circle cx="93.61" cy="78.71" r="0.9"/>
          <circle cx="93.87" cy="78.71" r="0.9"/>
          <circle cx="94.13" cy="78.71" r="0.9"/>
          <circle cx="94.38" cy="78.71" r="0.9"/>
          <circle cx="94.64" cy="78.71" r="0.9"/>
          <circle cx="94.9" cy="78.71" r="0.9"/>
          <circle cx="95.16" cy="78.71" r="0.9"/>
          <circle cx="95.42" cy="78.71" r="0.9"/>
          <circle cx="95.68" cy="78.71" r="0.9"/>
          <circle cx="95.93" cy="78.71" r="0.9"/>
          <circle cx="96.19" cy="78.71" r="0.9"/>
          <circle cx="96.45" cy="78.71" r="0.9"/>
          <circle cx="96.71" cy="78.71" r="0.9"/>
          <circle cx="96.97" cy="78.71" r="0.9"/>
          <circle cx="97.23" cy="78.71" r="0.9"/>
          <circle cx="97.48" cy="78.71" r="0.9"/>
          <circle cx="97.74" cy="78.71" r="0.9"/>
          <circle cx="98" cy="78.71" r="0.9"/>
          <circle cx="98.26" cy="78.71" r="0.9"/>
          <circle cx="98.52" cy="78.71" r="0.9"/>
          <circle cx="98.77" cy="78.71" r="0.9"/>
          <circle cx="99.03" cy="78.71" r="0.9"/>
          <circle cx="99.29" cy="78.71" r="0.9"/>
          <circle cx="99.55" cy="78.71" r="0.9"/>
          <circle cx="99.81" cy="78.71" r="0.9"/>
          <circle cx="100.07" cy="78.71" r="0.9"/>
          <circle cx="100.32" cy="78.71" r="0.9"/>
          <circle cx="100.58" cy="78.71" r="0.9"/>
          <circle cx="100.84" cy="78.71" r="0.9"/>
          <circle cx="101.1" cy="78.71" r="0.9"/>
          <circle cx="101.36" cy="78.71" r="0.9"/>
          <circle cx="101.62" cy="78.71" r="0.9"/>
          <circle cx="101.87" cy="78.71" r="0.9"/>
          <circle cx="102.13" cy="78.71" r="0.9"/>
          <circle cx="102.39" cy="78.71" r="0.9"/>
          <circle cx="102.65" cy="78.71" r="0.9"/>
          <circle cx="102.91" cy="78.71" r="0.9"/>
          <circle cx="103.17" cy="78.71" r="0.9"/>
          <circle cx="103.42" cy="78.71" r="0.9"/>
          <circle cx="103.68" cy="78.71" r="0.9"/>
          <circle cx="103.94" cy="78.71" r="0.9"/>
          <circle cx="104.2" cy="78.71" r="0.9"/>
          <circle cx="104.46" cy="78.71" r="0.9"/>
          <circle cx="104.72" cy="78.71" r="0.9"/>
          <circle cx="104.97" cy="78.71" r="0.9"/>
          <circle cx="105.23" cy="78.71" r="0.9"/>
          <circle cx="105.49" cy="78.71" r="0.9"/>
          <circle cx="105.75" cy="78.71" r="0.9"/>
          <circle cx="106.01" cy="78.71" r="0.9"/>
          <circle cx="106.27" cy="78.71" r="0.9"/>
          <circle cx="106.52" cy="78.71" r="0.9"/>
          <circle cx="106.78" cy="78.71" r="0.9"/>
          <circle cx="107.04" cy="78.71" r="0.9"/>
          <circle cx="107.3" cy="78.71" r="0.9"/>
          <circle cx="107.56" cy="78.71" r="0.9"/>
          <circle cx="107.82" cy="78.71" r="0.9"/>
          <circle cx="108.07" cy="78.71" r="0.9"/>
          <circle cx="108.33" cy="78.71" r="0.9"/>
          <circle cx="108.59" cy="78.71" r="0.9"/>
          <circle cx="108.85" cy="78.71" r="0.9"/>
          <circle cx="109.11" cy="78.71" r="0.9"/>
          <circle cx="109.37" cy="78.71" r="0.9"/>
          <circle cx="109.62" cy="78.71" r="0.9"/>
          <circle cx="109.88" cy="78.71" r="0.9"/>
          <circle cx="110.14" cy="78.71" r="0.9"/>
          <circle cx="110.4" cy="78.71" r="0.9"/>
          <circle cx="110.66" cy="78.71" r="0.9"/>
          <circle cx="110.92" cy="78.71" r="0.9"/>
          <circle cx="111.17" cy="78.71" r="0.9"/>
          <circle cx="111.43" cy="78.71" r="0.9"/>
          <circle cx="111.69" cy="78.71" r="0.9"/>
          <circle cx="111.95" cy="78.71" r="0.9"/>
          <circle cx="112.21" cy="78.71" r="0.9"/>
          <circle cx="112.47" cy="78.71" r="0.9"/>
          <circle cx="112.72" cy="78.71" r="0.9"/>
          <circle cx="112.98" cy="78.71" r="0.9"/>
          <circle cx="113.24" cy="78.71" r="0.9"/>
          <circle cx="113.5" cy="78.71" r="0.9"/>
          <circle cx="113.76" cy="78.71" r="0.9"/>
          <circle cx="114.02" cy="78.71" r="0.9"/>
          <circle cx="114.27" cy="78.71" r="0.9"/>
          <circle cx="114.53" cy="78.71" r="0.9"/>
          <circle cx="114.79" cy="78.71" r="0.9"/>
          <circle cx="115.05" cy="78.71" r="0.9"/>
          <circle cx="115.31" cy="78.71" r="0.9"/>
          <circle cx="115.56" cy="78.71" r="0.9"/>
          <circle cx="115.82" cy="78.71" r="0.9"/>
          <circle cx="116.08" cy="78.71" r="0.9"/>
          <circle cx="116.34" cy="78.71" r="0.9"/>
          <circle cx="116.6" cy="78.71" r="0.9"/>
          <circle cx="116.86" cy="78.71" r="0.9"/>
          <circle cx="117.11" cy="78.71" r="0.9"/>
          <circle cx="117.37" cy="78.71" r="0.9"/>
          <circle cx="117.63" cy="78.71" r="0.9"/>
          <circle cx="117.89" cy="78.71" r="0.9"/>
          <circle cx="118.15" cy="78.71" r="0.9"/>
          <circle cx="118.41" cy="78.71" r="0.9"/>
          <circle cx="118.66" cy="78.71" r="0.9"/>
          <circle cx="118.92" cy="78.71" r="0.9"/>
          <circle cx="119.18" cy="78.71" r="0.9"/>
          <circle cx="119.44" cy="78.71" r="0.9"/>
          <circle cx="119.7" cy="78.71" r="0.9"/>
          <circle cx="119.96" cy="78.71" r="0.9"/>
          <circle cx="120.21" cy="78.71" r="0.9"/>
          <circle cx="120.47" cy="78.71" r="0.9"/>
          <circle cx="120.73" cy="78.71" r="0.9"/>
          <circle cx="120.99" cy="78.71" r="0.9"/>
          <circle cx="121.25" cy="78.71" r="0.9"/>
          <circle cx="121.51" cy="78.71" r="0.9"/>
          <circle cx="121.76" cy="78.71" r="0.9"/>
          <circle cx="122.02" cy="78.71" r="0.9"/>
          <circle cx="122.28" cy="78.71" r="0.9"/>
          <circle cx="122.54" cy="78.71" r="0.9"/>
          <circle cx="122.8" cy="78.71" r="0.9"/>
          <circle cx="123.06" cy="78.71" r="0.9"/>
          <circle cx="123.31" cy="78.71" r="0.9"/>
          <circle cx="123.57" cy="78.71" r="0.9"/>
          <circle cx="123.83" cy="78.71" r="0.9"/>
          <circle cx="124.09" cy="78.71" r="0.9"/>
          <circle cx="124.35" cy="78.71" r="0.9"/>
          <circle cx="124.61" cy="78.71" r="0.9"/>
          <circle cx="124.86" cy="78.71" r="0.9"/>
          <circle cx="125.12" cy="78.71" r="0.9"/>
          <circle cx="125.38" cy="78.71" r="0.9"/>
          <circle cx="125.64" cy="78.71" r="0.9"/>
          <circle cx="125.9" cy="78.71" r="0.9"/>
          <circle cx="126.16" cy="78.71" r="0.9"/>
          <circle cx="126.41" cy="78.71" r="0.9"/>
          <circle cx="126.67" cy="78.71" r="0.9"/>
          <circle cx="126.93" cy="78.71" r="0.9"/>
          <circle cx="127.19" cy="78.71" r="0.9"/>
          <circle cx="127.45" cy="78.71" r="0.9"/>
          <circle cx="127.71" cy="78.71" r="0.9"/>
          <circle cx="127.96" cy="78.71" r="0.9"/>
          <circle cx="128.22" cy="78.71" r="0.9"/>
          <circle cx="128.48" cy="78.71" r="0.9"/>
          <circle cx="128.74" cy="78.71" r="0.9"/>
          <circle cx="129" cy="78.71" r="0.9"/>
          <circle cx="129.26" cy="78.71" r="0.9"/>
          <circle cx="129.51" cy="78.71" r="0.9"/>
          <circle cx="129.77" cy="78.71" r="0.9"/>
          <circle cx="130.03" cy="78.71" r="0.9"/>
          <circle cx="130.29" cy="78.71" r="0.9"/>
          <circle cx="130.55" cy="78.71" r="0.9"/>
          <circle cx="130.81" cy="78.71" r="0.9"/>
          <circle cx="131.06" cy="78.71" r="0.9"/>
          <circle cx="131.32" cy="78.71" r="0.9"/>
          <circle cx="131.58" cy="78.71" r="0.9"/>
          <circle cx="131.84" cy="78.71" r="0.9"/>
          <circle cx="132.1" cy="78.71" r="0.9"/>
          <circle cx="132.35" cy="78.71" r="0.9"/>
          <circle cx="132.61" cy="78.71" r="0.9"/>
          <circle cx="132.87" cy="78.71" r="0.9"/>
          <circle cx="133.13" cy="78.71" r="0.9"/>
          <circle cx="133.39" cy="78.71" r="0.9"/>
          <circle cx="133.65" cy="78.71" r="0.9"/>
          <circle cx="133.9" cy="78.71" r="0.9"/>
          <circle cx="134.16" cy="78.71" r="0.9"/>
          <circle cx="134.42" cy="78.71" r="0.9"/>
        </g>
      </g>
    </g>
    <g opacity="0" class="guide zoomslider" stroke="none" id="fig-a9ec3c81e95b4f6b839742ba6960be33-element-12">
      <g fill="#EAEAEA" stroke-width="0.3" stroke-opacity="0" stroke="#6A6A6A" id="fig-a9ec3c81e95b4f6b839742ba6960be33-element-13">
        <rect x="129.42" y="8" width="4" height="4"/>
        <g class="button_logo" fill="#6A6A6A" id="fig-a9ec3c81e95b4f6b839742ba6960be33-element-14">
          <path d="M130.22,9.6 L 131.02 9.6 131.02 8.8 131.82 8.8 131.82 9.6 132.62 9.6 132.62 10.4 131.82 10.4 131.82 11.2 131.02 11.2 131.02 10.4 130.22 10.4 z"/>
        </g>
      </g>
      <g fill="#EAEAEA" id="fig-a9ec3c81e95b4f6b839742ba6960be33-element-15">
        <rect x="109.92" y="8" width="19" height="4"/>
      </g>
      <g class="zoomslider_thumb" fill="#6A6A6A" id="fig-a9ec3c81e95b4f6b839742ba6960be33-element-16">
        <rect x="118.42" y="8" width="2" height="4"/>
      </g>
      <g fill="#EAEAEA" stroke-width="0.3" stroke-opacity="0" stroke="#6A6A6A" id="fig-a9ec3c81e95b4f6b839742ba6960be33-element-17">
        <rect x="105.42" y="8" width="4" height="4"/>
        <g class="button_logo" fill="#6A6A6A" id="fig-a9ec3c81e95b4f6b839742ba6960be33-element-18">
          <path d="M106.22,9.6 L 108.62 9.6 108.62 10.4 106.22 10.4 z"/>
        </g>
      </g>
    </g>
  </g>
  <g class="guide ylabels" font-size="2.82" font-family="'PT Sans Caption','Helvetica Neue','Helvetica',sans-serif" fill="#6C606B" id="fig-a9ec3c81e95b4f6b839742ba6960be33-element-19">
    <text x="28.1" y="164.77" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="hidden">-1.2×10⁻⁵</text>
    <text x="28.1" y="150.43" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="hidden">-1.0×10⁻⁵</text>
    <text x="28.1" y="136.09" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="hidden">-8.0×10⁻⁶</text>
    <text x="28.1" y="121.74" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="hidden">-6.0×10⁻⁶</text>
    <text x="28.1" y="107.4" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="hidden">-4.0×10⁻⁶</text>
    <text x="28.1" y="93.06" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="hidden">-2.0×10⁻⁶</text>
    <text x="28.1" y="78.72" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="visible">0</text>
    <text x="28.1" y="64.37" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="visible">2.0×10⁻⁶</text>
    <text x="28.1" y="50.03" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="visible">4.0×10⁻⁶</text>
    <text x="28.1" y="35.69" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="visible">6.0×10⁻⁶</text>
    <text x="28.1" y="21.34" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="visible">8.0×10⁻⁶</text>
    <text x="28.1" y="7" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="visible">1.0×10⁻⁵</text>
    <text x="28.1" y="-7.34" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="hidden">1.2×10⁻⁵</text>
    <text x="28.1" y="-21.69" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="hidden">1.4×10⁻⁵</text>
    <text x="28.1" y="-36.03" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="hidden">1.6×10⁻⁵</text>
    <text x="28.1" y="-50.37" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="hidden">1.8×10⁻⁵</text>
    <text x="28.1" y="-64.72" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="hidden">2.0×10⁻⁵</text>
    <text x="28.1" y="-79.06" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="hidden">2.2×10⁻⁵</text>
    <text x="28.1" y="150.43" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-1.00×10⁻⁵</text>
    <text x="28.1" y="146.84" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-9.50×10⁻⁶</text>
    <text x="28.1" y="143.26" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-9.00×10⁻⁶</text>
    <text x="28.1" y="139.67" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-8.50×10⁻⁶</text>
    <text x="28.1" y="136.09" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-8.00×10⁻⁶</text>
    <text x="28.1" y="132.5" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-7.50×10⁻⁶</text>
    <text x="28.1" y="128.92" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-7.00×10⁻⁶</text>
    <text x="28.1" y="125.33" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-6.50×10⁻⁶</text>
    <text x="28.1" y="121.74" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-6.00×10⁻⁶</text>
    <text x="28.1" y="118.16" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-5.50×10⁻⁶</text>
    <text x="28.1" y="114.57" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-5.00×10⁻⁶</text>
    <text x="28.1" y="110.99" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-4.50×10⁻⁶</text>
    <text x="28.1" y="107.4" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-4.00×10⁻⁶</text>
    <text x="28.1" y="103.82" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-3.50×10⁻⁶</text>
    <text x="28.1" y="100.23" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-3.00×10⁻⁶</text>
    <text x="28.1" y="96.64" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-2.50×10⁻⁶</text>
    <text x="28.1" y="93.06" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-2.00×10⁻⁶</text>
    <text x="28.1" y="89.47" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-1.50×10⁻⁶</text>
    <text x="28.1" y="85.89" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-1.00×10⁻⁶</text>
    <text x="28.1" y="82.3" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-5.00×10⁻⁷</text>
    <text x="28.1" y="78.72" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0</text>
    <text x="28.1" y="75.13" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">5.00×10⁻⁷</text>
    <text x="28.1" y="71.54" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.00×10⁻⁶</text>
    <text x="28.1" y="67.96" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.50×10⁻⁶</text>
    <text x="28.1" y="64.37" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">2.00×10⁻⁶</text>
    <text x="28.1" y="60.79" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">2.50×10⁻⁶</text>
    <text x="28.1" y="57.2" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">3.00×10⁻⁶</text>
    <text x="28.1" y="53.61" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">3.50×10⁻⁶</text>
    <text x="28.1" y="50.03" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">4.00×10⁻⁶</text>
    <text x="28.1" y="46.44" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">4.50×10⁻⁶</text>
    <text x="28.1" y="42.86" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">5.00×10⁻⁶</text>
    <text x="28.1" y="39.27" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">5.50×10⁻⁶</text>
    <text x="28.1" y="35.69" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">6.00×10⁻⁶</text>
    <text x="28.1" y="32.1" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">6.50×10⁻⁶</text>
    <text x="28.1" y="28.51" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">7.00×10⁻⁶</text>
    <text x="28.1" y="24.93" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">7.50×10⁻⁶</text>
    <text x="28.1" y="21.34" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">8.00×10⁻⁶</text>
    <text x="28.1" y="17.76" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">8.50×10⁻⁶</text>
    <text x="28.1" y="14.17" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">9.00×10⁻⁶</text>
    <text x="28.1" y="10.59" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">9.50×10⁻⁶</text>
    <text x="28.1" y="7" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.00×10⁻⁵</text>
    <text x="28.1" y="3.41" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.05×10⁻⁵</text>
    <text x="28.1" y="-0.17" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.10×10⁻⁵</text>
    <text x="28.1" y="-3.76" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.15×10⁻⁵</text>
    <text x="28.1" y="-7.34" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.20×10⁻⁵</text>
    <text x="28.1" y="-10.93" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.25×10⁻⁵</text>
    <text x="28.1" y="-14.51" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.30×10⁻⁵</text>
    <text x="28.1" y="-18.1" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.35×10⁻⁵</text>
    <text x="28.1" y="-21.69" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.40×10⁻⁵</text>
    <text x="28.1" y="-25.27" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.45×10⁻⁵</text>
    <text x="28.1" y="-28.86" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.50×10⁻⁵</text>
    <text x="28.1" y="-32.44" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.55×10⁻⁵</text>
    <text x="28.1" y="-36.03" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.60×10⁻⁵</text>
    <text x="28.1" y="-39.61" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.65×10⁻⁵</text>
    <text x="28.1" y="-43.2" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.70×10⁻⁵</text>
    <text x="28.1" y="-46.79" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.75×10⁻⁵</text>
    <text x="28.1" y="-50.37" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.80×10⁻⁵</text>
    <text x="28.1" y="-53.96" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.85×10⁻⁵</text>
    <text x="28.1" y="-57.54" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.90×10⁻⁵</text>
    <text x="28.1" y="-61.13" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">1.95×10⁻⁵</text>
    <text x="28.1" y="-64.72" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">2.00×10⁻⁵</text>
    <text x="28.1" y="150.43" text-anchor="end" dy="0.35em" gadfly:scale="0.5" visibility="hidden">-1×10⁻⁵</text>
    <text x="28.1" y="78.72" text-anchor="end" dy="0.35em" gadfly:scale="0.5" visibility="hidden">0</text>
    <text x="28.1" y="7" text-anchor="end" dy="0.35em" gadfly:scale="0.5" visibility="hidden">1×10⁻⁵</text>
    <text x="28.1" y="-64.72" text-anchor="end" dy="0.35em" gadfly:scale="0.5" visibility="hidden">2×10⁻⁵</text>
    <text x="28.1" y="150.43" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-1.0×10⁻⁵</text>
    <text x="28.1" y="143.26" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-9.0×10⁻⁶</text>
    <text x="28.1" y="136.09" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-8.0×10⁻⁶</text>
    <text x="28.1" y="128.92" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-7.0×10⁻⁶</text>
    <text x="28.1" y="121.74" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-6.0×10⁻⁶</text>
    <text x="28.1" y="114.57" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-5.0×10⁻⁶</text>
    <text x="28.1" y="107.4" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-4.0×10⁻⁶</text>
    <text x="28.1" y="100.23" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-3.0×10⁻⁶</text>
    <text x="28.1" y="93.06" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-2.0×10⁻⁶</text>
    <text x="28.1" y="85.89" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-1.0×10⁻⁶</text>
    <text x="28.1" y="78.72" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0</text>
    <text x="28.1" y="71.54" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">1.0×10⁻⁶</text>
    <text x="28.1" y="64.37" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">2.0×10⁻⁶</text>
    <text x="28.1" y="57.2" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">3.0×10⁻⁶</text>
    <text x="28.1" y="50.03" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">4.0×10⁻⁶</text>
    <text x="28.1" y="42.86" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">5.0×10⁻⁶</text>
    <text x="28.1" y="35.69" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">6.0×10⁻⁶</text>
    <text x="28.1" y="28.51" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">7.0×10⁻⁶</text>
    <text x="28.1" y="21.34" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">8.0×10⁻⁶</text>
    <text x="28.1" y="14.17" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">9.0×10⁻⁶</text>
    <text x="28.1" y="7" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">1.0×10⁻⁵</text>
    <text x="28.1" y="-0.17" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">1.1×10⁻⁵</text>
    <text x="28.1" y="-7.34" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">1.2×10⁻⁵</text>
    <text x="28.1" y="-14.51" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">1.3×10⁻⁵</text>
    <text x="28.1" y="-21.69" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">1.4×10⁻⁵</text>
    <text x="28.1" y="-28.86" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">1.5×10⁻⁵</text>
    <text x="28.1" y="-36.03" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">1.6×10⁻⁵</text>
    <text x="28.1" y="-43.2" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">1.7×10⁻⁵</text>
    <text x="28.1" y="-50.37" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">1.8×10⁻⁵</text>
    <text x="28.1" y="-57.54" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">1.9×10⁻⁵</text>
    <text x="28.1" y="-64.72" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">2.0×10⁻⁵</text>
  </g>
  <g font-size="3.88" font-family="'PT Sans','Helvetica Neue','Helvetica',sans-serif" fill="#564A55" stroke="none" id="fig-a9ec3c81e95b4f6b839742ba6960be33-element-20">
    <text x="8.81" y="40.86" text-anchor="middle" dy="0.35em" transform="rotate(-90, 8.81, 42.86)">Absolute Error</text>
  </g>
</g>
<defs>
<clipPath id="fig-a9ec3c81e95b4f6b839742ba6960be33-element-5">
  <path d="M29.1,5 L 136.42 5 136.42 80.72 29.1 80.72" />
</clipPath
></defs>
<script> <![CDATA[
(function(N){var k=/[\.\/]/,L=/\s*,\s*/,C=function(a,d){return a-d},a,v,y={n:{}},M=function(){for(var a=0,d=this.length;a<d;a++)if("undefined"!=typeof this[a])return this[a]},A=function(){for(var a=this.length;--a;)if("undefined"!=typeof this[a])return this[a]},w=function(k,d){k=String(k);var f=v,n=Array.prototype.slice.call(arguments,2),u=w.listeners(k),p=0,b,q=[],e={},l=[],r=a;l.firstDefined=M;l.lastDefined=A;a=k;for(var s=v=0,x=u.length;s<x;s++)"zIndex"in u[s]&&(q.push(u[s].zIndex),0>u[s].zIndex&&
(e[u[s].zIndex]=u[s]));for(q.sort(C);0>q[p];)if(b=e[q[p++] ],l.push(b.apply(d,n)),v)return v=f,l;for(s=0;s<x;s++)if(b=u[s],"zIndex"in b)if(b.zIndex==q[p]){l.push(b.apply(d,n));if(v)break;do if(p++,(b=e[q[p] ])&&l.push(b.apply(d,n)),v)break;while(b)}else e[b.zIndex]=b;else if(l.push(b.apply(d,n)),v)break;v=f;a=r;return l};w._events=y;w.listeners=function(a){a=a.split(k);var d=y,f,n,u,p,b,q,e,l=[d],r=[];u=0;for(p=a.length;u<p;u++){e=[];b=0;for(q=l.length;b<q;b++)for(d=l[b].n,f=[d[a[u] ],d["*"] ],n=2;n--;)if(d=
f[n])e.push(d),r=r.concat(d.f||[]);l=e}return r};w.on=function(a,d){a=String(a);if("function"!=typeof d)return function(){};for(var f=a.split(L),n=0,u=f.length;n<u;n++)(function(a){a=a.split(k);for(var b=y,f,e=0,l=a.length;e<l;e++)b=b.n,b=b.hasOwnProperty(a[e])&&b[a[e] ]||(b[a[e] ]={n:{}});b.f=b.f||[];e=0;for(l=b.f.length;e<l;e++)if(b.f[e]==d){f=!0;break}!f&&b.f.push(d)})(f[n]);return function(a){+a==+a&&(d.zIndex=+a)}};w.f=function(a){var d=[].slice.call(arguments,1);return function(){w.apply(null,
[a,null].concat(d).concat([].slice.call(arguments,0)))}};w.stop=function(){v=1};w.nt=function(k){return k?(new RegExp("(?:\\.|\\/|^)"+k+"(?:\\.|\\/|$)")).test(a):a};w.nts=function(){return a.split(k)};w.off=w.unbind=function(a,d){if(a){var f=a.split(L);if(1<f.length)for(var n=0,u=f.length;n<u;n++)w.off(f[n],d);else{for(var f=a.split(k),p,b,q,e,l=[y],n=0,u=f.length;n<u;n++)for(e=0;e<l.length;e+=q.length-2){q=[e,1];p=l[e].n;if("*"!=f[n])p[f[n] ]&&q.push(p[f[n] ]);else for(b in p)p.hasOwnProperty(b)&&
q.push(p[b]);l.splice.apply(l,q)}n=0;for(u=l.length;n<u;n++)for(p=l[n];p.n;){if(d){if(p.f){e=0;for(f=p.f.length;e<f;e++)if(p.f[e]==d){p.f.splice(e,1);break}!p.f.length&&delete p.f}for(b in p.n)if(p.n.hasOwnProperty(b)&&p.n[b].f){q=p.n[b].f;e=0;for(f=q.length;e<f;e++)if(q[e]==d){q.splice(e,1);break}!q.length&&delete p.n[b].f}}else for(b in delete p.f,p.n)p.n.hasOwnProperty(b)&&p.n[b].f&&delete p.n[b].f;p=p.n}}}else w._events=y={n:{}}};w.once=function(a,d){var f=function(){w.unbind(a,f);return d.apply(this,
arguments)};return w.on(a,f)};w.version="0.4.2";w.toString=function(){return"You are running Eve 0.4.2"};"undefined"!=typeof module&&module.exports?module.exports=w:"function"===typeof define&&define.amd?define("eve",[],function(){return w}):N.eve=w})(this);
(function(N,k){"function"===typeof define&&define.amd?define("Snap.svg",["eve"],function(L){return k(N,L)}):k(N,N.eve)})(this,function(N,k){var L=function(a){var k={},y=N.requestAnimationFrame||N.webkitRequestAnimationFrame||N.mozRequestAnimationFrame||N.oRequestAnimationFrame||N.msRequestAnimationFrame||function(a){setTimeout(a,16)},M=Array.isArray||function(a){return a instanceof Array||"[object Array]"==Object.prototype.toString.call(a)},A=0,w="M"+(+new Date).toString(36),z=function(a){if(null==
a)return this.s;var b=this.s-a;this.b+=this.dur*b;this.B+=this.dur*b;this.s=a},d=function(a){if(null==a)return this.spd;this.spd=a},f=function(a){if(null==a)return this.dur;this.s=this.s*a/this.dur;this.dur=a},n=function(){delete k[this.id];this.update();a("mina.stop."+this.id,this)},u=function(){this.pdif||(delete k[this.id],this.update(),this.pdif=this.get()-this.b)},p=function(){this.pdif&&(this.b=this.get()-this.pdif,delete this.pdif,k[this.id]=this)},b=function(){var a;if(M(this.start)){a=[];
for(var b=0,e=this.start.length;b<e;b++)a[b]=+this.start[b]+(this.end[b]-this.start[b])*this.easing(this.s)}else a=+this.start+(this.end-this.start)*this.easing(this.s);this.set(a)},q=function(){var l=0,b;for(b in k)if(k.hasOwnProperty(b)){var e=k[b],f=e.get();l++;e.s=(f-e.b)/(e.dur/e.spd);1<=e.s&&(delete k[b],e.s=1,l--,function(b){setTimeout(function(){a("mina.finish."+b.id,b)})}(e));e.update()}l&&y(q)},e=function(a,r,s,x,G,h,J){a={id:w+(A++).toString(36),start:a,end:r,b:s,s:0,dur:x-s,spd:1,get:G,
set:h,easing:J||e.linear,status:z,speed:d,duration:f,stop:n,pause:u,resume:p,update:b};k[a.id]=a;r=0;for(var K in k)if(k.hasOwnProperty(K)&&(r++,2==r))break;1==r&&y(q);return a};e.time=Date.now||function(){return+new Date};e.getById=function(a){return k[a]||null};e.linear=function(a){return a};e.easeout=function(a){return Math.pow(a,1.7)};e.easein=function(a){return Math.pow(a,0.48)};e.easeinout=function(a){if(1==a)return 1;if(0==a)return 0;var b=0.48-a/1.04,e=Math.sqrt(0.1734+b*b);a=e-b;a=Math.pow(Math.abs(a),
1/3)*(0>a?-1:1);b=-e-b;b=Math.pow(Math.abs(b),1/3)*(0>b?-1:1);a=a+b+0.5;return 3*(1-a)*a*a+a*a*a};e.backin=function(a){return 1==a?1:a*a*(2.70158*a-1.70158)};e.backout=function(a){if(0==a)return 0;a-=1;return a*a*(2.70158*a+1.70158)+1};e.elastic=function(a){return a==!!a?a:Math.pow(2,-10*a)*Math.sin(2*(a-0.075)*Math.PI/0.3)+1};e.bounce=function(a){a<1/2.75?a*=7.5625*a:a<2/2.75?(a-=1.5/2.75,a=7.5625*a*a+0.75):a<2.5/2.75?(a-=2.25/2.75,a=7.5625*a*a+0.9375):(a-=2.625/2.75,a=7.5625*a*a+0.984375);return a};
return N.mina=e}("undefined"==typeof k?function(){}:k),C=function(){function a(c,t){if(c){if(c.tagName)return x(c);if(y(c,"array")&&a.set)return a.set.apply(a,c);if(c instanceof e)return c;if(null==t)return c=G.doc.querySelector(c),x(c)}return new s(null==c?"100%":c,null==t?"100%":t)}function v(c,a){if(a){"#text"==c&&(c=G.doc.createTextNode(a.text||""));"string"==typeof c&&(c=v(c));if("string"==typeof a)return"xlink:"==a.substring(0,6)?c.getAttributeNS(m,a.substring(6)):"xml:"==a.substring(0,4)?c.getAttributeNS(la,
a.substring(4)):c.getAttribute(a);for(var da in a)if(a[h](da)){var b=J(a[da]);b?"xlink:"==da.substring(0,6)?c.setAttributeNS(m,da.substring(6),b):"xml:"==da.substring(0,4)?c.setAttributeNS(la,da.substring(4),b):c.setAttribute(da,b):c.removeAttribute(da)}}else c=G.doc.createElementNS(la,c);return c}function y(c,a){a=J.prototype.toLowerCase.call(a);return"finite"==a?isFinite(c):"array"==a&&(c instanceof Array||Array.isArray&&Array.isArray(c))?!0:"null"==a&&null===c||a==typeof c&&null!==c||"object"==
a&&c===Object(c)||$.call(c).slice(8,-1).toLowerCase()==a}function M(c){if("function"==typeof c||Object(c)!==c)return c;var a=new c.constructor,b;for(b in c)c[h](b)&&(a[b]=M(c[b]));return a}function A(c,a,b){function m(){var e=Array.prototype.slice.call(arguments,0),f=e.join("\u2400"),d=m.cache=m.cache||{},l=m.count=m.count||[];if(d[h](f)){a:for(var e=l,l=f,B=0,H=e.length;B<H;B++)if(e[B]===l){e.push(e.splice(B,1)[0]);break a}return b?b(d[f]):d[f]}1E3<=l.length&&delete d[l.shift()];l.push(f);d[f]=c.apply(a,
e);return b?b(d[f]):d[f]}return m}function w(c,a,b,m,e,f){return null==e?(c-=b,a-=m,c||a?(180*I.atan2(-a,-c)/C+540)%360:0):w(c,a,e,f)-w(b,m,e,f)}function z(c){return c%360*C/180}function d(c){var a=[];c=c.replace(/(?:^|\s)(\w+)\(([^)]+)\)/g,function(c,b,m){m=m.split(/\s*,\s*|\s+/);"rotate"==b&&1==m.length&&m.push(0,0);"scale"==b&&(2<m.length?m=m.slice(0,2):2==m.length&&m.push(0,0),1==m.length&&m.push(m[0],0,0));"skewX"==b?a.push(["m",1,0,I.tan(z(m[0])),1,0,0]):"skewY"==b?a.push(["m",1,I.tan(z(m[0])),
0,1,0,0]):a.push([b.charAt(0)].concat(m));return c});return a}function f(c,t){var b=O(c),m=new a.Matrix;if(b)for(var e=0,f=b.length;e<f;e++){var h=b[e],d=h.length,B=J(h[0]).toLowerCase(),H=h[0]!=B,l=H?m.invert():0,E;"t"==B&&2==d?m.translate(h[1],0):"t"==B&&3==d?H?(d=l.x(0,0),B=l.y(0,0),H=l.x(h[1],h[2]),l=l.y(h[1],h[2]),m.translate(H-d,l-B)):m.translate(h[1],h[2]):"r"==B?2==d?(E=E||t,m.rotate(h[1],E.x+E.width/2,E.y+E.height/2)):4==d&&(H?(H=l.x(h[2],h[3]),l=l.y(h[2],h[3]),m.rotate(h[1],H,l)):m.rotate(h[1],
h[2],h[3])):"s"==B?2==d||3==d?(E=E||t,m.scale(h[1],h[d-1],E.x+E.width/2,E.y+E.height/2)):4==d?H?(H=l.x(h[2],h[3]),l=l.y(h[2],h[3]),m.scale(h[1],h[1],H,l)):m.scale(h[1],h[1],h[2],h[3]):5==d&&(H?(H=l.x(h[3],h[4]),l=l.y(h[3],h[4]),m.scale(h[1],h[2],H,l)):m.scale(h[1],h[2],h[3],h[4])):"m"==B&&7==d&&m.add(h[1],h[2],h[3],h[4],h[5],h[6])}return m}function n(c,t){if(null==t){var m=!0;t="linearGradient"==c.type||"radialGradient"==c.type?c.node.getAttribute("gradientTransform"):"pattern"==c.type?c.node.getAttribute("patternTransform"):
c.node.getAttribute("transform");if(!t)return new a.Matrix;t=d(t)}else t=a._.rgTransform.test(t)?J(t).replace(/\.{3}|\u2026/g,c._.transform||aa):d(t),y(t,"array")&&(t=a.path?a.path.toString.call(t):J(t)),c._.transform=t;var b=f(t,c.getBBox(1));if(m)return b;c.matrix=b}function u(c){c=c.node.ownerSVGElement&&x(c.node.ownerSVGElement)||c.node.parentNode&&x(c.node.parentNode)||a.select("svg")||a(0,0);var t=c.select("defs"),t=null==t?!1:t.node;t||(t=r("defs",c.node).node);return t}function p(c){return c.node.ownerSVGElement&&
x(c.node.ownerSVGElement)||a.select("svg")}function b(c,a,m){function b(c){if(null==c)return aa;if(c==+c)return c;v(B,{width:c});try{return B.getBBox().width}catch(a){return 0}}function h(c){if(null==c)return aa;if(c==+c)return c;v(B,{height:c});try{return B.getBBox().height}catch(a){return 0}}function e(b,B){null==a?d[b]=B(c.attr(b)||0):b==a&&(d=B(null==m?c.attr(b)||0:m))}var f=p(c).node,d={},B=f.querySelector(".svg---mgr");B||(B=v("rect"),v(B,{x:-9E9,y:-9E9,width:10,height:10,"class":"svg---mgr",
fill:"none"}),f.appendChild(B));switch(c.type){case "rect":e("rx",b),e("ry",h);case "image":e("width",b),e("height",h);case "text":e("x",b);e("y",h);break;case "circle":e("cx",b);e("cy",h);e("r",b);break;case "ellipse":e("cx",b);e("cy",h);e("rx",b);e("ry",h);break;case "line":e("x1",b);e("x2",b);e("y1",h);e("y2",h);break;case "marker":e("refX",b);e("markerWidth",b);e("refY",h);e("markerHeight",h);break;case "radialGradient":e("fx",b);e("fy",h);break;case "tspan":e("dx",b);e("dy",h);break;default:e(a,
b)}f.removeChild(B);return d}function q(c){y(c,"array")||(c=Array.prototype.slice.call(arguments,0));for(var a=0,b=0,m=this.node;this[a];)delete this[a++];for(a=0;a<c.length;a++)"set"==c[a].type?c[a].forEach(function(c){m.appendChild(c.node)}):m.appendChild(c[a].node);for(var h=m.childNodes,a=0;a<h.length;a++)this[b++]=x(h[a]);return this}function e(c){if(c.snap in E)return E[c.snap];var a=this.id=V(),b;try{b=c.ownerSVGElement}catch(m){}this.node=c;b&&(this.paper=new s(b));this.type=c.tagName;this.anims=
{};this._={transform:[]};c.snap=a;E[a]=this;"g"==this.type&&(this.add=q);if(this.type in{g:1,mask:1,pattern:1})for(var e in s.prototype)s.prototype[h](e)&&(this[e]=s.prototype[e])}function l(c){this.node=c}function r(c,a){var b=v(c);a.appendChild(b);return x(b)}function s(c,a){var b,m,f,d=s.prototype;if(c&&"svg"==c.tagName){if(c.snap in E)return E[c.snap];var l=c.ownerDocument;b=new e(c);m=c.getElementsByTagName("desc")[0];f=c.getElementsByTagName("defs")[0];m||(m=v("desc"),m.appendChild(l.createTextNode("Created with Snap")),
b.node.appendChild(m));f||(f=v("defs"),b.node.appendChild(f));b.defs=f;for(var ca in d)d[h](ca)&&(b[ca]=d[ca]);b.paper=b.root=b}else b=r("svg",G.doc.body),v(b.node,{height:a,version:1.1,width:c,xmlns:la});return b}function x(c){return!c||c instanceof e||c instanceof l?c:c.tagName&&"svg"==c.tagName.toLowerCase()?new s(c):c.tagName&&"object"==c.tagName.toLowerCase()&&"image/svg+xml"==c.type?new s(c.contentDocument.getElementsByTagName("svg")[0]):new e(c)}a.version="0.3.0";a.toString=function(){return"Snap v"+
this.version};a._={};var G={win:N,doc:N.document};a._.glob=G;var h="hasOwnProperty",J=String,K=parseFloat,U=parseInt,I=Math,P=I.max,Q=I.min,Y=I.abs,C=I.PI,aa="",$=Object.prototype.toString,F=/^\s*((#[a-f\d]{6})|(#[a-f\d]{3})|rgba?\(\s*([\d\.]+%?\s*,\s*[\d\.]+%?\s*,\s*[\d\.]+%?(?:\s*,\s*[\d\.]+%?)?)\s*\)|hsba?\(\s*([\d\.]+(?:deg|\xb0|%)?\s*,\s*[\d\.]+%?\s*,\s*[\d\.]+(?:%?\s*,\s*[\d\.]+)?%?)\s*\)|hsla?\(\s*([\d\.]+(?:deg|\xb0|%)?\s*,\s*[\d\.]+%?\s*,\s*[\d\.]+(?:%?\s*,\s*[\d\.]+)?%?)\s*\))\s*$/i;a._.separator=
RegExp("[,\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]+");var S=RegExp("[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*"),X={hs:1,rg:1},W=RegExp("([a-z])[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029,]*((-?\\d*\\.?\\d*(?:e[\\-+]?\\d+)?[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,?[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*)+)",
"ig"),ma=RegExp("([rstm])[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029,]*((-?\\d*\\.?\\d*(?:e[\\-+]?\\d+)?[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,?[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*)+)","ig"),Z=RegExp("(-?\\d*\\.?\\d*(?:e[\\-+]?\\d+)?)[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,?[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*",
"ig"),na=0,ba="S"+(+new Date).toString(36),V=function(){return ba+(na++).toString(36)},m="http://www.w3.org/1999/xlink",la="http://www.w3.org/2000/svg",E={},ca=a.url=function(c){return"url('#"+c+"')"};a._.$=v;a._.id=V;a.format=function(){var c=/\{([^\}]+)\}/g,a=/(?:(?:^|\.)(.+?)(?=\[|\.|$|\()|\[('|")(.+?)\2\])(\(\))?/g,b=function(c,b,m){var h=m;b.replace(a,function(c,a,b,m,t){a=a||m;h&&(a in h&&(h=h[a]),"function"==typeof h&&t&&(h=h()))});return h=(null==h||h==m?c:h)+""};return function(a,m){return J(a).replace(c,
function(c,a){return b(c,a,m)})}}();a._.clone=M;a._.cacher=A;a.rad=z;a.deg=function(c){return 180*c/C%360};a.angle=w;a.is=y;a.snapTo=function(c,a,b){b=y(b,"finite")?b:10;if(y(c,"array"))for(var m=c.length;m--;){if(Y(c[m]-a)<=b)return c[m]}else{c=+c;m=a%c;if(m<b)return a-m;if(m>c-b)return a-m+c}return a};a.getRGB=A(function(c){if(!c||(c=J(c)).indexOf("-")+1)return{r:-1,g:-1,b:-1,hex:"none",error:1,toString:ka};if("none"==c)return{r:-1,g:-1,b:-1,hex:"none",toString:ka};!X[h](c.toLowerCase().substring(0,
2))&&"#"!=c.charAt()&&(c=T(c));if(!c)return{r:-1,g:-1,b:-1,hex:"none",error:1,toString:ka};var b,m,e,f,d;if(c=c.match(F)){c[2]&&(e=U(c[2].substring(5),16),m=U(c[2].substring(3,5),16),b=U(c[2].substring(1,3),16));c[3]&&(e=U((d=c[3].charAt(3))+d,16),m=U((d=c[3].charAt(2))+d,16),b=U((d=c[3].charAt(1))+d,16));c[4]&&(d=c[4].split(S),b=K(d[0]),"%"==d[0].slice(-1)&&(b*=2.55),m=K(d[1]),"%"==d[1].slice(-1)&&(m*=2.55),e=K(d[2]),"%"==d[2].slice(-1)&&(e*=2.55),"rgba"==c[1].toLowerCase().slice(0,4)&&(f=K(d[3])),
d[3]&&"%"==d[3].slice(-1)&&(f/=100));if(c[5])return d=c[5].split(S),b=K(d[0]),"%"==d[0].slice(-1)&&(b/=100),m=K(d[1]),"%"==d[1].slice(-1)&&(m/=100),e=K(d[2]),"%"==d[2].slice(-1)&&(e/=100),"deg"!=d[0].slice(-3)&&"\u00b0"!=d[0].slice(-1)||(b/=360),"hsba"==c[1].toLowerCase().slice(0,4)&&(f=K(d[3])),d[3]&&"%"==d[3].slice(-1)&&(f/=100),a.hsb2rgb(b,m,e,f);if(c[6])return d=c[6].split(S),b=K(d[0]),"%"==d[0].slice(-1)&&(b/=100),m=K(d[1]),"%"==d[1].slice(-1)&&(m/=100),e=K(d[2]),"%"==d[2].slice(-1)&&(e/=100),
"deg"!=d[0].slice(-3)&&"\u00b0"!=d[0].slice(-1)||(b/=360),"hsla"==c[1].toLowerCase().slice(0,4)&&(f=K(d[3])),d[3]&&"%"==d[3].slice(-1)&&(f/=100),a.hsl2rgb(b,m,e,f);b=Q(I.round(b),255);m=Q(I.round(m),255);e=Q(I.round(e),255);f=Q(P(f,0),1);c={r:b,g:m,b:e,toString:ka};c.hex="#"+(16777216|e|m<<8|b<<16).toString(16).slice(1);c.opacity=y(f,"finite")?f:1;return c}return{r:-1,g:-1,b:-1,hex:"none",error:1,toString:ka}},a);a.hsb=A(function(c,b,m){return a.hsb2rgb(c,b,m).hex});a.hsl=A(function(c,b,m){return a.hsl2rgb(c,
b,m).hex});a.rgb=A(function(c,a,b,m){if(y(m,"finite")){var e=I.round;return"rgba("+[e(c),e(a),e(b),+m.toFixed(2)]+")"}return"#"+(16777216|b|a<<8|c<<16).toString(16).slice(1)});var T=function(c){var a=G.doc.getElementsByTagName("head")[0]||G.doc.getElementsByTagName("svg")[0];T=A(function(c){if("red"==c.toLowerCase())return"rgb(255, 0, 0)";a.style.color="rgb(255, 0, 0)";a.style.color=c;c=G.doc.defaultView.getComputedStyle(a,aa).getPropertyValue("color");return"rgb(255, 0, 0)"==c?null:c});return T(c)},
qa=function(){return"hsb("+[this.h,this.s,this.b]+")"},ra=function(){return"hsl("+[this.h,this.s,this.l]+")"},ka=function(){return 1==this.opacity||null==this.opacity?this.hex:"rgba("+[this.r,this.g,this.b,this.opacity]+")"},D=function(c,b,m){null==b&&y(c,"object")&&"r"in c&&"g"in c&&"b"in c&&(m=c.b,b=c.g,c=c.r);null==b&&y(c,string)&&(m=a.getRGB(c),c=m.r,b=m.g,m=m.b);if(1<c||1<b||1<m)c/=255,b/=255,m/=255;return[c,b,m]},oa=function(c,b,m,e){c=I.round(255*c);b=I.round(255*b);m=I.round(255*m);c={r:c,
g:b,b:m,opacity:y(e,"finite")?e:1,hex:a.rgb(c,b,m),toString:ka};y(e,"finite")&&(c.opacity=e);return c};a.color=function(c){var b;y(c,"object")&&"h"in c&&"s"in c&&"b"in c?(b=a.hsb2rgb(c),c.r=b.r,c.g=b.g,c.b=b.b,c.opacity=1,c.hex=b.hex):y(c,"object")&&"h"in c&&"s"in c&&"l"in c?(b=a.hsl2rgb(c),c.r=b.r,c.g=b.g,c.b=b.b,c.opacity=1,c.hex=b.hex):(y(c,"string")&&(c=a.getRGB(c)),y(c,"object")&&"r"in c&&"g"in c&&"b"in c&&!("error"in c)?(b=a.rgb2hsl(c),c.h=b.h,c.s=b.s,c.l=b.l,b=a.rgb2hsb(c),c.v=b.b):(c={hex:"none"},
c.r=c.g=c.b=c.h=c.s=c.v=c.l=-1,c.error=1));c.toString=ka;return c};a.hsb2rgb=function(c,a,b,m){y(c,"object")&&"h"in c&&"s"in c&&"b"in c&&(b=c.b,a=c.s,c=c.h,m=c.o);var e,h,d;c=360*c%360/60;d=b*a;a=d*(1-Y(c%2-1));b=e=h=b-d;c=~~c;b+=[d,a,0,0,a,d][c];e+=[a,d,d,a,0,0][c];h+=[0,0,a,d,d,a][c];return oa(b,e,h,m)};a.hsl2rgb=function(c,a,b,m){y(c,"object")&&"h"in c&&"s"in c&&"l"in c&&(b=c.l,a=c.s,c=c.h);if(1<c||1<a||1<b)c/=360,a/=100,b/=100;var e,h,d;c=360*c%360/60;d=2*a*(0.5>b?b:1-b);a=d*(1-Y(c%2-1));b=e=
h=b-d/2;c=~~c;b+=[d,a,0,0,a,d][c];e+=[a,d,d,a,0,0][c];h+=[0,0,a,d,d,a][c];return oa(b,e,h,m)};a.rgb2hsb=function(c,a,b){b=D(c,a,b);c=b[0];a=b[1];b=b[2];var m,e;m=P(c,a,b);e=m-Q(c,a,b);c=((0==e?0:m==c?(a-b)/e:m==a?(b-c)/e+2:(c-a)/e+4)+360)%6*60/360;return{h:c,s:0==e?0:e/m,b:m,toString:qa}};a.rgb2hsl=function(c,a,b){b=D(c,a,b);c=b[0];a=b[1];b=b[2];var m,e,h;m=P(c,a,b);e=Q(c,a,b);h=m-e;c=((0==h?0:m==c?(a-b)/h:m==a?(b-c)/h+2:(c-a)/h+4)+360)%6*60/360;m=(m+e)/2;return{h:c,s:0==h?0:0.5>m?h/(2*m):h/(2-2*
m),l:m,toString:ra}};a.parsePathString=function(c){if(!c)return null;var b=a.path(c);if(b.arr)return a.path.clone(b.arr);var m={a:7,c:6,o:2,h:1,l:2,m:2,r:4,q:4,s:4,t:2,v:1,u:3,z:0},e=[];y(c,"array")&&y(c[0],"array")&&(e=a.path.clone(c));e.length||J(c).replace(W,function(c,a,b){var h=[];c=a.toLowerCase();b.replace(Z,function(c,a){a&&h.push(+a)});"m"==c&&2<h.length&&(e.push([a].concat(h.splice(0,2))),c="l",a="m"==a?"l":"L");"o"==c&&1==h.length&&e.push([a,h[0] ]);if("r"==c)e.push([a].concat(h));else for(;h.length>=
m[c]&&(e.push([a].concat(h.splice(0,m[c]))),m[c]););});e.toString=a.path.toString;b.arr=a.path.clone(e);return e};var O=a.parseTransformString=function(c){if(!c)return null;var b=[];y(c,"array")&&y(c[0],"array")&&(b=a.path.clone(c));b.length||J(c).replace(ma,function(c,a,m){var e=[];a.toLowerCase();m.replace(Z,function(c,a){a&&e.push(+a)});b.push([a].concat(e))});b.toString=a.path.toString;return b};a._.svgTransform2string=d;a._.rgTransform=RegExp("^[a-z][\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*-?\\.?\\d",
"i");a._.transform2matrix=f;a._unit2px=b;a._.getSomeDefs=u;a._.getSomeSVG=p;a.select=function(c){return x(G.doc.querySelector(c))};a.selectAll=function(c){c=G.doc.querySelectorAll(c);for(var b=(a.set||Array)(),m=0;m<c.length;m++)b.push(x(c[m]));return b};setInterval(function(){for(var c in E)if(E[h](c)){var a=E[c],b=a.node;("svg"!=a.type&&!b.ownerSVGElement||"svg"==a.type&&(!b.parentNode||"ownerSVGElement"in b.parentNode&&!b.ownerSVGElement))&&delete E[c]}},1E4);(function(c){function m(c){function a(c,
b){var m=v(c.node,b);(m=(m=m&&m.match(d))&&m[2])&&"#"==m.charAt()&&(m=m.substring(1))&&(f[m]=(f[m]||[]).concat(function(a){var m={};m[b]=ca(a);v(c.node,m)}))}function b(c){var a=v(c.node,"xlink:href");a&&"#"==a.charAt()&&(a=a.substring(1))&&(f[a]=(f[a]||[]).concat(function(a){c.attr("xlink:href","#"+a)}))}var e=c.selectAll("*"),h,d=/^\s*url\(("|'|)(.*)\1\)\s*$/;c=[];for(var f={},l=0,E=e.length;l<E;l++){h=e[l];a(h,"fill");a(h,"stroke");a(h,"filter");a(h,"mask");a(h,"clip-path");b(h);var t=v(h.node,
"id");t&&(v(h.node,{id:h.id}),c.push({old:t,id:h.id}))}l=0;for(E=c.length;l<E;l++)if(e=f[c[l].old])for(h=0,t=e.length;h<t;h++)e[h](c[l].id)}function e(c,a,b){return function(m){m=m.slice(c,a);1==m.length&&(m=m[0]);return b?b(m):m}}function d(c){return function(){var a=c?"<"+this.type:"",b=this.node.attributes,m=this.node.childNodes;if(c)for(var e=0,h=b.length;e<h;e++)a+=" "+b[e].name+'="'+b[e].value.replace(/"/g,'\\"')+'"';if(m.length){c&&(a+=">");e=0;for(h=m.length;e<h;e++)3==m[e].nodeType?a+=m[e].nodeValue:
1==m[e].nodeType&&(a+=x(m[e]).toString());c&&(a+="</"+this.type+">")}else c&&(a+="/>");return a}}c.attr=function(c,a){if(!c)return this;if(y(c,"string"))if(1<arguments.length){var b={};b[c]=a;c=b}else return k("snap.util.getattr."+c,this).firstDefined();for(var m in c)c[h](m)&&k("snap.util.attr."+m,this,c[m]);return this};c.getBBox=function(c){if(!a.Matrix||!a.path)return this.node.getBBox();var b=this,m=new a.Matrix;if(b.removed)return a._.box();for(;"use"==b.type;)if(c||(m=m.add(b.transform().localMatrix.translate(b.attr("x")||
0,b.attr("y")||0))),b.original)b=b.original;else var e=b.attr("xlink:href"),b=b.original=b.node.ownerDocument.getElementById(e.substring(e.indexOf("#")+1));var e=b._,h=a.path.get[b.type]||a.path.get.deflt;try{if(c)return e.bboxwt=h?a.path.getBBox(b.realPath=h(b)):a._.box(b.node.getBBox()),a._.box(e.bboxwt);b.realPath=h(b);b.matrix=b.transform().localMatrix;e.bbox=a.path.getBBox(a.path.map(b.realPath,m.add(b.matrix)));return a._.box(e.bbox)}catch(d){return a._.box()}};var f=function(){return this.string};
c.transform=function(c){var b=this._;if(null==c){var m=this;c=new a.Matrix(this.node.getCTM());for(var e=n(this),h=[e],d=new a.Matrix,l=e.toTransformString(),b=J(e)==J(this.matrix)?J(b.transform):l;"svg"!=m.type&&(m=m.parent());)h.push(n(m));for(m=h.length;m--;)d.add(h[m]);return{string:b,globalMatrix:c,totalMatrix:d,localMatrix:e,diffMatrix:c.clone().add(e.invert()),global:c.toTransformString(),total:d.toTransformString(),local:l,toString:f}}c instanceof a.Matrix?this.matrix=c:n(this,c);this.node&&
("linearGradient"==this.type||"radialGradient"==this.type?v(this.node,{gradientTransform:this.matrix}):"pattern"==this.type?v(this.node,{patternTransform:this.matrix}):v(this.node,{transform:this.matrix}));return this};c.parent=function(){return x(this.node.parentNode)};c.append=c.add=function(c){if(c){if("set"==c.type){var a=this;c.forEach(function(c){a.add(c)});return this}c=x(c);this.node.appendChild(c.node);c.paper=this.paper}return this};c.appendTo=function(c){c&&(c=x(c),c.append(this));return this};
c.prepend=function(c){if(c){if("set"==c.type){var a=this,b;c.forEach(function(c){b?b.after(c):a.prepend(c);b=c});return this}c=x(c);var m=c.parent();this.node.insertBefore(c.node,this.node.firstChild);this.add&&this.add();c.paper=this.paper;this.parent()&&this.parent().add();m&&m.add()}return this};c.prependTo=function(c){c=x(c);c.prepend(this);return this};c.before=function(c){if("set"==c.type){var a=this;c.forEach(function(c){var b=c.parent();a.node.parentNode.insertBefore(c.node,a.node);b&&b.add()});
this.parent().add();return this}c=x(c);var b=c.parent();this.node.parentNode.insertBefore(c.node,this.node);this.parent()&&this.parent().add();b&&b.add();c.paper=this.paper;return this};c.after=function(c){c=x(c);var a=c.parent();this.node.nextSibling?this.node.parentNode.insertBefore(c.node,this.node.nextSibling):this.node.parentNode.appendChild(c.node);this.parent()&&this.parent().add();a&&a.add();c.paper=this.paper;return this};c.insertBefore=function(c){c=x(c);var a=this.parent();c.node.parentNode.insertBefore(this.node,
c.node);this.paper=c.paper;a&&a.add();c.parent()&&c.parent().add();return this};c.insertAfter=function(c){c=x(c);var a=this.parent();c.node.parentNode.insertBefore(this.node,c.node.nextSibling);this.paper=c.paper;a&&a.add();c.parent()&&c.parent().add();return this};c.remove=function(){var c=this.parent();this.node.parentNode&&this.node.parentNode.removeChild(this.node);delete this.paper;this.removed=!0;c&&c.add();return this};c.select=function(c){return x(this.node.querySelector(c))};c.selectAll=
function(c){c=this.node.querySelectorAll(c);for(var b=(a.set||Array)(),m=0;m<c.length;m++)b.push(x(c[m]));return b};c.asPX=function(c,a){null==a&&(a=this.attr(c));return+b(this,c,a)};c.use=function(){var c,a=this.node.id;a||(a=this.id,v(this.node,{id:a}));c="linearGradient"==this.type||"radialGradient"==this.type||"pattern"==this.type?r(this.type,this.node.parentNode):r("use",this.node.parentNode);v(c.node,{"xlink:href":"#"+a});c.original=this;return c};var l=/\S+/g;c.addClass=function(c){var a=(c||
"").match(l)||[];c=this.node;var b=c.className.baseVal,m=b.match(l)||[],e,h,d;if(a.length){for(e=0;d=a[e++];)h=m.indexOf(d),~h||m.push(d);a=m.join(" ");b!=a&&(c.className.baseVal=a)}return this};c.removeClass=function(c){var a=(c||"").match(l)||[];c=this.node;var b=c.className.baseVal,m=b.match(l)||[],e,h;if(m.length){for(e=0;h=a[e++];)h=m.indexOf(h),~h&&m.splice(h,1);a=m.join(" ");b!=a&&(c.className.baseVal=a)}return this};c.hasClass=function(c){return!!~(this.node.className.baseVal.match(l)||[]).indexOf(c)};
c.toggleClass=function(c,a){if(null!=a)return a?this.addClass(c):this.removeClass(c);var b=(c||"").match(l)||[],m=this.node,e=m.className.baseVal,h=e.match(l)||[],d,f,E;for(d=0;E=b[d++];)f=h.indexOf(E),~f?h.splice(f,1):h.push(E);b=h.join(" ");e!=b&&(m.className.baseVal=b);return this};c.clone=function(){var c=x(this.node.cloneNode(!0));v(c.node,"id")&&v(c.node,{id:c.id});m(c);c.insertAfter(this);return c};c.toDefs=function(){u(this).appendChild(this.node);return this};c.pattern=c.toPattern=function(c,
a,b,m){var e=r("pattern",u(this));null==c&&(c=this.getBBox());y(c,"object")&&"x"in c&&(a=c.y,b=c.width,m=c.height,c=c.x);v(e.node,{x:c,y:a,width:b,height:m,patternUnits:"userSpaceOnUse",id:e.id,viewBox:[c,a,b,m].join(" ")});e.node.appendChild(this.node);return e};c.marker=function(c,a,b,m,e,h){var d=r("marker",u(this));null==c&&(c=this.getBBox());y(c,"object")&&"x"in c&&(a=c.y,b=c.width,m=c.height,e=c.refX||c.cx,h=c.refY||c.cy,c=c.x);v(d.node,{viewBox:[c,a,b,m].join(" "),markerWidth:b,markerHeight:m,
orient:"auto",refX:e||0,refY:h||0,id:d.id});d.node.appendChild(this.node);return d};var E=function(c,a,b,m){"function"!=typeof b||b.length||(m=b,b=L.linear);this.attr=c;this.dur=a;b&&(this.easing=b);m&&(this.callback=m)};a._.Animation=E;a.animation=function(c,a,b,m){return new E(c,a,b,m)};c.inAnim=function(){var c=[],a;for(a in this.anims)this.anims[h](a)&&function(a){c.push({anim:new E(a._attrs,a.dur,a.easing,a._callback),mina:a,curStatus:a.status(),status:function(c){return a.status(c)},stop:function(){a.stop()}})}(this.anims[a]);
return c};a.animate=function(c,a,b,m,e,h){"function"!=typeof e||e.length||(h=e,e=L.linear);var d=L.time();c=L(c,a,d,d+m,L.time,b,e);h&&k.once("mina.finish."+c.id,h);return c};c.stop=function(){for(var c=this.inAnim(),a=0,b=c.length;a<b;a++)c[a].stop();return this};c.animate=function(c,a,b,m){"function"!=typeof b||b.length||(m=b,b=L.linear);c instanceof E&&(m=c.callback,b=c.easing,a=b.dur,c=c.attr);var d=[],f=[],l={},t,ca,n,T=this,q;for(q in c)if(c[h](q)){T.equal?(n=T.equal(q,J(c[q])),t=n.from,ca=
n.to,n=n.f):(t=+T.attr(q),ca=+c[q]);var la=y(t,"array")?t.length:1;l[q]=e(d.length,d.length+la,n);d=d.concat(t);f=f.concat(ca)}t=L.time();var p=L(d,f,t,t+a,L.time,function(c){var a={},b;for(b in l)l[h](b)&&(a[b]=l[b](c));T.attr(a)},b);T.anims[p.id]=p;p._attrs=c;p._callback=m;k("snap.animcreated."+T.id,p);k.once("mina.finish."+p.id,function(){delete T.anims[p.id];m&&m.call(T)});k.once("mina.stop."+p.id,function(){delete T.anims[p.id]});return T};var T={};c.data=function(c,b){var m=T[this.id]=T[this.id]||
{};if(0==arguments.length)return k("snap.data.get."+this.id,this,m,null),m;if(1==arguments.length){if(a.is(c,"object")){for(var e in c)c[h](e)&&this.data(e,c[e]);return this}k("snap.data.get."+this.id,this,m[c],c);return m[c]}m[c]=b;k("snap.data.set."+this.id,this,b,c);return this};c.removeData=function(c){null==c?T[this.id]={}:T[this.id]&&delete T[this.id][c];return this};c.outerSVG=c.toString=d(1);c.innerSVG=d()})(e.prototype);a.parse=function(c){var a=G.doc.createDocumentFragment(),b=!0,m=G.doc.createElement("div");
c=J(c);c.match(/^\s*<\s*svg(?:\s|>)/)||(c="<svg>"+c+"</svg>",b=!1);m.innerHTML=c;if(c=m.getElementsByTagName("svg")[0])if(b)a=c;else for(;c.firstChild;)a.appendChild(c.firstChild);m.innerHTML=aa;return new l(a)};l.prototype.select=e.prototype.select;l.prototype.selectAll=e.prototype.selectAll;a.fragment=function(){for(var c=Array.prototype.slice.call(arguments,0),b=G.doc.createDocumentFragment(),m=0,e=c.length;m<e;m++){var h=c[m];h.node&&h.node.nodeType&&b.appendChild(h.node);h.nodeType&&b.appendChild(h);
"string"==typeof h&&b.appendChild(a.parse(h).node)}return new l(b)};a._.make=r;a._.wrap=x;s.prototype.el=function(c,a){var b=r(c,this.node);a&&b.attr(a);return b};k.on("snap.util.getattr",function(){var c=k.nt(),c=c.substring(c.lastIndexOf(".")+1),a=c.replace(/[A-Z]/g,function(c){return"-"+c.toLowerCase()});return pa[h](a)?this.node.ownerDocument.defaultView.getComputedStyle(this.node,null).getPropertyValue(a):v(this.node,c)});var pa={"alignment-baseline":0,"baseline-shift":0,clip:0,"clip-path":0,
"clip-rule":0,color:0,"color-interpolation":0,"color-interpolation-filters":0,"color-profile":0,"color-rendering":0,cursor:0,direction:0,display:0,"dominant-baseline":0,"enable-background":0,fill:0,"fill-opacity":0,"fill-rule":0,filter:0,"flood-color":0,"flood-opacity":0,font:0,"font-family":0,"font-size":0,"font-size-adjust":0,"font-stretch":0,"font-style":0,"font-variant":0,"font-weight":0,"glyph-orientation-horizontal":0,"glyph-orientation-vertical":0,"image-rendering":0,kerning:0,"letter-spacing":0,
"lighting-color":0,marker:0,"marker-end":0,"marker-mid":0,"marker-start":0,mask:0,opacity:0,overflow:0,"pointer-events":0,"shape-rendering":0,"stop-color":0,"stop-opacity":0,stroke:0,"stroke-dasharray":0,"stroke-dashoffset":0,"stroke-linecap":0,"stroke-linejoin":0,"stroke-miterlimit":0,"stroke-opacity":0,"stroke-width":0,"text-anchor":0,"text-decoration":0,"text-rendering":0,"unicode-bidi":0,visibility:0,"word-spacing":0,"writing-mode":0};k.on("snap.util.attr",function(c){var a=k.nt(),b={},a=a.substring(a.lastIndexOf(".")+
1);b[a]=c;var m=a.replace(/-(\w)/gi,function(c,a){return a.toUpperCase()}),a=a.replace(/[A-Z]/g,function(c){return"-"+c.toLowerCase()});pa[h](a)?this.node.style[m]=null==c?aa:c:v(this.node,b)});a.ajax=function(c,a,b,m){var e=new XMLHttpRequest,h=V();if(e){if(y(a,"function"))m=b,b=a,a=null;else if(y(a,"object")){var d=[],f;for(f in a)a.hasOwnProperty(f)&&d.push(encodeURIComponent(f)+"="+encodeURIComponent(a[f]));a=d.join("&")}e.open(a?"POST":"GET",c,!0);a&&(e.setRequestHeader("X-Requested-With","XMLHttpRequest"),
e.setRequestHeader("Content-type","application/x-www-form-urlencoded"));b&&(k.once("snap.ajax."+h+".0",b),k.once("snap.ajax."+h+".200",b),k.once("snap.ajax."+h+".304",b));e.onreadystatechange=function(){4==e.readyState&&k("snap.ajax."+h+"."+e.status,m,e)};if(4==e.readyState)return e;e.send(a);return e}};a.load=function(c,b,m){a.ajax(c,function(c){c=a.parse(c.responseText);m?b.call(m,c):b(c)})};a.getElementByPoint=function(c,a){var b,m,e=G.doc.elementFromPoint(c,a);if(G.win.opera&&"svg"==e.tagName){b=
e;m=b.getBoundingClientRect();b=b.ownerDocument;var h=b.body,d=b.documentElement;b=m.top+(g.win.pageYOffset||d.scrollTop||h.scrollTop)-(d.clientTop||h.clientTop||0);m=m.left+(g.win.pageXOffset||d.scrollLeft||h.scrollLeft)-(d.clientLeft||h.clientLeft||0);h=e.createSVGRect();h.x=c-m;h.y=a-b;h.width=h.height=1;b=e.getIntersectionList(h,null);b.length&&(e=b[b.length-1])}return e?x(e):null};a.plugin=function(c){c(a,e,s,G,l)};return G.win.Snap=a}();C.plugin(function(a,k,y,M,A){function w(a,d,f,b,q,e){null==
d&&"[object SVGMatrix]"==z.call(a)?(this.a=a.a,this.b=a.b,this.c=a.c,this.d=a.d,this.e=a.e,this.f=a.f):null!=a?(this.a=+a,this.b=+d,this.c=+f,this.d=+b,this.e=+q,this.f=+e):(this.a=1,this.c=this.b=0,this.d=1,this.f=this.e=0)}var z=Object.prototype.toString,d=String,f=Math;(function(n){function k(a){return a[0]*a[0]+a[1]*a[1]}function p(a){var d=f.sqrt(k(a));a[0]&&(a[0]/=d);a[1]&&(a[1]/=d)}n.add=function(a,d,e,f,n,p){var k=[[],[],[] ],u=[[this.a,this.c,this.e],[this.b,this.d,this.f],[0,0,1] ];d=[[a,
e,n],[d,f,p],[0,0,1] ];a&&a instanceof w&&(d=[[a.a,a.c,a.e],[a.b,a.d,a.f],[0,0,1] ]);for(a=0;3>a;a++)for(e=0;3>e;e++){for(f=n=0;3>f;f++)n+=u[a][f]*d[f][e];k[a][e]=n}this.a=k[0][0];this.b=k[1][0];this.c=k[0][1];this.d=k[1][1];this.e=k[0][2];this.f=k[1][2];return this};n.invert=function(){var a=this.a*this.d-this.b*this.c;return new w(this.d/a,-this.b/a,-this.c/a,this.a/a,(this.c*this.f-this.d*this.e)/a,(this.b*this.e-this.a*this.f)/a)};n.clone=function(){return new w(this.a,this.b,this.c,this.d,this.e,
this.f)};n.translate=function(a,d){return this.add(1,0,0,1,a,d)};n.scale=function(a,d,e,f){null==d&&(d=a);(e||f)&&this.add(1,0,0,1,e,f);this.add(a,0,0,d,0,0);(e||f)&&this.add(1,0,0,1,-e,-f);return this};n.rotate=function(b,d,e){b=a.rad(b);d=d||0;e=e||0;var l=+f.cos(b).toFixed(9);b=+f.sin(b).toFixed(9);this.add(l,b,-b,l,d,e);return this.add(1,0,0,1,-d,-e)};n.x=function(a,d){return a*this.a+d*this.c+this.e};n.y=function(a,d){return a*this.b+d*this.d+this.f};n.get=function(a){return+this[d.fromCharCode(97+
a)].toFixed(4)};n.toString=function(){return"matrix("+[this.get(0),this.get(1),this.get(2),this.get(3),this.get(4),this.get(5)].join()+")"};n.offset=function(){return[this.e.toFixed(4),this.f.toFixed(4)]};n.determinant=function(){return this.a*this.d-this.b*this.c};n.split=function(){var b={};b.dx=this.e;b.dy=this.f;var d=[[this.a,this.c],[this.b,this.d] ];b.scalex=f.sqrt(k(d[0]));p(d[0]);b.shear=d[0][0]*d[1][0]+d[0][1]*d[1][1];d[1]=[d[1][0]-d[0][0]*b.shear,d[1][1]-d[0][1]*b.shear];b.scaley=f.sqrt(k(d[1]));
p(d[1]);b.shear/=b.scaley;0>this.determinant()&&(b.scalex=-b.scalex);var e=-d[0][1],d=d[1][1];0>d?(b.rotate=a.deg(f.acos(d)),0>e&&(b.rotate=360-b.rotate)):b.rotate=a.deg(f.asin(e));b.isSimple=!+b.shear.toFixed(9)&&(b.scalex.toFixed(9)==b.scaley.toFixed(9)||!b.rotate);b.isSuperSimple=!+b.shear.toFixed(9)&&b.scalex.toFixed(9)==b.scaley.toFixed(9)&&!b.rotate;b.noRotation=!+b.shear.toFixed(9)&&!b.rotate;return b};n.toTransformString=function(a){a=a||this.split();if(+a.shear.toFixed(9))return"m"+[this.get(0),
this.get(1),this.get(2),this.get(3),this.get(4),this.get(5)];a.scalex=+a.scalex.toFixed(4);a.scaley=+a.scaley.toFixed(4);a.rotate=+a.rotate.toFixed(4);return(a.dx||a.dy?"t"+[+a.dx.toFixed(4),+a.dy.toFixed(4)]:"")+(1!=a.scalex||1!=a.scaley?"s"+[a.scalex,a.scaley,0,0]:"")+(a.rotate?"r"+[+a.rotate.toFixed(4),0,0]:"")}})(w.prototype);a.Matrix=w;a.matrix=function(a,d,f,b,k,e){return new w(a,d,f,b,k,e)}});C.plugin(function(a,v,y,M,A){function w(h){return function(d){k.stop();d instanceof A&&1==d.node.childNodes.length&&
("radialGradient"==d.node.firstChild.tagName||"linearGradient"==d.node.firstChild.tagName||"pattern"==d.node.firstChild.tagName)&&(d=d.node.firstChild,b(this).appendChild(d),d=u(d));if(d instanceof v)if("radialGradient"==d.type||"linearGradient"==d.type||"pattern"==d.type){d.node.id||e(d.node,{id:d.id});var f=l(d.node.id)}else f=d.attr(h);else f=a.color(d),f.error?(f=a(b(this).ownerSVGElement).gradient(d))?(f.node.id||e(f.node,{id:f.id}),f=l(f.node.id)):f=d:f=r(f);d={};d[h]=f;e(this.node,d);this.node.style[h]=
x}}function z(a){k.stop();a==+a&&(a+="px");this.node.style.fontSize=a}function d(a){var b=[];a=a.childNodes;for(var e=0,f=a.length;e<f;e++){var l=a[e];3==l.nodeType&&b.push(l.nodeValue);"tspan"==l.tagName&&(1==l.childNodes.length&&3==l.firstChild.nodeType?b.push(l.firstChild.nodeValue):b.push(d(l)))}return b}function f(){k.stop();return this.node.style.fontSize}var n=a._.make,u=a._.wrap,p=a.is,b=a._.getSomeDefs,q=/^url\(#?([^)]+)\)$/,e=a._.$,l=a.url,r=String,s=a._.separator,x="";k.on("snap.util.attr.mask",
function(a){if(a instanceof v||a instanceof A){k.stop();a instanceof A&&1==a.node.childNodes.length&&(a=a.node.firstChild,b(this).appendChild(a),a=u(a));if("mask"==a.type)var d=a;else d=n("mask",b(this)),d.node.appendChild(a.node);!d.node.id&&e(d.node,{id:d.id});e(this.node,{mask:l(d.id)})}});(function(a){k.on("snap.util.attr.clip",a);k.on("snap.util.attr.clip-path",a);k.on("snap.util.attr.clipPath",a)})(function(a){if(a instanceof v||a instanceof A){k.stop();if("clipPath"==a.type)var d=a;else d=
n("clipPath",b(this)),d.node.appendChild(a.node),!d.node.id&&e(d.node,{id:d.id});e(this.node,{"clip-path":l(d.id)})}});k.on("snap.util.attr.fill",w("fill"));k.on("snap.util.attr.stroke",w("stroke"));var G=/^([lr])(?:\(([^)]*)\))?(.*)$/i;k.on("snap.util.grad.parse",function(a){a=r(a);var b=a.match(G);if(!b)return null;a=b[1];var e=b[2],b=b[3],e=e.split(/\s*,\s*/).map(function(a){return+a==a?+a:a});1==e.length&&0==e[0]&&(e=[]);b=b.split("-");b=b.map(function(a){a=a.split(":");var b={color:a[0]};a[1]&&
(b.offset=parseFloat(a[1]));return b});return{type:a,params:e,stops:b}});k.on("snap.util.attr.d",function(b){k.stop();p(b,"array")&&p(b[0],"array")&&(b=a.path.toString.call(b));b=r(b);b.match(/[ruo]/i)&&(b=a.path.toAbsolute(b));e(this.node,{d:b})})(-1);k.on("snap.util.attr.#text",function(a){k.stop();a=r(a);for(a=M.doc.createTextNode(a);this.node.firstChild;)this.node.removeChild(this.node.firstChild);this.node.appendChild(a)})(-1);k.on("snap.util.attr.path",function(a){k.stop();this.attr({d:a})})(-1);
k.on("snap.util.attr.class",function(a){k.stop();this.node.className.baseVal=a})(-1);k.on("snap.util.attr.viewBox",function(a){a=p(a,"object")&&"x"in a?[a.x,a.y,a.width,a.height].join(" "):p(a,"array")?a.join(" "):a;e(this.node,{viewBox:a});k.stop()})(-1);k.on("snap.util.attr.transform",function(a){this.transform(a);k.stop()})(-1);k.on("snap.util.attr.r",function(a){"rect"==this.type&&(k.stop(),e(this.node,{rx:a,ry:a}))})(-1);k.on("snap.util.attr.textpath",function(a){k.stop();if("text"==this.type){var d,
f;if(!a&&this.textPath){for(a=this.textPath;a.node.firstChild;)this.node.appendChild(a.node.firstChild);a.remove();delete this.textPath}else if(p(a,"string")?(d=b(this),a=u(d.parentNode).path(a),d.appendChild(a.node),d=a.id,a.attr({id:d})):(a=u(a),a instanceof v&&(d=a.attr("id"),d||(d=a.id,a.attr({id:d})))),d)if(a=this.textPath,f=this.node,a)a.attr({"xlink:href":"#"+d});else{for(a=e("textPath",{"xlink:href":"#"+d});f.firstChild;)a.appendChild(f.firstChild);f.appendChild(a);this.textPath=u(a)}}})(-1);
k.on("snap.util.attr.text",function(a){if("text"==this.type){for(var b=this.node,d=function(a){var b=e("tspan");if(p(a,"array"))for(var f=0;f<a.length;f++)b.appendChild(d(a[f]));else b.appendChild(M.doc.createTextNode(a));b.normalize&&b.normalize();return b};b.firstChild;)b.removeChild(b.firstChild);for(a=d(a);a.firstChild;)b.appendChild(a.firstChild)}k.stop()})(-1);k.on("snap.util.attr.fontSize",z)(-1);k.on("snap.util.attr.font-size",z)(-1);k.on("snap.util.getattr.transform",function(){k.stop();
return this.transform()})(-1);k.on("snap.util.getattr.textpath",function(){k.stop();return this.textPath})(-1);(function(){function b(d){return function(){k.stop();var b=M.doc.defaultView.getComputedStyle(this.node,null).getPropertyValue("marker-"+d);return"none"==b?b:a(M.doc.getElementById(b.match(q)[1]))}}function d(a){return function(b){k.stop();var d="marker"+a.charAt(0).toUpperCase()+a.substring(1);if(""==b||!b)this.node.style[d]="none";else if("marker"==b.type){var f=b.node.id;f||e(b.node,{id:b.id});
this.node.style[d]=l(f)}}}k.on("snap.util.getattr.marker-end",b("end"))(-1);k.on("snap.util.getattr.markerEnd",b("end"))(-1);k.on("snap.util.getattr.marker-start",b("start"))(-1);k.on("snap.util.getattr.markerStart",b("start"))(-1);k.on("snap.util.getattr.marker-mid",b("mid"))(-1);k.on("snap.util.getattr.markerMid",b("mid"))(-1);k.on("snap.util.attr.marker-end",d("end"))(-1);k.on("snap.util.attr.markerEnd",d("end"))(-1);k.on("snap.util.attr.marker-start",d("start"))(-1);k.on("snap.util.attr.markerStart",
d("start"))(-1);k.on("snap.util.attr.marker-mid",d("mid"))(-1);k.on("snap.util.attr.markerMid",d("mid"))(-1)})();k.on("snap.util.getattr.r",function(){if("rect"==this.type&&e(this.node,"rx")==e(this.node,"ry"))return k.stop(),e(this.node,"rx")})(-1);k.on("snap.util.getattr.text",function(){if("text"==this.type||"tspan"==this.type){k.stop();var a=d(this.node);return 1==a.length?a[0]:a}})(-1);k.on("snap.util.getattr.#text",function(){return this.node.textContent})(-1);k.on("snap.util.getattr.viewBox",
function(){k.stop();var b=e(this.node,"viewBox");if(b)return b=b.split(s),a._.box(+b[0],+b[1],+b[2],+b[3])})(-1);k.on("snap.util.getattr.points",function(){var a=e(this.node,"points");k.stop();if(a)return a.split(s)})(-1);k.on("snap.util.getattr.path",function(){var a=e(this.node,"d");k.stop();return a})(-1);k.on("snap.util.getattr.class",function(){return this.node.className.baseVal})(-1);k.on("snap.util.getattr.fontSize",f)(-1);k.on("snap.util.getattr.font-size",f)(-1)});C.plugin(function(a,v,y,
M,A){function w(a){return a}function z(a){return function(b){return+b.toFixed(3)+a}}var d={"+":function(a,b){return a+b},"-":function(a,b){return a-b},"/":function(a,b){return a/b},"*":function(a,b){return a*b}},f=String,n=/[a-z]+$/i,u=/^\s*([+\-\/*])\s*=\s*([\d.eE+\-]+)\s*([^\d\s]+)?\s*$/;k.on("snap.util.attr",function(a){if(a=f(a).match(u)){var b=k.nt(),b=b.substring(b.lastIndexOf(".")+1),q=this.attr(b),e={};k.stop();var l=a[3]||"",r=q.match(n),s=d[a[1] ];r&&r==l?a=s(parseFloat(q),+a[2]):(q=this.asPX(b),
a=s(this.asPX(b),this.asPX(b,a[2]+l)));isNaN(q)||isNaN(a)||(e[b]=a,this.attr(e))}})(-10);k.on("snap.util.equal",function(a,b){var q=f(this.attr(a)||""),e=f(b).match(u);if(e){k.stop();var l=e[3]||"",r=q.match(n),s=d[e[1] ];if(r&&r==l)return{from:parseFloat(q),to:s(parseFloat(q),+e[2]),f:z(r)};q=this.asPX(a);return{from:q,to:s(q,this.asPX(a,e[2]+l)),f:w}}})(-10)});C.plugin(function(a,v,y,M,A){var w=y.prototype,z=a.is;w.rect=function(a,d,k,p,b,q){var e;null==q&&(q=b);z(a,"object")&&"[object Object]"==
a?e=a:null!=a&&(e={x:a,y:d,width:k,height:p},null!=b&&(e.rx=b,e.ry=q));return this.el("rect",e)};w.circle=function(a,d,k){var p;z(a,"object")&&"[object Object]"==a?p=a:null!=a&&(p={cx:a,cy:d,r:k});return this.el("circle",p)};var d=function(){function a(){this.parentNode.removeChild(this)}return function(d,k){var p=M.doc.createElement("img"),b=M.doc.body;p.style.cssText="position:absolute;left:-9999em;top:-9999em";p.onload=function(){k.call(p);p.onload=p.onerror=null;b.removeChild(p)};p.onerror=a;
b.appendChild(p);p.src=d}}();w.image=function(f,n,k,p,b){var q=this.el("image");if(z(f,"object")&&"src"in f)q.attr(f);else if(null!=f){var e={"xlink:href":f,preserveAspectRatio:"none"};null!=n&&null!=k&&(e.x=n,e.y=k);null!=p&&null!=b?(e.width=p,e.height=b):d(f,function(){a._.$(q.node,{width:this.offsetWidth,height:this.offsetHeight})});a._.$(q.node,e)}return q};w.ellipse=function(a,d,k,p){var b;z(a,"object")&&"[object Object]"==a?b=a:null!=a&&(b={cx:a,cy:d,rx:k,ry:p});return this.el("ellipse",b)};
w.path=function(a){var d;z(a,"object")&&!z(a,"array")?d=a:a&&(d={d:a});return this.el("path",d)};w.group=w.g=function(a){var d=this.el("g");1==arguments.length&&a&&!a.type?d.attr(a):arguments.length&&d.add(Array.prototype.slice.call(arguments,0));return d};w.svg=function(a,d,k,p,b,q,e,l){var r={};z(a,"object")&&null==d?r=a:(null!=a&&(r.x=a),null!=d&&(r.y=d),null!=k&&(r.width=k),null!=p&&(r.height=p),null!=b&&null!=q&&null!=e&&null!=l&&(r.viewBox=[b,q,e,l]));return this.el("svg",r)};w.mask=function(a){var d=
this.el("mask");1==arguments.length&&a&&!a.type?d.attr(a):arguments.length&&d.add(Array.prototype.slice.call(arguments,0));return d};w.ptrn=function(a,d,k,p,b,q,e,l){if(z(a,"object"))var r=a;else arguments.length?(r={},null!=a&&(r.x=a),null!=d&&(r.y=d),null!=k&&(r.width=k),null!=p&&(r.height=p),null!=b&&null!=q&&null!=e&&null!=l&&(r.viewBox=[b,q,e,l])):r={patternUnits:"userSpaceOnUse"};return this.el("pattern",r)};w.use=function(a){return null!=a?(make("use",this.node),a instanceof v&&(a.attr("id")||
a.attr({id:ID()}),a=a.attr("id")),this.el("use",{"xlink:href":a})):v.prototype.use.call(this)};w.text=function(a,d,k){var p={};z(a,"object")?p=a:null!=a&&(p={x:a,y:d,text:k||""});return this.el("text",p)};w.line=function(a,d,k,p){var b={};z(a,"object")?b=a:null!=a&&(b={x1:a,x2:k,y1:d,y2:p});return this.el("line",b)};w.polyline=function(a){1<arguments.length&&(a=Array.prototype.slice.call(arguments,0));var d={};z(a,"object")&&!z(a,"array")?d=a:null!=a&&(d={points:a});return this.el("polyline",d)};
w.polygon=function(a){1<arguments.length&&(a=Array.prototype.slice.call(arguments,0));var d={};z(a,"object")&&!z(a,"array")?d=a:null!=a&&(d={points:a});return this.el("polygon",d)};(function(){function d(){return this.selectAll("stop")}function n(b,d){var f=e("stop"),k={offset:+d+"%"};b=a.color(b);k["stop-color"]=b.hex;1>b.opacity&&(k["stop-opacity"]=b.opacity);e(f,k);this.node.appendChild(f);return this}function u(){if("linearGradient"==this.type){var b=e(this.node,"x1")||0,d=e(this.node,"x2")||
1,f=e(this.node,"y1")||0,k=e(this.node,"y2")||0;return a._.box(b,f,math.abs(d-b),math.abs(k-f))}b=this.node.r||0;return a._.box((this.node.cx||0.5)-b,(this.node.cy||0.5)-b,2*b,2*b)}function p(a,d){function f(a,b){for(var d=(b-u)/(a-w),e=w;e<a;e++)h[e].offset=+(+u+d*(e-w)).toFixed(2);w=a;u=b}var n=k("snap.util.grad.parse",null,d).firstDefined(),p;if(!n)return null;n.params.unshift(a);p="l"==n.type.toLowerCase()?b.apply(0,n.params):q.apply(0,n.params);n.type!=n.type.toLowerCase()&&e(p.node,{gradientUnits:"userSpaceOnUse"});
var h=n.stops,n=h.length,u=0,w=0;n--;for(var v=0;v<n;v++)"offset"in h[v]&&f(v,h[v].offset);h[n].offset=h[n].offset||100;f(n,h[n].offset);for(v=0;v<=n;v++){var y=h[v];p.addStop(y.color,y.offset)}return p}function b(b,k,p,q,w){b=a._.make("linearGradient",b);b.stops=d;b.addStop=n;b.getBBox=u;null!=k&&e(b.node,{x1:k,y1:p,x2:q,y2:w});return b}function q(b,k,p,q,w,h){b=a._.make("radialGradient",b);b.stops=d;b.addStop=n;b.getBBox=u;null!=k&&e(b.node,{cx:k,cy:p,r:q});null!=w&&null!=h&&e(b.node,{fx:w,fy:h});
return b}var e=a._.$;w.gradient=function(a){return p(this.defs,a)};w.gradientLinear=function(a,d,e,f){return b(this.defs,a,d,e,f)};w.gradientRadial=function(a,b,d,e,f){return q(this.defs,a,b,d,e,f)};w.toString=function(){var b=this.node.ownerDocument,d=b.createDocumentFragment(),b=b.createElement("div"),e=this.node.cloneNode(!0);d.appendChild(b);b.appendChild(e);a._.$(e,{xmlns:"http://www.w3.org/2000/svg"});b=b.innerHTML;d.removeChild(d.firstChild);return b};w.clear=function(){for(var a=this.node.firstChild,
b;a;)b=a.nextSibling,"defs"!=a.tagName?a.parentNode.removeChild(a):w.clear.call({node:a}),a=b}})()});C.plugin(function(a,k,y,M){function A(a){var b=A.ps=A.ps||{};b[a]?b[a].sleep=100:b[a]={sleep:100};setTimeout(function(){for(var d in b)b[L](d)&&d!=a&&(b[d].sleep--,!b[d].sleep&&delete b[d])});return b[a]}function w(a,b,d,e){null==a&&(a=b=d=e=0);null==b&&(b=a.y,d=a.width,e=a.height,a=a.x);return{x:a,y:b,width:d,w:d,height:e,h:e,x2:a+d,y2:b+e,cx:a+d/2,cy:b+e/2,r1:F.min(d,e)/2,r2:F.max(d,e)/2,r0:F.sqrt(d*
d+e*e)/2,path:s(a,b,d,e),vb:[a,b,d,e].join(" ")}}function z(){return this.join(",").replace(N,"$1")}function d(a){a=C(a);a.toString=z;return a}function f(a,b,d,h,f,k,l,n,p){if(null==p)return e(a,b,d,h,f,k,l,n);if(0>p||e(a,b,d,h,f,k,l,n)<p)p=void 0;else{var q=0.5,O=1-q,s;for(s=e(a,b,d,h,f,k,l,n,O);0.01<Z(s-p);)q/=2,O+=(s<p?1:-1)*q,s=e(a,b,d,h,f,k,l,n,O);p=O}return u(a,b,d,h,f,k,l,n,p)}function n(b,d){function e(a){return+(+a).toFixed(3)}return a._.cacher(function(a,h,l){a instanceof k&&(a=a.attr("d"));
a=I(a);for(var n,p,D,q,O="",s={},c=0,t=0,r=a.length;t<r;t++){D=a[t];if("M"==D[0])n=+D[1],p=+D[2];else{q=f(n,p,D[1],D[2],D[3],D[4],D[5],D[6]);if(c+q>h){if(d&&!s.start){n=f(n,p,D[1],D[2],D[3],D[4],D[5],D[6],h-c);O+=["C"+e(n.start.x),e(n.start.y),e(n.m.x),e(n.m.y),e(n.x),e(n.y)];if(l)return O;s.start=O;O=["M"+e(n.x),e(n.y)+"C"+e(n.n.x),e(n.n.y),e(n.end.x),e(n.end.y),e(D[5]),e(D[6])].join();c+=q;n=+D[5];p=+D[6];continue}if(!b&&!d)return n=f(n,p,D[1],D[2],D[3],D[4],D[5],D[6],h-c)}c+=q;n=+D[5];p=+D[6]}O+=
D.shift()+D}s.end=O;return n=b?c:d?s:u(n,p,D[0],D[1],D[2],D[3],D[4],D[5],1)},null,a._.clone)}function u(a,b,d,e,h,f,k,l,n){var p=1-n,q=ma(p,3),s=ma(p,2),c=n*n,t=c*n,r=q*a+3*s*n*d+3*p*n*n*h+t*k,q=q*b+3*s*n*e+3*p*n*n*f+t*l,s=a+2*n*(d-a)+c*(h-2*d+a),t=b+2*n*(e-b)+c*(f-2*e+b),x=d+2*n*(h-d)+c*(k-2*h+d),c=e+2*n*(f-e)+c*(l-2*f+e);a=p*a+n*d;b=p*b+n*e;h=p*h+n*k;f=p*f+n*l;l=90-180*F.atan2(s-x,t-c)/S;return{x:r,y:q,m:{x:s,y:t},n:{x:x,y:c},start:{x:a,y:b},end:{x:h,y:f},alpha:l}}function p(b,d,e,h,f,n,k,l){a.is(b,
"array")||(b=[b,d,e,h,f,n,k,l]);b=U.apply(null,b);return w(b.min.x,b.min.y,b.max.x-b.min.x,b.max.y-b.min.y)}function b(a,b,d){return b>=a.x&&b<=a.x+a.width&&d>=a.y&&d<=a.y+a.height}function q(a,d){a=w(a);d=w(d);return b(d,a.x,a.y)||b(d,a.x2,a.y)||b(d,a.x,a.y2)||b(d,a.x2,a.y2)||b(a,d.x,d.y)||b(a,d.x2,d.y)||b(a,d.x,d.y2)||b(a,d.x2,d.y2)||(a.x<d.x2&&a.x>d.x||d.x<a.x2&&d.x>a.x)&&(a.y<d.y2&&a.y>d.y||d.y<a.y2&&d.y>a.y)}function e(a,b,d,e,h,f,n,k,l){null==l&&(l=1);l=(1<l?1:0>l?0:l)/2;for(var p=[-0.1252,
0.1252,-0.3678,0.3678,-0.5873,0.5873,-0.7699,0.7699,-0.9041,0.9041,-0.9816,0.9816],q=[0.2491,0.2491,0.2335,0.2335,0.2032,0.2032,0.1601,0.1601,0.1069,0.1069,0.0472,0.0472],s=0,c=0;12>c;c++)var t=l*p[c]+l,r=t*(t*(-3*a+9*d-9*h+3*n)+6*a-12*d+6*h)-3*a+3*d,t=t*(t*(-3*b+9*e-9*f+3*k)+6*b-12*e+6*f)-3*b+3*e,s=s+q[c]*F.sqrt(r*r+t*t);return l*s}function l(a,b,d){a=I(a);b=I(b);for(var h,f,l,n,k,s,r,O,x,c,t=d?0:[],w=0,v=a.length;w<v;w++)if(x=a[w],"M"==x[0])h=k=x[1],f=s=x[2];else{"C"==x[0]?(x=[h,f].concat(x.slice(1)),
h=x[6],f=x[7]):(x=[h,f,h,f,k,s,k,s],h=k,f=s);for(var G=0,y=b.length;G<y;G++)if(c=b[G],"M"==c[0])l=r=c[1],n=O=c[2];else{"C"==c[0]?(c=[l,n].concat(c.slice(1)),l=c[6],n=c[7]):(c=[l,n,l,n,r,O,r,O],l=r,n=O);var z;var K=x,B=c;z=d;var H=p(K),J=p(B);if(q(H,J)){for(var H=e.apply(0,K),J=e.apply(0,B),H=~~(H/8),J=~~(J/8),U=[],A=[],F={},M=z?0:[],P=0;P<H+1;P++){var C=u.apply(0,K.concat(P/H));U.push({x:C.x,y:C.y,t:P/H})}for(P=0;P<J+1;P++)C=u.apply(0,B.concat(P/J)),A.push({x:C.x,y:C.y,t:P/J});for(P=0;P<H;P++)for(K=
0;K<J;K++){var Q=U[P],L=U[P+1],B=A[K],C=A[K+1],N=0.001>Z(L.x-Q.x)?"y":"x",S=0.001>Z(C.x-B.x)?"y":"x",R;R=Q.x;var Y=Q.y,V=L.x,ea=L.y,fa=B.x,ga=B.y,ha=C.x,ia=C.y;if(W(R,V)<X(fa,ha)||X(R,V)>W(fa,ha)||W(Y,ea)<X(ga,ia)||X(Y,ea)>W(ga,ia))R=void 0;else{var $=(R*ea-Y*V)*(fa-ha)-(R-V)*(fa*ia-ga*ha),aa=(R*ea-Y*V)*(ga-ia)-(Y-ea)*(fa*ia-ga*ha),ja=(R-V)*(ga-ia)-(Y-ea)*(fa-ha);if(ja){var $=$/ja,aa=aa/ja,ja=+$.toFixed(2),ba=+aa.toFixed(2);R=ja<+X(R,V).toFixed(2)||ja>+W(R,V).toFixed(2)||ja<+X(fa,ha).toFixed(2)||
ja>+W(fa,ha).toFixed(2)||ba<+X(Y,ea).toFixed(2)||ba>+W(Y,ea).toFixed(2)||ba<+X(ga,ia).toFixed(2)||ba>+W(ga,ia).toFixed(2)?void 0:{x:$,y:aa}}else R=void 0}R&&F[R.x.toFixed(4)]!=R.y.toFixed(4)&&(F[R.x.toFixed(4)]=R.y.toFixed(4),Q=Q.t+Z((R[N]-Q[N])/(L[N]-Q[N]))*(L.t-Q.t),B=B.t+Z((R[S]-B[S])/(C[S]-B[S]))*(C.t-B.t),0<=Q&&1>=Q&&0<=B&&1>=B&&(z?M++:M.push({x:R.x,y:R.y,t1:Q,t2:B})))}z=M}else z=z?0:[];if(d)t+=z;else{H=0;for(J=z.length;H<J;H++)z[H].segment1=w,z[H].segment2=G,z[H].bez1=x,z[H].bez2=c;t=t.concat(z)}}}return t}
function r(a){var b=A(a);if(b.bbox)return C(b.bbox);if(!a)return w();a=I(a);for(var d=0,e=0,h=[],f=[],l,n=0,k=a.length;n<k;n++)l=a[n],"M"==l[0]?(d=l[1],e=l[2],h.push(d),f.push(e)):(d=U(d,e,l[1],l[2],l[3],l[4],l[5],l[6]),h=h.concat(d.min.x,d.max.x),f=f.concat(d.min.y,d.max.y),d=l[5],e=l[6]);a=X.apply(0,h);l=X.apply(0,f);h=W.apply(0,h);f=W.apply(0,f);f=w(a,l,h-a,f-l);b.bbox=C(f);return f}function s(a,b,d,e,h){if(h)return[["M",+a+ +h,b],["l",d-2*h,0],["a",h,h,0,0,1,h,h],["l",0,e-2*h],["a",h,h,0,0,1,
-h,h],["l",2*h-d,0],["a",h,h,0,0,1,-h,-h],["l",0,2*h-e],["a",h,h,0,0,1,h,-h],["z"] ];a=[["M",a,b],["l",d,0],["l",0,e],["l",-d,0],["z"] ];a.toString=z;return a}function x(a,b,d,e,h){null==h&&null==e&&(e=d);a=+a;b=+b;d=+d;e=+e;if(null!=h){var f=Math.PI/180,l=a+d*Math.cos(-e*f);a+=d*Math.cos(-h*f);var n=b+d*Math.sin(-e*f);b+=d*Math.sin(-h*f);d=[["M",l,n],["A",d,d,0,+(180<h-e),0,a,b] ]}else d=[["M",a,b],["m",0,-e],["a",d,e,0,1,1,0,2*e],["a",d,e,0,1,1,0,-2*e],["z"] ];d.toString=z;return d}function G(b){var e=
A(b);if(e.abs)return d(e.abs);Q(b,"array")&&Q(b&&b[0],"array")||(b=a.parsePathString(b));if(!b||!b.length)return[["M",0,0] ];var h=[],f=0,l=0,n=0,k=0,p=0;"M"==b[0][0]&&(f=+b[0][1],l=+b[0][2],n=f,k=l,p++,h[0]=["M",f,l]);for(var q=3==b.length&&"M"==b[0][0]&&"R"==b[1][0].toUpperCase()&&"Z"==b[2][0].toUpperCase(),s,r,w=p,c=b.length;w<c;w++){h.push(s=[]);r=b[w];p=r[0];if(p!=p.toUpperCase())switch(s[0]=p.toUpperCase(),s[0]){case "A":s[1]=r[1];s[2]=r[2];s[3]=r[3];s[4]=r[4];s[5]=r[5];s[6]=+r[6]+f;s[7]=+r[7]+
l;break;case "V":s[1]=+r[1]+l;break;case "H":s[1]=+r[1]+f;break;case "R":for(var t=[f,l].concat(r.slice(1)),u=2,v=t.length;u<v;u++)t[u]=+t[u]+f,t[++u]=+t[u]+l;h.pop();h=h.concat(P(t,q));break;case "O":h.pop();t=x(f,l,r[1],r[2]);t.push(t[0]);h=h.concat(t);break;case "U":h.pop();h=h.concat(x(f,l,r[1],r[2],r[3]));s=["U"].concat(h[h.length-1].slice(-2));break;case "M":n=+r[1]+f,k=+r[2]+l;default:for(u=1,v=r.length;u<v;u++)s[u]=+r[u]+(u%2?f:l)}else if("R"==p)t=[f,l].concat(r.slice(1)),h.pop(),h=h.concat(P(t,
q)),s=["R"].concat(r.slice(-2));else if("O"==p)h.pop(),t=x(f,l,r[1],r[2]),t.push(t[0]),h=h.concat(t);else if("U"==p)h.pop(),h=h.concat(x(f,l,r[1],r[2],r[3])),s=["U"].concat(h[h.length-1].slice(-2));else for(t=0,u=r.length;t<u;t++)s[t]=r[t];p=p.toUpperCase();if("O"!=p)switch(s[0]){case "Z":f=+n;l=+k;break;case "H":f=s[1];break;case "V":l=s[1];break;case "M":n=s[s.length-2],k=s[s.length-1];default:f=s[s.length-2],l=s[s.length-1]}}h.toString=z;e.abs=d(h);return h}function h(a,b,d,e){return[a,b,d,e,d,
e]}function J(a,b,d,e,h,f){var l=1/3,n=2/3;return[l*a+n*d,l*b+n*e,l*h+n*d,l*f+n*e,h,f]}function K(b,d,e,h,f,l,n,k,p,s){var r=120*S/180,q=S/180*(+f||0),c=[],t,x=a._.cacher(function(a,b,c){var d=a*F.cos(c)-b*F.sin(c);a=a*F.sin(c)+b*F.cos(c);return{x:d,y:a}});if(s)v=s[0],t=s[1],l=s[2],u=s[3];else{t=x(b,d,-q);b=t.x;d=t.y;t=x(k,p,-q);k=t.x;p=t.y;F.cos(S/180*f);F.sin(S/180*f);t=(b-k)/2;v=(d-p)/2;u=t*t/(e*e)+v*v/(h*h);1<u&&(u=F.sqrt(u),e*=u,h*=u);var u=e*e,w=h*h,u=(l==n?-1:1)*F.sqrt(Z((u*w-u*v*v-w*t*t)/
(u*v*v+w*t*t)));l=u*e*v/h+(b+k)/2;var u=u*-h*t/e+(d+p)/2,v=F.asin(((d-u)/h).toFixed(9));t=F.asin(((p-u)/h).toFixed(9));v=b<l?S-v:v;t=k<l?S-t:t;0>v&&(v=2*S+v);0>t&&(t=2*S+t);n&&v>t&&(v-=2*S);!n&&t>v&&(t-=2*S)}if(Z(t-v)>r){var c=t,w=k,G=p;t=v+r*(n&&t>v?1:-1);k=l+e*F.cos(t);p=u+h*F.sin(t);c=K(k,p,e,h,f,0,n,w,G,[t,c,l,u])}l=t-v;f=F.cos(v);r=F.sin(v);n=F.cos(t);t=F.sin(t);l=F.tan(l/4);e=4/3*e*l;l*=4/3*h;h=[b,d];b=[b+e*r,d-l*f];d=[k+e*t,p-l*n];k=[k,p];b[0]=2*h[0]-b[0];b[1]=2*h[1]-b[1];if(s)return[b,d,k].concat(c);
c=[b,d,k].concat(c).join().split(",");s=[];k=0;for(p=c.length;k<p;k++)s[k]=k%2?x(c[k-1],c[k],q).y:x(c[k],c[k+1],q).x;return s}function U(a,b,d,e,h,f,l,k){for(var n=[],p=[[],[] ],s,r,c,t,q=0;2>q;++q)0==q?(r=6*a-12*d+6*h,s=-3*a+9*d-9*h+3*l,c=3*d-3*a):(r=6*b-12*e+6*f,s=-3*b+9*e-9*f+3*k,c=3*e-3*b),1E-12>Z(s)?1E-12>Z(r)||(s=-c/r,0<s&&1>s&&n.push(s)):(t=r*r-4*c*s,c=F.sqrt(t),0>t||(t=(-r+c)/(2*s),0<t&&1>t&&n.push(t),s=(-r-c)/(2*s),0<s&&1>s&&n.push(s)));for(r=q=n.length;q--;)s=n[q],c=1-s,p[0][q]=c*c*c*a+3*
c*c*s*d+3*c*s*s*h+s*s*s*l,p[1][q]=c*c*c*b+3*c*c*s*e+3*c*s*s*f+s*s*s*k;p[0][r]=a;p[1][r]=b;p[0][r+1]=l;p[1][r+1]=k;p[0].length=p[1].length=r+2;return{min:{x:X.apply(0,p[0]),y:X.apply(0,p[1])},max:{x:W.apply(0,p[0]),y:W.apply(0,p[1])}}}function I(a,b){var e=!b&&A(a);if(!b&&e.curve)return d(e.curve);var f=G(a),l=b&&G(b),n={x:0,y:0,bx:0,by:0,X:0,Y:0,qx:null,qy:null},k={x:0,y:0,bx:0,by:0,X:0,Y:0,qx:null,qy:null},p=function(a,b,c){if(!a)return["C",b.x,b.y,b.x,b.y,b.x,b.y];a[0]in{T:1,Q:1}||(b.qx=b.qy=null);
switch(a[0]){case "M":b.X=a[1];b.Y=a[2];break;case "A":a=["C"].concat(K.apply(0,[b.x,b.y].concat(a.slice(1))));break;case "S":"C"==c||"S"==c?(c=2*b.x-b.bx,b=2*b.y-b.by):(c=b.x,b=b.y);a=["C",c,b].concat(a.slice(1));break;case "T":"Q"==c||"T"==c?(b.qx=2*b.x-b.qx,b.qy=2*b.y-b.qy):(b.qx=b.x,b.qy=b.y);a=["C"].concat(J(b.x,b.y,b.qx,b.qy,a[1],a[2]));break;case "Q":b.qx=a[1];b.qy=a[2];a=["C"].concat(J(b.x,b.y,a[1],a[2],a[3],a[4]));break;case "L":a=["C"].concat(h(b.x,b.y,a[1],a[2]));break;case "H":a=["C"].concat(h(b.x,
b.y,a[1],b.y));break;case "V":a=["C"].concat(h(b.x,b.y,b.x,a[1]));break;case "Z":a=["C"].concat(h(b.x,b.y,b.X,b.Y))}return a},s=function(a,b){if(7<a[b].length){a[b].shift();for(var c=a[b];c.length;)q[b]="A",l&&(u[b]="A"),a.splice(b++,0,["C"].concat(c.splice(0,6)));a.splice(b,1);v=W(f.length,l&&l.length||0)}},r=function(a,b,c,d,e){a&&b&&"M"==a[e][0]&&"M"!=b[e][0]&&(b.splice(e,0,["M",d.x,d.y]),c.bx=0,c.by=0,c.x=a[e][1],c.y=a[e][2],v=W(f.length,l&&l.length||0))},q=[],u=[],c="",t="",x=0,v=W(f.length,
l&&l.length||0);for(;x<v;x++){f[x]&&(c=f[x][0]);"C"!=c&&(q[x]=c,x&&(t=q[x-1]));f[x]=p(f[x],n,t);"A"!=q[x]&&"C"==c&&(q[x]="C");s(f,x);l&&(l[x]&&(c=l[x][0]),"C"!=c&&(u[x]=c,x&&(t=u[x-1])),l[x]=p(l[x],k,t),"A"!=u[x]&&"C"==c&&(u[x]="C"),s(l,x));r(f,l,n,k,x);r(l,f,k,n,x);var w=f[x],z=l&&l[x],y=w.length,U=l&&z.length;n.x=w[y-2];n.y=w[y-1];n.bx=$(w[y-4])||n.x;n.by=$(w[y-3])||n.y;k.bx=l&&($(z[U-4])||k.x);k.by=l&&($(z[U-3])||k.y);k.x=l&&z[U-2];k.y=l&&z[U-1]}l||(e.curve=d(f));return l?[f,l]:f}function P(a,
b){for(var d=[],e=0,h=a.length;h-2*!b>e;e+=2){var f=[{x:+a[e-2],y:+a[e-1]},{x:+a[e],y:+a[e+1]},{x:+a[e+2],y:+a[e+3]},{x:+a[e+4],y:+a[e+5]}];b?e?h-4==e?f[3]={x:+a[0],y:+a[1]}:h-2==e&&(f[2]={x:+a[0],y:+a[1]},f[3]={x:+a[2],y:+a[3]}):f[0]={x:+a[h-2],y:+a[h-1]}:h-4==e?f[3]=f[2]:e||(f[0]={x:+a[e],y:+a[e+1]});d.push(["C",(-f[0].x+6*f[1].x+f[2].x)/6,(-f[0].y+6*f[1].y+f[2].y)/6,(f[1].x+6*f[2].x-f[3].x)/6,(f[1].y+6*f[2].y-f[3].y)/6,f[2].x,f[2].y])}return d}y=k.prototype;var Q=a.is,C=a._.clone,L="hasOwnProperty",
N=/,?([a-z]),?/gi,$=parseFloat,F=Math,S=F.PI,X=F.min,W=F.max,ma=F.pow,Z=F.abs;M=n(1);var na=n(),ba=n(0,1),V=a._unit2px;a.path=A;a.path.getTotalLength=M;a.path.getPointAtLength=na;a.path.getSubpath=function(a,b,d){if(1E-6>this.getTotalLength(a)-d)return ba(a,b).end;a=ba(a,d,1);return b?ba(a,b).end:a};y.getTotalLength=function(){if(this.node.getTotalLength)return this.node.getTotalLength()};y.getPointAtLength=function(a){return na(this.attr("d"),a)};y.getSubpath=function(b,d){return a.path.getSubpath(this.attr("d"),
b,d)};a._.box=w;a.path.findDotsAtSegment=u;a.path.bezierBBox=p;a.path.isPointInsideBBox=b;a.path.isBBoxIntersect=q;a.path.intersection=function(a,b){return l(a,b)};a.path.intersectionNumber=function(a,b){return l(a,b,1)};a.path.isPointInside=function(a,d,e){var h=r(a);return b(h,d,e)&&1==l(a,[["M",d,e],["H",h.x2+10] ],1)%2};a.path.getBBox=r;a.path.get={path:function(a){return a.attr("path")},circle:function(a){a=V(a);return x(a.cx,a.cy,a.r)},ellipse:function(a){a=V(a);return x(a.cx||0,a.cy||0,a.rx,
a.ry)},rect:function(a){a=V(a);return s(a.x||0,a.y||0,a.width,a.height,a.rx,a.ry)},image:function(a){a=V(a);return s(a.x||0,a.y||0,a.width,a.height)},line:function(a){return"M"+[a.attr("x1")||0,a.attr("y1")||0,a.attr("x2"),a.attr("y2")]},polyline:function(a){return"M"+a.attr("points")},polygon:function(a){return"M"+a.attr("points")+"z"},deflt:function(a){a=a.node.getBBox();return s(a.x,a.y,a.width,a.height)}};a.path.toRelative=function(b){var e=A(b),h=String.prototype.toLowerCase;if(e.rel)return d(e.rel);
a.is(b,"array")&&a.is(b&&b[0],"array")||(b=a.parsePathString(b));var f=[],l=0,n=0,k=0,p=0,s=0;"M"==b[0][0]&&(l=b[0][1],n=b[0][2],k=l,p=n,s++,f.push(["M",l,n]));for(var r=b.length;s<r;s++){var q=f[s]=[],x=b[s];if(x[0]!=h.call(x[0]))switch(q[0]=h.call(x[0]),q[0]){case "a":q[1]=x[1];q[2]=x[2];q[3]=x[3];q[4]=x[4];q[5]=x[5];q[6]=+(x[6]-l).toFixed(3);q[7]=+(x[7]-n).toFixed(3);break;case "v":q[1]=+(x[1]-n).toFixed(3);break;case "m":k=x[1],p=x[2];default:for(var c=1,t=x.length;c<t;c++)q[c]=+(x[c]-(c%2?l:
n)).toFixed(3)}else for(f[s]=[],"m"==x[0]&&(k=x[1]+l,p=x[2]+n),q=0,c=x.length;q<c;q++)f[s][q]=x[q];x=f[s].length;switch(f[s][0]){case "z":l=k;n=p;break;case "h":l+=+f[s][x-1];break;case "v":n+=+f[s][x-1];break;default:l+=+f[s][x-2],n+=+f[s][x-1]}}f.toString=z;e.rel=d(f);return f};a.path.toAbsolute=G;a.path.toCubic=I;a.path.map=function(a,b){if(!b)return a;var d,e,h,f,l,n,k;a=I(a);h=0;for(l=a.length;h<l;h++)for(k=a[h],f=1,n=k.length;f<n;f+=2)d=b.x(k[f],k[f+1]),e=b.y(k[f],k[f+1]),k[f]=d,k[f+1]=e;return a};
a.path.toString=z;a.path.clone=d});C.plugin(function(a,v,y,C){var A=Math.max,w=Math.min,z=function(a){this.items=[];this.bindings={};this.length=0;this.type="set";if(a)for(var f=0,n=a.length;f<n;f++)a[f]&&(this[this.items.length]=this.items[this.items.length]=a[f],this.length++)};v=z.prototype;v.push=function(){for(var a,f,n=0,k=arguments.length;n<k;n++)if(a=arguments[n])f=this.items.length,this[f]=this.items[f]=a,this.length++;return this};v.pop=function(){this.length&&delete this[this.length--];
return this.items.pop()};v.forEach=function(a,f){for(var n=0,k=this.items.length;n<k&&!1!==a.call(f,this.items[n],n);n++);return this};v.animate=function(d,f,n,u){"function"!=typeof n||n.length||(u=n,n=L.linear);d instanceof a._.Animation&&(u=d.callback,n=d.easing,f=n.dur,d=d.attr);var p=arguments;if(a.is(d,"array")&&a.is(p[p.length-1],"array"))var b=!0;var q,e=function(){q?this.b=q:q=this.b},l=0,r=u&&function(){l++==this.length&&u.call(this)};return this.forEach(function(a,l){k.once("snap.animcreated."+
a.id,e);b?p[l]&&a.animate.apply(a,p[l]):a.animate(d,f,n,r)})};v.remove=function(){for(;this.length;)this.pop().remove();return this};v.bind=function(a,f,k){var u={};if("function"==typeof f)this.bindings[a]=f;else{var p=k||a;this.bindings[a]=function(a){u[p]=a;f.attr(u)}}return this};v.attr=function(a){var f={},k;for(k in a)if(this.bindings[k])this.bindings[k](a[k]);else f[k]=a[k];a=0;for(k=this.items.length;a<k;a++)this.items[a].attr(f);return this};v.clear=function(){for(;this.length;)this.pop()};
v.splice=function(a,f,k){a=0>a?A(this.length+a,0):a;f=A(0,w(this.length-a,f));var u=[],p=[],b=[],q;for(q=2;q<arguments.length;q++)b.push(arguments[q]);for(q=0;q<f;q++)p.push(this[a+q]);for(;q<this.length-a;q++)u.push(this[a+q]);var e=b.length;for(q=0;q<e+u.length;q++)this.items[a+q]=this[a+q]=q<e?b[q]:u[q-e];for(q=this.items.length=this.length-=f-e;this[q];)delete this[q++];return new z(p)};v.exclude=function(a){for(var f=0,k=this.length;f<k;f++)if(this[f]==a)return this.splice(f,1),!0;return!1};
v.insertAfter=function(a){for(var f=this.items.length;f--;)this.items[f].insertAfter(a);return this};v.getBBox=function(){for(var a=[],f=[],k=[],u=[],p=this.items.length;p--;)if(!this.items[p].removed){var b=this.items[p].getBBox();a.push(b.x);f.push(b.y);k.push(b.x+b.width);u.push(b.y+b.height)}a=w.apply(0,a);f=w.apply(0,f);k=A.apply(0,k);u=A.apply(0,u);return{x:a,y:f,x2:k,y2:u,width:k-a,height:u-f,cx:a+(k-a)/2,cy:f+(u-f)/2}};v.clone=function(a){a=new z;for(var f=0,k=this.items.length;f<k;f++)a.push(this.items[f].clone());
return a};v.toString=function(){return"Snap\u2018s set"};v.type="set";a.set=function(){var a=new z;arguments.length&&a.push.apply(a,Array.prototype.slice.call(arguments,0));return a}});C.plugin(function(a,v,y,C){function A(a){var b=a[0];switch(b.toLowerCase()){case "t":return[b,0,0];case "m":return[b,1,0,0,1,0,0];case "r":return 4==a.length?[b,0,a[2],a[3] ]:[b,0];case "s":return 5==a.length?[b,1,1,a[3],a[4] ]:3==a.length?[b,1,1]:[b,1]}}function w(b,d,f){d=q(d).replace(/\.{3}|\u2026/g,b);b=a.parseTransformString(b)||
[];d=a.parseTransformString(d)||[];for(var k=Math.max(b.length,d.length),p=[],v=[],h=0,w,z,y,I;h<k;h++){y=b[h]||A(d[h]);I=d[h]||A(y);if(y[0]!=I[0]||"r"==y[0].toLowerCase()&&(y[2]!=I[2]||y[3]!=I[3])||"s"==y[0].toLowerCase()&&(y[3]!=I[3]||y[4]!=I[4])){b=a._.transform2matrix(b,f());d=a._.transform2matrix(d,f());p=[["m",b.a,b.b,b.c,b.d,b.e,b.f] ];v=[["m",d.a,d.b,d.c,d.d,d.e,d.f] ];break}p[h]=[];v[h]=[];w=0;for(z=Math.max(y.length,I.length);w<z;w++)w in y&&(p[h][w]=y[w]),w in I&&(v[h][w]=I[w])}return{from:u(p),
to:u(v),f:n(p)}}function z(a){return a}function d(a){return function(b){return+b.toFixed(3)+a}}function f(b){return a.rgb(b[0],b[1],b[2])}function n(a){var b=0,d,f,k,n,h,p,q=[];d=0;for(f=a.length;d<f;d++){h="[";p=['"'+a[d][0]+'"'];k=1;for(n=a[d].length;k<n;k++)p[k]="val["+b++ +"]";h+=p+"]";q[d]=h}return Function("val","return Snap.path.toString.call(["+q+"])")}function u(a){for(var b=[],d=0,f=a.length;d<f;d++)for(var k=1,n=a[d].length;k<n;k++)b.push(a[d][k]);return b}var p={},b=/[a-z]+$/i,q=String;
p.stroke=p.fill="colour";v.prototype.equal=function(a,b){return k("snap.util.equal",this,a,b).firstDefined()};k.on("snap.util.equal",function(e,k){var r,s;r=q(this.attr(e)||"");var x=this;if(r==+r&&k==+k)return{from:+r,to:+k,f:z};if("colour"==p[e])return r=a.color(r),s=a.color(k),{from:[r.r,r.g,r.b,r.opacity],to:[s.r,s.g,s.b,s.opacity],f:f};if("transform"==e||"gradientTransform"==e||"patternTransform"==e)return k instanceof a.Matrix&&(k=k.toTransformString()),a._.rgTransform.test(k)||(k=a._.svgTransform2string(k)),
w(r,k,function(){return x.getBBox(1)});if("d"==e||"path"==e)return r=a.path.toCubic(r,k),{from:u(r[0]),to:u(r[1]),f:n(r[0])};if("points"==e)return r=q(r).split(a._.separator),s=q(k).split(a._.separator),{from:r,to:s,f:function(a){return a}};aUnit=r.match(b);s=q(k).match(b);return aUnit&&aUnit==s?{from:parseFloat(r),to:parseFloat(k),f:d(aUnit)}:{from:this.asPX(e),to:this.asPX(e,k),f:z}})});C.plugin(function(a,v,y,C){var A=v.prototype,w="createTouch"in C.doc;v="click dblclick mousedown mousemove mouseout mouseover mouseup touchstart touchmove touchend touchcancel".split(" ");
var z={mousedown:"touchstart",mousemove:"touchmove",mouseup:"touchend"},d=function(a,b){var d="y"==a?"scrollTop":"scrollLeft",e=b&&b.node?b.node.ownerDocument:C.doc;return e[d in e.documentElement?"documentElement":"body"][d]},f=function(){this.returnValue=!1},n=function(){return this.originalEvent.preventDefault()},u=function(){this.cancelBubble=!0},p=function(){return this.originalEvent.stopPropagation()},b=function(){if(C.doc.addEventListener)return function(a,b,e,f){var k=w&&z[b]?z[b]:b,l=function(k){var l=
d("y",f),q=d("x",f);if(w&&z.hasOwnProperty(b))for(var r=0,u=k.targetTouches&&k.targetTouches.length;r<u;r++)if(k.targetTouches[r].target==a||a.contains(k.targetTouches[r].target)){u=k;k=k.targetTouches[r];k.originalEvent=u;k.preventDefault=n;k.stopPropagation=p;break}return e.call(f,k,k.clientX+q,k.clientY+l)};b!==k&&a.addEventListener(b,l,!1);a.addEventListener(k,l,!1);return function(){b!==k&&a.removeEventListener(b,l,!1);a.removeEventListener(k,l,!1);return!0}};if(C.doc.attachEvent)return function(a,
b,e,h){var k=function(a){a=a||h.node.ownerDocument.window.event;var b=d("y",h),k=d("x",h),k=a.clientX+k,b=a.clientY+b;a.preventDefault=a.preventDefault||f;a.stopPropagation=a.stopPropagation||u;return e.call(h,a,k,b)};a.attachEvent("on"+b,k);return function(){a.detachEvent("on"+b,k);return!0}}}(),q=[],e=function(a){for(var b=a.clientX,e=a.clientY,f=d("y"),l=d("x"),n,p=q.length;p--;){n=q[p];if(w)for(var r=a.touches&&a.touches.length,u;r--;){if(u=a.touches[r],u.identifier==n.el._drag.id||n.el.node.contains(u.target)){b=
u.clientX;e=u.clientY;(a.originalEvent?a.originalEvent:a).preventDefault();break}}else a.preventDefault();b+=l;e+=f;k("snap.drag.move."+n.el.id,n.move_scope||n.el,b-n.el._drag.x,e-n.el._drag.y,b,e,a)}},l=function(b){a.unmousemove(e).unmouseup(l);for(var d=q.length,f;d--;)f=q[d],f.el._drag={},k("snap.drag.end."+f.el.id,f.end_scope||f.start_scope||f.move_scope||f.el,b);q=[]};for(y=v.length;y--;)(function(d){a[d]=A[d]=function(e,f){a.is(e,"function")&&(this.events=this.events||[],this.events.push({name:d,
f:e,unbind:b(this.node||document,d,e,f||this)}));return this};a["un"+d]=A["un"+d]=function(a){for(var b=this.events||[],e=b.length;e--;)if(b[e].name==d&&(b[e].f==a||!a)){b[e].unbind();b.splice(e,1);!b.length&&delete this.events;break}return this}})(v[y]);A.hover=function(a,b,d,e){return this.mouseover(a,d).mouseout(b,e||d)};A.unhover=function(a,b){return this.unmouseover(a).unmouseout(b)};var r=[];A.drag=function(b,d,f,h,n,p){function u(r,v,w){(r.originalEvent||r).preventDefault();this._drag.x=v;
this._drag.y=w;this._drag.id=r.identifier;!q.length&&a.mousemove(e).mouseup(l);q.push({el:this,move_scope:h,start_scope:n,end_scope:p});d&&k.on("snap.drag.start."+this.id,d);b&&k.on("snap.drag.move."+this.id,b);f&&k.on("snap.drag.end."+this.id,f);k("snap.drag.start."+this.id,n||h||this,v,w,r)}if(!arguments.length){var v;return this.drag(function(a,b){this.attr({transform:v+(v?"T":"t")+[a,b]})},function(){v=this.transform().local})}this._drag={};r.push({el:this,start:u});this.mousedown(u);return this};
A.undrag=function(){for(var b=r.length;b--;)r[b].el==this&&(this.unmousedown(r[b].start),r.splice(b,1),k.unbind("snap.drag.*."+this.id));!r.length&&a.unmousemove(e).unmouseup(l);return this}});C.plugin(function(a,v,y,C){y=y.prototype;var A=/^\s*url\((.+)\)/,w=String,z=a._.$;a.filter={};y.filter=function(d){var f=this;"svg"!=f.type&&(f=f.paper);d=a.parse(w(d));var k=a._.id(),u=z("filter");z(u,{id:k,filterUnits:"userSpaceOnUse"});u.appendChild(d.node);f.defs.appendChild(u);return new v(u)};k.on("snap.util.getattr.filter",
function(){k.stop();var d=z(this.node,"filter");if(d)return(d=w(d).match(A))&&a.select(d[1])});k.on("snap.util.attr.filter",function(d){if(d instanceof v&&"filter"==d.type){k.stop();var f=d.node.id;f||(z(d.node,{id:d.id}),f=d.id);z(this.node,{filter:a.url(f)})}d&&"none"!=d||(k.stop(),this.node.removeAttribute("filter"))});a.filter.blur=function(d,f){null==d&&(d=2);return a.format('<feGaussianBlur stdDeviation="{def}"/>',{def:null==f?d:[d,f]})};a.filter.blur.toString=function(){return this()};a.filter.shadow=
function(d,f,k,u,p){"string"==typeof k&&(p=u=k,k=4);"string"!=typeof u&&(p=u,u="#000");null==k&&(k=4);null==p&&(p=1);null==d&&(d=0,f=2);null==f&&(f=d);u=a.color(u||"#000");return a.format('<feGaussianBlur in="SourceAlpha" stdDeviation="{blur}"/><feOffset dx="{dx}" dy="{dy}" result="offsetblur"/><feFlood flood-color="{color}"/><feComposite in2="offsetblur" operator="in"/><feComponentTransfer><feFuncA type="linear" slope="{opacity}"/></feComponentTransfer><feMerge><feMergeNode/><feMergeNode in="SourceGraphic"/></feMerge>',
{color:u,dx:d,dy:f,blur:k,opacity:p})};a.filter.shadow.toString=function(){return this()};a.filter.grayscale=function(d){null==d&&(d=1);return a.format('<feColorMatrix type="matrix" values="{a} {b} {c} 0 0 {d} {e} {f} 0 0 {g} {b} {h} 0 0 0 0 0 1 0"/>',{a:0.2126+0.7874*(1-d),b:0.7152-0.7152*(1-d),c:0.0722-0.0722*(1-d),d:0.2126-0.2126*(1-d),e:0.7152+0.2848*(1-d),f:0.0722-0.0722*(1-d),g:0.2126-0.2126*(1-d),h:0.0722+0.9278*(1-d)})};a.filter.grayscale.toString=function(){return this()};a.filter.sepia=
function(d){null==d&&(d=1);return a.format('<feColorMatrix type="matrix" values="{a} {b} {c} 0 0 {d} {e} {f} 0 0 {g} {h} {i} 0 0 0 0 0 1 0"/>',{a:0.393+0.607*(1-d),b:0.769-0.769*(1-d),c:0.189-0.189*(1-d),d:0.349-0.349*(1-d),e:0.686+0.314*(1-d),f:0.168-0.168*(1-d),g:0.272-0.272*(1-d),h:0.534-0.534*(1-d),i:0.131+0.869*(1-d)})};a.filter.sepia.toString=function(){return this()};a.filter.saturate=function(d){null==d&&(d=1);return a.format('<feColorMatrix type="saturate" values="{amount}"/>',{amount:1-
d})};a.filter.saturate.toString=function(){return this()};a.filter.hueRotate=function(d){return a.format('<feColorMatrix type="hueRotate" values="{angle}"/>',{angle:d||0})};a.filter.hueRotate.toString=function(){return this()};a.filter.invert=function(d){null==d&&(d=1);return a.format('<feComponentTransfer><feFuncR type="table" tableValues="{amount} {amount2}"/><feFuncG type="table" tableValues="{amount} {amount2}"/><feFuncB type="table" tableValues="{amount} {amount2}"/></feComponentTransfer>',{amount:d,
amount2:1-d})};a.filter.invert.toString=function(){return this()};a.filter.brightness=function(d){null==d&&(d=1);return a.format('<feComponentTransfer><feFuncR type="linear" slope="{amount}"/><feFuncG type="linear" slope="{amount}"/><feFuncB type="linear" slope="{amount}"/></feComponentTransfer>',{amount:d})};a.filter.brightness.toString=function(){return this()};a.filter.contrast=function(d){null==d&&(d=1);return a.format('<feComponentTransfer><feFuncR type="linear" slope="{amount}" intercept="{amount2}"/><feFuncG type="linear" slope="{amount}" intercept="{amount2}"/><feFuncB type="linear" slope="{amount}" intercept="{amount2}"/></feComponentTransfer>',
{amount:d,amount2:0.5-d/2})};a.filter.contrast.toString=function(){return this()}});return C});

]]> </script>
<script> <![CDATA[

(function (glob, factory) {
    // AMD support
    if (typeof define === "function" && define.amd) {
        // Define as an anonymous module
        define("Gadfly", ["Snap.svg"], function (Snap) {
            return factory(Snap);
        });
    } else {
        // Browser globals (glob is window)
        // Snap adds itself to window
        glob.Gadfly = factory(glob.Snap);
    }
}(this, function (Snap) {

var Gadfly = {};

// Get an x/y coordinate value in pixels
var xPX = function(fig, x) {
    var client_box = fig.node.getBoundingClientRect();
    return x * fig.node.viewBox.baseVal.width / client_box.width;
};

var yPX = function(fig, y) {
    var client_box = fig.node.getBoundingClientRect();
    return y * fig.node.viewBox.baseVal.height / client_box.height;
};


Snap.plugin(function (Snap, Element, Paper, global) {
    // Traverse upwards from a snap element to find and return the first
    // note with the "plotroot" class.
    Element.prototype.plotroot = function () {
        var element = this;
        while (!element.hasClass("plotroot") && element.parent() != null) {
            element = element.parent();
        }
        return element;
    };

    Element.prototype.svgroot = function () {
        var element = this;
        while (element.node.nodeName != "svg" && element.parent() != null) {
            element = element.parent();
        }
        return element;
    };

    Element.prototype.plotbounds = function () {
        var root = this.plotroot()
        var bbox = root.select(".guide.background").node.getBBox();
        return {
            x0: bbox.x,
            x1: bbox.x + bbox.width,
            y0: bbox.y,
            y1: bbox.y + bbox.height
        };
    };

    Element.prototype.plotcenter = function () {
        var root = this.plotroot()
        var bbox = root.select(".guide.background").node.getBBox();
        return {
            x: bbox.x + bbox.width / 2,
            y: bbox.y + bbox.height / 2
        };
    };

    // Emulate IE style mouseenter/mouseleave events, since Microsoft always
    // does everything right.
    // See: http://www.dynamic-tools.net/toolbox/isMouseLeaveOrEnter/
    var events = ["mouseenter", "mouseleave"];

    for (i in events) {
        (function (event_name) {
            var event_name = events[i];
            Element.prototype[event_name] = function (fn, scope) {
                if (Snap.is(fn, "function")) {
                    var fn2 = function (event) {
                        if (event.type != "mouseover" && event.type != "mouseout") {
                            return;
                        }

                        var reltg = event.relatedTarget ? event.relatedTarget :
                            event.type == "mouseout" ? event.toElement : event.fromElement;
                        while (reltg && reltg != this.node) reltg = reltg.parentNode;

                        if (reltg != this.node) {
                            return fn.apply(this, event);
                        }
                    };

                    if (event_name == "mouseenter") {
                        this.mouseover(fn2, scope);
                    } else {
                        this.mouseout(fn2, scope);
                    }
                }
                return this;
            };
        })(events[i]);
    }


    Element.prototype.mousewheel = function (fn, scope) {
        if (Snap.is(fn, "function")) {
            var el = this;
            var fn2 = function (event) {
                fn.apply(el, [event]);
            };
        }

        this.node.addEventListener(
            /Firefox/i.test(navigator.userAgent) ? "DOMMouseScroll" : "mousewheel",
            fn2);

        return this;
    };


    // Snap's attr function can be too slow for things like panning/zooming.
    // This is a function to directly update element attributes without going
    // through eve.
    Element.prototype.attribute = function(key, val) {
        if (val === undefined) {
            return this.node.getAttribute(key, val);
        } else {
            return this.node.setAttribute(key, val);
        }
    };
});


// When the plot is moused over, emphasize the grid lines.
Gadfly.plot_mouseover = function(event) {
    var root = this.plotroot();
    init_pan_zoom(root);

    var xgridlines = root.select(".xgridlines"),
        ygridlines = root.select(".ygridlines");

    xgridlines.data("unfocused_strokedash",
                    xgridlines.attr("stroke-dasharray").replace(/px/g, "mm"))
    ygridlines.data("unfocused_strokedash",
                    ygridlines.attr("stroke-dasharray").replace(/px/g, "mm"))

    // emphasize grid lines
    var destcolor = root.data("focused_xgrid_color");
    xgridlines.attr("stroke-dasharray", "none")
              .selectAll("path")
              .animate({stroke: destcolor}, 250);

    destcolor = root.data("focused_ygrid_color");
    ygridlines.attr("stroke-dasharray", "none")
              .selectAll("path")
              .animate({stroke: destcolor}, 250);

    // reveal zoom slider
    root.select(".zoomslider")
        .animate({opacity: 1.0}, 250);
};


// Unemphasize grid lines on mouse out.
Gadfly.plot_mouseout = function(event) {
    var root = this.plotroot();
    var xgridlines = root.select(".xgridlines"),
        ygridlines = root.select(".ygridlines");

    var destcolor = root.data("unfocused_xgrid_color");

    xgridlines.attr("stroke-dasharray", xgridlines.data("unfocused_strokedash"))
              .selectAll("path")
              .animate({stroke: destcolor}, 250);

    destcolor = root.data("unfocused_ygrid_color");
    ygridlines.attr("stroke-dasharray", ygridlines.data("unfocused_strokedash"))
              .selectAll("path")
              .animate({stroke: destcolor}, 250);

    // hide zoom slider
    root.select(".zoomslider")
        .animate({opacity: 0.0}, 250);
};


var set_geometry_transform = function(root, tx, ty, scale) {
    var xscalable = root.hasClass("xscalable"),
        yscalable = root.hasClass("yscalable");

    var old_scale = root.data("scale");

    var xscale = xscalable ? scale : 1.0,
        yscale = yscalable ? scale : 1.0;

    tx = xscalable ? tx : 0.0;
    ty = yscalable ? ty : 0.0;

    var t = new Snap.Matrix().translate(tx, ty).scale(xscale, yscale);

    root.selectAll(".geometry, image")
        .forEach(function (element, i) {
            element.transform(t);
        });

    bounds = root.plotbounds();

    if (yscalable) {
        var xfixed_t = new Snap.Matrix().translate(0, ty).scale(1.0, yscale);
        root.selectAll(".xfixed")
            .forEach(function (element, i) {
                element.transform(xfixed_t);
            });

        root.select(".ylabels")
            .transform(xfixed_t)
            .selectAll("text")
            .forEach(function (element, i) {
                if (element.attribute("gadfly:inscale") == "true") {
                    var cx = element.asPX("x"),
                        cy = element.asPX("y");
                    var st = element.data("static_transform");
                    unscale_t = new Snap.Matrix();
                    unscale_t.scale(1, 1/scale, cx, cy).add(st);
                    element.transform(unscale_t);

                    var y = cy * scale + ty;
                    element.attr("visibility",
                        bounds.y0 <= y && y <= bounds.y1 ? "visible" : "hidden");
                }
            });
    }

    if (xscalable) {
        var yfixed_t = new Snap.Matrix().translate(tx, 0).scale(xscale, 1.0);
        var xtrans = new Snap.Matrix().translate(tx, 0);
        root.selectAll(".yfixed")
            .forEach(function (element, i) {
                element.transform(yfixed_t);
            });

        root.select(".xlabels")
            .transform(yfixed_t)
            .selectAll("text")
            .forEach(function (element, i) {
                if (element.attribute("gadfly:inscale") == "true") {
                    var cx = element.asPX("x"),
                        cy = element.asPX("y");
                    var st = element.data("static_transform");
                    unscale_t = new Snap.Matrix();
                    unscale_t.scale(1/scale, 1, cx, cy).add(st);

                    element.transform(unscale_t);

                    var x = cx * scale + tx;
                    element.attr("visibility",
                        bounds.x0 <= x && x <= bounds.x1 ? "visible" : "hidden");
                    }
            });
    }

    // we must unscale anything that is scale invariance: widths, raiduses, etc.
    var size_attribs = ["font-size"];
    var unscaled_selection = ".geometry, .geometry *";
    if (xscalable) {
        size_attribs.push("rx");
        unscaled_selection += ", .xgridlines";
    }
    if (yscalable) {
        size_attribs.push("ry");
        unscaled_selection += ", .ygridlines";
    }

    root.selectAll(unscaled_selection)
        .forEach(function (element, i) {
            // circle need special help
            if (element.node.nodeName == "circle") {
                var cx = element.attribute("cx"),
                    cy = element.attribute("cy");
                unscale_t = new Snap.Matrix().scale(1/xscale, 1/yscale,
                                                        cx, cy);
                element.transform(unscale_t);
                return;
            }

            for (i in size_attribs) {
                var key = size_attribs[i];
                var val = parseFloat(element.attribute(key));
                if (val !== undefined && val != 0 && !isNaN(val)) {
                    element.attribute(key, val * old_scale / scale);
                }
            }
        });
};


// Find the most appropriate tick scale and update label visibility.
var update_tickscale = function(root, scale, axis) {
    if (!root.hasClass(axis + "scalable")) return;

    var tickscales = root.data(axis + "tickscales");
    var best_tickscale = 1.0;
    var best_tickscale_dist = Infinity;
    for (tickscale in tickscales) {
        var dist = Math.abs(Math.log(tickscale) - Math.log(scale));
        if (dist < best_tickscale_dist) {
            best_tickscale_dist = dist;
            best_tickscale = tickscale;
        }
    }

    if (best_tickscale != root.data(axis + "tickscale")) {
        root.data(axis + "tickscale", best_tickscale);
        var mark_inscale_gridlines = function (element, i) {
            var inscale = element.attr("gadfly:scale") == best_tickscale;
            element.attribute("gadfly:inscale", inscale);
            element.attr("visibility", inscale ? "visible" : "hidden");
        };

        var mark_inscale_labels = function (element, i) {
            var inscale = element.attr("gadfly:scale") == best_tickscale;
            element.attribute("gadfly:inscale", inscale);
            element.attr("visibility", inscale ? "visible" : "hidden");
        };

        root.select("." + axis + "gridlines").selectAll("path").forEach(mark_inscale_gridlines);
        root.select("." + axis + "labels").selectAll("text").forEach(mark_inscale_labels);
    }
};


var set_plot_pan_zoom = function(root, tx, ty, scale) {
    var old_scale = root.data("scale");
    var bounds = root.plotbounds();

    var width = bounds.x1 - bounds.x0,
        height = bounds.y1 - bounds.y0;

    // compute the viewport derived from tx, ty, and scale
    var x_min = -width * scale - (scale * width - width),
        x_max = width * scale,
        y_min = -height * scale - (scale * height - height),
        y_max = height * scale;

    var x0 = bounds.x0 - scale * bounds.x0,
        y0 = bounds.y0 - scale * bounds.y0;

    var tx = Math.max(Math.min(tx - x0, x_max), x_min),
        ty = Math.max(Math.min(ty - y0, y_max), y_min);

    tx += x0;
    ty += y0;

    // when the scale change, we may need to alter which set of
    // ticks is being displayed
    if (scale != old_scale) {
        update_tickscale(root, scale, "x");
        update_tickscale(root, scale, "y");
    }

    set_geometry_transform(root, tx, ty, scale);

    root.data("scale", scale);
    root.data("tx", tx);
    root.data("ty", ty);
};


var scale_centered_translation = function(root, scale) {
    var bounds = root.plotbounds();

    var width = bounds.x1 - bounds.x0,
        height = bounds.y1 - bounds.y0;

    var tx0 = root.data("tx"),
        ty0 = root.data("ty");

    var scale0 = root.data("scale");

    // how off from center the current view is
    var xoff = tx0 - (bounds.x0 * (1 - scale0) + (width * (1 - scale0)) / 2),
        yoff = ty0 - (bounds.y0 * (1 - scale0) + (height * (1 - scale0)) / 2);

    // rescale offsets
    xoff = xoff * scale / scale0;
    yoff = yoff * scale / scale0;

    // adjust for the panel position being scaled
    var x_edge_adjust = bounds.x0 * (1 - scale),
        y_edge_adjust = bounds.y0 * (1 - scale);

    return {
        x: xoff + x_edge_adjust + (width - width * scale) / 2,
        y: yoff + y_edge_adjust + (height - height * scale) / 2
    };
};


// Initialize data for panning zooming if it isn't already.
var init_pan_zoom = function(root) {
    if (root.data("zoompan-ready")) {
        return;
    }

    // The non-scaling-stroke trick. Rather than try to correct for the
    // stroke-width when zooming, we force it to a fixed value.
    var px_per_mm = root.node.getCTM().a;

    // Drag events report deltas in pixels, which we'd like to convert to
    // millimeters.
    root.data("px_per_mm", px_per_mm);

    root.selectAll("path")
        .forEach(function (element, i) {
        sw = element.asPX("stroke-width") * px_per_mm;
        if (sw > 0) {
            element.attribute("stroke-width", sw);
            element.attribute("vector-effect", "non-scaling-stroke");
        }
    });

    // Store ticks labels original tranformation
    root.selectAll(".xlabels > text, .ylabels > text")
        .forEach(function (element, i) {
            var lm = element.transform().localMatrix;
            element.data("static_transform",
                new Snap.Matrix(lm.a, lm.b, lm.c, lm.d, lm.e, lm.f));
        });

    if (root.data("tx") === undefined) root.data("tx", 0);
    if (root.data("ty") === undefined) root.data("ty", 0);
    if (root.data("scale") === undefined) root.data("scale", 1.0);
    if (root.data("xtickscales") === undefined) {

        // index all the tick scales that are listed
        var xtickscales = {};
        var ytickscales = {};
        var add_x_tick_scales = function (element, i) {
            xtickscales[element.attribute("gadfly:scale")] = true;
        };
        var add_y_tick_scales = function (element, i) {
            ytickscales[element.attribute("gadfly:scale")] = true;
        };

        root.select(".xgridlines").selectAll("path").forEach(add_x_tick_scales);
        root.select(".ygridlines").selectAll("path").forEach(add_y_tick_scales);
        root.select(".xlabels").selectAll("text").forEach(add_x_tick_scales);
        root.select(".ylabels").selectAll("text").forEach(add_y_tick_scales);

        root.data("xtickscales", xtickscales);
        root.data("ytickscales", ytickscales);
        root.data("xtickscale", 1.0);
    }

    var min_scale = 1.0, max_scale = 1.0;
    for (scale in xtickscales) {
        min_scale = Math.min(min_scale, scale);
        max_scale = Math.max(max_scale, scale);
    }
    for (scale in ytickscales) {
        min_scale = Math.min(min_scale, scale);
        max_scale = Math.max(max_scale, scale);
    }
    root.data("min_scale", min_scale);
    root.data("max_scale", max_scale);

    // store the original positions of labels
    root.select(".xlabels")
        .selectAll("text")
        .forEach(function (element, i) {
            element.data("x", element.asPX("x"));
        });

    root.select(".ylabels")
        .selectAll("text")
        .forEach(function (element, i) {
            element.data("y", element.asPX("y"));
        });

    // mark grid lines and ticks as in or out of scale.
    var mark_inscale = function (element, i) {
        element.attribute("gadfly:inscale", element.attribute("gadfly:scale") == 1.0);
    };

    root.select(".xgridlines").selectAll("path").forEach(mark_inscale);
    root.select(".ygridlines").selectAll("path").forEach(mark_inscale);
    root.select(".xlabels").selectAll("text").forEach(mark_inscale);
    root.select(".ylabels").selectAll("text").forEach(mark_inscale);

    // figure out the upper ond lower bounds on panning using the maximum
    // and minum grid lines
    var bounds = root.plotbounds();
    var pan_bounds = {
        x0: 0.0,
        y0: 0.0,
        x1: 0.0,
        y1: 0.0
    };

    root.select(".xgridlines")
        .selectAll("path")
        .forEach(function (element, i) {
            if (element.attribute("gadfly:inscale") == "true") {
                var bbox = element.node.getBBox();
                if (bounds.x1 - bbox.x < pan_bounds.x0) {
                    pan_bounds.x0 = bounds.x1 - bbox.x;
                }
                if (bounds.x0 - bbox.x > pan_bounds.x1) {
                    pan_bounds.x1 = bounds.x0 - bbox.x;
                }
            }
        });

    root.select(".ygridlines")
        .selectAll("path")
        .forEach(function (element, i) {
            if (element.attribute("gadfly:inscale") == "true") {
                var bbox = element.node.getBBox();
                if (bounds.y1 - bbox.y < pan_bounds.y0) {
                    pan_bounds.y0 = bounds.y1 - bbox.y;
                }
                if (bounds.y0 - bbox.y > pan_bounds.y1) {
                    pan_bounds.y1 = bounds.y0 - bbox.y;
                }
            }
        });

    // nudge these values a little
    pan_bounds.x0 -= 5;
    pan_bounds.x1 += 5;
    pan_bounds.y0 -= 5;
    pan_bounds.y1 += 5;
    root.data("pan_bounds", pan_bounds);

    // Set all grid lines at scale 1.0 to visible. Out of bounds lines
    // will be clipped.
    root.select(".xgridlines")
        .selectAll("path")
        .forEach(function (element, i) {
            if (element.attribute("gadfly:inscale") == "true") {
                element.attr("visibility", "visible");
            }
        });

    root.select(".ygridlines")
        .selectAll("path")
        .forEach(function (element, i) {
            if (element.attribute("gadfly:inscale") == "true") {
                element.attr("visibility", "visible");
            }
        });

    root.data("zoompan-ready", true)
};


// Panning
Gadfly.guide_background_drag_onmove = function(dx, dy, x, y, event) {
    var root = this.plotroot();
    var px_per_mm = root.data("px_per_mm");
    dx /= px_per_mm;
    dy /= px_per_mm;

    var tx0 = root.data("tx"),
        ty0 = root.data("ty");

    var dx0 = root.data("dx"),
        dy0 = root.data("dy");

    root.data("dx", dx);
    root.data("dy", dy);

    dx = dx - dx0;
    dy = dy - dy0;

    var tx = tx0 + dx,
        ty = ty0 + dy;

    set_plot_pan_zoom(root, tx, ty, root.data("scale"));
};


Gadfly.guide_background_drag_onstart = function(x, y, event) {
    var root = this.plotroot();
    root.data("dx", 0);
    root.data("dy", 0);
    init_pan_zoom(root);
};


Gadfly.guide_background_drag_onend = function(event) {
    var root = this.plotroot();
};


Gadfly.guide_background_scroll = function(event) {
    if (event.shiftKey) {
        var root = this.plotroot();
        init_pan_zoom(root);
        var new_scale = root.data("scale") * Math.pow(2, 0.002 * event.wheelDelta);
        new_scale = Math.max(
            root.data("min_scale"),
            Math.min(root.data("max_scale"), new_scale))
        update_plot_scale(root, new_scale);
        event.stopPropagation();
    }
};


Gadfly.zoomslider_button_mouseover = function(event) {
    this.select(".button_logo")
         .animate({fill: this.data("mouseover_color")}, 100);
};


Gadfly.zoomslider_button_mouseout = function(event) {
     this.select(".button_logo")
         .animate({fill: this.data("mouseout_color")}, 100);
};


Gadfly.zoomslider_zoomout_click = function(event) {
    var root = this.plotroot();
    init_pan_zoom(root);
    var min_scale = root.data("min_scale"),
        scale = root.data("scale");
    Snap.animate(
        scale,
        Math.max(min_scale, scale / 1.5),
        function (new_scale) {
            update_plot_scale(root, new_scale);
        },
        200);
};


Gadfly.zoomslider_zoomin_click = function(event) {
    var root = this.plotroot();
    init_pan_zoom(root);
    var max_scale = root.data("max_scale"),
        scale = root.data("scale");

    Snap.animate(
        scale,
        Math.min(max_scale, scale * 1.5),
        function (new_scale) {
            update_plot_scale(root, new_scale);
        },
        200);
};


Gadfly.zoomslider_track_click = function(event) {
    // TODO
};


Gadfly.zoomslider_thumb_mousedown = function(event) {
    this.animate({fill: this.data("mouseover_color")}, 100);
};


Gadfly.zoomslider_thumb_mouseup = function(event) {
    this.animate({fill: this.data("mouseout_color")}, 100);
};


// compute the position in [0, 1] of the zoom slider thumb from the current scale
var slider_position_from_scale = function(scale, min_scale, max_scale) {
    if (scale >= 1.0) {
        return 0.5 + 0.5 * (Math.log(scale) / Math.log(max_scale));
    }
    else {
        return 0.5 * (Math.log(scale) - Math.log(min_scale)) / (0 - Math.log(min_scale));
    }
}


var update_plot_scale = function(root, new_scale) {
    var trans = scale_centered_translation(root, new_scale);
    set_plot_pan_zoom(root, trans.x, trans.y, new_scale);

    root.selectAll(".zoomslider_thumb")
        .forEach(function (element, i) {
            var min_pos = element.data("min_pos"),
                max_pos = element.data("max_pos"),
                min_scale = root.data("min_scale"),
                max_scale = root.data("max_scale");
            var xmid = (min_pos + max_pos) / 2;
            var xpos = slider_position_from_scale(new_scale, min_scale, max_scale);
            element.transform(new Snap.Matrix().translate(
                Math.max(min_pos, Math.min(
                         max_pos, min_pos + (max_pos - min_pos) * xpos)) - xmid, 0));
    });
};


Gadfly.zoomslider_thumb_dragmove = function(dx, dy, x, y) {
    var root = this.plotroot();
    var min_pos = this.data("min_pos"),
        max_pos = this.data("max_pos"),
        min_scale = root.data("min_scale"),
        max_scale = root.data("max_scale"),
        old_scale = root.data("old_scale");

    var px_per_mm = root.data("px_per_mm");
    dx /= px_per_mm;
    dy /= px_per_mm;

    var xmid = (min_pos + max_pos) / 2;
    var xpos = slider_position_from_scale(old_scale, min_scale, max_scale) +
                   dx / (max_pos - min_pos);

    // compute the new scale
    var new_scale;
    if (xpos >= 0.5) {
        new_scale = Math.exp(2.0 * (xpos - 0.5) * Math.log(max_scale));
    }
    else {
        new_scale = Math.exp(2.0 * xpos * (0 - Math.log(min_scale)) +
                        Math.log(min_scale));
    }
    new_scale = Math.min(max_scale, Math.max(min_scale, new_scale));

    update_plot_scale(root, new_scale);
};


Gadfly.zoomslider_thumb_dragstart = function(event) {
    var root = this.plotroot();
    init_pan_zoom(root);

    // keep track of what the scale was when we started dragging
    root.data("old_scale", root.data("scale"));
};


Gadfly.zoomslider_thumb_dragend = function(event) {
};


var toggle_color_class = function(root, color_class, ison) {
    var guides = root.selectAll(".guide." + color_class + ",.guide ." + color_class);
    var geoms = root.selectAll(".geometry." + color_class + ",.geometry ." + color_class);
    if (ison) {
        guides.animate({opacity: 0.5}, 250);
        geoms.animate({opacity: 0.0}, 250);
    } else {
        guides.animate({opacity: 1.0}, 250);
        geoms.animate({opacity: 1.0}, 250);
    }
};


Gadfly.colorkey_swatch_click = function(event) {
    var root = this.plotroot();
    var color_class = this.data("color_class");

    if (event.shiftKey) {
        root.selectAll(".colorkey text")
            .forEach(function (element) {
                var other_color_class = element.data("color_class");
                if (other_color_class != color_class) {
                    toggle_color_class(root, other_color_class,
                                       element.attr("opacity") == 1.0);
                }
            });
    } else {
        toggle_color_class(root, color_class, this.attr("opacity") == 1.0);
    }
};


return Gadfly;

}));


//@ sourceURL=gadfly.js

(function (glob, factory) {
    // AMD support
      if (typeof require === "function" && typeof define === "function" && define.amd) {
        require(["Snap.svg", "Gadfly"], function (Snap, Gadfly) {
            factory(Snap, Gadfly);
        });
      } else {
          factory(glob.Snap, glob.Gadfly);
      }
})(window, function (Snap, Gadfly) {
    var fig = Snap("#fig-a9ec3c81e95b4f6b839742ba6960be33");
fig.select("#fig-a9ec3c81e95b4f6b839742ba6960be33-element-4")
   .mouseenter(Gadfly.plot_mouseover)
.mouseleave(Gadfly.plot_mouseout)
.mousewheel(Gadfly.guide_background_scroll)
.drag(Gadfly.guide_background_drag_onmove,
      Gadfly.guide_background_drag_onstart,
      Gadfly.guide_background_drag_onend)
;
fig.select("#fig-a9ec3c81e95b4f6b839742ba6960be33-element-7")
   .plotroot().data("unfocused_ygrid_color", "#D0D0E0")
;
fig.select("#fig-a9ec3c81e95b4f6b839742ba6960be33-element-7")
   .plotroot().data("focused_ygrid_color", "#A0A0A0")
;
fig.select("#fig-a9ec3c81e95b4f6b839742ba6960be33-element-8")
   .plotroot().data("unfocused_xgrid_color", "#D0D0E0")
;
fig.select("#fig-a9ec3c81e95b4f6b839742ba6960be33-element-8")
   .plotroot().data("focused_xgrid_color", "#A0A0A0")
;
fig.select("#fig-a9ec3c81e95b4f6b839742ba6960be33-element-13")
   .data("mouseover_color", "#cd5c5c")
;
fig.select("#fig-a9ec3c81e95b4f6b839742ba6960be33-element-13")
   .data("mouseout_color", "#6a6a6a")
;
fig.select("#fig-a9ec3c81e95b4f6b839742ba6960be33-element-13")
   .click(Gadfly.zoomslider_zoomin_click)
.mouseenter(Gadfly.zoomslider_button_mouseover)
.mouseleave(Gadfly.zoomslider_button_mouseout)
;
fig.select("#fig-a9ec3c81e95b4f6b839742ba6960be33-element-15")
   .data("max_pos", 120.42)
;
fig.select("#fig-a9ec3c81e95b4f6b839742ba6960be33-element-15")
   .data("min_pos", 103.42)
;
fig.select("#fig-a9ec3c81e95b4f6b839742ba6960be33-element-15")
   .click(Gadfly.zoomslider_track_click);
fig.select("#fig-a9ec3c81e95b4f6b839742ba6960be33-element-16")
   .data("max_pos", 120.42)
;
fig.select("#fig-a9ec3c81e95b4f6b839742ba6960be33-element-16")
   .data("min_pos", 103.42)
;
fig.select("#fig-a9ec3c81e95b4f6b839742ba6960be33-element-16")
   .data("mouseover_color", "#cd5c5c")
;
fig.select("#fig-a9ec3c81e95b4f6b839742ba6960be33-element-16")
   .data("mouseout_color", "#6a6a6a")
;
fig.select("#fig-a9ec3c81e95b4f6b839742ba6960be33-element-16")
   .drag(Gadfly.zoomslider_thumb_dragmove,
     Gadfly.zoomslider_thumb_dragstart,
     Gadfly.zoomslider_thumb_dragend)
.mousedown(Gadfly.zoomslider_thumb_mousedown)
.mouseup(Gadfly.zoomslider_thumb_mouseup)
;
fig.select("#fig-a9ec3c81e95b4f6b839742ba6960be33-element-17")
   .data("mouseover_color", "#cd5c5c")
;
fig.select("#fig-a9ec3c81e95b4f6b839742ba6960be33-element-17")
   .data("mouseout_color", "#6a6a6a")
;
fig.select("#fig-a9ec3c81e95b4f6b839742ba6960be33-element-17")
   .click(Gadfly.zoomslider_zoomout_click)
.mouseenter(Gadfly.zoomslider_button_mouseover)
.mouseleave(Gadfly.zoomslider_button_mouseout)
;
    });
]]> </script>
</svg>





    plot(x=t,y=estb, Guide.XLabel("Time"), Guide.YLabel("b(t)"),Guide.XTicks(ticks=[0:1:10]))





<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg"
     xmlns:xlink="http://www.w3.org/1999/xlink"
     xmlns:gadfly="http://www.gadflyjl.org/ns"
     version="1.2"
     width="141.42mm" height="100mm" viewBox="0 0 141.42 100"
     stroke="none"
     fill="#000000"
     stroke-width="0.3"
     font-size="3.88"

     id="fig-4f8776f47c1745e3b1527a931867061a">
<g class="plotroot xscalable yscalable" id="fig-4f8776f47c1745e3b1527a931867061a-element-1">
  <g font-size="3.88" font-family="'PT Sans','Helvetica Neue','Helvetica',sans-serif" fill="#564A55" stroke="none" id="fig-4f8776f47c1745e3b1527a931867061a-element-2">
    <text x="80.59" y="92" text-anchor="middle">Time</text>
  </g>
  <g class="guide xlabels" font-size="2.82" font-family="'PT Sans Caption','Helvetica Neue','Helvetica',sans-serif" fill="#6C606B" id="fig-4f8776f47c1745e3b1527a931867061a-element-3">
    <text x="26.77" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">0</text>
    <text x="37.53" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">1</text>
    <text x="48.3" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">2</text>
    <text x="59.06" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">3</text>
    <text x="69.83" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">4</text>
    <text x="80.59" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">5</text>
    <text x="91.36" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">6</text>
    <text x="102.12" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">7</text>
    <text x="112.89" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">8</text>
    <text x="123.66" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">9</text>
    <text x="134.42" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">10</text>
  </g>
  <g clip-path="url(#fig-4f8776f47c1745e3b1527a931867061a-element-5)" id="fig-4f8776f47c1745e3b1527a931867061a-element-4">
    <g pointer-events="visible" opacity="1" fill="none" stroke="none" class="guide background" id="fig-4f8776f47c1745e3b1527a931867061a-element-6">
      <rect x="24.77" y="5" width="111.66" height="75.72"/>
    </g>
    <g class="guide ygridlines xfixed" stroke-dasharray="0.5,0.5" stroke-width="0.2" stroke="#D0D0E0" id="fig-4f8776f47c1745e3b1527a931867061a-element-7">
      <path fill="none" d="M24.77,174.34 L 136.42 174.34" gadfly:scale="1.0" visibility="hidden"/>
      <path fill="none" d="M24.77,150.43 L 136.42 150.43" gadfly:scale="1.0" visibility="hidden"/>
      <path fill="none" d="M24.77,126.52 L 136.42 126.52" gadfly:scale="1.0" visibility="hidden"/>
      <path fill="none" d="M24.77,102.62 L 136.42 102.62" gadfly:scale="1.0" visibility="hidden"/>
      <path fill="none" d="M24.77,78.72 L 136.42 78.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M24.77,54.81 L 136.42 54.81" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M24.77,30.9 L 136.42 30.9" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M24.77,7 L 136.42 7" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M24.77,-16.9 L 136.42 -16.9" gadfly:scale="1.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-40.81 L 136.42 -40.81" gadfly:scale="1.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-64.71 L 136.42 -64.71" gadfly:scale="1.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-88.62 L 136.42 -88.62" gadfly:scale="1.0" visibility="hidden"/>
      <path fill="none" d="M24.77,150.43 L 136.42 150.43" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,148.04 L 136.42 148.04" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,145.65 L 136.42 145.65" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,143.26 L 136.42 143.26" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,140.87 L 136.42 140.87" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,138.48 L 136.42 138.48" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,136.09 L 136.42 136.09" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,133.7 L 136.42 133.7" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,131.31 L 136.42 131.31" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,128.92 L 136.42 128.92" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,126.52 L 136.42 126.52" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,124.13 L 136.42 124.13" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,121.74 L 136.42 121.74" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,119.35 L 136.42 119.35" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,116.96 L 136.42 116.96" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,114.57 L 136.42 114.57" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,112.18 L 136.42 112.18" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,109.79 L 136.42 109.79" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,107.4 L 136.42 107.4" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,105.01 L 136.42 105.01" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,102.62 L 136.42 102.62" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,100.23 L 136.42 100.23" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,97.84 L 136.42 97.84" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,95.45 L 136.42 95.45" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,93.06 L 136.42 93.06" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,90.67 L 136.42 90.67" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,88.28 L 136.42 88.28" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,85.89 L 136.42 85.89" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,83.5 L 136.42 83.5" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,81.11 L 136.42 81.11" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,78.72 L 136.42 78.72" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,76.32 L 136.42 76.32" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,73.93 L 136.42 73.93" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,71.54 L 136.42 71.54" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,69.15 L 136.42 69.15" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,66.76 L 136.42 66.76" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,64.37 L 136.42 64.37" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,61.98 L 136.42 61.98" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,59.59 L 136.42 59.59" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,57.2 L 136.42 57.2" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,54.81 L 136.42 54.81" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,52.42 L 136.42 52.42" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,50.03 L 136.42 50.03" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,47.64 L 136.42 47.64" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,45.25 L 136.42 45.25" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,42.86 L 136.42 42.86" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,40.47 L 136.42 40.47" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,38.08 L 136.42 38.08" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,35.69 L 136.42 35.69" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,33.3 L 136.42 33.3" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,30.9 L 136.42 30.9" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,28.51 L 136.42 28.51" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,26.12 L 136.42 26.12" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,23.73 L 136.42 23.73" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,21.34 L 136.42 21.34" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,18.95 L 136.42 18.95" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,16.56 L 136.42 16.56" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,14.17 L 136.42 14.17" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,11.78 L 136.42 11.78" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,9.39 L 136.42 9.39" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,7 L 136.42 7" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,4.61 L 136.42 4.61" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,2.22 L 136.42 2.22" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-0.17 L 136.42 -0.17" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-2.56 L 136.42 -2.56" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-4.95 L 136.42 -4.95" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-7.34 L 136.42 -7.34" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-9.73 L 136.42 -9.73" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-12.12 L 136.42 -12.12" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-14.51 L 136.42 -14.51" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-16.9 L 136.42 -16.9" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-19.3 L 136.42 -19.3" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-21.69 L 136.42 -21.69" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-24.08 L 136.42 -24.08" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-26.47 L 136.42 -26.47" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-28.86 L 136.42 -28.86" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-31.25 L 136.42 -31.25" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-33.64 L 136.42 -33.64" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-36.03 L 136.42 -36.03" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-38.42 L 136.42 -38.42" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-40.81 L 136.42 -40.81" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-43.2 L 136.42 -43.2" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-45.59 L 136.42 -45.59" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-47.98 L 136.42 -47.98" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-50.37 L 136.42 -50.37" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-52.76 L 136.42 -52.76" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-55.15 L 136.42 -55.15" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-57.54 L 136.42 -57.54" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-59.93 L 136.42 -59.93" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-62.32 L 136.42 -62.32" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-64.71 L 136.42 -64.71" gadfly:scale="10.0" visibility="hidden"/>
      <path fill="none" d="M24.77,222.14 L 136.42 222.14" gadfly:scale="0.5" visibility="hidden"/>
      <path fill="none" d="M24.77,126.52 L 136.42 126.52" gadfly:scale="0.5" visibility="hidden"/>
      <path fill="none" d="M24.77,30.9 L 136.42 30.9" gadfly:scale="0.5" visibility="hidden"/>
      <path fill="none" d="M24.77,-64.71 L 136.42 -64.71" gadfly:scale="0.5" visibility="hidden"/>
      <path fill="none" d="M24.77,150.43 L 136.42 150.43" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,145.65 L 136.42 145.65" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,140.87 L 136.42 140.87" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,136.09 L 136.42 136.09" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,131.31 L 136.42 131.31" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,126.52 L 136.42 126.52" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,121.74 L 136.42 121.74" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,116.96 L 136.42 116.96" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,112.18 L 136.42 112.18" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,107.4 L 136.42 107.4" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,102.62 L 136.42 102.62" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,97.84 L 136.42 97.84" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,93.06 L 136.42 93.06" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,88.28 L 136.42 88.28" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,83.5 L 136.42 83.5" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,78.72 L 136.42 78.72" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,73.93 L 136.42 73.93" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,69.15 L 136.42 69.15" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,64.37 L 136.42 64.37" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,59.59 L 136.42 59.59" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,54.81 L 136.42 54.81" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,50.03 L 136.42 50.03" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,45.25 L 136.42 45.25" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,40.47 L 136.42 40.47" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,35.69 L 136.42 35.69" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,30.9 L 136.42 30.9" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,26.12 L 136.42 26.12" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,21.34 L 136.42 21.34" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,16.56 L 136.42 16.56" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,11.78 L 136.42 11.78" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,7 L 136.42 7" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,2.22 L 136.42 2.22" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-2.56 L 136.42 -2.56" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-7.34 L 136.42 -7.34" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-12.12 L 136.42 -12.12" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-16.9 L 136.42 -16.9" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-21.69 L 136.42 -21.69" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-26.47 L 136.42 -26.47" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-31.25 L 136.42 -31.25" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-36.03 L 136.42 -36.03" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-40.81 L 136.42 -40.81" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-45.59 L 136.42 -45.59" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-50.37 L 136.42 -50.37" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-55.15 L 136.42 -55.15" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-59.93 L 136.42 -59.93" gadfly:scale="5.0" visibility="hidden"/>
      <path fill="none" d="M24.77,-64.71 L 136.42 -64.71" gadfly:scale="5.0" visibility="hidden"/>
    </g>
    <g class="guide xgridlines yfixed" stroke-dasharray="0.5,0.5" stroke-width="0.2" stroke="#D0D0E0" id="fig-4f8776f47c1745e3b1527a931867061a-element-8">
      <path fill="none" d="M26.77,5 L 26.77 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M37.53,5 L 37.53 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M48.3,5 L 48.3 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M59.06,5 L 59.06 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M69.83,5 L 69.83 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M80.59,5 L 80.59 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M91.36,5 L 91.36 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M102.12,5 L 102.12 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M112.89,5 L 112.89 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M123.66,5 L 123.66 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M134.42,5 L 134.42 80.72" gadfly:scale="1.0" visibility="visible"/>
    </g>
    <g class="plotpanel" id="fig-4f8776f47c1745e3b1527a931867061a-element-9">
      <g class="geometry" id="fig-4f8776f47c1745e3b1527a931867061a-element-10">
        <g class="color_RGB{Float32}(0.0f0,0.74736935f0,1.0f0)" stroke="#FFFFFF" stroke-width="0.3" fill="#00BFFF" id="fig-4f8776f47c1745e3b1527a931867061a-element-11">
          <circle cx="26.77" cy="75.19" r="0.9"/>
          <circle cx="27.03" cy="21.26" r="0.9"/>
          <circle cx="27.3" cy="21.49" r="0.9"/>
          <circle cx="27.57" cy="22.01" r="0.9"/>
          <circle cx="27.84" cy="22.75" r="0.9"/>
          <circle cx="28.11" cy="23.7" r="0.9"/>
          <circle cx="28.38" cy="24.82" r="0.9"/>
          <circle cx="28.65" cy="26.09" r="0.9"/>
          <circle cx="28.92" cy="27.48" r="0.9"/>
          <circle cx="29.19" cy="28.95" r="0.9"/>
          <circle cx="29.46" cy="30.47" r="0.9"/>
          <circle cx="29.73" cy="32.01" r="0.9"/>
          <circle cx="29.99" cy="33.51" r="0.9"/>
          <circle cx="30.26" cy="34.95" r="0.9"/>
          <circle cx="30.53" cy="36.3" r="0.9"/>
          <circle cx="30.8" cy="37.5" r="0.9"/>
          <circle cx="31.07" cy="38.55" r="0.9"/>
          <circle cx="31.34" cy="39.41" r="0.9"/>
          <circle cx="31.61" cy="40.06" r="0.9"/>
          <circle cx="31.88" cy="40.48" r="0.9"/>
          <circle cx="32.15" cy="40.67" r="0.9"/>
          <circle cx="32.42" cy="40.61" r="0.9"/>
          <circle cx="32.69" cy="40.32" r="0.9"/>
          <circle cx="32.96" cy="39.8" r="0.9"/>
          <circle cx="33.22" cy="39.06" r="0.9"/>
          <circle cx="33.49" cy="38.11" r="0.9"/>
          <circle cx="33.76" cy="36.99" r="0.9"/>
          <circle cx="34.03" cy="35.72" r="0.9"/>
          <circle cx="34.3" cy="34.33" r="0.9"/>
          <circle cx="34.57" cy="32.86" r="0.9"/>
          <circle cx="34.84" cy="31.34" r="0.9"/>
          <circle cx="35.11" cy="29.8" r="0.9"/>
          <circle cx="35.38" cy="28.3" r="0.9"/>
          <circle cx="35.65" cy="26.86" r="0.9"/>
          <circle cx="35.92" cy="25.51" r="0.9"/>
          <circle cx="36.18" cy="24.31" r="0.9"/>
          <circle cx="36.45" cy="23.26" r="0.9"/>
          <circle cx="36.72" cy="22.4" r="0.9"/>
          <circle cx="36.99" cy="21.75" r="0.9"/>
          <circle cx="37.26" cy="21.33" r="0.9"/>
          <circle cx="37.53" cy="21.14" r="0.9"/>
          <circle cx="37.8" cy="21.2" r="0.9"/>
          <circle cx="38.07" cy="21.49" r="0.9"/>
          <circle cx="38.34" cy="22.01" r="0.9"/>
          <circle cx="38.61" cy="22.75" r="0.9"/>
          <circle cx="38.88" cy="23.7" r="0.9"/>
          <circle cx="39.15" cy="24.82" r="0.9"/>
          <circle cx="39.41" cy="26.09" r="0.9"/>
          <circle cx="39.68" cy="27.48" r="0.9"/>
          <circle cx="39.95" cy="28.95" r="0.9"/>
          <circle cx="40.22" cy="30.47" r="0.9"/>
          <circle cx="40.49" cy="32.01" r="0.9"/>
          <circle cx="40.76" cy="33.51" r="0.9"/>
          <circle cx="41.03" cy="34.95" r="0.9"/>
          <circle cx="41.3" cy="36.3" r="0.9"/>
          <circle cx="41.57" cy="37.5" r="0.9"/>
          <circle cx="41.84" cy="38.55" r="0.9"/>
          <circle cx="42.11" cy="39.41" r="0.9"/>
          <circle cx="42.38" cy="40.06" r="0.9"/>
          <circle cx="42.64" cy="40.48" r="0.9"/>
          <circle cx="42.91" cy="40.67" r="0.9"/>
          <circle cx="43.18" cy="40.61" r="0.9"/>
          <circle cx="43.45" cy="40.32" r="0.9"/>
          <circle cx="43.72" cy="39.8" r="0.9"/>
          <circle cx="43.99" cy="39.06" r="0.9"/>
          <circle cx="44.26" cy="38.11" r="0.9"/>
          <circle cx="44.53" cy="36.99" r="0.9"/>
          <circle cx="44.8" cy="35.72" r="0.9"/>
          <circle cx="45.07" cy="34.33" r="0.9"/>
          <circle cx="45.34" cy="32.86" r="0.9"/>
          <circle cx="45.6" cy="31.34" r="0.9"/>
          <circle cx="45.87" cy="29.8" r="0.9"/>
          <circle cx="46.14" cy="28.3" r="0.9"/>
          <circle cx="46.41" cy="26.86" r="0.9"/>
          <circle cx="46.68" cy="25.51" r="0.9"/>
          <circle cx="46.95" cy="24.31" r="0.9"/>
          <circle cx="47.22" cy="23.26" r="0.9"/>
          <circle cx="47.49" cy="22.4" r="0.9"/>
          <circle cx="47.76" cy="21.75" r="0.9"/>
          <circle cx="48.03" cy="21.33" r="0.9"/>
          <circle cx="48.3" cy="21.14" r="0.9"/>
          <circle cx="48.57" cy="21.2" r="0.9"/>
          <circle cx="48.83" cy="21.49" r="0.9"/>
          <circle cx="49.1" cy="22.01" r="0.9"/>
          <circle cx="49.37" cy="22.75" r="0.9"/>
          <circle cx="49.64" cy="23.7" r="0.9"/>
          <circle cx="49.91" cy="24.82" r="0.9"/>
          <circle cx="50.18" cy="26.09" r="0.9"/>
          <circle cx="50.45" cy="27.48" r="0.9"/>
          <circle cx="50.72" cy="28.95" r="0.9"/>
          <circle cx="50.99" cy="30.47" r="0.9"/>
          <circle cx="51.26" cy="32.01" r="0.9"/>
          <circle cx="51.53" cy="33.51" r="0.9"/>
          <circle cx="51.8" cy="34.95" r="0.9"/>
          <circle cx="52.06" cy="36.3" r="0.9"/>
          <circle cx="52.33" cy="37.5" r="0.9"/>
          <circle cx="52.6" cy="38.55" r="0.9"/>
          <circle cx="52.87" cy="39.41" r="0.9"/>
          <circle cx="53.14" cy="40.06" r="0.9"/>
          <circle cx="53.41" cy="40.48" r="0.9"/>
          <circle cx="53.68" cy="40.67" r="0.9"/>
          <circle cx="53.95" cy="40.61" r="0.9"/>
          <circle cx="54.22" cy="40.32" r="0.9"/>
          <circle cx="54.49" cy="39.8" r="0.9"/>
          <circle cx="54.76" cy="39.06" r="0.9"/>
          <circle cx="55.02" cy="38.11" r="0.9"/>
          <circle cx="55.29" cy="36.99" r="0.9"/>
          <circle cx="55.56" cy="35.72" r="0.9"/>
          <circle cx="55.83" cy="34.33" r="0.9"/>
          <circle cx="56.1" cy="32.86" r="0.9"/>
          <circle cx="56.37" cy="31.34" r="0.9"/>
          <circle cx="56.64" cy="29.8" r="0.9"/>
          <circle cx="56.91" cy="28.3" r="0.9"/>
          <circle cx="57.18" cy="26.86" r="0.9"/>
          <circle cx="57.45" cy="25.51" r="0.9"/>
          <circle cx="57.72" cy="24.31" r="0.9"/>
          <circle cx="57.99" cy="23.26" r="0.9"/>
          <circle cx="58.25" cy="22.4" r="0.9"/>
          <circle cx="58.52" cy="21.75" r="0.9"/>
          <circle cx="58.79" cy="21.33" r="0.9"/>
          <circle cx="59.06" cy="21.14" r="0.9"/>
          <circle cx="59.33" cy="21.2" r="0.9"/>
          <circle cx="59.6" cy="21.49" r="0.9"/>
          <circle cx="59.87" cy="22.01" r="0.9"/>
          <circle cx="60.14" cy="22.75" r="0.9"/>
          <circle cx="60.41" cy="23.7" r="0.9"/>
          <circle cx="60.68" cy="24.82" r="0.9"/>
          <circle cx="60.95" cy="26.09" r="0.9"/>
          <circle cx="61.22" cy="27.48" r="0.9"/>
          <circle cx="61.48" cy="28.95" r="0.9"/>
          <circle cx="61.75" cy="30.47" r="0.9"/>
          <circle cx="62.02" cy="32.01" r="0.9"/>
          <circle cx="62.29" cy="33.51" r="0.9"/>
          <circle cx="62.56" cy="34.95" r="0.9"/>
          <circle cx="62.83" cy="36.3" r="0.9"/>
          <circle cx="63.1" cy="37.5" r="0.9"/>
          <circle cx="63.37" cy="38.55" r="0.9"/>
          <circle cx="63.64" cy="39.41" r="0.9"/>
          <circle cx="63.91" cy="40.06" r="0.9"/>
          <circle cx="64.18" cy="40.48" r="0.9"/>
          <circle cx="64.44" cy="40.67" r="0.9"/>
          <circle cx="64.71" cy="40.61" r="0.9"/>
          <circle cx="64.98" cy="40.32" r="0.9"/>
          <circle cx="65.25" cy="39.8" r="0.9"/>
          <circle cx="65.52" cy="39.06" r="0.9"/>
          <circle cx="65.79" cy="38.11" r="0.9"/>
          <circle cx="66.06" cy="36.99" r="0.9"/>
          <circle cx="66.33" cy="35.72" r="0.9"/>
          <circle cx="66.6" cy="34.33" r="0.9"/>
          <circle cx="66.87" cy="32.86" r="0.9"/>
          <circle cx="67.14" cy="31.34" r="0.9"/>
          <circle cx="67.41" cy="29.8" r="0.9"/>
          <circle cx="67.67" cy="28.3" r="0.9"/>
          <circle cx="67.94" cy="26.86" r="0.9"/>
          <circle cx="68.21" cy="25.51" r="0.9"/>
          <circle cx="68.48" cy="24.31" r="0.9"/>
          <circle cx="68.75" cy="23.26" r="0.9"/>
          <circle cx="69.02" cy="22.4" r="0.9"/>
          <circle cx="69.29" cy="21.75" r="0.9"/>
          <circle cx="69.56" cy="21.33" r="0.9"/>
          <circle cx="69.83" cy="21.14" r="0.9"/>
          <circle cx="70.1" cy="21.2" r="0.9"/>
          <circle cx="70.37" cy="21.49" r="0.9"/>
          <circle cx="70.63" cy="22.01" r="0.9"/>
          <circle cx="70.9" cy="22.75" r="0.9"/>
          <circle cx="71.17" cy="23.7" r="0.9"/>
          <circle cx="71.44" cy="24.82" r="0.9"/>
          <circle cx="71.71" cy="26.09" r="0.9"/>
          <circle cx="71.98" cy="27.48" r="0.9"/>
          <circle cx="72.25" cy="28.95" r="0.9"/>
          <circle cx="72.52" cy="30.47" r="0.9"/>
          <circle cx="72.79" cy="32.01" r="0.9"/>
          <circle cx="73.06" cy="33.51" r="0.9"/>
          <circle cx="73.33" cy="34.95" r="0.9"/>
          <circle cx="73.6" cy="36.3" r="0.9"/>
          <circle cx="73.86" cy="37.5" r="0.9"/>
          <circle cx="74.13" cy="38.55" r="0.9"/>
          <circle cx="74.4" cy="39.41" r="0.9"/>
          <circle cx="74.67" cy="40.06" r="0.9"/>
          <circle cx="74.94" cy="40.48" r="0.9"/>
          <circle cx="75.21" cy="40.67" r="0.9"/>
          <circle cx="75.48" cy="40.61" r="0.9"/>
          <circle cx="75.75" cy="40.32" r="0.9"/>
          <circle cx="76.02" cy="39.8" r="0.9"/>
          <circle cx="76.29" cy="39.06" r="0.9"/>
          <circle cx="76.56" cy="38.11" r="0.9"/>
          <circle cx="76.83" cy="36.99" r="0.9"/>
          <circle cx="77.09" cy="35.72" r="0.9"/>
          <circle cx="77.36" cy="34.33" r="0.9"/>
          <circle cx="77.63" cy="32.86" r="0.9"/>
          <circle cx="77.9" cy="31.34" r="0.9"/>
          <circle cx="78.17" cy="29.8" r="0.9"/>
          <circle cx="78.44" cy="28.3" r="0.9"/>
          <circle cx="78.71" cy="26.86" r="0.9"/>
          <circle cx="78.98" cy="25.51" r="0.9"/>
          <circle cx="79.25" cy="24.31" r="0.9"/>
          <circle cx="79.52" cy="23.26" r="0.9"/>
          <circle cx="79.79" cy="22.4" r="0.9"/>
          <circle cx="80.05" cy="21.75" r="0.9"/>
          <circle cx="80.32" cy="21.33" r="0.9"/>
          <circle cx="80.59" cy="21.14" r="0.9"/>
          <circle cx="80.86" cy="21.2" r="0.9"/>
          <circle cx="81.13" cy="21.49" r="0.9"/>
          <circle cx="81.4" cy="22.01" r="0.9"/>
          <circle cx="81.67" cy="22.75" r="0.9"/>
          <circle cx="81.94" cy="23.7" r="0.9"/>
          <circle cx="82.21" cy="24.82" r="0.9"/>
          <circle cx="82.48" cy="26.09" r="0.9"/>
          <circle cx="82.75" cy="27.48" r="0.9"/>
          <circle cx="83.02" cy="28.95" r="0.9"/>
          <circle cx="83.28" cy="30.47" r="0.9"/>
          <circle cx="83.55" cy="32.01" r="0.9"/>
          <circle cx="83.82" cy="33.51" r="0.9"/>
          <circle cx="84.09" cy="34.95" r="0.9"/>
          <circle cx="84.36" cy="36.3" r="0.9"/>
          <circle cx="84.63" cy="37.5" r="0.9"/>
          <circle cx="84.9" cy="38.55" r="0.9"/>
          <circle cx="85.17" cy="39.41" r="0.9"/>
          <circle cx="85.44" cy="40.06" r="0.9"/>
          <circle cx="85.71" cy="40.48" r="0.9"/>
          <circle cx="85.98" cy="40.67" r="0.9"/>
          <circle cx="86.25" cy="40.61" r="0.9"/>
          <circle cx="86.51" cy="40.32" r="0.9"/>
          <circle cx="86.78" cy="39.8" r="0.9"/>
          <circle cx="87.05" cy="39.06" r="0.9"/>
          <circle cx="87.32" cy="38.11" r="0.9"/>
          <circle cx="87.59" cy="36.99" r="0.9"/>
          <circle cx="87.86" cy="35.72" r="0.9"/>
          <circle cx="88.13" cy="34.33" r="0.9"/>
          <circle cx="88.4" cy="32.86" r="0.9"/>
          <circle cx="88.67" cy="31.34" r="0.9"/>
          <circle cx="88.94" cy="29.8" r="0.9"/>
          <circle cx="89.21" cy="28.3" r="0.9"/>
          <circle cx="89.47" cy="26.86" r="0.9"/>
          <circle cx="89.74" cy="25.51" r="0.9"/>
          <circle cx="90.01" cy="24.31" r="0.9"/>
          <circle cx="90.28" cy="23.26" r="0.9"/>
          <circle cx="90.55" cy="22.4" r="0.9"/>
          <circle cx="90.82" cy="21.75" r="0.9"/>
          <circle cx="91.09" cy="21.33" r="0.9"/>
          <circle cx="91.36" cy="21.14" r="0.9"/>
          <circle cx="91.63" cy="21.2" r="0.9"/>
          <circle cx="91.9" cy="21.49" r="0.9"/>
          <circle cx="92.17" cy="22.01" r="0.9"/>
          <circle cx="92.44" cy="22.75" r="0.9"/>
          <circle cx="92.7" cy="23.7" r="0.9"/>
          <circle cx="92.97" cy="24.82" r="0.9"/>
          <circle cx="93.24" cy="26.09" r="0.9"/>
          <circle cx="93.51" cy="27.48" r="0.9"/>
          <circle cx="93.78" cy="28.95" r="0.9"/>
          <circle cx="94.05" cy="30.47" r="0.9"/>
          <circle cx="94.32" cy="32.01" r="0.9"/>
          <circle cx="94.59" cy="33.51" r="0.9"/>
          <circle cx="94.86" cy="34.95" r="0.9"/>
          <circle cx="95.13" cy="36.3" r="0.9"/>
          <circle cx="95.4" cy="37.5" r="0.9"/>
          <circle cx="95.67" cy="38.55" r="0.9"/>
          <circle cx="95.93" cy="39.41" r="0.9"/>
          <circle cx="96.2" cy="40.06" r="0.9"/>
          <circle cx="96.47" cy="40.48" r="0.9"/>
          <circle cx="96.74" cy="40.67" r="0.9"/>
          <circle cx="97.01" cy="40.61" r="0.9"/>
          <circle cx="97.28" cy="40.32" r="0.9"/>
          <circle cx="97.55" cy="39.8" r="0.9"/>
          <circle cx="97.82" cy="39.06" r="0.9"/>
          <circle cx="98.09" cy="38.11" r="0.9"/>
          <circle cx="98.36" cy="36.99" r="0.9"/>
          <circle cx="98.63" cy="35.72" r="0.9"/>
          <circle cx="98.89" cy="34.33" r="0.9"/>
          <circle cx="99.16" cy="32.86" r="0.9"/>
          <circle cx="99.43" cy="31.34" r="0.9"/>
          <circle cx="99.7" cy="29.8" r="0.9"/>
          <circle cx="99.97" cy="28.3" r="0.9"/>
          <circle cx="100.24" cy="26.86" r="0.9"/>
          <circle cx="100.51" cy="25.51" r="0.9"/>
          <circle cx="100.78" cy="24.31" r="0.9"/>
          <circle cx="101.05" cy="23.26" r="0.9"/>
          <circle cx="101.32" cy="22.4" r="0.9"/>
          <circle cx="101.59" cy="21.75" r="0.9"/>
          <circle cx="101.86" cy="21.33" r="0.9"/>
          <circle cx="102.12" cy="21.14" r="0.9"/>
          <circle cx="102.39" cy="21.2" r="0.9"/>
          <circle cx="102.66" cy="21.49" r="0.9"/>
          <circle cx="102.93" cy="22.01" r="0.9"/>
          <circle cx="103.2" cy="22.75" r="0.9"/>
          <circle cx="103.47" cy="23.7" r="0.9"/>
          <circle cx="103.74" cy="24.82" r="0.9"/>
          <circle cx="104.01" cy="26.09" r="0.9"/>
          <circle cx="104.28" cy="27.48" r="0.9"/>
          <circle cx="104.55" cy="28.95" r="0.9"/>
          <circle cx="104.82" cy="30.47" r="0.9"/>
          <circle cx="105.08" cy="32.01" r="0.9"/>
          <circle cx="105.35" cy="33.51" r="0.9"/>
          <circle cx="105.62" cy="34.95" r="0.9"/>
          <circle cx="105.89" cy="36.3" r="0.9"/>
          <circle cx="106.16" cy="37.5" r="0.9"/>
          <circle cx="106.43" cy="38.55" r="0.9"/>
          <circle cx="106.7" cy="39.41" r="0.9"/>
          <circle cx="106.97" cy="40.06" r="0.9"/>
          <circle cx="107.24" cy="40.48" r="0.9"/>
          <circle cx="107.51" cy="40.67" r="0.9"/>
          <circle cx="107.78" cy="40.61" r="0.9"/>
          <circle cx="108.05" cy="40.32" r="0.9"/>
          <circle cx="108.31" cy="39.8" r="0.9"/>
          <circle cx="108.58" cy="39.06" r="0.9"/>
          <circle cx="108.85" cy="38.11" r="0.9"/>
          <circle cx="109.12" cy="36.99" r="0.9"/>
          <circle cx="109.39" cy="35.72" r="0.9"/>
          <circle cx="109.66" cy="34.33" r="0.9"/>
          <circle cx="109.93" cy="32.86" r="0.9"/>
          <circle cx="110.2" cy="31.34" r="0.9"/>
          <circle cx="110.47" cy="29.8" r="0.9"/>
          <circle cx="110.74" cy="28.3" r="0.9"/>
          <circle cx="111.01" cy="26.86" r="0.9"/>
          <circle cx="111.28" cy="25.51" r="0.9"/>
          <circle cx="111.54" cy="24.31" r="0.9"/>
          <circle cx="111.81" cy="23.26" r="0.9"/>
          <circle cx="112.08" cy="22.4" r="0.9"/>
          <circle cx="112.35" cy="21.75" r="0.9"/>
          <circle cx="112.62" cy="21.33" r="0.9"/>
          <circle cx="112.89" cy="21.14" r="0.9"/>
          <circle cx="113.16" cy="21.2" r="0.9"/>
          <circle cx="113.43" cy="21.49" r="0.9"/>
          <circle cx="113.7" cy="22.01" r="0.9"/>
          <circle cx="113.97" cy="22.75" r="0.9"/>
          <circle cx="114.24" cy="23.7" r="0.9"/>
          <circle cx="114.5" cy="24.82" r="0.9"/>
          <circle cx="114.77" cy="26.09" r="0.9"/>
          <circle cx="115.04" cy="27.48" r="0.9"/>
          <circle cx="115.31" cy="28.95" r="0.9"/>
          <circle cx="115.58" cy="30.47" r="0.9"/>
          <circle cx="115.85" cy="32.01" r="0.9"/>
          <circle cx="116.12" cy="33.51" r="0.9"/>
          <circle cx="116.39" cy="34.95" r="0.9"/>
          <circle cx="116.66" cy="36.3" r="0.9"/>
          <circle cx="116.93" cy="37.5" r="0.9"/>
          <circle cx="117.2" cy="38.55" r="0.9"/>
          <circle cx="117.47" cy="39.41" r="0.9"/>
          <circle cx="117.73" cy="40.06" r="0.9"/>
          <circle cx="118" cy="40.48" r="0.9"/>
          <circle cx="118.27" cy="40.67" r="0.9"/>
          <circle cx="118.54" cy="40.61" r="0.9"/>
          <circle cx="118.81" cy="40.32" r="0.9"/>
          <circle cx="119.08" cy="39.8" r="0.9"/>
          <circle cx="119.35" cy="39.06" r="0.9"/>
          <circle cx="119.62" cy="38.11" r="0.9"/>
          <circle cx="119.89" cy="36.99" r="0.9"/>
          <circle cx="120.16" cy="35.72" r="0.9"/>
          <circle cx="120.43" cy="34.33" r="0.9"/>
          <circle cx="120.7" cy="32.86" r="0.9"/>
          <circle cx="120.96" cy="31.34" r="0.9"/>
          <circle cx="121.23" cy="29.8" r="0.9"/>
          <circle cx="121.5" cy="28.3" r="0.9"/>
          <circle cx="121.77" cy="26.86" r="0.9"/>
          <circle cx="122.04" cy="25.51" r="0.9"/>
          <circle cx="122.31" cy="24.31" r="0.9"/>
          <circle cx="122.58" cy="23.26" r="0.9"/>
          <circle cx="122.85" cy="22.4" r="0.9"/>
          <circle cx="123.12" cy="21.75" r="0.9"/>
          <circle cx="123.39" cy="21.33" r="0.9"/>
          <circle cx="123.66" cy="21.14" r="0.9"/>
          <circle cx="123.92" cy="21.2" r="0.9"/>
          <circle cx="124.19" cy="21.49" r="0.9"/>
          <circle cx="124.46" cy="22.01" r="0.9"/>
          <circle cx="124.73" cy="22.75" r="0.9"/>
          <circle cx="125" cy="23.7" r="0.9"/>
          <circle cx="125.27" cy="24.82" r="0.9"/>
          <circle cx="125.54" cy="26.09" r="0.9"/>
          <circle cx="125.81" cy="27.48" r="0.9"/>
          <circle cx="126.08" cy="28.95" r="0.9"/>
          <circle cx="126.35" cy="30.47" r="0.9"/>
          <circle cx="126.62" cy="32.01" r="0.9"/>
          <circle cx="126.89" cy="33.51" r="0.9"/>
          <circle cx="127.15" cy="34.95" r="0.9"/>
          <circle cx="127.42" cy="36.3" r="0.9"/>
          <circle cx="127.69" cy="37.5" r="0.9"/>
          <circle cx="127.96" cy="38.55" r="0.9"/>
          <circle cx="128.23" cy="39.41" r="0.9"/>
          <circle cx="128.5" cy="40.06" r="0.9"/>
          <circle cx="128.77" cy="40.48" r="0.9"/>
          <circle cx="129.04" cy="40.67" r="0.9"/>
          <circle cx="129.31" cy="40.61" r="0.9"/>
          <circle cx="129.58" cy="40.32" r="0.9"/>
          <circle cx="129.85" cy="39.8" r="0.9"/>
          <circle cx="130.12" cy="39.06" r="0.9"/>
          <circle cx="130.38" cy="38.11" r="0.9"/>
          <circle cx="130.65" cy="36.99" r="0.9"/>
          <circle cx="130.92" cy="35.72" r="0.9"/>
          <circle cx="131.19" cy="34.33" r="0.9"/>
          <circle cx="131.46" cy="32.86" r="0.9"/>
          <circle cx="131.73" cy="31.34" r="0.9"/>
          <circle cx="132" cy="29.8" r="0.9"/>
          <circle cx="132.27" cy="28.3" r="0.9"/>
          <circle cx="132.54" cy="26.86" r="0.9"/>
          <circle cx="132.81" cy="25.51" r="0.9"/>
          <circle cx="133.08" cy="24.31" r="0.9"/>
          <circle cx="133.34" cy="23.26" r="0.9"/>
          <circle cx="133.61" cy="22.4" r="0.9"/>
          <circle cx="133.88" cy="21.75" r="0.9"/>
          <circle cx="134.15" cy="21.32" r="0.9"/>
          <circle cx="134.42" cy="30.89" r="0.9"/>
        </g>
      </g>
    </g>
    <g opacity="0" class="guide zoomslider" stroke="none" id="fig-4f8776f47c1745e3b1527a931867061a-element-12">
      <g fill="#EAEAEA" stroke-width="0.3" stroke-opacity="0" stroke="#6A6A6A" id="fig-4f8776f47c1745e3b1527a931867061a-element-13">
        <rect x="129.42" y="8" width="4" height="4"/>
        <g class="button_logo" fill="#6A6A6A" id="fig-4f8776f47c1745e3b1527a931867061a-element-14">
          <path d="M130.22,9.6 L 131.02 9.6 131.02 8.8 131.82 8.8 131.82 9.6 132.62 9.6 132.62 10.4 131.82 10.4 131.82 11.2 131.02 11.2 131.02 10.4 130.22 10.4 z"/>
        </g>
      </g>
      <g fill="#EAEAEA" id="fig-4f8776f47c1745e3b1527a931867061a-element-15">
        <rect x="109.92" y="8" width="19" height="4"/>
      </g>
      <g class="zoomslider_thumb" fill="#6A6A6A" id="fig-4f8776f47c1745e3b1527a931867061a-element-16">
        <rect x="118.42" y="8" width="2" height="4"/>
      </g>
      <g fill="#EAEAEA" stroke-width="0.3" stroke-opacity="0" stroke="#6A6A6A" id="fig-4f8776f47c1745e3b1527a931867061a-element-17">
        <rect x="105.42" y="8" width="4" height="4"/>
        <g class="button_logo" fill="#6A6A6A" id="fig-4f8776f47c1745e3b1527a931867061a-element-18">
          <path d="M106.22,9.6 L 108.62 9.6 108.62 10.4 106.22 10.4 z"/>
        </g>
      </g>
    </g>
  </g>
  <g class="guide ylabels" font-size="2.82" font-family="'PT Sans Caption','Helvetica Neue','Helvetica',sans-serif" fill="#6C606B" id="fig-4f8776f47c1745e3b1527a931867061a-element-19">
    <text x="23.77" y="174.34" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="hidden">-0.0030</text>
    <text x="23.77" y="150.43" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="hidden">-0.0025</text>
    <text x="23.77" y="126.52" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="hidden">-0.0020</text>
    <text x="23.77" y="102.62" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="hidden">-0.0015</text>
    <text x="23.77" y="78.72" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="visible">-0.0010</text>
    <text x="23.77" y="54.81" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="visible">-0.0005</text>
    <text x="23.77" y="30.9" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="visible">0.0000</text>
    <text x="23.77" y="7" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="visible">0.0005</text>
    <text x="23.77" y="-16.9" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="hidden">0.0010</text>
    <text x="23.77" y="-40.81" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="hidden">0.0015</text>
    <text x="23.77" y="-64.71" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="hidden">0.0020</text>
    <text x="23.77" y="-88.62" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="hidden">0.0025</text>
    <text x="23.77" y="150.43" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00250</text>
    <text x="23.77" y="148.04" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00245</text>
    <text x="23.77" y="145.65" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00240</text>
    <text x="23.77" y="143.26" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00235</text>
    <text x="23.77" y="140.87" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00230</text>
    <text x="23.77" y="138.48" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00225</text>
    <text x="23.77" y="136.09" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00220</text>
    <text x="23.77" y="133.7" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00215</text>
    <text x="23.77" y="131.31" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00210</text>
    <text x="23.77" y="128.92" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00205</text>
    <text x="23.77" y="126.52" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00200</text>
    <text x="23.77" y="124.13" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00195</text>
    <text x="23.77" y="121.74" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00190</text>
    <text x="23.77" y="119.35" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00185</text>
    <text x="23.77" y="116.96" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00180</text>
    <text x="23.77" y="114.57" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00175</text>
    <text x="23.77" y="112.18" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00170</text>
    <text x="23.77" y="109.79" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00165</text>
    <text x="23.77" y="107.4" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00160</text>
    <text x="23.77" y="105.01" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00155</text>
    <text x="23.77" y="102.62" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00150</text>
    <text x="23.77" y="100.23" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00145</text>
    <text x="23.77" y="97.84" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00140</text>
    <text x="23.77" y="95.45" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00135</text>
    <text x="23.77" y="93.06" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00130</text>
    <text x="23.77" y="90.67" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00125</text>
    <text x="23.77" y="88.28" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00120</text>
    <text x="23.77" y="85.89" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00115</text>
    <text x="23.77" y="83.5" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00110</text>
    <text x="23.77" y="81.11" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00105</text>
    <text x="23.77" y="78.72" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00100</text>
    <text x="23.77" y="76.32" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00095</text>
    <text x="23.77" y="73.93" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00090</text>
    <text x="23.77" y="71.54" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00085</text>
    <text x="23.77" y="69.15" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00080</text>
    <text x="23.77" y="66.76" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00075</text>
    <text x="23.77" y="64.37" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00070</text>
    <text x="23.77" y="61.98" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00065</text>
    <text x="23.77" y="59.59" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00060</text>
    <text x="23.77" y="57.2" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00055</text>
    <text x="23.77" y="54.81" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00050</text>
    <text x="23.77" y="52.42" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00045</text>
    <text x="23.77" y="50.03" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00040</text>
    <text x="23.77" y="47.64" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00035</text>
    <text x="23.77" y="45.25" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00030</text>
    <text x="23.77" y="42.86" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00025</text>
    <text x="23.77" y="40.47" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00020</text>
    <text x="23.77" y="38.08" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00015</text>
    <text x="23.77" y="35.69" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00010</text>
    <text x="23.77" y="33.3" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">-0.00005</text>
    <text x="23.77" y="30.9" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00000</text>
    <text x="23.77" y="28.51" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00005</text>
    <text x="23.77" y="26.12" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00010</text>
    <text x="23.77" y="23.73" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00015</text>
    <text x="23.77" y="21.34" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00020</text>
    <text x="23.77" y="18.95" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00025</text>
    <text x="23.77" y="16.56" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00030</text>
    <text x="23.77" y="14.17" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00035</text>
    <text x="23.77" y="11.78" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00040</text>
    <text x="23.77" y="9.39" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00045</text>
    <text x="23.77" y="7" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00050</text>
    <text x="23.77" y="4.61" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00055</text>
    <text x="23.77" y="2.22" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00060</text>
    <text x="23.77" y="-0.17" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00065</text>
    <text x="23.77" y="-2.56" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00070</text>
    <text x="23.77" y="-4.95" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00075</text>
    <text x="23.77" y="-7.34" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00080</text>
    <text x="23.77" y="-9.73" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00085</text>
    <text x="23.77" y="-12.12" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00090</text>
    <text x="23.77" y="-14.51" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00095</text>
    <text x="23.77" y="-16.9" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00100</text>
    <text x="23.77" y="-19.3" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00105</text>
    <text x="23.77" y="-21.69" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00110</text>
    <text x="23.77" y="-24.08" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00115</text>
    <text x="23.77" y="-26.47" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00120</text>
    <text x="23.77" y="-28.86" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00125</text>
    <text x="23.77" y="-31.25" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00130</text>
    <text x="23.77" y="-33.64" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00135</text>
    <text x="23.77" y="-36.03" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00140</text>
    <text x="23.77" y="-38.42" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00145</text>
    <text x="23.77" y="-40.81" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00150</text>
    <text x="23.77" y="-43.2" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00155</text>
    <text x="23.77" y="-45.59" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00160</text>
    <text x="23.77" y="-47.98" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00165</text>
    <text x="23.77" y="-50.37" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00170</text>
    <text x="23.77" y="-52.76" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00175</text>
    <text x="23.77" y="-55.15" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00180</text>
    <text x="23.77" y="-57.54" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00185</text>
    <text x="23.77" y="-59.93" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00190</text>
    <text x="23.77" y="-62.32" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00195</text>
    <text x="23.77" y="-64.71" text-anchor="end" dy="0.35em" gadfly:scale="10.0" visibility="hidden">0.00200</text>
    <text x="23.77" y="222.14" text-anchor="end" dy="0.35em" gadfly:scale="0.5" visibility="hidden">-0.004</text>
    <text x="23.77" y="126.52" text-anchor="end" dy="0.35em" gadfly:scale="0.5" visibility="hidden">-0.002</text>
    <text x="23.77" y="30.9" text-anchor="end" dy="0.35em" gadfly:scale="0.5" visibility="hidden">0.000</text>
    <text x="23.77" y="-64.71" text-anchor="end" dy="0.35em" gadfly:scale="0.5" visibility="hidden">0.002</text>
    <text x="23.77" y="150.43" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-0.0025</text>
    <text x="23.77" y="145.65" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-0.0024</text>
    <text x="23.77" y="140.87" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-0.0023</text>
    <text x="23.77" y="136.09" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-0.0022</text>
    <text x="23.77" y="131.31" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-0.0021</text>
    <text x="23.77" y="126.52" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-0.0020</text>
    <text x="23.77" y="121.74" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-0.0019</text>
    <text x="23.77" y="116.96" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-0.0018</text>
    <text x="23.77" y="112.18" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-0.0017</text>
    <text x="23.77" y="107.4" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-0.0016</text>
    <text x="23.77" y="102.62" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-0.0015</text>
    <text x="23.77" y="97.84" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-0.0014</text>
    <text x="23.77" y="93.06" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-0.0013</text>
    <text x="23.77" y="88.28" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-0.0012</text>
    <text x="23.77" y="83.5" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-0.0011</text>
    <text x="23.77" y="78.72" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-0.0010</text>
    <text x="23.77" y="73.93" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-0.0009</text>
    <text x="23.77" y="69.15" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-0.0008</text>
    <text x="23.77" y="64.37" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-0.0007</text>
    <text x="23.77" y="59.59" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-0.0006</text>
    <text x="23.77" y="54.81" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-0.0005</text>
    <text x="23.77" y="50.03" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-0.0004</text>
    <text x="23.77" y="45.25" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-0.0003</text>
    <text x="23.77" y="40.47" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-0.0002</text>
    <text x="23.77" y="35.69" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">-0.0001</text>
    <text x="23.77" y="30.9" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.0000</text>
    <text x="23.77" y="26.12" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.0001</text>
    <text x="23.77" y="21.34" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.0002</text>
    <text x="23.77" y="16.56" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.0003</text>
    <text x="23.77" y="11.78" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.0004</text>
    <text x="23.77" y="7" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.0005</text>
    <text x="23.77" y="2.22" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.0006</text>
    <text x="23.77" y="-2.56" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.0007</text>
    <text x="23.77" y="-7.34" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.0008</text>
    <text x="23.77" y="-12.12" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.0009</text>
    <text x="23.77" y="-16.9" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.0010</text>
    <text x="23.77" y="-21.69" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.0011</text>
    <text x="23.77" y="-26.47" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.0012</text>
    <text x="23.77" y="-31.25" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.0013</text>
    <text x="23.77" y="-36.03" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.0014</text>
    <text x="23.77" y="-40.81" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.0015</text>
    <text x="23.77" y="-45.59" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.0016</text>
    <text x="23.77" y="-50.37" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.0017</text>
    <text x="23.77" y="-55.15" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.0018</text>
    <text x="23.77" y="-59.93" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.0019</text>
    <text x="23.77" y="-64.71" text-anchor="end" dy="0.35em" gadfly:scale="5.0" visibility="hidden">0.0020</text>
  </g>
  <g font-size="3.88" font-family="'PT Sans','Helvetica Neue','Helvetica',sans-serif" fill="#564A55" stroke="none" id="fig-4f8776f47c1745e3b1527a931867061a-element-20">
    <text x="8.81" y="40.86" text-anchor="middle" dy="0.35em" transform="rotate(-90, 8.81, 42.86)">b(t)</text>
  </g>
</g>
<defs>
<clipPath id="fig-4f8776f47c1745e3b1527a931867061a-element-5">
  <path d="M24.77,5 L 136.42 5 136.42 80.72 24.77 80.72" />
</clipPath
></defs>
<script> <![CDATA[
(function(N){var k=/[\.\/]/,L=/\s*,\s*/,C=function(a,d){return a-d},a,v,y={n:{}},M=function(){for(var a=0,d=this.length;a<d;a++)if("undefined"!=typeof this[a])return this[a]},A=function(){for(var a=this.length;--a;)if("undefined"!=typeof this[a])return this[a]},w=function(k,d){k=String(k);var f=v,n=Array.prototype.slice.call(arguments,2),u=w.listeners(k),p=0,b,q=[],e={},l=[],r=a;l.firstDefined=M;l.lastDefined=A;a=k;for(var s=v=0,x=u.length;s<x;s++)"zIndex"in u[s]&&(q.push(u[s].zIndex),0>u[s].zIndex&&
(e[u[s].zIndex]=u[s]));for(q.sort(C);0>q[p];)if(b=e[q[p++] ],l.push(b.apply(d,n)),v)return v=f,l;for(s=0;s<x;s++)if(b=u[s],"zIndex"in b)if(b.zIndex==q[p]){l.push(b.apply(d,n));if(v)break;do if(p++,(b=e[q[p] ])&&l.push(b.apply(d,n)),v)break;while(b)}else e[b.zIndex]=b;else if(l.push(b.apply(d,n)),v)break;v=f;a=r;return l};w._events=y;w.listeners=function(a){a=a.split(k);var d=y,f,n,u,p,b,q,e,l=[d],r=[];u=0;for(p=a.length;u<p;u++){e=[];b=0;for(q=l.length;b<q;b++)for(d=l[b].n,f=[d[a[u] ],d["*"] ],n=2;n--;)if(d=
f[n])e.push(d),r=r.concat(d.f||[]);l=e}return r};w.on=function(a,d){a=String(a);if("function"!=typeof d)return function(){};for(var f=a.split(L),n=0,u=f.length;n<u;n++)(function(a){a=a.split(k);for(var b=y,f,e=0,l=a.length;e<l;e++)b=b.n,b=b.hasOwnProperty(a[e])&&b[a[e] ]||(b[a[e] ]={n:{}});b.f=b.f||[];e=0;for(l=b.f.length;e<l;e++)if(b.f[e]==d){f=!0;break}!f&&b.f.push(d)})(f[n]);return function(a){+a==+a&&(d.zIndex=+a)}};w.f=function(a){var d=[].slice.call(arguments,1);return function(){w.apply(null,
[a,null].concat(d).concat([].slice.call(arguments,0)))}};w.stop=function(){v=1};w.nt=function(k){return k?(new RegExp("(?:\\.|\\/|^)"+k+"(?:\\.|\\/|$)")).test(a):a};w.nts=function(){return a.split(k)};w.off=w.unbind=function(a,d){if(a){var f=a.split(L);if(1<f.length)for(var n=0,u=f.length;n<u;n++)w.off(f[n],d);else{for(var f=a.split(k),p,b,q,e,l=[y],n=0,u=f.length;n<u;n++)for(e=0;e<l.length;e+=q.length-2){q=[e,1];p=l[e].n;if("*"!=f[n])p[f[n] ]&&q.push(p[f[n] ]);else for(b in p)p.hasOwnProperty(b)&&
q.push(p[b]);l.splice.apply(l,q)}n=0;for(u=l.length;n<u;n++)for(p=l[n];p.n;){if(d){if(p.f){e=0;for(f=p.f.length;e<f;e++)if(p.f[e]==d){p.f.splice(e,1);break}!p.f.length&&delete p.f}for(b in p.n)if(p.n.hasOwnProperty(b)&&p.n[b].f){q=p.n[b].f;e=0;for(f=q.length;e<f;e++)if(q[e]==d){q.splice(e,1);break}!q.length&&delete p.n[b].f}}else for(b in delete p.f,p.n)p.n.hasOwnProperty(b)&&p.n[b].f&&delete p.n[b].f;p=p.n}}}else w._events=y={n:{}}};w.once=function(a,d){var f=function(){w.unbind(a,f);return d.apply(this,
arguments)};return w.on(a,f)};w.version="0.4.2";w.toString=function(){return"You are running Eve 0.4.2"};"undefined"!=typeof module&&module.exports?module.exports=w:"function"===typeof define&&define.amd?define("eve",[],function(){return w}):N.eve=w})(this);
(function(N,k){"function"===typeof define&&define.amd?define("Snap.svg",["eve"],function(L){return k(N,L)}):k(N,N.eve)})(this,function(N,k){var L=function(a){var k={},y=N.requestAnimationFrame||N.webkitRequestAnimationFrame||N.mozRequestAnimationFrame||N.oRequestAnimationFrame||N.msRequestAnimationFrame||function(a){setTimeout(a,16)},M=Array.isArray||function(a){return a instanceof Array||"[object Array]"==Object.prototype.toString.call(a)},A=0,w="M"+(+new Date).toString(36),z=function(a){if(null==
a)return this.s;var b=this.s-a;this.b+=this.dur*b;this.B+=this.dur*b;this.s=a},d=function(a){if(null==a)return this.spd;this.spd=a},f=function(a){if(null==a)return this.dur;this.s=this.s*a/this.dur;this.dur=a},n=function(){delete k[this.id];this.update();a("mina.stop."+this.id,this)},u=function(){this.pdif||(delete k[this.id],this.update(),this.pdif=this.get()-this.b)},p=function(){this.pdif&&(this.b=this.get()-this.pdif,delete this.pdif,k[this.id]=this)},b=function(){var a;if(M(this.start)){a=[];
for(var b=0,e=this.start.length;b<e;b++)a[b]=+this.start[b]+(this.end[b]-this.start[b])*this.easing(this.s)}else a=+this.start+(this.end-this.start)*this.easing(this.s);this.set(a)},q=function(){var l=0,b;for(b in k)if(k.hasOwnProperty(b)){var e=k[b],f=e.get();l++;e.s=(f-e.b)/(e.dur/e.spd);1<=e.s&&(delete k[b],e.s=1,l--,function(b){setTimeout(function(){a("mina.finish."+b.id,b)})}(e));e.update()}l&&y(q)},e=function(a,r,s,x,G,h,J){a={id:w+(A++).toString(36),start:a,end:r,b:s,s:0,dur:x-s,spd:1,get:G,
set:h,easing:J||e.linear,status:z,speed:d,duration:f,stop:n,pause:u,resume:p,update:b};k[a.id]=a;r=0;for(var K in k)if(k.hasOwnProperty(K)&&(r++,2==r))break;1==r&&y(q);return a};e.time=Date.now||function(){return+new Date};e.getById=function(a){return k[a]||null};e.linear=function(a){return a};e.easeout=function(a){return Math.pow(a,1.7)};e.easein=function(a){return Math.pow(a,0.48)};e.easeinout=function(a){if(1==a)return 1;if(0==a)return 0;var b=0.48-a/1.04,e=Math.sqrt(0.1734+b*b);a=e-b;a=Math.pow(Math.abs(a),
1/3)*(0>a?-1:1);b=-e-b;b=Math.pow(Math.abs(b),1/3)*(0>b?-1:1);a=a+b+0.5;return 3*(1-a)*a*a+a*a*a};e.backin=function(a){return 1==a?1:a*a*(2.70158*a-1.70158)};e.backout=function(a){if(0==a)return 0;a-=1;return a*a*(2.70158*a+1.70158)+1};e.elastic=function(a){return a==!!a?a:Math.pow(2,-10*a)*Math.sin(2*(a-0.075)*Math.PI/0.3)+1};e.bounce=function(a){a<1/2.75?a*=7.5625*a:a<2/2.75?(a-=1.5/2.75,a=7.5625*a*a+0.75):a<2.5/2.75?(a-=2.25/2.75,a=7.5625*a*a+0.9375):(a-=2.625/2.75,a=7.5625*a*a+0.984375);return a};
return N.mina=e}("undefined"==typeof k?function(){}:k),C=function(){function a(c,t){if(c){if(c.tagName)return x(c);if(y(c,"array")&&a.set)return a.set.apply(a,c);if(c instanceof e)return c;if(null==t)return c=G.doc.querySelector(c),x(c)}return new s(null==c?"100%":c,null==t?"100%":t)}function v(c,a){if(a){"#text"==c&&(c=G.doc.createTextNode(a.text||""));"string"==typeof c&&(c=v(c));if("string"==typeof a)return"xlink:"==a.substring(0,6)?c.getAttributeNS(m,a.substring(6)):"xml:"==a.substring(0,4)?c.getAttributeNS(la,
a.substring(4)):c.getAttribute(a);for(var da in a)if(a[h](da)){var b=J(a[da]);b?"xlink:"==da.substring(0,6)?c.setAttributeNS(m,da.substring(6),b):"xml:"==da.substring(0,4)?c.setAttributeNS(la,da.substring(4),b):c.setAttribute(da,b):c.removeAttribute(da)}}else c=G.doc.createElementNS(la,c);return c}function y(c,a){a=J.prototype.toLowerCase.call(a);return"finite"==a?isFinite(c):"array"==a&&(c instanceof Array||Array.isArray&&Array.isArray(c))?!0:"null"==a&&null===c||a==typeof c&&null!==c||"object"==
a&&c===Object(c)||$.call(c).slice(8,-1).toLowerCase()==a}function M(c){if("function"==typeof c||Object(c)!==c)return c;var a=new c.constructor,b;for(b in c)c[h](b)&&(a[b]=M(c[b]));return a}function A(c,a,b){function m(){var e=Array.prototype.slice.call(arguments,0),f=e.join("\u2400"),d=m.cache=m.cache||{},l=m.count=m.count||[];if(d[h](f)){a:for(var e=l,l=f,B=0,H=e.length;B<H;B++)if(e[B]===l){e.push(e.splice(B,1)[0]);break a}return b?b(d[f]):d[f]}1E3<=l.length&&delete d[l.shift()];l.push(f);d[f]=c.apply(a,
e);return b?b(d[f]):d[f]}return m}function w(c,a,b,m,e,f){return null==e?(c-=b,a-=m,c||a?(180*I.atan2(-a,-c)/C+540)%360:0):w(c,a,e,f)-w(b,m,e,f)}function z(c){return c%360*C/180}function d(c){var a=[];c=c.replace(/(?:^|\s)(\w+)\(([^)]+)\)/g,function(c,b,m){m=m.split(/\s*,\s*|\s+/);"rotate"==b&&1==m.length&&m.push(0,0);"scale"==b&&(2<m.length?m=m.slice(0,2):2==m.length&&m.push(0,0),1==m.length&&m.push(m[0],0,0));"skewX"==b?a.push(["m",1,0,I.tan(z(m[0])),1,0,0]):"skewY"==b?a.push(["m",1,I.tan(z(m[0])),
0,1,0,0]):a.push([b.charAt(0)].concat(m));return c});return a}function f(c,t){var b=O(c),m=new a.Matrix;if(b)for(var e=0,f=b.length;e<f;e++){var h=b[e],d=h.length,B=J(h[0]).toLowerCase(),H=h[0]!=B,l=H?m.invert():0,E;"t"==B&&2==d?m.translate(h[1],0):"t"==B&&3==d?H?(d=l.x(0,0),B=l.y(0,0),H=l.x(h[1],h[2]),l=l.y(h[1],h[2]),m.translate(H-d,l-B)):m.translate(h[1],h[2]):"r"==B?2==d?(E=E||t,m.rotate(h[1],E.x+E.width/2,E.y+E.height/2)):4==d&&(H?(H=l.x(h[2],h[3]),l=l.y(h[2],h[3]),m.rotate(h[1],H,l)):m.rotate(h[1],
h[2],h[3])):"s"==B?2==d||3==d?(E=E||t,m.scale(h[1],h[d-1],E.x+E.width/2,E.y+E.height/2)):4==d?H?(H=l.x(h[2],h[3]),l=l.y(h[2],h[3]),m.scale(h[1],h[1],H,l)):m.scale(h[1],h[1],h[2],h[3]):5==d&&(H?(H=l.x(h[3],h[4]),l=l.y(h[3],h[4]),m.scale(h[1],h[2],H,l)):m.scale(h[1],h[2],h[3],h[4])):"m"==B&&7==d&&m.add(h[1],h[2],h[3],h[4],h[5],h[6])}return m}function n(c,t){if(null==t){var m=!0;t="linearGradient"==c.type||"radialGradient"==c.type?c.node.getAttribute("gradientTransform"):"pattern"==c.type?c.node.getAttribute("patternTransform"):
c.node.getAttribute("transform");if(!t)return new a.Matrix;t=d(t)}else t=a._.rgTransform.test(t)?J(t).replace(/\.{3}|\u2026/g,c._.transform||aa):d(t),y(t,"array")&&(t=a.path?a.path.toString.call(t):J(t)),c._.transform=t;var b=f(t,c.getBBox(1));if(m)return b;c.matrix=b}function u(c){c=c.node.ownerSVGElement&&x(c.node.ownerSVGElement)||c.node.parentNode&&x(c.node.parentNode)||a.select("svg")||a(0,0);var t=c.select("defs"),t=null==t?!1:t.node;t||(t=r("defs",c.node).node);return t}function p(c){return c.node.ownerSVGElement&&
x(c.node.ownerSVGElement)||a.select("svg")}function b(c,a,m){function b(c){if(null==c)return aa;if(c==+c)return c;v(B,{width:c});try{return B.getBBox().width}catch(a){return 0}}function h(c){if(null==c)return aa;if(c==+c)return c;v(B,{height:c});try{return B.getBBox().height}catch(a){return 0}}function e(b,B){null==a?d[b]=B(c.attr(b)||0):b==a&&(d=B(null==m?c.attr(b)||0:m))}var f=p(c).node,d={},B=f.querySelector(".svg---mgr");B||(B=v("rect"),v(B,{x:-9E9,y:-9E9,width:10,height:10,"class":"svg---mgr",
fill:"none"}),f.appendChild(B));switch(c.type){case "rect":e("rx",b),e("ry",h);case "image":e("width",b),e("height",h);case "text":e("x",b);e("y",h);break;case "circle":e("cx",b);e("cy",h);e("r",b);break;case "ellipse":e("cx",b);e("cy",h);e("rx",b);e("ry",h);break;case "line":e("x1",b);e("x2",b);e("y1",h);e("y2",h);break;case "marker":e("refX",b);e("markerWidth",b);e("refY",h);e("markerHeight",h);break;case "radialGradient":e("fx",b);e("fy",h);break;case "tspan":e("dx",b);e("dy",h);break;default:e(a,
b)}f.removeChild(B);return d}function q(c){y(c,"array")||(c=Array.prototype.slice.call(arguments,0));for(var a=0,b=0,m=this.node;this[a];)delete this[a++];for(a=0;a<c.length;a++)"set"==c[a].type?c[a].forEach(function(c){m.appendChild(c.node)}):m.appendChild(c[a].node);for(var h=m.childNodes,a=0;a<h.length;a++)this[b++]=x(h[a]);return this}function e(c){if(c.snap in E)return E[c.snap];var a=this.id=V(),b;try{b=c.ownerSVGElement}catch(m){}this.node=c;b&&(this.paper=new s(b));this.type=c.tagName;this.anims=
{};this._={transform:[]};c.snap=a;E[a]=this;"g"==this.type&&(this.add=q);if(this.type in{g:1,mask:1,pattern:1})for(var e in s.prototype)s.prototype[h](e)&&(this[e]=s.prototype[e])}function l(c){this.node=c}function r(c,a){var b=v(c);a.appendChild(b);return x(b)}function s(c,a){var b,m,f,d=s.prototype;if(c&&"svg"==c.tagName){if(c.snap in E)return E[c.snap];var l=c.ownerDocument;b=new e(c);m=c.getElementsByTagName("desc")[0];f=c.getElementsByTagName("defs")[0];m||(m=v("desc"),m.appendChild(l.createTextNode("Created with Snap")),
b.node.appendChild(m));f||(f=v("defs"),b.node.appendChild(f));b.defs=f;for(var ca in d)d[h](ca)&&(b[ca]=d[ca]);b.paper=b.root=b}else b=r("svg",G.doc.body),v(b.node,{height:a,version:1.1,width:c,xmlns:la});return b}function x(c){return!c||c instanceof e||c instanceof l?c:c.tagName&&"svg"==c.tagName.toLowerCase()?new s(c):c.tagName&&"object"==c.tagName.toLowerCase()&&"image/svg+xml"==c.type?new s(c.contentDocument.getElementsByTagName("svg")[0]):new e(c)}a.version="0.3.0";a.toString=function(){return"Snap v"+
this.version};a._={};var G={win:N,doc:N.document};a._.glob=G;var h="hasOwnProperty",J=String,K=parseFloat,U=parseInt,I=Math,P=I.max,Q=I.min,Y=I.abs,C=I.PI,aa="",$=Object.prototype.toString,F=/^\s*((#[a-f\d]{6})|(#[a-f\d]{3})|rgba?\(\s*([\d\.]+%?\s*,\s*[\d\.]+%?\s*,\s*[\d\.]+%?(?:\s*,\s*[\d\.]+%?)?)\s*\)|hsba?\(\s*([\d\.]+(?:deg|\xb0|%)?\s*,\s*[\d\.]+%?\s*,\s*[\d\.]+(?:%?\s*,\s*[\d\.]+)?%?)\s*\)|hsla?\(\s*([\d\.]+(?:deg|\xb0|%)?\s*,\s*[\d\.]+%?\s*,\s*[\d\.]+(?:%?\s*,\s*[\d\.]+)?%?)\s*\))\s*$/i;a._.separator=
RegExp("[,\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]+");var S=RegExp("[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*"),X={hs:1,rg:1},W=RegExp("([a-z])[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029,]*((-?\\d*\\.?\\d*(?:e[\\-+]?\\d+)?[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,?[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*)+)",
"ig"),ma=RegExp("([rstm])[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029,]*((-?\\d*\\.?\\d*(?:e[\\-+]?\\d+)?[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,?[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*)+)","ig"),Z=RegExp("(-?\\d*\\.?\\d*(?:e[\\-+]?\\d+)?)[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,?[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*",
"ig"),na=0,ba="S"+(+new Date).toString(36),V=function(){return ba+(na++).toString(36)},m="http://www.w3.org/1999/xlink",la="http://www.w3.org/2000/svg",E={},ca=a.url=function(c){return"url('#"+c+"')"};a._.$=v;a._.id=V;a.format=function(){var c=/\{([^\}]+)\}/g,a=/(?:(?:^|\.)(.+?)(?=\[|\.|$|\()|\[('|")(.+?)\2\])(\(\))?/g,b=function(c,b,m){var h=m;b.replace(a,function(c,a,b,m,t){a=a||m;h&&(a in h&&(h=h[a]),"function"==typeof h&&t&&(h=h()))});return h=(null==h||h==m?c:h)+""};return function(a,m){return J(a).replace(c,
function(c,a){return b(c,a,m)})}}();a._.clone=M;a._.cacher=A;a.rad=z;a.deg=function(c){return 180*c/C%360};a.angle=w;a.is=y;a.snapTo=function(c,a,b){b=y(b,"finite")?b:10;if(y(c,"array"))for(var m=c.length;m--;){if(Y(c[m]-a)<=b)return c[m]}else{c=+c;m=a%c;if(m<b)return a-m;if(m>c-b)return a-m+c}return a};a.getRGB=A(function(c){if(!c||(c=J(c)).indexOf("-")+1)return{r:-1,g:-1,b:-1,hex:"none",error:1,toString:ka};if("none"==c)return{r:-1,g:-1,b:-1,hex:"none",toString:ka};!X[h](c.toLowerCase().substring(0,
2))&&"#"!=c.charAt()&&(c=T(c));if(!c)return{r:-1,g:-1,b:-1,hex:"none",error:1,toString:ka};var b,m,e,f,d;if(c=c.match(F)){c[2]&&(e=U(c[2].substring(5),16),m=U(c[2].substring(3,5),16),b=U(c[2].substring(1,3),16));c[3]&&(e=U((d=c[3].charAt(3))+d,16),m=U((d=c[3].charAt(2))+d,16),b=U((d=c[3].charAt(1))+d,16));c[4]&&(d=c[4].split(S),b=K(d[0]),"%"==d[0].slice(-1)&&(b*=2.55),m=K(d[1]),"%"==d[1].slice(-1)&&(m*=2.55),e=K(d[2]),"%"==d[2].slice(-1)&&(e*=2.55),"rgba"==c[1].toLowerCase().slice(0,4)&&(f=K(d[3])),
d[3]&&"%"==d[3].slice(-1)&&(f/=100));if(c[5])return d=c[5].split(S),b=K(d[0]),"%"==d[0].slice(-1)&&(b/=100),m=K(d[1]),"%"==d[1].slice(-1)&&(m/=100),e=K(d[2]),"%"==d[2].slice(-1)&&(e/=100),"deg"!=d[0].slice(-3)&&"\u00b0"!=d[0].slice(-1)||(b/=360),"hsba"==c[1].toLowerCase().slice(0,4)&&(f=K(d[3])),d[3]&&"%"==d[3].slice(-1)&&(f/=100),a.hsb2rgb(b,m,e,f);if(c[6])return d=c[6].split(S),b=K(d[0]),"%"==d[0].slice(-1)&&(b/=100),m=K(d[1]),"%"==d[1].slice(-1)&&(m/=100),e=K(d[2]),"%"==d[2].slice(-1)&&(e/=100),
"deg"!=d[0].slice(-3)&&"\u00b0"!=d[0].slice(-1)||(b/=360),"hsla"==c[1].toLowerCase().slice(0,4)&&(f=K(d[3])),d[3]&&"%"==d[3].slice(-1)&&(f/=100),a.hsl2rgb(b,m,e,f);b=Q(I.round(b),255);m=Q(I.round(m),255);e=Q(I.round(e),255);f=Q(P(f,0),1);c={r:b,g:m,b:e,toString:ka};c.hex="#"+(16777216|e|m<<8|b<<16).toString(16).slice(1);c.opacity=y(f,"finite")?f:1;return c}return{r:-1,g:-1,b:-1,hex:"none",error:1,toString:ka}},a);a.hsb=A(function(c,b,m){return a.hsb2rgb(c,b,m).hex});a.hsl=A(function(c,b,m){return a.hsl2rgb(c,
b,m).hex});a.rgb=A(function(c,a,b,m){if(y(m,"finite")){var e=I.round;return"rgba("+[e(c),e(a),e(b),+m.toFixed(2)]+")"}return"#"+(16777216|b|a<<8|c<<16).toString(16).slice(1)});var T=function(c){var a=G.doc.getElementsByTagName("head")[0]||G.doc.getElementsByTagName("svg")[0];T=A(function(c){if("red"==c.toLowerCase())return"rgb(255, 0, 0)";a.style.color="rgb(255, 0, 0)";a.style.color=c;c=G.doc.defaultView.getComputedStyle(a,aa).getPropertyValue("color");return"rgb(255, 0, 0)"==c?null:c});return T(c)},
qa=function(){return"hsb("+[this.h,this.s,this.b]+")"},ra=function(){return"hsl("+[this.h,this.s,this.l]+")"},ka=function(){return 1==this.opacity||null==this.opacity?this.hex:"rgba("+[this.r,this.g,this.b,this.opacity]+")"},D=function(c,b,m){null==b&&y(c,"object")&&"r"in c&&"g"in c&&"b"in c&&(m=c.b,b=c.g,c=c.r);null==b&&y(c,string)&&(m=a.getRGB(c),c=m.r,b=m.g,m=m.b);if(1<c||1<b||1<m)c/=255,b/=255,m/=255;return[c,b,m]},oa=function(c,b,m,e){c=I.round(255*c);b=I.round(255*b);m=I.round(255*m);c={r:c,
g:b,b:m,opacity:y(e,"finite")?e:1,hex:a.rgb(c,b,m),toString:ka};y(e,"finite")&&(c.opacity=e);return c};a.color=function(c){var b;y(c,"object")&&"h"in c&&"s"in c&&"b"in c?(b=a.hsb2rgb(c),c.r=b.r,c.g=b.g,c.b=b.b,c.opacity=1,c.hex=b.hex):y(c,"object")&&"h"in c&&"s"in c&&"l"in c?(b=a.hsl2rgb(c),c.r=b.r,c.g=b.g,c.b=b.b,c.opacity=1,c.hex=b.hex):(y(c,"string")&&(c=a.getRGB(c)),y(c,"object")&&"r"in c&&"g"in c&&"b"in c&&!("error"in c)?(b=a.rgb2hsl(c),c.h=b.h,c.s=b.s,c.l=b.l,b=a.rgb2hsb(c),c.v=b.b):(c={hex:"none"},
c.r=c.g=c.b=c.h=c.s=c.v=c.l=-1,c.error=1));c.toString=ka;return c};a.hsb2rgb=function(c,a,b,m){y(c,"object")&&"h"in c&&"s"in c&&"b"in c&&(b=c.b,a=c.s,c=c.h,m=c.o);var e,h,d;c=360*c%360/60;d=b*a;a=d*(1-Y(c%2-1));b=e=h=b-d;c=~~c;b+=[d,a,0,0,a,d][c];e+=[a,d,d,a,0,0][c];h+=[0,0,a,d,d,a][c];return oa(b,e,h,m)};a.hsl2rgb=function(c,a,b,m){y(c,"object")&&"h"in c&&"s"in c&&"l"in c&&(b=c.l,a=c.s,c=c.h);if(1<c||1<a||1<b)c/=360,a/=100,b/=100;var e,h,d;c=360*c%360/60;d=2*a*(0.5>b?b:1-b);a=d*(1-Y(c%2-1));b=e=
h=b-d/2;c=~~c;b+=[d,a,0,0,a,d][c];e+=[a,d,d,a,0,0][c];h+=[0,0,a,d,d,a][c];return oa(b,e,h,m)};a.rgb2hsb=function(c,a,b){b=D(c,a,b);c=b[0];a=b[1];b=b[2];var m,e;m=P(c,a,b);e=m-Q(c,a,b);c=((0==e?0:m==c?(a-b)/e:m==a?(b-c)/e+2:(c-a)/e+4)+360)%6*60/360;return{h:c,s:0==e?0:e/m,b:m,toString:qa}};a.rgb2hsl=function(c,a,b){b=D(c,a,b);c=b[0];a=b[1];b=b[2];var m,e,h;m=P(c,a,b);e=Q(c,a,b);h=m-e;c=((0==h?0:m==c?(a-b)/h:m==a?(b-c)/h+2:(c-a)/h+4)+360)%6*60/360;m=(m+e)/2;return{h:c,s:0==h?0:0.5>m?h/(2*m):h/(2-2*
m),l:m,toString:ra}};a.parsePathString=function(c){if(!c)return null;var b=a.path(c);if(b.arr)return a.path.clone(b.arr);var m={a:7,c:6,o:2,h:1,l:2,m:2,r:4,q:4,s:4,t:2,v:1,u:3,z:0},e=[];y(c,"array")&&y(c[0],"array")&&(e=a.path.clone(c));e.length||J(c).replace(W,function(c,a,b){var h=[];c=a.toLowerCase();b.replace(Z,function(c,a){a&&h.push(+a)});"m"==c&&2<h.length&&(e.push([a].concat(h.splice(0,2))),c="l",a="m"==a?"l":"L");"o"==c&&1==h.length&&e.push([a,h[0] ]);if("r"==c)e.push([a].concat(h));else for(;h.length>=
m[c]&&(e.push([a].concat(h.splice(0,m[c]))),m[c]););});e.toString=a.path.toString;b.arr=a.path.clone(e);return e};var O=a.parseTransformString=function(c){if(!c)return null;var b=[];y(c,"array")&&y(c[0],"array")&&(b=a.path.clone(c));b.length||J(c).replace(ma,function(c,a,m){var e=[];a.toLowerCase();m.replace(Z,function(c,a){a&&e.push(+a)});b.push([a].concat(e))});b.toString=a.path.toString;return b};a._.svgTransform2string=d;a._.rgTransform=RegExp("^[a-z][\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*-?\\.?\\d",
"i");a._.transform2matrix=f;a._unit2px=b;a._.getSomeDefs=u;a._.getSomeSVG=p;a.select=function(c){return x(G.doc.querySelector(c))};a.selectAll=function(c){c=G.doc.querySelectorAll(c);for(var b=(a.set||Array)(),m=0;m<c.length;m++)b.push(x(c[m]));return b};setInterval(function(){for(var c in E)if(E[h](c)){var a=E[c],b=a.node;("svg"!=a.type&&!b.ownerSVGElement||"svg"==a.type&&(!b.parentNode||"ownerSVGElement"in b.parentNode&&!b.ownerSVGElement))&&delete E[c]}},1E4);(function(c){function m(c){function a(c,
b){var m=v(c.node,b);(m=(m=m&&m.match(d))&&m[2])&&"#"==m.charAt()&&(m=m.substring(1))&&(f[m]=(f[m]||[]).concat(function(a){var m={};m[b]=ca(a);v(c.node,m)}))}function b(c){var a=v(c.node,"xlink:href");a&&"#"==a.charAt()&&(a=a.substring(1))&&(f[a]=(f[a]||[]).concat(function(a){c.attr("xlink:href","#"+a)}))}var e=c.selectAll("*"),h,d=/^\s*url\(("|'|)(.*)\1\)\s*$/;c=[];for(var f={},l=0,E=e.length;l<E;l++){h=e[l];a(h,"fill");a(h,"stroke");a(h,"filter");a(h,"mask");a(h,"clip-path");b(h);var t=v(h.node,
"id");t&&(v(h.node,{id:h.id}),c.push({old:t,id:h.id}))}l=0;for(E=c.length;l<E;l++)if(e=f[c[l].old])for(h=0,t=e.length;h<t;h++)e[h](c[l].id)}function e(c,a,b){return function(m){m=m.slice(c,a);1==m.length&&(m=m[0]);return b?b(m):m}}function d(c){return function(){var a=c?"<"+this.type:"",b=this.node.attributes,m=this.node.childNodes;if(c)for(var e=0,h=b.length;e<h;e++)a+=" "+b[e].name+'="'+b[e].value.replace(/"/g,'\\"')+'"';if(m.length){c&&(a+=">");e=0;for(h=m.length;e<h;e++)3==m[e].nodeType?a+=m[e].nodeValue:
1==m[e].nodeType&&(a+=x(m[e]).toString());c&&(a+="</"+this.type+">")}else c&&(a+="/>");return a}}c.attr=function(c,a){if(!c)return this;if(y(c,"string"))if(1<arguments.length){var b={};b[c]=a;c=b}else return k("snap.util.getattr."+c,this).firstDefined();for(var m in c)c[h](m)&&k("snap.util.attr."+m,this,c[m]);return this};c.getBBox=function(c){if(!a.Matrix||!a.path)return this.node.getBBox();var b=this,m=new a.Matrix;if(b.removed)return a._.box();for(;"use"==b.type;)if(c||(m=m.add(b.transform().localMatrix.translate(b.attr("x")||
0,b.attr("y")||0))),b.original)b=b.original;else var e=b.attr("xlink:href"),b=b.original=b.node.ownerDocument.getElementById(e.substring(e.indexOf("#")+1));var e=b._,h=a.path.get[b.type]||a.path.get.deflt;try{if(c)return e.bboxwt=h?a.path.getBBox(b.realPath=h(b)):a._.box(b.node.getBBox()),a._.box(e.bboxwt);b.realPath=h(b);b.matrix=b.transform().localMatrix;e.bbox=a.path.getBBox(a.path.map(b.realPath,m.add(b.matrix)));return a._.box(e.bbox)}catch(d){return a._.box()}};var f=function(){return this.string};
c.transform=function(c){var b=this._;if(null==c){var m=this;c=new a.Matrix(this.node.getCTM());for(var e=n(this),h=[e],d=new a.Matrix,l=e.toTransformString(),b=J(e)==J(this.matrix)?J(b.transform):l;"svg"!=m.type&&(m=m.parent());)h.push(n(m));for(m=h.length;m--;)d.add(h[m]);return{string:b,globalMatrix:c,totalMatrix:d,localMatrix:e,diffMatrix:c.clone().add(e.invert()),global:c.toTransformString(),total:d.toTransformString(),local:l,toString:f}}c instanceof a.Matrix?this.matrix=c:n(this,c);this.node&&
("linearGradient"==this.type||"radialGradient"==this.type?v(this.node,{gradientTransform:this.matrix}):"pattern"==this.type?v(this.node,{patternTransform:this.matrix}):v(this.node,{transform:this.matrix}));return this};c.parent=function(){return x(this.node.parentNode)};c.append=c.add=function(c){if(c){if("set"==c.type){var a=this;c.forEach(function(c){a.add(c)});return this}c=x(c);this.node.appendChild(c.node);c.paper=this.paper}return this};c.appendTo=function(c){c&&(c=x(c),c.append(this));return this};
c.prepend=function(c){if(c){if("set"==c.type){var a=this,b;c.forEach(function(c){b?b.after(c):a.prepend(c);b=c});return this}c=x(c);var m=c.parent();this.node.insertBefore(c.node,this.node.firstChild);this.add&&this.add();c.paper=this.paper;this.parent()&&this.parent().add();m&&m.add()}return this};c.prependTo=function(c){c=x(c);c.prepend(this);return this};c.before=function(c){if("set"==c.type){var a=this;c.forEach(function(c){var b=c.parent();a.node.parentNode.insertBefore(c.node,a.node);b&&b.add()});
this.parent().add();return this}c=x(c);var b=c.parent();this.node.parentNode.insertBefore(c.node,this.node);this.parent()&&this.parent().add();b&&b.add();c.paper=this.paper;return this};c.after=function(c){c=x(c);var a=c.parent();this.node.nextSibling?this.node.parentNode.insertBefore(c.node,this.node.nextSibling):this.node.parentNode.appendChild(c.node);this.parent()&&this.parent().add();a&&a.add();c.paper=this.paper;return this};c.insertBefore=function(c){c=x(c);var a=this.parent();c.node.parentNode.insertBefore(this.node,
c.node);this.paper=c.paper;a&&a.add();c.parent()&&c.parent().add();return this};c.insertAfter=function(c){c=x(c);var a=this.parent();c.node.parentNode.insertBefore(this.node,c.node.nextSibling);this.paper=c.paper;a&&a.add();c.parent()&&c.parent().add();return this};c.remove=function(){var c=this.parent();this.node.parentNode&&this.node.parentNode.removeChild(this.node);delete this.paper;this.removed=!0;c&&c.add();return this};c.select=function(c){return x(this.node.querySelector(c))};c.selectAll=
function(c){c=this.node.querySelectorAll(c);for(var b=(a.set||Array)(),m=0;m<c.length;m++)b.push(x(c[m]));return b};c.asPX=function(c,a){null==a&&(a=this.attr(c));return+b(this,c,a)};c.use=function(){var c,a=this.node.id;a||(a=this.id,v(this.node,{id:a}));c="linearGradient"==this.type||"radialGradient"==this.type||"pattern"==this.type?r(this.type,this.node.parentNode):r("use",this.node.parentNode);v(c.node,{"xlink:href":"#"+a});c.original=this;return c};var l=/\S+/g;c.addClass=function(c){var a=(c||
"").match(l)||[];c=this.node;var b=c.className.baseVal,m=b.match(l)||[],e,h,d;if(a.length){for(e=0;d=a[e++];)h=m.indexOf(d),~h||m.push(d);a=m.join(" ");b!=a&&(c.className.baseVal=a)}return this};c.removeClass=function(c){var a=(c||"").match(l)||[];c=this.node;var b=c.className.baseVal,m=b.match(l)||[],e,h;if(m.length){for(e=0;h=a[e++];)h=m.indexOf(h),~h&&m.splice(h,1);a=m.join(" ");b!=a&&(c.className.baseVal=a)}return this};c.hasClass=function(c){return!!~(this.node.className.baseVal.match(l)||[]).indexOf(c)};
c.toggleClass=function(c,a){if(null!=a)return a?this.addClass(c):this.removeClass(c);var b=(c||"").match(l)||[],m=this.node,e=m.className.baseVal,h=e.match(l)||[],d,f,E;for(d=0;E=b[d++];)f=h.indexOf(E),~f?h.splice(f,1):h.push(E);b=h.join(" ");e!=b&&(m.className.baseVal=b);return this};c.clone=function(){var c=x(this.node.cloneNode(!0));v(c.node,"id")&&v(c.node,{id:c.id});m(c);c.insertAfter(this);return c};c.toDefs=function(){u(this).appendChild(this.node);return this};c.pattern=c.toPattern=function(c,
a,b,m){var e=r("pattern",u(this));null==c&&(c=this.getBBox());y(c,"object")&&"x"in c&&(a=c.y,b=c.width,m=c.height,c=c.x);v(e.node,{x:c,y:a,width:b,height:m,patternUnits:"userSpaceOnUse",id:e.id,viewBox:[c,a,b,m].join(" ")});e.node.appendChild(this.node);return e};c.marker=function(c,a,b,m,e,h){var d=r("marker",u(this));null==c&&(c=this.getBBox());y(c,"object")&&"x"in c&&(a=c.y,b=c.width,m=c.height,e=c.refX||c.cx,h=c.refY||c.cy,c=c.x);v(d.node,{viewBox:[c,a,b,m].join(" "),markerWidth:b,markerHeight:m,
orient:"auto",refX:e||0,refY:h||0,id:d.id});d.node.appendChild(this.node);return d};var E=function(c,a,b,m){"function"!=typeof b||b.length||(m=b,b=L.linear);this.attr=c;this.dur=a;b&&(this.easing=b);m&&(this.callback=m)};a._.Animation=E;a.animation=function(c,a,b,m){return new E(c,a,b,m)};c.inAnim=function(){var c=[],a;for(a in this.anims)this.anims[h](a)&&function(a){c.push({anim:new E(a._attrs,a.dur,a.easing,a._callback),mina:a,curStatus:a.status(),status:function(c){return a.status(c)},stop:function(){a.stop()}})}(this.anims[a]);
return c};a.animate=function(c,a,b,m,e,h){"function"!=typeof e||e.length||(h=e,e=L.linear);var d=L.time();c=L(c,a,d,d+m,L.time,b,e);h&&k.once("mina.finish."+c.id,h);return c};c.stop=function(){for(var c=this.inAnim(),a=0,b=c.length;a<b;a++)c[a].stop();return this};c.animate=function(c,a,b,m){"function"!=typeof b||b.length||(m=b,b=L.linear);c instanceof E&&(m=c.callback,b=c.easing,a=b.dur,c=c.attr);var d=[],f=[],l={},t,ca,n,T=this,q;for(q in c)if(c[h](q)){T.equal?(n=T.equal(q,J(c[q])),t=n.from,ca=
n.to,n=n.f):(t=+T.attr(q),ca=+c[q]);var la=y(t,"array")?t.length:1;l[q]=e(d.length,d.length+la,n);d=d.concat(t);f=f.concat(ca)}t=L.time();var p=L(d,f,t,t+a,L.time,function(c){var a={},b;for(b in l)l[h](b)&&(a[b]=l[b](c));T.attr(a)},b);T.anims[p.id]=p;p._attrs=c;p._callback=m;k("snap.animcreated."+T.id,p);k.once("mina.finish."+p.id,function(){delete T.anims[p.id];m&&m.call(T)});k.once("mina.stop."+p.id,function(){delete T.anims[p.id]});return T};var T={};c.data=function(c,b){var m=T[this.id]=T[this.id]||
{};if(0==arguments.length)return k("snap.data.get."+this.id,this,m,null),m;if(1==arguments.length){if(a.is(c,"object")){for(var e in c)c[h](e)&&this.data(e,c[e]);return this}k("snap.data.get."+this.id,this,m[c],c);return m[c]}m[c]=b;k("snap.data.set."+this.id,this,b,c);return this};c.removeData=function(c){null==c?T[this.id]={}:T[this.id]&&delete T[this.id][c];return this};c.outerSVG=c.toString=d(1);c.innerSVG=d()})(e.prototype);a.parse=function(c){var a=G.doc.createDocumentFragment(),b=!0,m=G.doc.createElement("div");
c=J(c);c.match(/^\s*<\s*svg(?:\s|>)/)||(c="<svg>"+c+"</svg>",b=!1);m.innerHTML=c;if(c=m.getElementsByTagName("svg")[0])if(b)a=c;else for(;c.firstChild;)a.appendChild(c.firstChild);m.innerHTML=aa;return new l(a)};l.prototype.select=e.prototype.select;l.prototype.selectAll=e.prototype.selectAll;a.fragment=function(){for(var c=Array.prototype.slice.call(arguments,0),b=G.doc.createDocumentFragment(),m=0,e=c.length;m<e;m++){var h=c[m];h.node&&h.node.nodeType&&b.appendChild(h.node);h.nodeType&&b.appendChild(h);
"string"==typeof h&&b.appendChild(a.parse(h).node)}return new l(b)};a._.make=r;a._.wrap=x;s.prototype.el=function(c,a){var b=r(c,this.node);a&&b.attr(a);return b};k.on("snap.util.getattr",function(){var c=k.nt(),c=c.substring(c.lastIndexOf(".")+1),a=c.replace(/[A-Z]/g,function(c){return"-"+c.toLowerCase()});return pa[h](a)?this.node.ownerDocument.defaultView.getComputedStyle(this.node,null).getPropertyValue(a):v(this.node,c)});var pa={"alignment-baseline":0,"baseline-shift":0,clip:0,"clip-path":0,
"clip-rule":0,color:0,"color-interpolation":0,"color-interpolation-filters":0,"color-profile":0,"color-rendering":0,cursor:0,direction:0,display:0,"dominant-baseline":0,"enable-background":0,fill:0,"fill-opacity":0,"fill-rule":0,filter:0,"flood-color":0,"flood-opacity":0,font:0,"font-family":0,"font-size":0,"font-size-adjust":0,"font-stretch":0,"font-style":0,"font-variant":0,"font-weight":0,"glyph-orientation-horizontal":0,"glyph-orientation-vertical":0,"image-rendering":0,kerning:0,"letter-spacing":0,
"lighting-color":0,marker:0,"marker-end":0,"marker-mid":0,"marker-start":0,mask:0,opacity:0,overflow:0,"pointer-events":0,"shape-rendering":0,"stop-color":0,"stop-opacity":0,stroke:0,"stroke-dasharray":0,"stroke-dashoffset":0,"stroke-linecap":0,"stroke-linejoin":0,"stroke-miterlimit":0,"stroke-opacity":0,"stroke-width":0,"text-anchor":0,"text-decoration":0,"text-rendering":0,"unicode-bidi":0,visibility:0,"word-spacing":0,"writing-mode":0};k.on("snap.util.attr",function(c){var a=k.nt(),b={},a=a.substring(a.lastIndexOf(".")+
1);b[a]=c;var m=a.replace(/-(\w)/gi,function(c,a){return a.toUpperCase()}),a=a.replace(/[A-Z]/g,function(c){return"-"+c.toLowerCase()});pa[h](a)?this.node.style[m]=null==c?aa:c:v(this.node,b)});a.ajax=function(c,a,b,m){var e=new XMLHttpRequest,h=V();if(e){if(y(a,"function"))m=b,b=a,a=null;else if(y(a,"object")){var d=[],f;for(f in a)a.hasOwnProperty(f)&&d.push(encodeURIComponent(f)+"="+encodeURIComponent(a[f]));a=d.join("&")}e.open(a?"POST":"GET",c,!0);a&&(e.setRequestHeader("X-Requested-With","XMLHttpRequest"),
e.setRequestHeader("Content-type","application/x-www-form-urlencoded"));b&&(k.once("snap.ajax."+h+".0",b),k.once("snap.ajax."+h+".200",b),k.once("snap.ajax."+h+".304",b));e.onreadystatechange=function(){4==e.readyState&&k("snap.ajax."+h+"."+e.status,m,e)};if(4==e.readyState)return e;e.send(a);return e}};a.load=function(c,b,m){a.ajax(c,function(c){c=a.parse(c.responseText);m?b.call(m,c):b(c)})};a.getElementByPoint=function(c,a){var b,m,e=G.doc.elementFromPoint(c,a);if(G.win.opera&&"svg"==e.tagName){b=
e;m=b.getBoundingClientRect();b=b.ownerDocument;var h=b.body,d=b.documentElement;b=m.top+(g.win.pageYOffset||d.scrollTop||h.scrollTop)-(d.clientTop||h.clientTop||0);m=m.left+(g.win.pageXOffset||d.scrollLeft||h.scrollLeft)-(d.clientLeft||h.clientLeft||0);h=e.createSVGRect();h.x=c-m;h.y=a-b;h.width=h.height=1;b=e.getIntersectionList(h,null);b.length&&(e=b[b.length-1])}return e?x(e):null};a.plugin=function(c){c(a,e,s,G,l)};return G.win.Snap=a}();C.plugin(function(a,k,y,M,A){function w(a,d,f,b,q,e){null==
d&&"[object SVGMatrix]"==z.call(a)?(this.a=a.a,this.b=a.b,this.c=a.c,this.d=a.d,this.e=a.e,this.f=a.f):null!=a?(this.a=+a,this.b=+d,this.c=+f,this.d=+b,this.e=+q,this.f=+e):(this.a=1,this.c=this.b=0,this.d=1,this.f=this.e=0)}var z=Object.prototype.toString,d=String,f=Math;(function(n){function k(a){return a[0]*a[0]+a[1]*a[1]}function p(a){var d=f.sqrt(k(a));a[0]&&(a[0]/=d);a[1]&&(a[1]/=d)}n.add=function(a,d,e,f,n,p){var k=[[],[],[] ],u=[[this.a,this.c,this.e],[this.b,this.d,this.f],[0,0,1] ];d=[[a,
e,n],[d,f,p],[0,0,1] ];a&&a instanceof w&&(d=[[a.a,a.c,a.e],[a.b,a.d,a.f],[0,0,1] ]);for(a=0;3>a;a++)for(e=0;3>e;e++){for(f=n=0;3>f;f++)n+=u[a][f]*d[f][e];k[a][e]=n}this.a=k[0][0];this.b=k[1][0];this.c=k[0][1];this.d=k[1][1];this.e=k[0][2];this.f=k[1][2];return this};n.invert=function(){var a=this.a*this.d-this.b*this.c;return new w(this.d/a,-this.b/a,-this.c/a,this.a/a,(this.c*this.f-this.d*this.e)/a,(this.b*this.e-this.a*this.f)/a)};n.clone=function(){return new w(this.a,this.b,this.c,this.d,this.e,
this.f)};n.translate=function(a,d){return this.add(1,0,0,1,a,d)};n.scale=function(a,d,e,f){null==d&&(d=a);(e||f)&&this.add(1,0,0,1,e,f);this.add(a,0,0,d,0,0);(e||f)&&this.add(1,0,0,1,-e,-f);return this};n.rotate=function(b,d,e){b=a.rad(b);d=d||0;e=e||0;var l=+f.cos(b).toFixed(9);b=+f.sin(b).toFixed(9);this.add(l,b,-b,l,d,e);return this.add(1,0,0,1,-d,-e)};n.x=function(a,d){return a*this.a+d*this.c+this.e};n.y=function(a,d){return a*this.b+d*this.d+this.f};n.get=function(a){return+this[d.fromCharCode(97+
a)].toFixed(4)};n.toString=function(){return"matrix("+[this.get(0),this.get(1),this.get(2),this.get(3),this.get(4),this.get(5)].join()+")"};n.offset=function(){return[this.e.toFixed(4),this.f.toFixed(4)]};n.determinant=function(){return this.a*this.d-this.b*this.c};n.split=function(){var b={};b.dx=this.e;b.dy=this.f;var d=[[this.a,this.c],[this.b,this.d] ];b.scalex=f.sqrt(k(d[0]));p(d[0]);b.shear=d[0][0]*d[1][0]+d[0][1]*d[1][1];d[1]=[d[1][0]-d[0][0]*b.shear,d[1][1]-d[0][1]*b.shear];b.scaley=f.sqrt(k(d[1]));
p(d[1]);b.shear/=b.scaley;0>this.determinant()&&(b.scalex=-b.scalex);var e=-d[0][1],d=d[1][1];0>d?(b.rotate=a.deg(f.acos(d)),0>e&&(b.rotate=360-b.rotate)):b.rotate=a.deg(f.asin(e));b.isSimple=!+b.shear.toFixed(9)&&(b.scalex.toFixed(9)==b.scaley.toFixed(9)||!b.rotate);b.isSuperSimple=!+b.shear.toFixed(9)&&b.scalex.toFixed(9)==b.scaley.toFixed(9)&&!b.rotate;b.noRotation=!+b.shear.toFixed(9)&&!b.rotate;return b};n.toTransformString=function(a){a=a||this.split();if(+a.shear.toFixed(9))return"m"+[this.get(0),
this.get(1),this.get(2),this.get(3),this.get(4),this.get(5)];a.scalex=+a.scalex.toFixed(4);a.scaley=+a.scaley.toFixed(4);a.rotate=+a.rotate.toFixed(4);return(a.dx||a.dy?"t"+[+a.dx.toFixed(4),+a.dy.toFixed(4)]:"")+(1!=a.scalex||1!=a.scaley?"s"+[a.scalex,a.scaley,0,0]:"")+(a.rotate?"r"+[+a.rotate.toFixed(4),0,0]:"")}})(w.prototype);a.Matrix=w;a.matrix=function(a,d,f,b,k,e){return new w(a,d,f,b,k,e)}});C.plugin(function(a,v,y,M,A){function w(h){return function(d){k.stop();d instanceof A&&1==d.node.childNodes.length&&
("radialGradient"==d.node.firstChild.tagName||"linearGradient"==d.node.firstChild.tagName||"pattern"==d.node.firstChild.tagName)&&(d=d.node.firstChild,b(this).appendChild(d),d=u(d));if(d instanceof v)if("radialGradient"==d.type||"linearGradient"==d.type||"pattern"==d.type){d.node.id||e(d.node,{id:d.id});var f=l(d.node.id)}else f=d.attr(h);else f=a.color(d),f.error?(f=a(b(this).ownerSVGElement).gradient(d))?(f.node.id||e(f.node,{id:f.id}),f=l(f.node.id)):f=d:f=r(f);d={};d[h]=f;e(this.node,d);this.node.style[h]=
x}}function z(a){k.stop();a==+a&&(a+="px");this.node.style.fontSize=a}function d(a){var b=[];a=a.childNodes;for(var e=0,f=a.length;e<f;e++){var l=a[e];3==l.nodeType&&b.push(l.nodeValue);"tspan"==l.tagName&&(1==l.childNodes.length&&3==l.firstChild.nodeType?b.push(l.firstChild.nodeValue):b.push(d(l)))}return b}function f(){k.stop();return this.node.style.fontSize}var n=a._.make,u=a._.wrap,p=a.is,b=a._.getSomeDefs,q=/^url\(#?([^)]+)\)$/,e=a._.$,l=a.url,r=String,s=a._.separator,x="";k.on("snap.util.attr.mask",
function(a){if(a instanceof v||a instanceof A){k.stop();a instanceof A&&1==a.node.childNodes.length&&(a=a.node.firstChild,b(this).appendChild(a),a=u(a));if("mask"==a.type)var d=a;else d=n("mask",b(this)),d.node.appendChild(a.node);!d.node.id&&e(d.node,{id:d.id});e(this.node,{mask:l(d.id)})}});(function(a){k.on("snap.util.attr.clip",a);k.on("snap.util.attr.clip-path",a);k.on("snap.util.attr.clipPath",a)})(function(a){if(a instanceof v||a instanceof A){k.stop();if("clipPath"==a.type)var d=a;else d=
n("clipPath",b(this)),d.node.appendChild(a.node),!d.node.id&&e(d.node,{id:d.id});e(this.node,{"clip-path":l(d.id)})}});k.on("snap.util.attr.fill",w("fill"));k.on("snap.util.attr.stroke",w("stroke"));var G=/^([lr])(?:\(([^)]*)\))?(.*)$/i;k.on("snap.util.grad.parse",function(a){a=r(a);var b=a.match(G);if(!b)return null;a=b[1];var e=b[2],b=b[3],e=e.split(/\s*,\s*/).map(function(a){return+a==a?+a:a});1==e.length&&0==e[0]&&(e=[]);b=b.split("-");b=b.map(function(a){a=a.split(":");var b={color:a[0]};a[1]&&
(b.offset=parseFloat(a[1]));return b});return{type:a,params:e,stops:b}});k.on("snap.util.attr.d",function(b){k.stop();p(b,"array")&&p(b[0],"array")&&(b=a.path.toString.call(b));b=r(b);b.match(/[ruo]/i)&&(b=a.path.toAbsolute(b));e(this.node,{d:b})})(-1);k.on("snap.util.attr.#text",function(a){k.stop();a=r(a);for(a=M.doc.createTextNode(a);this.node.firstChild;)this.node.removeChild(this.node.firstChild);this.node.appendChild(a)})(-1);k.on("snap.util.attr.path",function(a){k.stop();this.attr({d:a})})(-1);
k.on("snap.util.attr.class",function(a){k.stop();this.node.className.baseVal=a})(-1);k.on("snap.util.attr.viewBox",function(a){a=p(a,"object")&&"x"in a?[a.x,a.y,a.width,a.height].join(" "):p(a,"array")?a.join(" "):a;e(this.node,{viewBox:a});k.stop()})(-1);k.on("snap.util.attr.transform",function(a){this.transform(a);k.stop()})(-1);k.on("snap.util.attr.r",function(a){"rect"==this.type&&(k.stop(),e(this.node,{rx:a,ry:a}))})(-1);k.on("snap.util.attr.textpath",function(a){k.stop();if("text"==this.type){var d,
f;if(!a&&this.textPath){for(a=this.textPath;a.node.firstChild;)this.node.appendChild(a.node.firstChild);a.remove();delete this.textPath}else if(p(a,"string")?(d=b(this),a=u(d.parentNode).path(a),d.appendChild(a.node),d=a.id,a.attr({id:d})):(a=u(a),a instanceof v&&(d=a.attr("id"),d||(d=a.id,a.attr({id:d})))),d)if(a=this.textPath,f=this.node,a)a.attr({"xlink:href":"#"+d});else{for(a=e("textPath",{"xlink:href":"#"+d});f.firstChild;)a.appendChild(f.firstChild);f.appendChild(a);this.textPath=u(a)}}})(-1);
k.on("snap.util.attr.text",function(a){if("text"==this.type){for(var b=this.node,d=function(a){var b=e("tspan");if(p(a,"array"))for(var f=0;f<a.length;f++)b.appendChild(d(a[f]));else b.appendChild(M.doc.createTextNode(a));b.normalize&&b.normalize();return b};b.firstChild;)b.removeChild(b.firstChild);for(a=d(a);a.firstChild;)b.appendChild(a.firstChild)}k.stop()})(-1);k.on("snap.util.attr.fontSize",z)(-1);k.on("snap.util.attr.font-size",z)(-1);k.on("snap.util.getattr.transform",function(){k.stop();
return this.transform()})(-1);k.on("snap.util.getattr.textpath",function(){k.stop();return this.textPath})(-1);(function(){function b(d){return function(){k.stop();var b=M.doc.defaultView.getComputedStyle(this.node,null).getPropertyValue("marker-"+d);return"none"==b?b:a(M.doc.getElementById(b.match(q)[1]))}}function d(a){return function(b){k.stop();var d="marker"+a.charAt(0).toUpperCase()+a.substring(1);if(""==b||!b)this.node.style[d]="none";else if("marker"==b.type){var f=b.node.id;f||e(b.node,{id:b.id});
this.node.style[d]=l(f)}}}k.on("snap.util.getattr.marker-end",b("end"))(-1);k.on("snap.util.getattr.markerEnd",b("end"))(-1);k.on("snap.util.getattr.marker-start",b("start"))(-1);k.on("snap.util.getattr.markerStart",b("start"))(-1);k.on("snap.util.getattr.marker-mid",b("mid"))(-1);k.on("snap.util.getattr.markerMid",b("mid"))(-1);k.on("snap.util.attr.marker-end",d("end"))(-1);k.on("snap.util.attr.markerEnd",d("end"))(-1);k.on("snap.util.attr.marker-start",d("start"))(-1);k.on("snap.util.attr.markerStart",
d("start"))(-1);k.on("snap.util.attr.marker-mid",d("mid"))(-1);k.on("snap.util.attr.markerMid",d("mid"))(-1)})();k.on("snap.util.getattr.r",function(){if("rect"==this.type&&e(this.node,"rx")==e(this.node,"ry"))return k.stop(),e(this.node,"rx")})(-1);k.on("snap.util.getattr.text",function(){if("text"==this.type||"tspan"==this.type){k.stop();var a=d(this.node);return 1==a.length?a[0]:a}})(-1);k.on("snap.util.getattr.#text",function(){return this.node.textContent})(-1);k.on("snap.util.getattr.viewBox",
function(){k.stop();var b=e(this.node,"viewBox");if(b)return b=b.split(s),a._.box(+b[0],+b[1],+b[2],+b[3])})(-1);k.on("snap.util.getattr.points",function(){var a=e(this.node,"points");k.stop();if(a)return a.split(s)})(-1);k.on("snap.util.getattr.path",function(){var a=e(this.node,"d");k.stop();return a})(-1);k.on("snap.util.getattr.class",function(){return this.node.className.baseVal})(-1);k.on("snap.util.getattr.fontSize",f)(-1);k.on("snap.util.getattr.font-size",f)(-1)});C.plugin(function(a,v,y,
M,A){function w(a){return a}function z(a){return function(b){return+b.toFixed(3)+a}}var d={"+":function(a,b){return a+b},"-":function(a,b){return a-b},"/":function(a,b){return a/b},"*":function(a,b){return a*b}},f=String,n=/[a-z]+$/i,u=/^\s*([+\-\/*])\s*=\s*([\d.eE+\-]+)\s*([^\d\s]+)?\s*$/;k.on("snap.util.attr",function(a){if(a=f(a).match(u)){var b=k.nt(),b=b.substring(b.lastIndexOf(".")+1),q=this.attr(b),e={};k.stop();var l=a[3]||"",r=q.match(n),s=d[a[1] ];r&&r==l?a=s(parseFloat(q),+a[2]):(q=this.asPX(b),
a=s(this.asPX(b),this.asPX(b,a[2]+l)));isNaN(q)||isNaN(a)||(e[b]=a,this.attr(e))}})(-10);k.on("snap.util.equal",function(a,b){var q=f(this.attr(a)||""),e=f(b).match(u);if(e){k.stop();var l=e[3]||"",r=q.match(n),s=d[e[1] ];if(r&&r==l)return{from:parseFloat(q),to:s(parseFloat(q),+e[2]),f:z(r)};q=this.asPX(a);return{from:q,to:s(q,this.asPX(a,e[2]+l)),f:w}}})(-10)});C.plugin(function(a,v,y,M,A){var w=y.prototype,z=a.is;w.rect=function(a,d,k,p,b,q){var e;null==q&&(q=b);z(a,"object")&&"[object Object]"==
a?e=a:null!=a&&(e={x:a,y:d,width:k,height:p},null!=b&&(e.rx=b,e.ry=q));return this.el("rect",e)};w.circle=function(a,d,k){var p;z(a,"object")&&"[object Object]"==a?p=a:null!=a&&(p={cx:a,cy:d,r:k});return this.el("circle",p)};var d=function(){function a(){this.parentNode.removeChild(this)}return function(d,k){var p=M.doc.createElement("img"),b=M.doc.body;p.style.cssText="position:absolute;left:-9999em;top:-9999em";p.onload=function(){k.call(p);p.onload=p.onerror=null;b.removeChild(p)};p.onerror=a;
b.appendChild(p);p.src=d}}();w.image=function(f,n,k,p,b){var q=this.el("image");if(z(f,"object")&&"src"in f)q.attr(f);else if(null!=f){var e={"xlink:href":f,preserveAspectRatio:"none"};null!=n&&null!=k&&(e.x=n,e.y=k);null!=p&&null!=b?(e.width=p,e.height=b):d(f,function(){a._.$(q.node,{width:this.offsetWidth,height:this.offsetHeight})});a._.$(q.node,e)}return q};w.ellipse=function(a,d,k,p){var b;z(a,"object")&&"[object Object]"==a?b=a:null!=a&&(b={cx:a,cy:d,rx:k,ry:p});return this.el("ellipse",b)};
w.path=function(a){var d;z(a,"object")&&!z(a,"array")?d=a:a&&(d={d:a});return this.el("path",d)};w.group=w.g=function(a){var d=this.el("g");1==arguments.length&&a&&!a.type?d.attr(a):arguments.length&&d.add(Array.prototype.slice.call(arguments,0));return d};w.svg=function(a,d,k,p,b,q,e,l){var r={};z(a,"object")&&null==d?r=a:(null!=a&&(r.x=a),null!=d&&(r.y=d),null!=k&&(r.width=k),null!=p&&(r.height=p),null!=b&&null!=q&&null!=e&&null!=l&&(r.viewBox=[b,q,e,l]));return this.el("svg",r)};w.mask=function(a){var d=
this.el("mask");1==arguments.length&&a&&!a.type?d.attr(a):arguments.length&&d.add(Array.prototype.slice.call(arguments,0));return d};w.ptrn=function(a,d,k,p,b,q,e,l){if(z(a,"object"))var r=a;else arguments.length?(r={},null!=a&&(r.x=a),null!=d&&(r.y=d),null!=k&&(r.width=k),null!=p&&(r.height=p),null!=b&&null!=q&&null!=e&&null!=l&&(r.viewBox=[b,q,e,l])):r={patternUnits:"userSpaceOnUse"};return this.el("pattern",r)};w.use=function(a){return null!=a?(make("use",this.node),a instanceof v&&(a.attr("id")||
a.attr({id:ID()}),a=a.attr("id")),this.el("use",{"xlink:href":a})):v.prototype.use.call(this)};w.text=function(a,d,k){var p={};z(a,"object")?p=a:null!=a&&(p={x:a,y:d,text:k||""});return this.el("text",p)};w.line=function(a,d,k,p){var b={};z(a,"object")?b=a:null!=a&&(b={x1:a,x2:k,y1:d,y2:p});return this.el("line",b)};w.polyline=function(a){1<arguments.length&&(a=Array.prototype.slice.call(arguments,0));var d={};z(a,"object")&&!z(a,"array")?d=a:null!=a&&(d={points:a});return this.el("polyline",d)};
w.polygon=function(a){1<arguments.length&&(a=Array.prototype.slice.call(arguments,0));var d={};z(a,"object")&&!z(a,"array")?d=a:null!=a&&(d={points:a});return this.el("polygon",d)};(function(){function d(){return this.selectAll("stop")}function n(b,d){var f=e("stop"),k={offset:+d+"%"};b=a.color(b);k["stop-color"]=b.hex;1>b.opacity&&(k["stop-opacity"]=b.opacity);e(f,k);this.node.appendChild(f);return this}function u(){if("linearGradient"==this.type){var b=e(this.node,"x1")||0,d=e(this.node,"x2")||
1,f=e(this.node,"y1")||0,k=e(this.node,"y2")||0;return a._.box(b,f,math.abs(d-b),math.abs(k-f))}b=this.node.r||0;return a._.box((this.node.cx||0.5)-b,(this.node.cy||0.5)-b,2*b,2*b)}function p(a,d){function f(a,b){for(var d=(b-u)/(a-w),e=w;e<a;e++)h[e].offset=+(+u+d*(e-w)).toFixed(2);w=a;u=b}var n=k("snap.util.grad.parse",null,d).firstDefined(),p;if(!n)return null;n.params.unshift(a);p="l"==n.type.toLowerCase()?b.apply(0,n.params):q.apply(0,n.params);n.type!=n.type.toLowerCase()&&e(p.node,{gradientUnits:"userSpaceOnUse"});
var h=n.stops,n=h.length,u=0,w=0;n--;for(var v=0;v<n;v++)"offset"in h[v]&&f(v,h[v].offset);h[n].offset=h[n].offset||100;f(n,h[n].offset);for(v=0;v<=n;v++){var y=h[v];p.addStop(y.color,y.offset)}return p}function b(b,k,p,q,w){b=a._.make("linearGradient",b);b.stops=d;b.addStop=n;b.getBBox=u;null!=k&&e(b.node,{x1:k,y1:p,x2:q,y2:w});return b}function q(b,k,p,q,w,h){b=a._.make("radialGradient",b);b.stops=d;b.addStop=n;b.getBBox=u;null!=k&&e(b.node,{cx:k,cy:p,r:q});null!=w&&null!=h&&e(b.node,{fx:w,fy:h});
return b}var e=a._.$;w.gradient=function(a){return p(this.defs,a)};w.gradientLinear=function(a,d,e,f){return b(this.defs,a,d,e,f)};w.gradientRadial=function(a,b,d,e,f){return q(this.defs,a,b,d,e,f)};w.toString=function(){var b=this.node.ownerDocument,d=b.createDocumentFragment(),b=b.createElement("div"),e=this.node.cloneNode(!0);d.appendChild(b);b.appendChild(e);a._.$(e,{xmlns:"http://www.w3.org/2000/svg"});b=b.innerHTML;d.removeChild(d.firstChild);return b};w.clear=function(){for(var a=this.node.firstChild,
b;a;)b=a.nextSibling,"defs"!=a.tagName?a.parentNode.removeChild(a):w.clear.call({node:a}),a=b}})()});C.plugin(function(a,k,y,M){function A(a){var b=A.ps=A.ps||{};b[a]?b[a].sleep=100:b[a]={sleep:100};setTimeout(function(){for(var d in b)b[L](d)&&d!=a&&(b[d].sleep--,!b[d].sleep&&delete b[d])});return b[a]}function w(a,b,d,e){null==a&&(a=b=d=e=0);null==b&&(b=a.y,d=a.width,e=a.height,a=a.x);return{x:a,y:b,width:d,w:d,height:e,h:e,x2:a+d,y2:b+e,cx:a+d/2,cy:b+e/2,r1:F.min(d,e)/2,r2:F.max(d,e)/2,r0:F.sqrt(d*
d+e*e)/2,path:s(a,b,d,e),vb:[a,b,d,e].join(" ")}}function z(){return this.join(",").replace(N,"$1")}function d(a){a=C(a);a.toString=z;return a}function f(a,b,d,h,f,k,l,n,p){if(null==p)return e(a,b,d,h,f,k,l,n);if(0>p||e(a,b,d,h,f,k,l,n)<p)p=void 0;else{var q=0.5,O=1-q,s;for(s=e(a,b,d,h,f,k,l,n,O);0.01<Z(s-p);)q/=2,O+=(s<p?1:-1)*q,s=e(a,b,d,h,f,k,l,n,O);p=O}return u(a,b,d,h,f,k,l,n,p)}function n(b,d){function e(a){return+(+a).toFixed(3)}return a._.cacher(function(a,h,l){a instanceof k&&(a=a.attr("d"));
a=I(a);for(var n,p,D,q,O="",s={},c=0,t=0,r=a.length;t<r;t++){D=a[t];if("M"==D[0])n=+D[1],p=+D[2];else{q=f(n,p,D[1],D[2],D[3],D[4],D[5],D[6]);if(c+q>h){if(d&&!s.start){n=f(n,p,D[1],D[2],D[3],D[4],D[5],D[6],h-c);O+=["C"+e(n.start.x),e(n.start.y),e(n.m.x),e(n.m.y),e(n.x),e(n.y)];if(l)return O;s.start=O;O=["M"+e(n.x),e(n.y)+"C"+e(n.n.x),e(n.n.y),e(n.end.x),e(n.end.y),e(D[5]),e(D[6])].join();c+=q;n=+D[5];p=+D[6];continue}if(!b&&!d)return n=f(n,p,D[1],D[2],D[3],D[4],D[5],D[6],h-c)}c+=q;n=+D[5];p=+D[6]}O+=
D.shift()+D}s.end=O;return n=b?c:d?s:u(n,p,D[0],D[1],D[2],D[3],D[4],D[5],1)},null,a._.clone)}function u(a,b,d,e,h,f,k,l,n){var p=1-n,q=ma(p,3),s=ma(p,2),c=n*n,t=c*n,r=q*a+3*s*n*d+3*p*n*n*h+t*k,q=q*b+3*s*n*e+3*p*n*n*f+t*l,s=a+2*n*(d-a)+c*(h-2*d+a),t=b+2*n*(e-b)+c*(f-2*e+b),x=d+2*n*(h-d)+c*(k-2*h+d),c=e+2*n*(f-e)+c*(l-2*f+e);a=p*a+n*d;b=p*b+n*e;h=p*h+n*k;f=p*f+n*l;l=90-180*F.atan2(s-x,t-c)/S;return{x:r,y:q,m:{x:s,y:t},n:{x:x,y:c},start:{x:a,y:b},end:{x:h,y:f},alpha:l}}function p(b,d,e,h,f,n,k,l){a.is(b,
"array")||(b=[b,d,e,h,f,n,k,l]);b=U.apply(null,b);return w(b.min.x,b.min.y,b.max.x-b.min.x,b.max.y-b.min.y)}function b(a,b,d){return b>=a.x&&b<=a.x+a.width&&d>=a.y&&d<=a.y+a.height}function q(a,d){a=w(a);d=w(d);return b(d,a.x,a.y)||b(d,a.x2,a.y)||b(d,a.x,a.y2)||b(d,a.x2,a.y2)||b(a,d.x,d.y)||b(a,d.x2,d.y)||b(a,d.x,d.y2)||b(a,d.x2,d.y2)||(a.x<d.x2&&a.x>d.x||d.x<a.x2&&d.x>a.x)&&(a.y<d.y2&&a.y>d.y||d.y<a.y2&&d.y>a.y)}function e(a,b,d,e,h,f,n,k,l){null==l&&(l=1);l=(1<l?1:0>l?0:l)/2;for(var p=[-0.1252,
0.1252,-0.3678,0.3678,-0.5873,0.5873,-0.7699,0.7699,-0.9041,0.9041,-0.9816,0.9816],q=[0.2491,0.2491,0.2335,0.2335,0.2032,0.2032,0.1601,0.1601,0.1069,0.1069,0.0472,0.0472],s=0,c=0;12>c;c++)var t=l*p[c]+l,r=t*(t*(-3*a+9*d-9*h+3*n)+6*a-12*d+6*h)-3*a+3*d,t=t*(t*(-3*b+9*e-9*f+3*k)+6*b-12*e+6*f)-3*b+3*e,s=s+q[c]*F.sqrt(r*r+t*t);return l*s}function l(a,b,d){a=I(a);b=I(b);for(var h,f,l,n,k,s,r,O,x,c,t=d?0:[],w=0,v=a.length;w<v;w++)if(x=a[w],"M"==x[0])h=k=x[1],f=s=x[2];else{"C"==x[0]?(x=[h,f].concat(x.slice(1)),
h=x[6],f=x[7]):(x=[h,f,h,f,k,s,k,s],h=k,f=s);for(var G=0,y=b.length;G<y;G++)if(c=b[G],"M"==c[0])l=r=c[1],n=O=c[2];else{"C"==c[0]?(c=[l,n].concat(c.slice(1)),l=c[6],n=c[7]):(c=[l,n,l,n,r,O,r,O],l=r,n=O);var z;var K=x,B=c;z=d;var H=p(K),J=p(B);if(q(H,J)){for(var H=e.apply(0,K),J=e.apply(0,B),H=~~(H/8),J=~~(J/8),U=[],A=[],F={},M=z?0:[],P=0;P<H+1;P++){var C=u.apply(0,K.concat(P/H));U.push({x:C.x,y:C.y,t:P/H})}for(P=0;P<J+1;P++)C=u.apply(0,B.concat(P/J)),A.push({x:C.x,y:C.y,t:P/J});for(P=0;P<H;P++)for(K=
0;K<J;K++){var Q=U[P],L=U[P+1],B=A[K],C=A[K+1],N=0.001>Z(L.x-Q.x)?"y":"x",S=0.001>Z(C.x-B.x)?"y":"x",R;R=Q.x;var Y=Q.y,V=L.x,ea=L.y,fa=B.x,ga=B.y,ha=C.x,ia=C.y;if(W(R,V)<X(fa,ha)||X(R,V)>W(fa,ha)||W(Y,ea)<X(ga,ia)||X(Y,ea)>W(ga,ia))R=void 0;else{var $=(R*ea-Y*V)*(fa-ha)-(R-V)*(fa*ia-ga*ha),aa=(R*ea-Y*V)*(ga-ia)-(Y-ea)*(fa*ia-ga*ha),ja=(R-V)*(ga-ia)-(Y-ea)*(fa-ha);if(ja){var $=$/ja,aa=aa/ja,ja=+$.toFixed(2),ba=+aa.toFixed(2);R=ja<+X(R,V).toFixed(2)||ja>+W(R,V).toFixed(2)||ja<+X(fa,ha).toFixed(2)||
ja>+W(fa,ha).toFixed(2)||ba<+X(Y,ea).toFixed(2)||ba>+W(Y,ea).toFixed(2)||ba<+X(ga,ia).toFixed(2)||ba>+W(ga,ia).toFixed(2)?void 0:{x:$,y:aa}}else R=void 0}R&&F[R.x.toFixed(4)]!=R.y.toFixed(4)&&(F[R.x.toFixed(4)]=R.y.toFixed(4),Q=Q.t+Z((R[N]-Q[N])/(L[N]-Q[N]))*(L.t-Q.t),B=B.t+Z((R[S]-B[S])/(C[S]-B[S]))*(C.t-B.t),0<=Q&&1>=Q&&0<=B&&1>=B&&(z?M++:M.push({x:R.x,y:R.y,t1:Q,t2:B})))}z=M}else z=z?0:[];if(d)t+=z;else{H=0;for(J=z.length;H<J;H++)z[H].segment1=w,z[H].segment2=G,z[H].bez1=x,z[H].bez2=c;t=t.concat(z)}}}return t}
function r(a){var b=A(a);if(b.bbox)return C(b.bbox);if(!a)return w();a=I(a);for(var d=0,e=0,h=[],f=[],l,n=0,k=a.length;n<k;n++)l=a[n],"M"==l[0]?(d=l[1],e=l[2],h.push(d),f.push(e)):(d=U(d,e,l[1],l[2],l[3],l[4],l[5],l[6]),h=h.concat(d.min.x,d.max.x),f=f.concat(d.min.y,d.max.y),d=l[5],e=l[6]);a=X.apply(0,h);l=X.apply(0,f);h=W.apply(0,h);f=W.apply(0,f);f=w(a,l,h-a,f-l);b.bbox=C(f);return f}function s(a,b,d,e,h){if(h)return[["M",+a+ +h,b],["l",d-2*h,0],["a",h,h,0,0,1,h,h],["l",0,e-2*h],["a",h,h,0,0,1,
-h,h],["l",2*h-d,0],["a",h,h,0,0,1,-h,-h],["l",0,2*h-e],["a",h,h,0,0,1,h,-h],["z"] ];a=[["M",a,b],["l",d,0],["l",0,e],["l",-d,0],["z"] ];a.toString=z;return a}function x(a,b,d,e,h){null==h&&null==e&&(e=d);a=+a;b=+b;d=+d;e=+e;if(null!=h){var f=Math.PI/180,l=a+d*Math.cos(-e*f);a+=d*Math.cos(-h*f);var n=b+d*Math.sin(-e*f);b+=d*Math.sin(-h*f);d=[["M",l,n],["A",d,d,0,+(180<h-e),0,a,b] ]}else d=[["M",a,b],["m",0,-e],["a",d,e,0,1,1,0,2*e],["a",d,e,0,1,1,0,-2*e],["z"] ];d.toString=z;return d}function G(b){var e=
A(b);if(e.abs)return d(e.abs);Q(b,"array")&&Q(b&&b[0],"array")||(b=a.parsePathString(b));if(!b||!b.length)return[["M",0,0] ];var h=[],f=0,l=0,n=0,k=0,p=0;"M"==b[0][0]&&(f=+b[0][1],l=+b[0][2],n=f,k=l,p++,h[0]=["M",f,l]);for(var q=3==b.length&&"M"==b[0][0]&&"R"==b[1][0].toUpperCase()&&"Z"==b[2][0].toUpperCase(),s,r,w=p,c=b.length;w<c;w++){h.push(s=[]);r=b[w];p=r[0];if(p!=p.toUpperCase())switch(s[0]=p.toUpperCase(),s[0]){case "A":s[1]=r[1];s[2]=r[2];s[3]=r[3];s[4]=r[4];s[5]=r[5];s[6]=+r[6]+f;s[7]=+r[7]+
l;break;case "V":s[1]=+r[1]+l;break;case "H":s[1]=+r[1]+f;break;case "R":for(var t=[f,l].concat(r.slice(1)),u=2,v=t.length;u<v;u++)t[u]=+t[u]+f,t[++u]=+t[u]+l;h.pop();h=h.concat(P(t,q));break;case "O":h.pop();t=x(f,l,r[1],r[2]);t.push(t[0]);h=h.concat(t);break;case "U":h.pop();h=h.concat(x(f,l,r[1],r[2],r[3]));s=["U"].concat(h[h.length-1].slice(-2));break;case "M":n=+r[1]+f,k=+r[2]+l;default:for(u=1,v=r.length;u<v;u++)s[u]=+r[u]+(u%2?f:l)}else if("R"==p)t=[f,l].concat(r.slice(1)),h.pop(),h=h.concat(P(t,
q)),s=["R"].concat(r.slice(-2));else if("O"==p)h.pop(),t=x(f,l,r[1],r[2]),t.push(t[0]),h=h.concat(t);else if("U"==p)h.pop(),h=h.concat(x(f,l,r[1],r[2],r[3])),s=["U"].concat(h[h.length-1].slice(-2));else for(t=0,u=r.length;t<u;t++)s[t]=r[t];p=p.toUpperCase();if("O"!=p)switch(s[0]){case "Z":f=+n;l=+k;break;case "H":f=s[1];break;case "V":l=s[1];break;case "M":n=s[s.length-2],k=s[s.length-1];default:f=s[s.length-2],l=s[s.length-1]}}h.toString=z;e.abs=d(h);return h}function h(a,b,d,e){return[a,b,d,e,d,
e]}function J(a,b,d,e,h,f){var l=1/3,n=2/3;return[l*a+n*d,l*b+n*e,l*h+n*d,l*f+n*e,h,f]}function K(b,d,e,h,f,l,n,k,p,s){var r=120*S/180,q=S/180*(+f||0),c=[],t,x=a._.cacher(function(a,b,c){var d=a*F.cos(c)-b*F.sin(c);a=a*F.sin(c)+b*F.cos(c);return{x:d,y:a}});if(s)v=s[0],t=s[1],l=s[2],u=s[3];else{t=x(b,d,-q);b=t.x;d=t.y;t=x(k,p,-q);k=t.x;p=t.y;F.cos(S/180*f);F.sin(S/180*f);t=(b-k)/2;v=(d-p)/2;u=t*t/(e*e)+v*v/(h*h);1<u&&(u=F.sqrt(u),e*=u,h*=u);var u=e*e,w=h*h,u=(l==n?-1:1)*F.sqrt(Z((u*w-u*v*v-w*t*t)/
(u*v*v+w*t*t)));l=u*e*v/h+(b+k)/2;var u=u*-h*t/e+(d+p)/2,v=F.asin(((d-u)/h).toFixed(9));t=F.asin(((p-u)/h).toFixed(9));v=b<l?S-v:v;t=k<l?S-t:t;0>v&&(v=2*S+v);0>t&&(t=2*S+t);n&&v>t&&(v-=2*S);!n&&t>v&&(t-=2*S)}if(Z(t-v)>r){var c=t,w=k,G=p;t=v+r*(n&&t>v?1:-1);k=l+e*F.cos(t);p=u+h*F.sin(t);c=K(k,p,e,h,f,0,n,w,G,[t,c,l,u])}l=t-v;f=F.cos(v);r=F.sin(v);n=F.cos(t);t=F.sin(t);l=F.tan(l/4);e=4/3*e*l;l*=4/3*h;h=[b,d];b=[b+e*r,d-l*f];d=[k+e*t,p-l*n];k=[k,p];b[0]=2*h[0]-b[0];b[1]=2*h[1]-b[1];if(s)return[b,d,k].concat(c);
c=[b,d,k].concat(c).join().split(",");s=[];k=0;for(p=c.length;k<p;k++)s[k]=k%2?x(c[k-1],c[k],q).y:x(c[k],c[k+1],q).x;return s}function U(a,b,d,e,h,f,l,k){for(var n=[],p=[[],[] ],s,r,c,t,q=0;2>q;++q)0==q?(r=6*a-12*d+6*h,s=-3*a+9*d-9*h+3*l,c=3*d-3*a):(r=6*b-12*e+6*f,s=-3*b+9*e-9*f+3*k,c=3*e-3*b),1E-12>Z(s)?1E-12>Z(r)||(s=-c/r,0<s&&1>s&&n.push(s)):(t=r*r-4*c*s,c=F.sqrt(t),0>t||(t=(-r+c)/(2*s),0<t&&1>t&&n.push(t),s=(-r-c)/(2*s),0<s&&1>s&&n.push(s)));for(r=q=n.length;q--;)s=n[q],c=1-s,p[0][q]=c*c*c*a+3*
c*c*s*d+3*c*s*s*h+s*s*s*l,p[1][q]=c*c*c*b+3*c*c*s*e+3*c*s*s*f+s*s*s*k;p[0][r]=a;p[1][r]=b;p[0][r+1]=l;p[1][r+1]=k;p[0].length=p[1].length=r+2;return{min:{x:X.apply(0,p[0]),y:X.apply(0,p[1])},max:{x:W.apply(0,p[0]),y:W.apply(0,p[1])}}}function I(a,b){var e=!b&&A(a);if(!b&&e.curve)return d(e.curve);var f=G(a),l=b&&G(b),n={x:0,y:0,bx:0,by:0,X:0,Y:0,qx:null,qy:null},k={x:0,y:0,bx:0,by:0,X:0,Y:0,qx:null,qy:null},p=function(a,b,c){if(!a)return["C",b.x,b.y,b.x,b.y,b.x,b.y];a[0]in{T:1,Q:1}||(b.qx=b.qy=null);
switch(a[0]){case "M":b.X=a[1];b.Y=a[2];break;case "A":a=["C"].concat(K.apply(0,[b.x,b.y].concat(a.slice(1))));break;case "S":"C"==c||"S"==c?(c=2*b.x-b.bx,b=2*b.y-b.by):(c=b.x,b=b.y);a=["C",c,b].concat(a.slice(1));break;case "T":"Q"==c||"T"==c?(b.qx=2*b.x-b.qx,b.qy=2*b.y-b.qy):(b.qx=b.x,b.qy=b.y);a=["C"].concat(J(b.x,b.y,b.qx,b.qy,a[1],a[2]));break;case "Q":b.qx=a[1];b.qy=a[2];a=["C"].concat(J(b.x,b.y,a[1],a[2],a[3],a[4]));break;case "L":a=["C"].concat(h(b.x,b.y,a[1],a[2]));break;case "H":a=["C"].concat(h(b.x,
b.y,a[1],b.y));break;case "V":a=["C"].concat(h(b.x,b.y,b.x,a[1]));break;case "Z":a=["C"].concat(h(b.x,b.y,b.X,b.Y))}return a},s=function(a,b){if(7<a[b].length){a[b].shift();for(var c=a[b];c.length;)q[b]="A",l&&(u[b]="A"),a.splice(b++,0,["C"].concat(c.splice(0,6)));a.splice(b,1);v=W(f.length,l&&l.length||0)}},r=function(a,b,c,d,e){a&&b&&"M"==a[e][0]&&"M"!=b[e][0]&&(b.splice(e,0,["M",d.x,d.y]),c.bx=0,c.by=0,c.x=a[e][1],c.y=a[e][2],v=W(f.length,l&&l.length||0))},q=[],u=[],c="",t="",x=0,v=W(f.length,
l&&l.length||0);for(;x<v;x++){f[x]&&(c=f[x][0]);"C"!=c&&(q[x]=c,x&&(t=q[x-1]));f[x]=p(f[x],n,t);"A"!=q[x]&&"C"==c&&(q[x]="C");s(f,x);l&&(l[x]&&(c=l[x][0]),"C"!=c&&(u[x]=c,x&&(t=u[x-1])),l[x]=p(l[x],k,t),"A"!=u[x]&&"C"==c&&(u[x]="C"),s(l,x));r(f,l,n,k,x);r(l,f,k,n,x);var w=f[x],z=l&&l[x],y=w.length,U=l&&z.length;n.x=w[y-2];n.y=w[y-1];n.bx=$(w[y-4])||n.x;n.by=$(w[y-3])||n.y;k.bx=l&&($(z[U-4])||k.x);k.by=l&&($(z[U-3])||k.y);k.x=l&&z[U-2];k.y=l&&z[U-1]}l||(e.curve=d(f));return l?[f,l]:f}function P(a,
b){for(var d=[],e=0,h=a.length;h-2*!b>e;e+=2){var f=[{x:+a[e-2],y:+a[e-1]},{x:+a[e],y:+a[e+1]},{x:+a[e+2],y:+a[e+3]},{x:+a[e+4],y:+a[e+5]}];b?e?h-4==e?f[3]={x:+a[0],y:+a[1]}:h-2==e&&(f[2]={x:+a[0],y:+a[1]},f[3]={x:+a[2],y:+a[3]}):f[0]={x:+a[h-2],y:+a[h-1]}:h-4==e?f[3]=f[2]:e||(f[0]={x:+a[e],y:+a[e+1]});d.push(["C",(-f[0].x+6*f[1].x+f[2].x)/6,(-f[0].y+6*f[1].y+f[2].y)/6,(f[1].x+6*f[2].x-f[3].x)/6,(f[1].y+6*f[2].y-f[3].y)/6,f[2].x,f[2].y])}return d}y=k.prototype;var Q=a.is,C=a._.clone,L="hasOwnProperty",
N=/,?([a-z]),?/gi,$=parseFloat,F=Math,S=F.PI,X=F.min,W=F.max,ma=F.pow,Z=F.abs;M=n(1);var na=n(),ba=n(0,1),V=a._unit2px;a.path=A;a.path.getTotalLength=M;a.path.getPointAtLength=na;a.path.getSubpath=function(a,b,d){if(1E-6>this.getTotalLength(a)-d)return ba(a,b).end;a=ba(a,d,1);return b?ba(a,b).end:a};y.getTotalLength=function(){if(this.node.getTotalLength)return this.node.getTotalLength()};y.getPointAtLength=function(a){return na(this.attr("d"),a)};y.getSubpath=function(b,d){return a.path.getSubpath(this.attr("d"),
b,d)};a._.box=w;a.path.findDotsAtSegment=u;a.path.bezierBBox=p;a.path.isPointInsideBBox=b;a.path.isBBoxIntersect=q;a.path.intersection=function(a,b){return l(a,b)};a.path.intersectionNumber=function(a,b){return l(a,b,1)};a.path.isPointInside=function(a,d,e){var h=r(a);return b(h,d,e)&&1==l(a,[["M",d,e],["H",h.x2+10] ],1)%2};a.path.getBBox=r;a.path.get={path:function(a){return a.attr("path")},circle:function(a){a=V(a);return x(a.cx,a.cy,a.r)},ellipse:function(a){a=V(a);return x(a.cx||0,a.cy||0,a.rx,
a.ry)},rect:function(a){a=V(a);return s(a.x||0,a.y||0,a.width,a.height,a.rx,a.ry)},image:function(a){a=V(a);return s(a.x||0,a.y||0,a.width,a.height)},line:function(a){return"M"+[a.attr("x1")||0,a.attr("y1")||0,a.attr("x2"),a.attr("y2")]},polyline:function(a){return"M"+a.attr("points")},polygon:function(a){return"M"+a.attr("points")+"z"},deflt:function(a){a=a.node.getBBox();return s(a.x,a.y,a.width,a.height)}};a.path.toRelative=function(b){var e=A(b),h=String.prototype.toLowerCase;if(e.rel)return d(e.rel);
a.is(b,"array")&&a.is(b&&b[0],"array")||(b=a.parsePathString(b));var f=[],l=0,n=0,k=0,p=0,s=0;"M"==b[0][0]&&(l=b[0][1],n=b[0][2],k=l,p=n,s++,f.push(["M",l,n]));for(var r=b.length;s<r;s++){var q=f[s]=[],x=b[s];if(x[0]!=h.call(x[0]))switch(q[0]=h.call(x[0]),q[0]){case "a":q[1]=x[1];q[2]=x[2];q[3]=x[3];q[4]=x[4];q[5]=x[5];q[6]=+(x[6]-l).toFixed(3);q[7]=+(x[7]-n).toFixed(3);break;case "v":q[1]=+(x[1]-n).toFixed(3);break;case "m":k=x[1],p=x[2];default:for(var c=1,t=x.length;c<t;c++)q[c]=+(x[c]-(c%2?l:
n)).toFixed(3)}else for(f[s]=[],"m"==x[0]&&(k=x[1]+l,p=x[2]+n),q=0,c=x.length;q<c;q++)f[s][q]=x[q];x=f[s].length;switch(f[s][0]){case "z":l=k;n=p;break;case "h":l+=+f[s][x-1];break;case "v":n+=+f[s][x-1];break;default:l+=+f[s][x-2],n+=+f[s][x-1]}}f.toString=z;e.rel=d(f);return f};a.path.toAbsolute=G;a.path.toCubic=I;a.path.map=function(a,b){if(!b)return a;var d,e,h,f,l,n,k;a=I(a);h=0;for(l=a.length;h<l;h++)for(k=a[h],f=1,n=k.length;f<n;f+=2)d=b.x(k[f],k[f+1]),e=b.y(k[f],k[f+1]),k[f]=d,k[f+1]=e;return a};
a.path.toString=z;a.path.clone=d});C.plugin(function(a,v,y,C){var A=Math.max,w=Math.min,z=function(a){this.items=[];this.bindings={};this.length=0;this.type="set";if(a)for(var f=0,n=a.length;f<n;f++)a[f]&&(this[this.items.length]=this.items[this.items.length]=a[f],this.length++)};v=z.prototype;v.push=function(){for(var a,f,n=0,k=arguments.length;n<k;n++)if(a=arguments[n])f=this.items.length,this[f]=this.items[f]=a,this.length++;return this};v.pop=function(){this.length&&delete this[this.length--];
return this.items.pop()};v.forEach=function(a,f){for(var n=0,k=this.items.length;n<k&&!1!==a.call(f,this.items[n],n);n++);return this};v.animate=function(d,f,n,u){"function"!=typeof n||n.length||(u=n,n=L.linear);d instanceof a._.Animation&&(u=d.callback,n=d.easing,f=n.dur,d=d.attr);var p=arguments;if(a.is(d,"array")&&a.is(p[p.length-1],"array"))var b=!0;var q,e=function(){q?this.b=q:q=this.b},l=0,r=u&&function(){l++==this.length&&u.call(this)};return this.forEach(function(a,l){k.once("snap.animcreated."+
a.id,e);b?p[l]&&a.animate.apply(a,p[l]):a.animate(d,f,n,r)})};v.remove=function(){for(;this.length;)this.pop().remove();return this};v.bind=function(a,f,k){var u={};if("function"==typeof f)this.bindings[a]=f;else{var p=k||a;this.bindings[a]=function(a){u[p]=a;f.attr(u)}}return this};v.attr=function(a){var f={},k;for(k in a)if(this.bindings[k])this.bindings[k](a[k]);else f[k]=a[k];a=0;for(k=this.items.length;a<k;a++)this.items[a].attr(f);return this};v.clear=function(){for(;this.length;)this.pop()};
v.splice=function(a,f,k){a=0>a?A(this.length+a,0):a;f=A(0,w(this.length-a,f));var u=[],p=[],b=[],q;for(q=2;q<arguments.length;q++)b.push(arguments[q]);for(q=0;q<f;q++)p.push(this[a+q]);for(;q<this.length-a;q++)u.push(this[a+q]);var e=b.length;for(q=0;q<e+u.length;q++)this.items[a+q]=this[a+q]=q<e?b[q]:u[q-e];for(q=this.items.length=this.length-=f-e;this[q];)delete this[q++];return new z(p)};v.exclude=function(a){for(var f=0,k=this.length;f<k;f++)if(this[f]==a)return this.splice(f,1),!0;return!1};
v.insertAfter=function(a){for(var f=this.items.length;f--;)this.items[f].insertAfter(a);return this};v.getBBox=function(){for(var a=[],f=[],k=[],u=[],p=this.items.length;p--;)if(!this.items[p].removed){var b=this.items[p].getBBox();a.push(b.x);f.push(b.y);k.push(b.x+b.width);u.push(b.y+b.height)}a=w.apply(0,a);f=w.apply(0,f);k=A.apply(0,k);u=A.apply(0,u);return{x:a,y:f,x2:k,y2:u,width:k-a,height:u-f,cx:a+(k-a)/2,cy:f+(u-f)/2}};v.clone=function(a){a=new z;for(var f=0,k=this.items.length;f<k;f++)a.push(this.items[f].clone());
return a};v.toString=function(){return"Snap\u2018s set"};v.type="set";a.set=function(){var a=new z;arguments.length&&a.push.apply(a,Array.prototype.slice.call(arguments,0));return a}});C.plugin(function(a,v,y,C){function A(a){var b=a[0];switch(b.toLowerCase()){case "t":return[b,0,0];case "m":return[b,1,0,0,1,0,0];case "r":return 4==a.length?[b,0,a[2],a[3] ]:[b,0];case "s":return 5==a.length?[b,1,1,a[3],a[4] ]:3==a.length?[b,1,1]:[b,1]}}function w(b,d,f){d=q(d).replace(/\.{3}|\u2026/g,b);b=a.parseTransformString(b)||
[];d=a.parseTransformString(d)||[];for(var k=Math.max(b.length,d.length),p=[],v=[],h=0,w,z,y,I;h<k;h++){y=b[h]||A(d[h]);I=d[h]||A(y);if(y[0]!=I[0]||"r"==y[0].toLowerCase()&&(y[2]!=I[2]||y[3]!=I[3])||"s"==y[0].toLowerCase()&&(y[3]!=I[3]||y[4]!=I[4])){b=a._.transform2matrix(b,f());d=a._.transform2matrix(d,f());p=[["m",b.a,b.b,b.c,b.d,b.e,b.f] ];v=[["m",d.a,d.b,d.c,d.d,d.e,d.f] ];break}p[h]=[];v[h]=[];w=0;for(z=Math.max(y.length,I.length);w<z;w++)w in y&&(p[h][w]=y[w]),w in I&&(v[h][w]=I[w])}return{from:u(p),
to:u(v),f:n(p)}}function z(a){return a}function d(a){return function(b){return+b.toFixed(3)+a}}function f(b){return a.rgb(b[0],b[1],b[2])}function n(a){var b=0,d,f,k,n,h,p,q=[];d=0;for(f=a.length;d<f;d++){h="[";p=['"'+a[d][0]+'"'];k=1;for(n=a[d].length;k<n;k++)p[k]="val["+b++ +"]";h+=p+"]";q[d]=h}return Function("val","return Snap.path.toString.call(["+q+"])")}function u(a){for(var b=[],d=0,f=a.length;d<f;d++)for(var k=1,n=a[d].length;k<n;k++)b.push(a[d][k]);return b}var p={},b=/[a-z]+$/i,q=String;
p.stroke=p.fill="colour";v.prototype.equal=function(a,b){return k("snap.util.equal",this,a,b).firstDefined()};k.on("snap.util.equal",function(e,k){var r,s;r=q(this.attr(e)||"");var x=this;if(r==+r&&k==+k)return{from:+r,to:+k,f:z};if("colour"==p[e])return r=a.color(r),s=a.color(k),{from:[r.r,r.g,r.b,r.opacity],to:[s.r,s.g,s.b,s.opacity],f:f};if("transform"==e||"gradientTransform"==e||"patternTransform"==e)return k instanceof a.Matrix&&(k=k.toTransformString()),a._.rgTransform.test(k)||(k=a._.svgTransform2string(k)),
w(r,k,function(){return x.getBBox(1)});if("d"==e||"path"==e)return r=a.path.toCubic(r,k),{from:u(r[0]),to:u(r[1]),f:n(r[0])};if("points"==e)return r=q(r).split(a._.separator),s=q(k).split(a._.separator),{from:r,to:s,f:function(a){return a}};aUnit=r.match(b);s=q(k).match(b);return aUnit&&aUnit==s?{from:parseFloat(r),to:parseFloat(k),f:d(aUnit)}:{from:this.asPX(e),to:this.asPX(e,k),f:z}})});C.plugin(function(a,v,y,C){var A=v.prototype,w="createTouch"in C.doc;v="click dblclick mousedown mousemove mouseout mouseover mouseup touchstart touchmove touchend touchcancel".split(" ");
var z={mousedown:"touchstart",mousemove:"touchmove",mouseup:"touchend"},d=function(a,b){var d="y"==a?"scrollTop":"scrollLeft",e=b&&b.node?b.node.ownerDocument:C.doc;return e[d in e.documentElement?"documentElement":"body"][d]},f=function(){this.returnValue=!1},n=function(){return this.originalEvent.preventDefault()},u=function(){this.cancelBubble=!0},p=function(){return this.originalEvent.stopPropagation()},b=function(){if(C.doc.addEventListener)return function(a,b,e,f){var k=w&&z[b]?z[b]:b,l=function(k){var l=
d("y",f),q=d("x",f);if(w&&z.hasOwnProperty(b))for(var r=0,u=k.targetTouches&&k.targetTouches.length;r<u;r++)if(k.targetTouches[r].target==a||a.contains(k.targetTouches[r].target)){u=k;k=k.targetTouches[r];k.originalEvent=u;k.preventDefault=n;k.stopPropagation=p;break}return e.call(f,k,k.clientX+q,k.clientY+l)};b!==k&&a.addEventListener(b,l,!1);a.addEventListener(k,l,!1);return function(){b!==k&&a.removeEventListener(b,l,!1);a.removeEventListener(k,l,!1);return!0}};if(C.doc.attachEvent)return function(a,
b,e,h){var k=function(a){a=a||h.node.ownerDocument.window.event;var b=d("y",h),k=d("x",h),k=a.clientX+k,b=a.clientY+b;a.preventDefault=a.preventDefault||f;a.stopPropagation=a.stopPropagation||u;return e.call(h,a,k,b)};a.attachEvent("on"+b,k);return function(){a.detachEvent("on"+b,k);return!0}}}(),q=[],e=function(a){for(var b=a.clientX,e=a.clientY,f=d("y"),l=d("x"),n,p=q.length;p--;){n=q[p];if(w)for(var r=a.touches&&a.touches.length,u;r--;){if(u=a.touches[r],u.identifier==n.el._drag.id||n.el.node.contains(u.target)){b=
u.clientX;e=u.clientY;(a.originalEvent?a.originalEvent:a).preventDefault();break}}else a.preventDefault();b+=l;e+=f;k("snap.drag.move."+n.el.id,n.move_scope||n.el,b-n.el._drag.x,e-n.el._drag.y,b,e,a)}},l=function(b){a.unmousemove(e).unmouseup(l);for(var d=q.length,f;d--;)f=q[d],f.el._drag={},k("snap.drag.end."+f.el.id,f.end_scope||f.start_scope||f.move_scope||f.el,b);q=[]};for(y=v.length;y--;)(function(d){a[d]=A[d]=function(e,f){a.is(e,"function")&&(this.events=this.events||[],this.events.push({name:d,
f:e,unbind:b(this.node||document,d,e,f||this)}));return this};a["un"+d]=A["un"+d]=function(a){for(var b=this.events||[],e=b.length;e--;)if(b[e].name==d&&(b[e].f==a||!a)){b[e].unbind();b.splice(e,1);!b.length&&delete this.events;break}return this}})(v[y]);A.hover=function(a,b,d,e){return this.mouseover(a,d).mouseout(b,e||d)};A.unhover=function(a,b){return this.unmouseover(a).unmouseout(b)};var r=[];A.drag=function(b,d,f,h,n,p){function u(r,v,w){(r.originalEvent||r).preventDefault();this._drag.x=v;
this._drag.y=w;this._drag.id=r.identifier;!q.length&&a.mousemove(e).mouseup(l);q.push({el:this,move_scope:h,start_scope:n,end_scope:p});d&&k.on("snap.drag.start."+this.id,d);b&&k.on("snap.drag.move."+this.id,b);f&&k.on("snap.drag.end."+this.id,f);k("snap.drag.start."+this.id,n||h||this,v,w,r)}if(!arguments.length){var v;return this.drag(function(a,b){this.attr({transform:v+(v?"T":"t")+[a,b]})},function(){v=this.transform().local})}this._drag={};r.push({el:this,start:u});this.mousedown(u);return this};
A.undrag=function(){for(var b=r.length;b--;)r[b].el==this&&(this.unmousedown(r[b].start),r.splice(b,1),k.unbind("snap.drag.*."+this.id));!r.length&&a.unmousemove(e).unmouseup(l);return this}});C.plugin(function(a,v,y,C){y=y.prototype;var A=/^\s*url\((.+)\)/,w=String,z=a._.$;a.filter={};y.filter=function(d){var f=this;"svg"!=f.type&&(f=f.paper);d=a.parse(w(d));var k=a._.id(),u=z("filter");z(u,{id:k,filterUnits:"userSpaceOnUse"});u.appendChild(d.node);f.defs.appendChild(u);return new v(u)};k.on("snap.util.getattr.filter",
function(){k.stop();var d=z(this.node,"filter");if(d)return(d=w(d).match(A))&&a.select(d[1])});k.on("snap.util.attr.filter",function(d){if(d instanceof v&&"filter"==d.type){k.stop();var f=d.node.id;f||(z(d.node,{id:d.id}),f=d.id);z(this.node,{filter:a.url(f)})}d&&"none"!=d||(k.stop(),this.node.removeAttribute("filter"))});a.filter.blur=function(d,f){null==d&&(d=2);return a.format('<feGaussianBlur stdDeviation="{def}"/>',{def:null==f?d:[d,f]})};a.filter.blur.toString=function(){return this()};a.filter.shadow=
function(d,f,k,u,p){"string"==typeof k&&(p=u=k,k=4);"string"!=typeof u&&(p=u,u="#000");null==k&&(k=4);null==p&&(p=1);null==d&&(d=0,f=2);null==f&&(f=d);u=a.color(u||"#000");return a.format('<feGaussianBlur in="SourceAlpha" stdDeviation="{blur}"/><feOffset dx="{dx}" dy="{dy}" result="offsetblur"/><feFlood flood-color="{color}"/><feComposite in2="offsetblur" operator="in"/><feComponentTransfer><feFuncA type="linear" slope="{opacity}"/></feComponentTransfer><feMerge><feMergeNode/><feMergeNode in="SourceGraphic"/></feMerge>',
{color:u,dx:d,dy:f,blur:k,opacity:p})};a.filter.shadow.toString=function(){return this()};a.filter.grayscale=function(d){null==d&&(d=1);return a.format('<feColorMatrix type="matrix" values="{a} {b} {c} 0 0 {d} {e} {f} 0 0 {g} {b} {h} 0 0 0 0 0 1 0"/>',{a:0.2126+0.7874*(1-d),b:0.7152-0.7152*(1-d),c:0.0722-0.0722*(1-d),d:0.2126-0.2126*(1-d),e:0.7152+0.2848*(1-d),f:0.0722-0.0722*(1-d),g:0.2126-0.2126*(1-d),h:0.0722+0.9278*(1-d)})};a.filter.grayscale.toString=function(){return this()};a.filter.sepia=
function(d){null==d&&(d=1);return a.format('<feColorMatrix type="matrix" values="{a} {b} {c} 0 0 {d} {e} {f} 0 0 {g} {h} {i} 0 0 0 0 0 1 0"/>',{a:0.393+0.607*(1-d),b:0.769-0.769*(1-d),c:0.189-0.189*(1-d),d:0.349-0.349*(1-d),e:0.686+0.314*(1-d),f:0.168-0.168*(1-d),g:0.272-0.272*(1-d),h:0.534-0.534*(1-d),i:0.131+0.869*(1-d)})};a.filter.sepia.toString=function(){return this()};a.filter.saturate=function(d){null==d&&(d=1);return a.format('<feColorMatrix type="saturate" values="{amount}"/>',{amount:1-
d})};a.filter.saturate.toString=function(){return this()};a.filter.hueRotate=function(d){return a.format('<feColorMatrix type="hueRotate" values="{angle}"/>',{angle:d||0})};a.filter.hueRotate.toString=function(){return this()};a.filter.invert=function(d){null==d&&(d=1);return a.format('<feComponentTransfer><feFuncR type="table" tableValues="{amount} {amount2}"/><feFuncG type="table" tableValues="{amount} {amount2}"/><feFuncB type="table" tableValues="{amount} {amount2}"/></feComponentTransfer>',{amount:d,
amount2:1-d})};a.filter.invert.toString=function(){return this()};a.filter.brightness=function(d){null==d&&(d=1);return a.format('<feComponentTransfer><feFuncR type="linear" slope="{amount}"/><feFuncG type="linear" slope="{amount}"/><feFuncB type="linear" slope="{amount}"/></feComponentTransfer>',{amount:d})};a.filter.brightness.toString=function(){return this()};a.filter.contrast=function(d){null==d&&(d=1);return a.format('<feComponentTransfer><feFuncR type="linear" slope="{amount}" intercept="{amount2}"/><feFuncG type="linear" slope="{amount}" intercept="{amount2}"/><feFuncB type="linear" slope="{amount}" intercept="{amount2}"/></feComponentTransfer>',
{amount:d,amount2:0.5-d/2})};a.filter.contrast.toString=function(){return this()}});return C});

]]> </script>
<script> <![CDATA[

(function (glob, factory) {
    // AMD support
    if (typeof define === "function" && define.amd) {
        // Define as an anonymous module
        define("Gadfly", ["Snap.svg"], function (Snap) {
            return factory(Snap);
        });
    } else {
        // Browser globals (glob is window)
        // Snap adds itself to window
        glob.Gadfly = factory(glob.Snap);
    }
}(this, function (Snap) {

var Gadfly = {};

// Get an x/y coordinate value in pixels
var xPX = function(fig, x) {
    var client_box = fig.node.getBoundingClientRect();
    return x * fig.node.viewBox.baseVal.width / client_box.width;
};

var yPX = function(fig, y) {
    var client_box = fig.node.getBoundingClientRect();
    return y * fig.node.viewBox.baseVal.height / client_box.height;
};


Snap.plugin(function (Snap, Element, Paper, global) {
    // Traverse upwards from a snap element to find and return the first
    // note with the "plotroot" class.
    Element.prototype.plotroot = function () {
        var element = this;
        while (!element.hasClass("plotroot") && element.parent() != null) {
            element = element.parent();
        }
        return element;
    };

    Element.prototype.svgroot = function () {
        var element = this;
        while (element.node.nodeName != "svg" && element.parent() != null) {
            element = element.parent();
        }
        return element;
    };

    Element.prototype.plotbounds = function () {
        var root = this.plotroot()
        var bbox = root.select(".guide.background").node.getBBox();
        return {
            x0: bbox.x,
            x1: bbox.x + bbox.width,
            y0: bbox.y,
            y1: bbox.y + bbox.height
        };
    };

    Element.prototype.plotcenter = function () {
        var root = this.plotroot()
        var bbox = root.select(".guide.background").node.getBBox();
        return {
            x: bbox.x + bbox.width / 2,
            y: bbox.y + bbox.height / 2
        };
    };

    // Emulate IE style mouseenter/mouseleave events, since Microsoft always
    // does everything right.
    // See: http://www.dynamic-tools.net/toolbox/isMouseLeaveOrEnter/
    var events = ["mouseenter", "mouseleave"];

    for (i in events) {
        (function (event_name) {
            var event_name = events[i];
            Element.prototype[event_name] = function (fn, scope) {
                if (Snap.is(fn, "function")) {
                    var fn2 = function (event) {
                        if (event.type != "mouseover" && event.type != "mouseout") {
                            return;
                        }

                        var reltg = event.relatedTarget ? event.relatedTarget :
                            event.type == "mouseout" ? event.toElement : event.fromElement;
                        while (reltg && reltg != this.node) reltg = reltg.parentNode;

                        if (reltg != this.node) {
                            return fn.apply(this, event);
                        }
                    };

                    if (event_name == "mouseenter") {
                        this.mouseover(fn2, scope);
                    } else {
                        this.mouseout(fn2, scope);
                    }
                }
                return this;
            };
        })(events[i]);
    }


    Element.prototype.mousewheel = function (fn, scope) {
        if (Snap.is(fn, "function")) {
            var el = this;
            var fn2 = function (event) {
                fn.apply(el, [event]);
            };
        }

        this.node.addEventListener(
            /Firefox/i.test(navigator.userAgent) ? "DOMMouseScroll" : "mousewheel",
            fn2);

        return this;
    };


    // Snap's attr function can be too slow for things like panning/zooming.
    // This is a function to directly update element attributes without going
    // through eve.
    Element.prototype.attribute = function(key, val) {
        if (val === undefined) {
            return this.node.getAttribute(key, val);
        } else {
            return this.node.setAttribute(key, val);
        }
    };
});


// When the plot is moused over, emphasize the grid lines.
Gadfly.plot_mouseover = function(event) {
    var root = this.plotroot();
    init_pan_zoom(root);

    var xgridlines = root.select(".xgridlines"),
        ygridlines = root.select(".ygridlines");

    xgridlines.data("unfocused_strokedash",
                    xgridlines.attr("stroke-dasharray").replace(/px/g, "mm"))
    ygridlines.data("unfocused_strokedash",
                    ygridlines.attr("stroke-dasharray").replace(/px/g, "mm"))

    // emphasize grid lines
    var destcolor = root.data("focused_xgrid_color");
    xgridlines.attr("stroke-dasharray", "none")
              .selectAll("path")
              .animate({stroke: destcolor}, 250);

    destcolor = root.data("focused_ygrid_color");
    ygridlines.attr("stroke-dasharray", "none")
              .selectAll("path")
              .animate({stroke: destcolor}, 250);

    // reveal zoom slider
    root.select(".zoomslider")
        .animate({opacity: 1.0}, 250);
};


// Unemphasize grid lines on mouse out.
Gadfly.plot_mouseout = function(event) {
    var root = this.plotroot();
    var xgridlines = root.select(".xgridlines"),
        ygridlines = root.select(".ygridlines");

    var destcolor = root.data("unfocused_xgrid_color");

    xgridlines.attr("stroke-dasharray", xgridlines.data("unfocused_strokedash"))
              .selectAll("path")
              .animate({stroke: destcolor}, 250);

    destcolor = root.data("unfocused_ygrid_color");
    ygridlines.attr("stroke-dasharray", ygridlines.data("unfocused_strokedash"))
              .selectAll("path")
              .animate({stroke: destcolor}, 250);

    // hide zoom slider
    root.select(".zoomslider")
        .animate({opacity: 0.0}, 250);
};


var set_geometry_transform = function(root, tx, ty, scale) {
    var xscalable = root.hasClass("xscalable"),
        yscalable = root.hasClass("yscalable");

    var old_scale = root.data("scale");

    var xscale = xscalable ? scale : 1.0,
        yscale = yscalable ? scale : 1.0;

    tx = xscalable ? tx : 0.0;
    ty = yscalable ? ty : 0.0;

    var t = new Snap.Matrix().translate(tx, ty).scale(xscale, yscale);

    root.selectAll(".geometry, image")
        .forEach(function (element, i) {
            element.transform(t);
        });

    bounds = root.plotbounds();

    if (yscalable) {
        var xfixed_t = new Snap.Matrix().translate(0, ty).scale(1.0, yscale);
        root.selectAll(".xfixed")
            .forEach(function (element, i) {
                element.transform(xfixed_t);
            });

        root.select(".ylabels")
            .transform(xfixed_t)
            .selectAll("text")
            .forEach(function (element, i) {
                if (element.attribute("gadfly:inscale") == "true") {
                    var cx = element.asPX("x"),
                        cy = element.asPX("y");
                    var st = element.data("static_transform");
                    unscale_t = new Snap.Matrix();
                    unscale_t.scale(1, 1/scale, cx, cy).add(st);
                    element.transform(unscale_t);

                    var y = cy * scale + ty;
                    element.attr("visibility",
                        bounds.y0 <= y && y <= bounds.y1 ? "visible" : "hidden");
                }
            });
    }

    if (xscalable) {
        var yfixed_t = new Snap.Matrix().translate(tx, 0).scale(xscale, 1.0);
        var xtrans = new Snap.Matrix().translate(tx, 0);
        root.selectAll(".yfixed")
            .forEach(function (element, i) {
                element.transform(yfixed_t);
            });

        root.select(".xlabels")
            .transform(yfixed_t)
            .selectAll("text")
            .forEach(function (element, i) {
                if (element.attribute("gadfly:inscale") == "true") {
                    var cx = element.asPX("x"),
                        cy = element.asPX("y");
                    var st = element.data("static_transform");
                    unscale_t = new Snap.Matrix();
                    unscale_t.scale(1/scale, 1, cx, cy).add(st);

                    element.transform(unscale_t);

                    var x = cx * scale + tx;
                    element.attr("visibility",
                        bounds.x0 <= x && x <= bounds.x1 ? "visible" : "hidden");
                    }
            });
    }

    // we must unscale anything that is scale invariance: widths, raiduses, etc.
    var size_attribs = ["font-size"];
    var unscaled_selection = ".geometry, .geometry *";
    if (xscalable) {
        size_attribs.push("rx");
        unscaled_selection += ", .xgridlines";
    }
    if (yscalable) {
        size_attribs.push("ry");
        unscaled_selection += ", .ygridlines";
    }

    root.selectAll(unscaled_selection)
        .forEach(function (element, i) {
            // circle need special help
            if (element.node.nodeName == "circle") {
                var cx = element.attribute("cx"),
                    cy = element.attribute("cy");
                unscale_t = new Snap.Matrix().scale(1/xscale, 1/yscale,
                                                        cx, cy);
                element.transform(unscale_t);
                return;
            }

            for (i in size_attribs) {
                var key = size_attribs[i];
                var val = parseFloat(element.attribute(key));
                if (val !== undefined && val != 0 && !isNaN(val)) {
                    element.attribute(key, val * old_scale / scale);
                }
            }
        });
};


// Find the most appropriate tick scale and update label visibility.
var update_tickscale = function(root, scale, axis) {
    if (!root.hasClass(axis + "scalable")) return;

    var tickscales = root.data(axis + "tickscales");
    var best_tickscale = 1.0;
    var best_tickscale_dist = Infinity;
    for (tickscale in tickscales) {
        var dist = Math.abs(Math.log(tickscale) - Math.log(scale));
        if (dist < best_tickscale_dist) {
            best_tickscale_dist = dist;
            best_tickscale = tickscale;
        }
    }

    if (best_tickscale != root.data(axis + "tickscale")) {
        root.data(axis + "tickscale", best_tickscale);
        var mark_inscale_gridlines = function (element, i) {
            var inscale = element.attr("gadfly:scale") == best_tickscale;
            element.attribute("gadfly:inscale", inscale);
            element.attr("visibility", inscale ? "visible" : "hidden");
        };

        var mark_inscale_labels = function (element, i) {
            var inscale = element.attr("gadfly:scale") == best_tickscale;
            element.attribute("gadfly:inscale", inscale);
            element.attr("visibility", inscale ? "visible" : "hidden");
        };

        root.select("." + axis + "gridlines").selectAll("path").forEach(mark_inscale_gridlines);
        root.select("." + axis + "labels").selectAll("text").forEach(mark_inscale_labels);
    }
};


var set_plot_pan_zoom = function(root, tx, ty, scale) {
    var old_scale = root.data("scale");
    var bounds = root.plotbounds();

    var width = bounds.x1 - bounds.x0,
        height = bounds.y1 - bounds.y0;

    // compute the viewport derived from tx, ty, and scale
    var x_min = -width * scale - (scale * width - width),
        x_max = width * scale,
        y_min = -height * scale - (scale * height - height),
        y_max = height * scale;

    var x0 = bounds.x0 - scale * bounds.x0,
        y0 = bounds.y0 - scale * bounds.y0;

    var tx = Math.max(Math.min(tx - x0, x_max), x_min),
        ty = Math.max(Math.min(ty - y0, y_max), y_min);

    tx += x0;
    ty += y0;

    // when the scale change, we may need to alter which set of
    // ticks is being displayed
    if (scale != old_scale) {
        update_tickscale(root, scale, "x");
        update_tickscale(root, scale, "y");
    }

    set_geometry_transform(root, tx, ty, scale);

    root.data("scale", scale);
    root.data("tx", tx);
    root.data("ty", ty);
};


var scale_centered_translation = function(root, scale) {
    var bounds = root.plotbounds();

    var width = bounds.x1 - bounds.x0,
        height = bounds.y1 - bounds.y0;

    var tx0 = root.data("tx"),
        ty0 = root.data("ty");

    var scale0 = root.data("scale");

    // how off from center the current view is
    var xoff = tx0 - (bounds.x0 * (1 - scale0) + (width * (1 - scale0)) / 2),
        yoff = ty0 - (bounds.y0 * (1 - scale0) + (height * (1 - scale0)) / 2);

    // rescale offsets
    xoff = xoff * scale / scale0;
    yoff = yoff * scale / scale0;

    // adjust for the panel position being scaled
    var x_edge_adjust = bounds.x0 * (1 - scale),
        y_edge_adjust = bounds.y0 * (1 - scale);

    return {
        x: xoff + x_edge_adjust + (width - width * scale) / 2,
        y: yoff + y_edge_adjust + (height - height * scale) / 2
    };
};


// Initialize data for panning zooming if it isn't already.
var init_pan_zoom = function(root) {
    if (root.data("zoompan-ready")) {
        return;
    }

    // The non-scaling-stroke trick. Rather than try to correct for the
    // stroke-width when zooming, we force it to a fixed value.
    var px_per_mm = root.node.getCTM().a;

    // Drag events report deltas in pixels, which we'd like to convert to
    // millimeters.
    root.data("px_per_mm", px_per_mm);

    root.selectAll("path")
        .forEach(function (element, i) {
        sw = element.asPX("stroke-width") * px_per_mm;
        if (sw > 0) {
            element.attribute("stroke-width", sw);
            element.attribute("vector-effect", "non-scaling-stroke");
        }
    });

    // Store ticks labels original tranformation
    root.selectAll(".xlabels > text, .ylabels > text")
        .forEach(function (element, i) {
            var lm = element.transform().localMatrix;
            element.data("static_transform",
                new Snap.Matrix(lm.a, lm.b, lm.c, lm.d, lm.e, lm.f));
        });

    if (root.data("tx") === undefined) root.data("tx", 0);
    if (root.data("ty") === undefined) root.data("ty", 0);
    if (root.data("scale") === undefined) root.data("scale", 1.0);
    if (root.data("xtickscales") === undefined) {

        // index all the tick scales that are listed
        var xtickscales = {};
        var ytickscales = {};
        var add_x_tick_scales = function (element, i) {
            xtickscales[element.attribute("gadfly:scale")] = true;
        };
        var add_y_tick_scales = function (element, i) {
            ytickscales[element.attribute("gadfly:scale")] = true;
        };

        root.select(".xgridlines").selectAll("path").forEach(add_x_tick_scales);
        root.select(".ygridlines").selectAll("path").forEach(add_y_tick_scales);
        root.select(".xlabels").selectAll("text").forEach(add_x_tick_scales);
        root.select(".ylabels").selectAll("text").forEach(add_y_tick_scales);

        root.data("xtickscales", xtickscales);
        root.data("ytickscales", ytickscales);
        root.data("xtickscale", 1.0);
    }

    var min_scale = 1.0, max_scale = 1.0;
    for (scale in xtickscales) {
        min_scale = Math.min(min_scale, scale);
        max_scale = Math.max(max_scale, scale);
    }
    for (scale in ytickscales) {
        min_scale = Math.min(min_scale, scale);
        max_scale = Math.max(max_scale, scale);
    }
    root.data("min_scale", min_scale);
    root.data("max_scale", max_scale);

    // store the original positions of labels
    root.select(".xlabels")
        .selectAll("text")
        .forEach(function (element, i) {
            element.data("x", element.asPX("x"));
        });

    root.select(".ylabels")
        .selectAll("text")
        .forEach(function (element, i) {
            element.data("y", element.asPX("y"));
        });

    // mark grid lines and ticks as in or out of scale.
    var mark_inscale = function (element, i) {
        element.attribute("gadfly:inscale", element.attribute("gadfly:scale") == 1.0);
    };

    root.select(".xgridlines").selectAll("path").forEach(mark_inscale);
    root.select(".ygridlines").selectAll("path").forEach(mark_inscale);
    root.select(".xlabels").selectAll("text").forEach(mark_inscale);
    root.select(".ylabels").selectAll("text").forEach(mark_inscale);

    // figure out the upper ond lower bounds on panning using the maximum
    // and minum grid lines
    var bounds = root.plotbounds();
    var pan_bounds = {
        x0: 0.0,
        y0: 0.0,
        x1: 0.0,
        y1: 0.0
    };

    root.select(".xgridlines")
        .selectAll("path")
        .forEach(function (element, i) {
            if (element.attribute("gadfly:inscale") == "true") {
                var bbox = element.node.getBBox();
                if (bounds.x1 - bbox.x < pan_bounds.x0) {
                    pan_bounds.x0 = bounds.x1 - bbox.x;
                }
                if (bounds.x0 - bbox.x > pan_bounds.x1) {
                    pan_bounds.x1 = bounds.x0 - bbox.x;
                }
            }
        });

    root.select(".ygridlines")
        .selectAll("path")
        .forEach(function (element, i) {
            if (element.attribute("gadfly:inscale") == "true") {
                var bbox = element.node.getBBox();
                if (bounds.y1 - bbox.y < pan_bounds.y0) {
                    pan_bounds.y0 = bounds.y1 - bbox.y;
                }
                if (bounds.y0 - bbox.y > pan_bounds.y1) {
                    pan_bounds.y1 = bounds.y0 - bbox.y;
                }
            }
        });

    // nudge these values a little
    pan_bounds.x0 -= 5;
    pan_bounds.x1 += 5;
    pan_bounds.y0 -= 5;
    pan_bounds.y1 += 5;
    root.data("pan_bounds", pan_bounds);

    // Set all grid lines at scale 1.0 to visible. Out of bounds lines
    // will be clipped.
    root.select(".xgridlines")
        .selectAll("path")
        .forEach(function (element, i) {
            if (element.attribute("gadfly:inscale") == "true") {
                element.attr("visibility", "visible");
            }
        });

    root.select(".ygridlines")
        .selectAll("path")
        .forEach(function (element, i) {
            if (element.attribute("gadfly:inscale") == "true") {
                element.attr("visibility", "visible");
            }
        });

    root.data("zoompan-ready", true)
};


// Panning
Gadfly.guide_background_drag_onmove = function(dx, dy, x, y, event) {
    var root = this.plotroot();
    var px_per_mm = root.data("px_per_mm");
    dx /= px_per_mm;
    dy /= px_per_mm;

    var tx0 = root.data("tx"),
        ty0 = root.data("ty");

    var dx0 = root.data("dx"),
        dy0 = root.data("dy");

    root.data("dx", dx);
    root.data("dy", dy);

    dx = dx - dx0;
    dy = dy - dy0;

    var tx = tx0 + dx,
        ty = ty0 + dy;

    set_plot_pan_zoom(root, tx, ty, root.data("scale"));
};


Gadfly.guide_background_drag_onstart = function(x, y, event) {
    var root = this.plotroot();
    root.data("dx", 0);
    root.data("dy", 0);
    init_pan_zoom(root);
};


Gadfly.guide_background_drag_onend = function(event) {
    var root = this.plotroot();
};


Gadfly.guide_background_scroll = function(event) {
    if (event.shiftKey) {
        var root = this.plotroot();
        init_pan_zoom(root);
        var new_scale = root.data("scale") * Math.pow(2, 0.002 * event.wheelDelta);
        new_scale = Math.max(
            root.data("min_scale"),
            Math.min(root.data("max_scale"), new_scale))
        update_plot_scale(root, new_scale);
        event.stopPropagation();
    }
};


Gadfly.zoomslider_button_mouseover = function(event) {
    this.select(".button_logo")
         .animate({fill: this.data("mouseover_color")}, 100);
};


Gadfly.zoomslider_button_mouseout = function(event) {
     this.select(".button_logo")
         .animate({fill: this.data("mouseout_color")}, 100);
};


Gadfly.zoomslider_zoomout_click = function(event) {
    var root = this.plotroot();
    init_pan_zoom(root);
    var min_scale = root.data("min_scale"),
        scale = root.data("scale");
    Snap.animate(
        scale,
        Math.max(min_scale, scale / 1.5),
        function (new_scale) {
            update_plot_scale(root, new_scale);
        },
        200);
};


Gadfly.zoomslider_zoomin_click = function(event) {
    var root = this.plotroot();
    init_pan_zoom(root);
    var max_scale = root.data("max_scale"),
        scale = root.data("scale");

    Snap.animate(
        scale,
        Math.min(max_scale, scale * 1.5),
        function (new_scale) {
            update_plot_scale(root, new_scale);
        },
        200);
};


Gadfly.zoomslider_track_click = function(event) {
    // TODO
};


Gadfly.zoomslider_thumb_mousedown = function(event) {
    this.animate({fill: this.data("mouseover_color")}, 100);
};


Gadfly.zoomslider_thumb_mouseup = function(event) {
    this.animate({fill: this.data("mouseout_color")}, 100);
};


// compute the position in [0, 1] of the zoom slider thumb from the current scale
var slider_position_from_scale = function(scale, min_scale, max_scale) {
    if (scale >= 1.0) {
        return 0.5 + 0.5 * (Math.log(scale) / Math.log(max_scale));
    }
    else {
        return 0.5 * (Math.log(scale) - Math.log(min_scale)) / (0 - Math.log(min_scale));
    }
}


var update_plot_scale = function(root, new_scale) {
    var trans = scale_centered_translation(root, new_scale);
    set_plot_pan_zoom(root, trans.x, trans.y, new_scale);

    root.selectAll(".zoomslider_thumb")
        .forEach(function (element, i) {
            var min_pos = element.data("min_pos"),
                max_pos = element.data("max_pos"),
                min_scale = root.data("min_scale"),
                max_scale = root.data("max_scale");
            var xmid = (min_pos + max_pos) / 2;
            var xpos = slider_position_from_scale(new_scale, min_scale, max_scale);
            element.transform(new Snap.Matrix().translate(
                Math.max(min_pos, Math.min(
                         max_pos, min_pos + (max_pos - min_pos) * xpos)) - xmid, 0));
    });
};


Gadfly.zoomslider_thumb_dragmove = function(dx, dy, x, y) {
    var root = this.plotroot();
    var min_pos = this.data("min_pos"),
        max_pos = this.data("max_pos"),
        min_scale = root.data("min_scale"),
        max_scale = root.data("max_scale"),
        old_scale = root.data("old_scale");

    var px_per_mm = root.data("px_per_mm");
    dx /= px_per_mm;
    dy /= px_per_mm;

    var xmid = (min_pos + max_pos) / 2;
    var xpos = slider_position_from_scale(old_scale, min_scale, max_scale) +
                   dx / (max_pos - min_pos);

    // compute the new scale
    var new_scale;
    if (xpos >= 0.5) {
        new_scale = Math.exp(2.0 * (xpos - 0.5) * Math.log(max_scale));
    }
    else {
        new_scale = Math.exp(2.0 * xpos * (0 - Math.log(min_scale)) +
                        Math.log(min_scale));
    }
    new_scale = Math.min(max_scale, Math.max(min_scale, new_scale));

    update_plot_scale(root, new_scale);
};


Gadfly.zoomslider_thumb_dragstart = function(event) {
    var root = this.plotroot();
    init_pan_zoom(root);

    // keep track of what the scale was when we started dragging
    root.data("old_scale", root.data("scale"));
};


Gadfly.zoomslider_thumb_dragend = function(event) {
};


var toggle_color_class = function(root, color_class, ison) {
    var guides = root.selectAll(".guide." + color_class + ",.guide ." + color_class);
    var geoms = root.selectAll(".geometry." + color_class + ",.geometry ." + color_class);
    if (ison) {
        guides.animate({opacity: 0.5}, 250);
        geoms.animate({opacity: 0.0}, 250);
    } else {
        guides.animate({opacity: 1.0}, 250);
        geoms.animate({opacity: 1.0}, 250);
    }
};


Gadfly.colorkey_swatch_click = function(event) {
    var root = this.plotroot();
    var color_class = this.data("color_class");

    if (event.shiftKey) {
        root.selectAll(".colorkey text")
            .forEach(function (element) {
                var other_color_class = element.data("color_class");
                if (other_color_class != color_class) {
                    toggle_color_class(root, other_color_class,
                                       element.attr("opacity") == 1.0);
                }
            });
    } else {
        toggle_color_class(root, color_class, this.attr("opacity") == 1.0);
    }
};


return Gadfly;

}));


//@ sourceURL=gadfly.js

(function (glob, factory) {
    // AMD support
      if (typeof require === "function" && typeof define === "function" && define.amd) {
        require(["Snap.svg", "Gadfly"], function (Snap, Gadfly) {
            factory(Snap, Gadfly);
        });
      } else {
          factory(glob.Snap, glob.Gadfly);
      }
})(window, function (Snap, Gadfly) {
    var fig = Snap("#fig-4f8776f47c1745e3b1527a931867061a");
fig.select("#fig-4f8776f47c1745e3b1527a931867061a-element-4")
   .mouseenter(Gadfly.plot_mouseover)
.mouseleave(Gadfly.plot_mouseout)
.mousewheel(Gadfly.guide_background_scroll)
.drag(Gadfly.guide_background_drag_onmove,
      Gadfly.guide_background_drag_onstart,
      Gadfly.guide_background_drag_onend)
;
fig.select("#fig-4f8776f47c1745e3b1527a931867061a-element-7")
   .plotroot().data("unfocused_ygrid_color", "#D0D0E0")
;
fig.select("#fig-4f8776f47c1745e3b1527a931867061a-element-7")
   .plotroot().data("focused_ygrid_color", "#A0A0A0")
;
fig.select("#fig-4f8776f47c1745e3b1527a931867061a-element-8")
   .plotroot().data("unfocused_xgrid_color", "#D0D0E0")
;
fig.select("#fig-4f8776f47c1745e3b1527a931867061a-element-8")
   .plotroot().data("focused_xgrid_color", "#A0A0A0")
;
fig.select("#fig-4f8776f47c1745e3b1527a931867061a-element-13")
   .data("mouseover_color", "#cd5c5c")
;
fig.select("#fig-4f8776f47c1745e3b1527a931867061a-element-13")
   .data("mouseout_color", "#6a6a6a")
;
fig.select("#fig-4f8776f47c1745e3b1527a931867061a-element-13")
   .click(Gadfly.zoomslider_zoomin_click)
.mouseenter(Gadfly.zoomslider_button_mouseover)
.mouseleave(Gadfly.zoomslider_button_mouseout)
;
fig.select("#fig-4f8776f47c1745e3b1527a931867061a-element-15")
   .data("max_pos", 120.42)
;
fig.select("#fig-4f8776f47c1745e3b1527a931867061a-element-15")
   .data("min_pos", 103.42)
;
fig.select("#fig-4f8776f47c1745e3b1527a931867061a-element-15")
   .click(Gadfly.zoomslider_track_click);
fig.select("#fig-4f8776f47c1745e3b1527a931867061a-element-16")
   .data("max_pos", 120.42)
;
fig.select("#fig-4f8776f47c1745e3b1527a931867061a-element-16")
   .data("min_pos", 103.42)
;
fig.select("#fig-4f8776f47c1745e3b1527a931867061a-element-16")
   .data("mouseover_color", "#cd5c5c")
;
fig.select("#fig-4f8776f47c1745e3b1527a931867061a-element-16")
   .data("mouseout_color", "#6a6a6a")
;
fig.select("#fig-4f8776f47c1745e3b1527a931867061a-element-16")
   .drag(Gadfly.zoomslider_thumb_dragmove,
     Gadfly.zoomslider_thumb_dragstart,
     Gadfly.zoomslider_thumb_dragend)
.mousedown(Gadfly.zoomslider_thumb_mousedown)
.mouseup(Gadfly.zoomslider_thumb_mouseup)
;
fig.select("#fig-4f8776f47c1745e3b1527a931867061a-element-17")
   .data("mouseover_color", "#cd5c5c")
;
fig.select("#fig-4f8776f47c1745e3b1527a931867061a-element-17")
   .data("mouseout_color", "#6a6a6a")
;
fig.select("#fig-4f8776f47c1745e3b1527a931867061a-element-17")
   .click(Gadfly.zoomslider_zoomout_click)
.mouseenter(Gadfly.zoomslider_button_mouseover)
.mouseleave(Gadfly.zoomslider_button_mouseout)
;
    });
]]> </script>
</svg>





    plot(x=t,y=p1hat, Guide.XLabel("Time"), Guide.YLabel("p1hat(t)"), Guide.YTicks(ticks=[0:0.0025:0.0225]), Guide.XTicks(ticks=[0:1:10]))




<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg"
     xmlns:xlink="http://www.w3.org/1999/xlink"
     xmlns:gadfly="http://www.gadflyjl.org/ns"
     version="1.2"
     width="141.42mm" height="100mm" viewBox="0 0 141.42 100"
     stroke="none"
     fill="#000000"
     stroke-width="0.3"
     font-size="3.88"

     id="fig-513a44c54ef244079cf52ea51c3ae086">
<g class="plotroot xscalable yscalable" id="fig-513a44c54ef244079cf52ea51c3ae086-element-1">
  <g font-size="3.88" font-family="'PT Sans','Helvetica Neue','Helvetica',sans-serif" fill="#564A55" stroke="none" id="fig-513a44c54ef244079cf52ea51c3ae086-element-2">
    <text x="80.04" y="92" text-anchor="middle">Time</text>
  </g>
  <g class="guide xlabels" font-size="2.82" font-family="'PT Sans Caption','Helvetica Neue','Helvetica',sans-serif" fill="#6C606B" id="fig-513a44c54ef244079cf52ea51c3ae086-element-3">
    <text x="25.65" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">0</text>
    <text x="36.53" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">1</text>
    <text x="47.41" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">2</text>
    <text x="58.28" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">3</text>
    <text x="69.16" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">4</text>
    <text x="80.04" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">5</text>
    <text x="90.91" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">6</text>
    <text x="101.79" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">7</text>
    <text x="112.67" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">8</text>
    <text x="123.54" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">9</text>
    <text x="134.42" y="84.39" text-anchor="middle" gadfly:scale="1.0" visibility="visible">10</text>
  </g>
  <g clip-path="url(#fig-513a44c54ef244079cf52ea51c3ae086-element-5)" id="fig-513a44c54ef244079cf52ea51c3ae086-element-4">
    <g pointer-events="visible" opacity="1" fill="none" stroke="none" class="guide background" id="fig-513a44c54ef244079cf52ea51c3ae086-element-6">
      <rect x="23.65" y="5" width="112.77" height="75.72"/>
    </g>
    <g class="guide xgridlines yfixed" stroke-dasharray="0.5,0.5" stroke-width="0.2" stroke="#D0D0E0" id="fig-513a44c54ef244079cf52ea51c3ae086-element-7">
      <path fill="none" d="M25.65,5 L 25.65 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M36.53,5 L 36.53 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M47.41,5 L 47.41 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M58.28,5 L 58.28 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M69.16,5 L 69.16 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M80.04,5 L 80.04 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M90.91,5 L 90.91 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M101.79,5 L 101.79 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M112.67,5 L 112.67 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M123.54,5 L 123.54 80.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M134.42,5 L 134.42 80.72" gadfly:scale="1.0" visibility="visible"/>
    </g>
    <g class="guide ygridlines xfixed" stroke-dasharray="0.5,0.5" stroke-width="0.2" stroke="#D0D0E0" id="fig-513a44c54ef244079cf52ea51c3ae086-element-8">
      <path fill="none" d="M23.65,78.72 L 136.42 78.72" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M23.65,70.75 L 136.42 70.75" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M23.65,62.78 L 136.42 62.78" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M23.65,54.81 L 136.42 54.81" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M23.65,46.84 L 136.42 46.84" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M23.65,38.87 L 136.42 38.87" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M23.65,30.91 L 136.42 30.91" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M23.65,22.94 L 136.42 22.94" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M23.65,14.97 L 136.42 14.97" gadfly:scale="1.0" visibility="visible"/>
      <path fill="none" d="M23.65,7 L 136.42 7" gadfly:scale="1.0" visibility="visible"/>
    </g>
    <g class="plotpanel" id="fig-513a44c54ef244079cf52ea51c3ae086-element-9">
      <g class="geometry" id="fig-513a44c54ef244079cf52ea51c3ae086-element-10">
        <g class="color_RGB{Float32}(0.0f0,0.74736935f0,1.0f0)" stroke="#FFFFFF" stroke-width="0.3" fill="#00BFFF" id="fig-513a44c54ef244079cf52ea51c3ae086-element-11">
          <circle cx="25.65" cy="78.72" r="0.9"/>
          <circle cx="25.92" cy="15.41" r="0.9"/>
          <circle cx="26.2" cy="15.54" r="0.9"/>
          <circle cx="26.47" cy="15.75" r="0.9"/>
          <circle cx="26.74" cy="16.04" r="0.9"/>
          <circle cx="27.01" cy="16.4" r="0.9"/>
          <circle cx="27.28" cy="16.82" r="0.9"/>
          <circle cx="27.56" cy="17.29" r="0.9"/>
          <circle cx="27.83" cy="17.8" r="0.9"/>
          <circle cx="28.1" cy="18.33" r="0.9"/>
          <circle cx="28.37" cy="18.88" r="0.9"/>
          <circle cx="28.64" cy="19.43" r="0.9"/>
          <circle cx="28.91" cy="19.97" r="0.9"/>
          <circle cx="29.19" cy="20.48" r="0.9"/>
          <circle cx="29.46" cy="20.95" r="0.9"/>
          <circle cx="29.73" cy="21.37" r="0.9"/>
          <circle cx="30" cy="21.73" r="0.9"/>
          <circle cx="30.27" cy="22.01" r="0.9"/>
          <circle cx="30.55" cy="22.22" r="0.9"/>
          <circle cx="30.82" cy="22.35" r="0.9"/>
          <circle cx="31.09" cy="22.4" r="0.9"/>
          <circle cx="31.36" cy="22.35" r="0.9"/>
          <circle cx="31.63" cy="22.22" r="0.9"/>
          <circle cx="31.91" cy="22.01" r="0.9"/>
          <circle cx="32.18" cy="21.73" r="0.9"/>
          <circle cx="32.45" cy="21.37" r="0.9"/>
          <circle cx="32.72" cy="20.95" r="0.9"/>
          <circle cx="32.99" cy="20.48" r="0.9"/>
          <circle cx="33.27" cy="19.97" r="0.9"/>
          <circle cx="33.54" cy="19.43" r="0.9"/>
          <circle cx="33.81" cy="18.88" r="0.9"/>
          <circle cx="34.08" cy="18.33" r="0.9"/>
          <circle cx="34.35" cy="17.8" r="0.9"/>
          <circle cx="34.63" cy="17.29" r="0.9"/>
          <circle cx="34.9" cy="16.82" r="0.9"/>
          <circle cx="35.17" cy="16.4" r="0.9"/>
          <circle cx="35.44" cy="16.04" r="0.9"/>
          <circle cx="35.71" cy="15.75" r="0.9"/>
          <circle cx="35.98" cy="15.54" r="0.9"/>
          <circle cx="36.26" cy="15.41" r="0.9"/>
          <circle cx="36.53" cy="15.37" r="0.9"/>
          <circle cx="36.8" cy="15.41" r="0.9"/>
          <circle cx="37.07" cy="15.54" r="0.9"/>
          <circle cx="37.34" cy="15.75" r="0.9"/>
          <circle cx="37.62" cy="16.04" r="0.9"/>
          <circle cx="37.89" cy="16.4" r="0.9"/>
          <circle cx="38.16" cy="16.82" r="0.9"/>
          <circle cx="38.43" cy="17.29" r="0.9"/>
          <circle cx="38.7" cy="17.8" r="0.9"/>
          <circle cx="38.98" cy="18.33" r="0.9"/>
          <circle cx="39.25" cy="18.88" r="0.9"/>
          <circle cx="39.52" cy="19.43" r="0.9"/>
          <circle cx="39.79" cy="19.97" r="0.9"/>
          <circle cx="40.06" cy="20.48" r="0.9"/>
          <circle cx="40.34" cy="20.95" r="0.9"/>
          <circle cx="40.61" cy="21.37" r="0.9"/>
          <circle cx="40.88" cy="21.73" r="0.9"/>
          <circle cx="41.15" cy="22.01" r="0.9"/>
          <circle cx="41.42" cy="22.22" r="0.9"/>
          <circle cx="41.7" cy="22.35" r="0.9"/>
          <circle cx="41.97" cy="22.4" r="0.9"/>
          <circle cx="42.24" cy="22.35" r="0.9"/>
          <circle cx="42.51" cy="22.22" r="0.9"/>
          <circle cx="42.78" cy="22.01" r="0.9"/>
          <circle cx="43.05" cy="21.73" r="0.9"/>
          <circle cx="43.33" cy="21.37" r="0.9"/>
          <circle cx="43.6" cy="20.95" r="0.9"/>
          <circle cx="43.87" cy="20.48" r="0.9"/>
          <circle cx="44.14" cy="19.97" r="0.9"/>
          <circle cx="44.41" cy="19.43" r="0.9"/>
          <circle cx="44.69" cy="18.88" r="0.9"/>
          <circle cx="44.96" cy="18.33" r="0.9"/>
          <circle cx="45.23" cy="17.8" r="0.9"/>
          <circle cx="45.5" cy="17.29" r="0.9"/>
          <circle cx="45.77" cy="16.82" r="0.9"/>
          <circle cx="46.05" cy="16.4" r="0.9"/>
          <circle cx="46.32" cy="16.04" r="0.9"/>
          <circle cx="46.59" cy="15.75" r="0.9"/>
          <circle cx="46.86" cy="15.54" r="0.9"/>
          <circle cx="47.13" cy="15.41" r="0.9"/>
          <circle cx="47.41" cy="15.37" r="0.9"/>
          <circle cx="47.68" cy="15.41" r="0.9"/>
          <circle cx="47.95" cy="15.54" r="0.9"/>
          <circle cx="48.22" cy="15.75" r="0.9"/>
          <circle cx="48.49" cy="16.04" r="0.9"/>
          <circle cx="48.77" cy="16.4" r="0.9"/>
          <circle cx="49.04" cy="16.82" r="0.9"/>
          <circle cx="49.31" cy="17.29" r="0.9"/>
          <circle cx="49.58" cy="17.8" r="0.9"/>
          <circle cx="49.85" cy="18.33" r="0.9"/>
          <circle cx="50.12" cy="18.88" r="0.9"/>
          <circle cx="50.4" cy="19.43" r="0.9"/>
          <circle cx="50.67" cy="19.97" r="0.9"/>
          <circle cx="50.94" cy="20.48" r="0.9"/>
          <circle cx="51.21" cy="20.95" r="0.9"/>
          <circle cx="51.48" cy="21.37" r="0.9"/>
          <circle cx="51.76" cy="21.73" r="0.9"/>
          <circle cx="52.03" cy="22.01" r="0.9"/>
          <circle cx="52.3" cy="22.22" r="0.9"/>
          <circle cx="52.57" cy="22.35" r="0.9"/>
          <circle cx="52.84" cy="22.4" r="0.9"/>
          <circle cx="53.12" cy="22.35" r="0.9"/>
          <circle cx="53.39" cy="22.22" r="0.9"/>
          <circle cx="53.66" cy="22.01" r="0.9"/>
          <circle cx="53.93" cy="21.73" r="0.9"/>
          <circle cx="54.2" cy="21.37" r="0.9"/>
          <circle cx="54.48" cy="20.95" r="0.9"/>
          <circle cx="54.75" cy="20.48" r="0.9"/>
          <circle cx="55.02" cy="19.97" r="0.9"/>
          <circle cx="55.29" cy="19.43" r="0.9"/>
          <circle cx="55.56" cy="18.88" r="0.9"/>
          <circle cx="55.84" cy="18.33" r="0.9"/>
          <circle cx="56.11" cy="17.8" r="0.9"/>
          <circle cx="56.38" cy="17.29" r="0.9"/>
          <circle cx="56.65" cy="16.82" r="0.9"/>
          <circle cx="56.92" cy="16.4" r="0.9"/>
          <circle cx="57.19" cy="16.04" r="0.9"/>
          <circle cx="57.47" cy="15.75" r="0.9"/>
          <circle cx="57.74" cy="15.54" r="0.9"/>
          <circle cx="58.01" cy="15.41" r="0.9"/>
          <circle cx="58.28" cy="15.37" r="0.9"/>
          <circle cx="58.55" cy="15.41" r="0.9"/>
          <circle cx="58.83" cy="15.54" r="0.9"/>
          <circle cx="59.1" cy="15.75" r="0.9"/>
          <circle cx="59.37" cy="16.04" r="0.9"/>
          <circle cx="59.64" cy="16.4" r="0.9"/>
          <circle cx="59.91" cy="16.82" r="0.9"/>
          <circle cx="60.19" cy="17.29" r="0.9"/>
          <circle cx="60.46" cy="17.8" r="0.9"/>
          <circle cx="60.73" cy="18.33" r="0.9"/>
          <circle cx="61" cy="18.88" r="0.9"/>
          <circle cx="61.27" cy="19.43" r="0.9"/>
          <circle cx="61.55" cy="19.97" r="0.9"/>
          <circle cx="61.82" cy="20.48" r="0.9"/>
          <circle cx="62.09" cy="20.95" r="0.9"/>
          <circle cx="62.36" cy="21.37" r="0.9"/>
          <circle cx="62.63" cy="21.73" r="0.9"/>
          <circle cx="62.91" cy="22.01" r="0.9"/>
          <circle cx="63.18" cy="22.22" r="0.9"/>
          <circle cx="63.45" cy="22.35" r="0.9"/>
          <circle cx="63.72" cy="22.4" r="0.9"/>
          <circle cx="63.99" cy="22.35" r="0.9"/>
          <circle cx="64.26" cy="22.22" r="0.9"/>
          <circle cx="64.54" cy="22.01" r="0.9"/>
          <circle cx="64.81" cy="21.73" r="0.9"/>
          <circle cx="65.08" cy="21.37" r="0.9"/>
          <circle cx="65.35" cy="20.95" r="0.9"/>
          <circle cx="65.62" cy="20.48" r="0.9"/>
          <circle cx="65.9" cy="19.97" r="0.9"/>
          <circle cx="66.17" cy="19.43" r="0.9"/>
          <circle cx="66.44" cy="18.88" r="0.9"/>
          <circle cx="66.71" cy="18.33" r="0.9"/>
          <circle cx="66.98" cy="17.8" r="0.9"/>
          <circle cx="67.26" cy="17.29" r="0.9"/>
          <circle cx="67.53" cy="16.82" r="0.9"/>
          <circle cx="67.8" cy="16.4" r="0.9"/>
          <circle cx="68.07" cy="16.04" r="0.9"/>
          <circle cx="68.34" cy="15.75" r="0.9"/>
          <circle cx="68.62" cy="15.54" r="0.9"/>
          <circle cx="68.89" cy="15.41" r="0.9"/>
          <circle cx="69.16" cy="15.37" r="0.9"/>
          <circle cx="69.43" cy="15.41" r="0.9"/>
          <circle cx="69.7" cy="15.54" r="0.9"/>
          <circle cx="69.98" cy="15.75" r="0.9"/>
          <circle cx="70.25" cy="16.04" r="0.9"/>
          <circle cx="70.52" cy="16.4" r="0.9"/>
          <circle cx="70.79" cy="16.82" r="0.9"/>
          <circle cx="71.06" cy="17.29" r="0.9"/>
          <circle cx="71.33" cy="17.8" r="0.9"/>
          <circle cx="71.61" cy="18.33" r="0.9"/>
          <circle cx="71.88" cy="18.88" r="0.9"/>
          <circle cx="72.15" cy="19.43" r="0.9"/>
          <circle cx="72.42" cy="19.97" r="0.9"/>
          <circle cx="72.69" cy="20.48" r="0.9"/>
          <circle cx="72.97" cy="20.95" r="0.9"/>
          <circle cx="73.24" cy="21.37" r="0.9"/>
          <circle cx="73.51" cy="21.73" r="0.9"/>
          <circle cx="73.78" cy="22.01" r="0.9"/>
          <circle cx="74.05" cy="22.22" r="0.9"/>
          <circle cx="74.33" cy="22.35" r="0.9"/>
          <circle cx="74.6" cy="22.4" r="0.9"/>
          <circle cx="74.87" cy="22.35" r="0.9"/>
          <circle cx="75.14" cy="22.22" r="0.9"/>
          <circle cx="75.41" cy="22.01" r="0.9"/>
          <circle cx="75.69" cy="21.73" r="0.9"/>
          <circle cx="75.96" cy="21.37" r="0.9"/>
          <circle cx="76.23" cy="20.95" r="0.9"/>
          <circle cx="76.5" cy="20.48" r="0.9"/>
          <circle cx="76.77" cy="19.97" r="0.9"/>
          <circle cx="77.05" cy="19.43" r="0.9"/>
          <circle cx="77.32" cy="18.88" r="0.9"/>
          <circle cx="77.59" cy="18.33" r="0.9"/>
          <circle cx="77.86" cy="17.8" r="0.9"/>
          <circle cx="78.13" cy="17.29" r="0.9"/>
          <circle cx="78.4" cy="16.82" r="0.9"/>
          <circle cx="78.68" cy="16.4" r="0.9"/>
          <circle cx="78.95" cy="16.04" r="0.9"/>
          <circle cx="79.22" cy="15.75" r="0.9"/>
          <circle cx="79.49" cy="15.54" r="0.9"/>
          <circle cx="79.76" cy="15.41" r="0.9"/>
          <circle cx="80.04" cy="15.37" r="0.9"/>
          <circle cx="80.31" cy="15.41" r="0.9"/>
          <circle cx="80.58" cy="15.54" r="0.9"/>
          <circle cx="80.85" cy="15.75" r="0.9"/>
          <circle cx="81.12" cy="16.04" r="0.9"/>
          <circle cx="81.4" cy="16.4" r="0.9"/>
          <circle cx="81.67" cy="16.82" r="0.9"/>
          <circle cx="81.94" cy="17.29" r="0.9"/>
          <circle cx="82.21" cy="17.8" r="0.9"/>
          <circle cx="82.48" cy="18.33" r="0.9"/>
          <circle cx="82.76" cy="18.88" r="0.9"/>
          <circle cx="83.03" cy="19.43" r="0.9"/>
          <circle cx="83.3" cy="19.97" r="0.9"/>
          <circle cx="83.57" cy="20.48" r="0.9"/>
          <circle cx="83.84" cy="20.95" r="0.9"/>
          <circle cx="84.12" cy="21.37" r="0.9"/>
          <circle cx="84.39" cy="21.73" r="0.9"/>
          <circle cx="84.66" cy="22.01" r="0.9"/>
          <circle cx="84.93" cy="22.22" r="0.9"/>
          <circle cx="85.2" cy="22.35" r="0.9"/>
          <circle cx="85.47" cy="22.4" r="0.9"/>
          <circle cx="85.75" cy="22.35" r="0.9"/>
          <circle cx="86.02" cy="22.22" r="0.9"/>
          <circle cx="86.29" cy="22.01" r="0.9"/>
          <circle cx="86.56" cy="21.73" r="0.9"/>
          <circle cx="86.83" cy="21.37" r="0.9"/>
          <circle cx="87.11" cy="20.95" r="0.9"/>
          <circle cx="87.38" cy="20.48" r="0.9"/>
          <circle cx="87.65" cy="19.97" r="0.9"/>
          <circle cx="87.92" cy="19.43" r="0.9"/>
          <circle cx="88.19" cy="18.88" r="0.9"/>
          <circle cx="88.47" cy="18.33" r="0.9"/>
          <circle cx="88.74" cy="17.8" r="0.9"/>
          <circle cx="89.01" cy="17.29" r="0.9"/>
          <circle cx="89.28" cy="16.82" r="0.9"/>
          <circle cx="89.55" cy="16.4" r="0.9"/>
          <circle cx="89.83" cy="16.04" r="0.9"/>
          <circle cx="90.1" cy="15.75" r="0.9"/>
          <circle cx="90.37" cy="15.54" r="0.9"/>
          <circle cx="90.64" cy="15.41" r="0.9"/>
          <circle cx="90.91" cy="15.37" r="0.9"/>
          <circle cx="91.19" cy="15.41" r="0.9"/>
          <circle cx="91.46" cy="15.54" r="0.9"/>
          <circle cx="91.73" cy="15.75" r="0.9"/>
          <circle cx="92" cy="16.04" r="0.9"/>
          <circle cx="92.27" cy="16.4" r="0.9"/>
          <circle cx="92.55" cy="16.82" r="0.9"/>
          <circle cx="92.82" cy="17.29" r="0.9"/>
          <circle cx="93.09" cy="17.8" r="0.9"/>
          <circle cx="93.36" cy="18.33" r="0.9"/>
          <circle cx="93.63" cy="18.88" r="0.9"/>
          <circle cx="93.9" cy="19.43" r="0.9"/>
          <circle cx="94.18" cy="19.97" r="0.9"/>
          <circle cx="94.45" cy="20.48" r="0.9"/>
          <circle cx="94.72" cy="20.95" r="0.9"/>
          <circle cx="94.99" cy="21.37" r="0.9"/>
          <circle cx="95.26" cy="21.73" r="0.9"/>
          <circle cx="95.54" cy="22.01" r="0.9"/>
          <circle cx="95.81" cy="22.22" r="0.9"/>
          <circle cx="96.08" cy="22.35" r="0.9"/>
          <circle cx="96.35" cy="22.4" r="0.9"/>
          <circle cx="96.62" cy="22.35" r="0.9"/>
          <circle cx="96.9" cy="22.22" r="0.9"/>
          <circle cx="97.17" cy="22.01" r="0.9"/>
          <circle cx="97.44" cy="21.73" r="0.9"/>
          <circle cx="97.71" cy="21.37" r="0.9"/>
          <circle cx="97.98" cy="20.95" r="0.9"/>
          <circle cx="98.26" cy="20.48" r="0.9"/>
          <circle cx="98.53" cy="19.97" r="0.9"/>
          <circle cx="98.8" cy="19.43" r="0.9"/>
          <circle cx="99.07" cy="18.88" r="0.9"/>
          <circle cx="99.34" cy="18.33" r="0.9"/>
          <circle cx="99.62" cy="17.8" r="0.9"/>
          <circle cx="99.89" cy="17.29" r="0.9"/>
          <circle cx="100.16" cy="16.82" r="0.9"/>
          <circle cx="100.43" cy="16.4" r="0.9"/>
          <circle cx="100.7" cy="16.04" r="0.9"/>
          <circle cx="100.97" cy="15.75" r="0.9"/>
          <circle cx="101.25" cy="15.54" r="0.9"/>
          <circle cx="101.52" cy="15.41" r="0.9"/>
          <circle cx="101.79" cy="15.37" r="0.9"/>
          <circle cx="102.06" cy="15.41" r="0.9"/>
          <circle cx="102.33" cy="15.54" r="0.9"/>
          <circle cx="102.61" cy="15.75" r="0.9"/>
          <circle cx="102.88" cy="16.04" r="0.9"/>
          <circle cx="103.15" cy="16.4" r="0.9"/>
          <circle cx="103.42" cy="16.82" r="0.9"/>
          <circle cx="103.69" cy="17.29" r="0.9"/>
          <circle cx="103.97" cy="17.8" r="0.9"/>
          <circle cx="104.24" cy="18.33" r="0.9"/>
          <circle cx="104.51" cy="18.88" r="0.9"/>
          <circle cx="104.78" cy="19.43" r="0.9"/>
          <circle cx="105.05" cy="19.97" r="0.9"/>
          <circle cx="105.33" cy="20.48" r="0.9"/>
          <circle cx="105.6" cy="20.95" r="0.9"/>
          <circle cx="105.87" cy="21.37" r="0.9"/>
          <circle cx="106.14" cy="21.73" r="0.9"/>
          <circle cx="106.41" cy="22.01" r="0.9"/>
          <circle cx="106.69" cy="22.22" r="0.9"/>
          <circle cx="106.96" cy="22.35" r="0.9"/>
          <circle cx="107.23" cy="22.4" r="0.9"/>
          <circle cx="107.5" cy="22.35" r="0.9"/>
          <circle cx="107.77" cy="22.22" r="0.9"/>
          <circle cx="108.04" cy="22.01" r="0.9"/>
          <circle cx="108.32" cy="21.73" r="0.9"/>
          <circle cx="108.59" cy="21.37" r="0.9"/>
          <circle cx="108.86" cy="20.95" r="0.9"/>
          <circle cx="109.13" cy="20.48" r="0.9"/>
          <circle cx="109.4" cy="19.97" r="0.9"/>
          <circle cx="109.68" cy="19.43" r="0.9"/>
          <circle cx="109.95" cy="18.88" r="0.9"/>
          <circle cx="110.22" cy="18.33" r="0.9"/>
          <circle cx="110.49" cy="17.8" r="0.9"/>
          <circle cx="110.76" cy="17.29" r="0.9"/>
          <circle cx="111.04" cy="16.82" r="0.9"/>
          <circle cx="111.31" cy="16.4" r="0.9"/>
          <circle cx="111.58" cy="16.04" r="0.9"/>
          <circle cx="111.85" cy="15.75" r="0.9"/>
          <circle cx="112.12" cy="15.54" r="0.9"/>
          <circle cx="112.4" cy="15.41" r="0.9"/>
          <circle cx="112.67" cy="15.37" r="0.9"/>
          <circle cx="112.94" cy="15.41" r="0.9"/>
          <circle cx="113.21" cy="15.54" r="0.9"/>
          <circle cx="113.48" cy="15.75" r="0.9"/>
          <circle cx="113.76" cy="16.04" r="0.9"/>
          <circle cx="114.03" cy="16.4" r="0.9"/>
          <circle cx="114.3" cy="16.82" r="0.9"/>
          <circle cx="114.57" cy="17.29" r="0.9"/>
          <circle cx="114.84" cy="17.8" r="0.9"/>
          <circle cx="115.11" cy="18.33" r="0.9"/>
          <circle cx="115.39" cy="18.88" r="0.9"/>
          <circle cx="115.66" cy="19.43" r="0.9"/>
          <circle cx="115.93" cy="19.97" r="0.9"/>
          <circle cx="116.2" cy="20.48" r="0.9"/>
          <circle cx="116.47" cy="20.95" r="0.9"/>
          <circle cx="116.75" cy="21.37" r="0.9"/>
          <circle cx="117.02" cy="21.73" r="0.9"/>
          <circle cx="117.29" cy="22.01" r="0.9"/>
          <circle cx="117.56" cy="22.22" r="0.9"/>
          <circle cx="117.83" cy="22.35" r="0.9"/>
          <circle cx="118.11" cy="22.4" r="0.9"/>
          <circle cx="118.38" cy="22.35" r="0.9"/>
          <circle cx="118.65" cy="22.22" r="0.9"/>
          <circle cx="118.92" cy="22.01" r="0.9"/>
          <circle cx="119.19" cy="21.73" r="0.9"/>
          <circle cx="119.47" cy="21.37" r="0.9"/>
          <circle cx="119.74" cy="20.95" r="0.9"/>
          <circle cx="120.01" cy="20.48" r="0.9"/>
          <circle cx="120.28" cy="19.97" r="0.9"/>
          <circle cx="120.55" cy="19.43" r="0.9"/>
          <circle cx="120.83" cy="18.88" r="0.9"/>
          <circle cx="121.1" cy="18.33" r="0.9"/>
          <circle cx="121.37" cy="17.8" r="0.9"/>
          <circle cx="121.64" cy="17.29" r="0.9"/>
          <circle cx="121.91" cy="16.82" r="0.9"/>
          <circle cx="122.18" cy="16.4" r="0.9"/>
          <circle cx="122.46" cy="16.04" r="0.9"/>
          <circle cx="122.73" cy="15.75" r="0.9"/>
          <circle cx="123" cy="15.54" r="0.9"/>
          <circle cx="123.27" cy="15.41" r="0.9"/>
          <circle cx="123.54" cy="15.37" r="0.9"/>
          <circle cx="123.82" cy="15.41" r="0.9"/>
          <circle cx="124.09" cy="15.54" r="0.9"/>
          <circle cx="124.36" cy="15.75" r="0.9"/>
          <circle cx="124.63" cy="16.04" r="0.9"/>
          <circle cx="124.9" cy="16.4" r="0.9"/>
          <circle cx="125.18" cy="16.82" r="0.9"/>
          <circle cx="125.45" cy="17.29" r="0.9"/>
          <circle cx="125.72" cy="17.8" r="0.9"/>
          <circle cx="125.99" cy="18.33" r="0.9"/>
          <circle cx="126.26" cy="18.88" r="0.9"/>
          <circle cx="126.54" cy="19.43" r="0.9"/>
          <circle cx="126.81" cy="19.97" r="0.9"/>
          <circle cx="127.08" cy="20.48" r="0.9"/>
          <circle cx="127.35" cy="20.95" r="0.9"/>
          <circle cx="127.62" cy="21.37" r="0.9"/>
          <circle cx="127.9" cy="21.73" r="0.9"/>
          <circle cx="128.17" cy="22.01" r="0.9"/>
          <circle cx="128.44" cy="22.22" r="0.9"/>
          <circle cx="128.71" cy="22.35" r="0.9"/>
          <circle cx="128.98" cy="22.4" r="0.9"/>
          <circle cx="129.25" cy="22.35" r="0.9"/>
          <circle cx="129.53" cy="22.22" r="0.9"/>
          <circle cx="129.8" cy="22.01" r="0.9"/>
          <circle cx="130.07" cy="21.73" r="0.9"/>
          <circle cx="130.34" cy="21.37" r="0.9"/>
          <circle cx="130.61" cy="20.95" r="0.9"/>
          <circle cx="130.89" cy="20.48" r="0.9"/>
          <circle cx="131.16" cy="19.97" r="0.9"/>
          <circle cx="131.43" cy="19.43" r="0.9"/>
          <circle cx="131.7" cy="18.88" r="0.9"/>
          <circle cx="131.97" cy="18.33" r="0.9"/>
          <circle cx="132.25" cy="17.8" r="0.9"/>
          <circle cx="132.52" cy="17.29" r="0.9"/>
          <circle cx="132.79" cy="16.82" r="0.9"/>
          <circle cx="133.06" cy="16.4" r="0.9"/>
          <circle cx="133.33" cy="16.04" r="0.9"/>
          <circle cx="133.61" cy="15.75" r="0.9"/>
          <circle cx="133.88" cy="15.54" r="0.9"/>
          <circle cx="134.15" cy="15.41" r="0.9"/>
          <circle cx="134.42" cy="15.36" r="0.9"/>
        </g>
      </g>
    </g>
    <g opacity="0" class="guide zoomslider" stroke="none" id="fig-513a44c54ef244079cf52ea51c3ae086-element-12">
      <g fill="#EAEAEA" stroke-width="0.3" stroke-opacity="0" stroke="#6A6A6A" id="fig-513a44c54ef244079cf52ea51c3ae086-element-13">
        <rect x="129.42" y="8" width="4" height="4"/>
        <g class="button_logo" fill="#6A6A6A" id="fig-513a44c54ef244079cf52ea51c3ae086-element-14">
          <path d="M130.22,9.6 L 131.02 9.6 131.02 8.8 131.82 8.8 131.82 9.6 132.62 9.6 132.62 10.4 131.82 10.4 131.82 11.2 131.02 11.2 131.02 10.4 130.22 10.4 z"/>
        </g>
      </g>
      <g fill="#EAEAEA" id="fig-513a44c54ef244079cf52ea51c3ae086-element-15">
        <rect x="109.92" y="8" width="19" height="4"/>
      </g>
      <g class="zoomslider_thumb" fill="#6A6A6A" id="fig-513a44c54ef244079cf52ea51c3ae086-element-16">
        <rect x="118.42" y="8" width="2" height="4"/>
      </g>
      <g fill="#EAEAEA" stroke-width="0.3" stroke-opacity="0" stroke="#6A6A6A" id="fig-513a44c54ef244079cf52ea51c3ae086-element-17">
        <rect x="105.42" y="8" width="4" height="4"/>
        <g class="button_logo" fill="#6A6A6A" id="fig-513a44c54ef244079cf52ea51c3ae086-element-18">
          <path d="M106.22,9.6 L 108.62 9.6 108.62 10.4 106.22 10.4 z"/>
        </g>
      </g>
    </g>
  </g>
  <g class="guide ylabels" font-size="2.82" font-family="'PT Sans Caption','Helvetica Neue','Helvetica',sans-serif" fill="#6C606B" id="fig-513a44c54ef244079cf52ea51c3ae086-element-19">
    <text x="22.65" y="78.72" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="visible">0.0000</text>
    <text x="22.65" y="70.75" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="visible">0.0025</text>
    <text x="22.65" y="62.78" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="visible">0.0050</text>
    <text x="22.65" y="54.81" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="visible">0.0075</text>
    <text x="22.65" y="46.84" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="visible">0.0100</text>
    <text x="22.65" y="38.87" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="visible">0.0125</text>
    <text x="22.65" y="30.91" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="visible">0.0150</text>
    <text x="22.65" y="22.94" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="visible">0.0175</text>
    <text x="22.65" y="14.97" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="visible">0.0200</text>
    <text x="22.65" y="7" text-anchor="end" dy="0.35em" gadfly:scale="1.0" visibility="visible">0.0225</text>
  </g>
  <g font-size="3.88" font-family="'PT Sans','Helvetica Neue','Helvetica',sans-serif" fill="#564A55" stroke="none" id="fig-513a44c54ef244079cf52ea51c3ae086-element-20">
    <text x="8.81" y="40.86" text-anchor="middle" dy="0.35em" transform="rotate(-90, 8.81, 42.86)">p1hat(t)</text>
  </g>
</g>
<defs>
<clipPath id="fig-513a44c54ef244079cf52ea51c3ae086-element-5">
  <path d="M23.65,5 L 136.42 5 136.42 80.72 23.65 80.72" />
</clipPath
></defs>
<script> <![CDATA[
(function(N){var k=/[\.\/]/,L=/\s*,\s*/,C=function(a,d){return a-d},a,v,y={n:{}},M=function(){for(var a=0,d=this.length;a<d;a++)if("undefined"!=typeof this[a])return this[a]},A=function(){for(var a=this.length;--a;)if("undefined"!=typeof this[a])return this[a]},w=function(k,d){k=String(k);var f=v,n=Array.prototype.slice.call(arguments,2),u=w.listeners(k),p=0,b,q=[],e={},l=[],r=a;l.firstDefined=M;l.lastDefined=A;a=k;for(var s=v=0,x=u.length;s<x;s++)"zIndex"in u[s]&&(q.push(u[s].zIndex),0>u[s].zIndex&&
(e[u[s].zIndex]=u[s]));for(q.sort(C);0>q[p];)if(b=e[q[p++] ],l.push(b.apply(d,n)),v)return v=f,l;for(s=0;s<x;s++)if(b=u[s],"zIndex"in b)if(b.zIndex==q[p]){l.push(b.apply(d,n));if(v)break;do if(p++,(b=e[q[p] ])&&l.push(b.apply(d,n)),v)break;while(b)}else e[b.zIndex]=b;else if(l.push(b.apply(d,n)),v)break;v=f;a=r;return l};w._events=y;w.listeners=function(a){a=a.split(k);var d=y,f,n,u,p,b,q,e,l=[d],r=[];u=0;for(p=a.length;u<p;u++){e=[];b=0;for(q=l.length;b<q;b++)for(d=l[b].n,f=[d[a[u] ],d["*"] ],n=2;n--;)if(d=
f[n])e.push(d),r=r.concat(d.f||[]);l=e}return r};w.on=function(a,d){a=String(a);if("function"!=typeof d)return function(){};for(var f=a.split(L),n=0,u=f.length;n<u;n++)(function(a){a=a.split(k);for(var b=y,f,e=0,l=a.length;e<l;e++)b=b.n,b=b.hasOwnProperty(a[e])&&b[a[e] ]||(b[a[e] ]={n:{}});b.f=b.f||[];e=0;for(l=b.f.length;e<l;e++)if(b.f[e]==d){f=!0;break}!f&&b.f.push(d)})(f[n]);return function(a){+a==+a&&(d.zIndex=+a)}};w.f=function(a){var d=[].slice.call(arguments,1);return function(){w.apply(null,
[a,null].concat(d).concat([].slice.call(arguments,0)))}};w.stop=function(){v=1};w.nt=function(k){return k?(new RegExp("(?:\\.|\\/|^)"+k+"(?:\\.|\\/|$)")).test(a):a};w.nts=function(){return a.split(k)};w.off=w.unbind=function(a,d){if(a){var f=a.split(L);if(1<f.length)for(var n=0,u=f.length;n<u;n++)w.off(f[n],d);else{for(var f=a.split(k),p,b,q,e,l=[y],n=0,u=f.length;n<u;n++)for(e=0;e<l.length;e+=q.length-2){q=[e,1];p=l[e].n;if("*"!=f[n])p[f[n] ]&&q.push(p[f[n] ]);else for(b in p)p.hasOwnProperty(b)&&
q.push(p[b]);l.splice.apply(l,q)}n=0;for(u=l.length;n<u;n++)for(p=l[n];p.n;){if(d){if(p.f){e=0;for(f=p.f.length;e<f;e++)if(p.f[e]==d){p.f.splice(e,1);break}!p.f.length&&delete p.f}for(b in p.n)if(p.n.hasOwnProperty(b)&&p.n[b].f){q=p.n[b].f;e=0;for(f=q.length;e<f;e++)if(q[e]==d){q.splice(e,1);break}!q.length&&delete p.n[b].f}}else for(b in delete p.f,p.n)p.n.hasOwnProperty(b)&&p.n[b].f&&delete p.n[b].f;p=p.n}}}else w._events=y={n:{}}};w.once=function(a,d){var f=function(){w.unbind(a,f);return d.apply(this,
arguments)};return w.on(a,f)};w.version="0.4.2";w.toString=function(){return"You are running Eve 0.4.2"};"undefined"!=typeof module&&module.exports?module.exports=w:"function"===typeof define&&define.amd?define("eve",[],function(){return w}):N.eve=w})(this);
(function(N,k){"function"===typeof define&&define.amd?define("Snap.svg",["eve"],function(L){return k(N,L)}):k(N,N.eve)})(this,function(N,k){var L=function(a){var k={},y=N.requestAnimationFrame||N.webkitRequestAnimationFrame||N.mozRequestAnimationFrame||N.oRequestAnimationFrame||N.msRequestAnimationFrame||function(a){setTimeout(a,16)},M=Array.isArray||function(a){return a instanceof Array||"[object Array]"==Object.prototype.toString.call(a)},A=0,w="M"+(+new Date).toString(36),z=function(a){if(null==
a)return this.s;var b=this.s-a;this.b+=this.dur*b;this.B+=this.dur*b;this.s=a},d=function(a){if(null==a)return this.spd;this.spd=a},f=function(a){if(null==a)return this.dur;this.s=this.s*a/this.dur;this.dur=a},n=function(){delete k[this.id];this.update();a("mina.stop."+this.id,this)},u=function(){this.pdif||(delete k[this.id],this.update(),this.pdif=this.get()-this.b)},p=function(){this.pdif&&(this.b=this.get()-this.pdif,delete this.pdif,k[this.id]=this)},b=function(){var a;if(M(this.start)){a=[];
for(var b=0,e=this.start.length;b<e;b++)a[b]=+this.start[b]+(this.end[b]-this.start[b])*this.easing(this.s)}else a=+this.start+(this.end-this.start)*this.easing(this.s);this.set(a)},q=function(){var l=0,b;for(b in k)if(k.hasOwnProperty(b)){var e=k[b],f=e.get();l++;e.s=(f-e.b)/(e.dur/e.spd);1<=e.s&&(delete k[b],e.s=1,l--,function(b){setTimeout(function(){a("mina.finish."+b.id,b)})}(e));e.update()}l&&y(q)},e=function(a,r,s,x,G,h,J){a={id:w+(A++).toString(36),start:a,end:r,b:s,s:0,dur:x-s,spd:1,get:G,
set:h,easing:J||e.linear,status:z,speed:d,duration:f,stop:n,pause:u,resume:p,update:b};k[a.id]=a;r=0;for(var K in k)if(k.hasOwnProperty(K)&&(r++,2==r))break;1==r&&y(q);return a};e.time=Date.now||function(){return+new Date};e.getById=function(a){return k[a]||null};e.linear=function(a){return a};e.easeout=function(a){return Math.pow(a,1.7)};e.easein=function(a){return Math.pow(a,0.48)};e.easeinout=function(a){if(1==a)return 1;if(0==a)return 0;var b=0.48-a/1.04,e=Math.sqrt(0.1734+b*b);a=e-b;a=Math.pow(Math.abs(a),
1/3)*(0>a?-1:1);b=-e-b;b=Math.pow(Math.abs(b),1/3)*(0>b?-1:1);a=a+b+0.5;return 3*(1-a)*a*a+a*a*a};e.backin=function(a){return 1==a?1:a*a*(2.70158*a-1.70158)};e.backout=function(a){if(0==a)return 0;a-=1;return a*a*(2.70158*a+1.70158)+1};e.elastic=function(a){return a==!!a?a:Math.pow(2,-10*a)*Math.sin(2*(a-0.075)*Math.PI/0.3)+1};e.bounce=function(a){a<1/2.75?a*=7.5625*a:a<2/2.75?(a-=1.5/2.75,a=7.5625*a*a+0.75):a<2.5/2.75?(a-=2.25/2.75,a=7.5625*a*a+0.9375):(a-=2.625/2.75,a=7.5625*a*a+0.984375);return a};
return N.mina=e}("undefined"==typeof k?function(){}:k),C=function(){function a(c,t){if(c){if(c.tagName)return x(c);if(y(c,"array")&&a.set)return a.set.apply(a,c);if(c instanceof e)return c;if(null==t)return c=G.doc.querySelector(c),x(c)}return new s(null==c?"100%":c,null==t?"100%":t)}function v(c,a){if(a){"#text"==c&&(c=G.doc.createTextNode(a.text||""));"string"==typeof c&&(c=v(c));if("string"==typeof a)return"xlink:"==a.substring(0,6)?c.getAttributeNS(m,a.substring(6)):"xml:"==a.substring(0,4)?c.getAttributeNS(la,
a.substring(4)):c.getAttribute(a);for(var da in a)if(a[h](da)){var b=J(a[da]);b?"xlink:"==da.substring(0,6)?c.setAttributeNS(m,da.substring(6),b):"xml:"==da.substring(0,4)?c.setAttributeNS(la,da.substring(4),b):c.setAttribute(da,b):c.removeAttribute(da)}}else c=G.doc.createElementNS(la,c);return c}function y(c,a){a=J.prototype.toLowerCase.call(a);return"finite"==a?isFinite(c):"array"==a&&(c instanceof Array||Array.isArray&&Array.isArray(c))?!0:"null"==a&&null===c||a==typeof c&&null!==c||"object"==
a&&c===Object(c)||$.call(c).slice(8,-1).toLowerCase()==a}function M(c){if("function"==typeof c||Object(c)!==c)return c;var a=new c.constructor,b;for(b in c)c[h](b)&&(a[b]=M(c[b]));return a}function A(c,a,b){function m(){var e=Array.prototype.slice.call(arguments,0),f=e.join("\u2400"),d=m.cache=m.cache||{},l=m.count=m.count||[];if(d[h](f)){a:for(var e=l,l=f,B=0,H=e.length;B<H;B++)if(e[B]===l){e.push(e.splice(B,1)[0]);break a}return b?b(d[f]):d[f]}1E3<=l.length&&delete d[l.shift()];l.push(f);d[f]=c.apply(a,
e);return b?b(d[f]):d[f]}return m}function w(c,a,b,m,e,f){return null==e?(c-=b,a-=m,c||a?(180*I.atan2(-a,-c)/C+540)%360:0):w(c,a,e,f)-w(b,m,e,f)}function z(c){return c%360*C/180}function d(c){var a=[];c=c.replace(/(?:^|\s)(\w+)\(([^)]+)\)/g,function(c,b,m){m=m.split(/\s*,\s*|\s+/);"rotate"==b&&1==m.length&&m.push(0,0);"scale"==b&&(2<m.length?m=m.slice(0,2):2==m.length&&m.push(0,0),1==m.length&&m.push(m[0],0,0));"skewX"==b?a.push(["m",1,0,I.tan(z(m[0])),1,0,0]):"skewY"==b?a.push(["m",1,I.tan(z(m[0])),
0,1,0,0]):a.push([b.charAt(0)].concat(m));return c});return a}function f(c,t){var b=O(c),m=new a.Matrix;if(b)for(var e=0,f=b.length;e<f;e++){var h=b[e],d=h.length,B=J(h[0]).toLowerCase(),H=h[0]!=B,l=H?m.invert():0,E;"t"==B&&2==d?m.translate(h[1],0):"t"==B&&3==d?H?(d=l.x(0,0),B=l.y(0,0),H=l.x(h[1],h[2]),l=l.y(h[1],h[2]),m.translate(H-d,l-B)):m.translate(h[1],h[2]):"r"==B?2==d?(E=E||t,m.rotate(h[1],E.x+E.width/2,E.y+E.height/2)):4==d&&(H?(H=l.x(h[2],h[3]),l=l.y(h[2],h[3]),m.rotate(h[1],H,l)):m.rotate(h[1],
h[2],h[3])):"s"==B?2==d||3==d?(E=E||t,m.scale(h[1],h[d-1],E.x+E.width/2,E.y+E.height/2)):4==d?H?(H=l.x(h[2],h[3]),l=l.y(h[2],h[3]),m.scale(h[1],h[1],H,l)):m.scale(h[1],h[1],h[2],h[3]):5==d&&(H?(H=l.x(h[3],h[4]),l=l.y(h[3],h[4]),m.scale(h[1],h[2],H,l)):m.scale(h[1],h[2],h[3],h[4])):"m"==B&&7==d&&m.add(h[1],h[2],h[3],h[4],h[5],h[6])}return m}function n(c,t){if(null==t){var m=!0;t="linearGradient"==c.type||"radialGradient"==c.type?c.node.getAttribute("gradientTransform"):"pattern"==c.type?c.node.getAttribute("patternTransform"):
c.node.getAttribute("transform");if(!t)return new a.Matrix;t=d(t)}else t=a._.rgTransform.test(t)?J(t).replace(/\.{3}|\u2026/g,c._.transform||aa):d(t),y(t,"array")&&(t=a.path?a.path.toString.call(t):J(t)),c._.transform=t;var b=f(t,c.getBBox(1));if(m)return b;c.matrix=b}function u(c){c=c.node.ownerSVGElement&&x(c.node.ownerSVGElement)||c.node.parentNode&&x(c.node.parentNode)||a.select("svg")||a(0,0);var t=c.select("defs"),t=null==t?!1:t.node;t||(t=r("defs",c.node).node);return t}function p(c){return c.node.ownerSVGElement&&
x(c.node.ownerSVGElement)||a.select("svg")}function b(c,a,m){function b(c){if(null==c)return aa;if(c==+c)return c;v(B,{width:c});try{return B.getBBox().width}catch(a){return 0}}function h(c){if(null==c)return aa;if(c==+c)return c;v(B,{height:c});try{return B.getBBox().height}catch(a){return 0}}function e(b,B){null==a?d[b]=B(c.attr(b)||0):b==a&&(d=B(null==m?c.attr(b)||0:m))}var f=p(c).node,d={},B=f.querySelector(".svg---mgr");B||(B=v("rect"),v(B,{x:-9E9,y:-9E9,width:10,height:10,"class":"svg---mgr",
fill:"none"}),f.appendChild(B));switch(c.type){case "rect":e("rx",b),e("ry",h);case "image":e("width",b),e("height",h);case "text":e("x",b);e("y",h);break;case "circle":e("cx",b);e("cy",h);e("r",b);break;case "ellipse":e("cx",b);e("cy",h);e("rx",b);e("ry",h);break;case "line":e("x1",b);e("x2",b);e("y1",h);e("y2",h);break;case "marker":e("refX",b);e("markerWidth",b);e("refY",h);e("markerHeight",h);break;case "radialGradient":e("fx",b);e("fy",h);break;case "tspan":e("dx",b);e("dy",h);break;default:e(a,
b)}f.removeChild(B);return d}function q(c){y(c,"array")||(c=Array.prototype.slice.call(arguments,0));for(var a=0,b=0,m=this.node;this[a];)delete this[a++];for(a=0;a<c.length;a++)"set"==c[a].type?c[a].forEach(function(c){m.appendChild(c.node)}):m.appendChild(c[a].node);for(var h=m.childNodes,a=0;a<h.length;a++)this[b++]=x(h[a]);return this}function e(c){if(c.snap in E)return E[c.snap];var a=this.id=V(),b;try{b=c.ownerSVGElement}catch(m){}this.node=c;b&&(this.paper=new s(b));this.type=c.tagName;this.anims=
{};this._={transform:[]};c.snap=a;E[a]=this;"g"==this.type&&(this.add=q);if(this.type in{g:1,mask:1,pattern:1})for(var e in s.prototype)s.prototype[h](e)&&(this[e]=s.prototype[e])}function l(c){this.node=c}function r(c,a){var b=v(c);a.appendChild(b);return x(b)}function s(c,a){var b,m,f,d=s.prototype;if(c&&"svg"==c.tagName){if(c.snap in E)return E[c.snap];var l=c.ownerDocument;b=new e(c);m=c.getElementsByTagName("desc")[0];f=c.getElementsByTagName("defs")[0];m||(m=v("desc"),m.appendChild(l.createTextNode("Created with Snap")),
b.node.appendChild(m));f||(f=v("defs"),b.node.appendChild(f));b.defs=f;for(var ca in d)d[h](ca)&&(b[ca]=d[ca]);b.paper=b.root=b}else b=r("svg",G.doc.body),v(b.node,{height:a,version:1.1,width:c,xmlns:la});return b}function x(c){return!c||c instanceof e||c instanceof l?c:c.tagName&&"svg"==c.tagName.toLowerCase()?new s(c):c.tagName&&"object"==c.tagName.toLowerCase()&&"image/svg+xml"==c.type?new s(c.contentDocument.getElementsByTagName("svg")[0]):new e(c)}a.version="0.3.0";a.toString=function(){return"Snap v"+
this.version};a._={};var G={win:N,doc:N.document};a._.glob=G;var h="hasOwnProperty",J=String,K=parseFloat,U=parseInt,I=Math,P=I.max,Q=I.min,Y=I.abs,C=I.PI,aa="",$=Object.prototype.toString,F=/^\s*((#[a-f\d]{6})|(#[a-f\d]{3})|rgba?\(\s*([\d\.]+%?\s*,\s*[\d\.]+%?\s*,\s*[\d\.]+%?(?:\s*,\s*[\d\.]+%?)?)\s*\)|hsba?\(\s*([\d\.]+(?:deg|\xb0|%)?\s*,\s*[\d\.]+%?\s*,\s*[\d\.]+(?:%?\s*,\s*[\d\.]+)?%?)\s*\)|hsla?\(\s*([\d\.]+(?:deg|\xb0|%)?\s*,\s*[\d\.]+%?\s*,\s*[\d\.]+(?:%?\s*,\s*[\d\.]+)?%?)\s*\))\s*$/i;a._.separator=
RegExp("[,\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]+");var S=RegExp("[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*"),X={hs:1,rg:1},W=RegExp("([a-z])[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029,]*((-?\\d*\\.?\\d*(?:e[\\-+]?\\d+)?[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,?[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*)+)",
"ig"),ma=RegExp("([rstm])[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029,]*((-?\\d*\\.?\\d*(?:e[\\-+]?\\d+)?[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,?[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*)+)","ig"),Z=RegExp("(-?\\d*\\.?\\d*(?:e[\\-+]?\\d+)?)[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,?[\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*",
"ig"),na=0,ba="S"+(+new Date).toString(36),V=function(){return ba+(na++).toString(36)},m="http://www.w3.org/1999/xlink",la="http://www.w3.org/2000/svg",E={},ca=a.url=function(c){return"url('#"+c+"')"};a._.$=v;a._.id=V;a.format=function(){var c=/\{([^\}]+)\}/g,a=/(?:(?:^|\.)(.+?)(?=\[|\.|$|\()|\[('|")(.+?)\2\])(\(\))?/g,b=function(c,b,m){var h=m;b.replace(a,function(c,a,b,m,t){a=a||m;h&&(a in h&&(h=h[a]),"function"==typeof h&&t&&(h=h()))});return h=(null==h||h==m?c:h)+""};return function(a,m){return J(a).replace(c,
function(c,a){return b(c,a,m)})}}();a._.clone=M;a._.cacher=A;a.rad=z;a.deg=function(c){return 180*c/C%360};a.angle=w;a.is=y;a.snapTo=function(c,a,b){b=y(b,"finite")?b:10;if(y(c,"array"))for(var m=c.length;m--;){if(Y(c[m]-a)<=b)return c[m]}else{c=+c;m=a%c;if(m<b)return a-m;if(m>c-b)return a-m+c}return a};a.getRGB=A(function(c){if(!c||(c=J(c)).indexOf("-")+1)return{r:-1,g:-1,b:-1,hex:"none",error:1,toString:ka};if("none"==c)return{r:-1,g:-1,b:-1,hex:"none",toString:ka};!X[h](c.toLowerCase().substring(0,
2))&&"#"!=c.charAt()&&(c=T(c));if(!c)return{r:-1,g:-1,b:-1,hex:"none",error:1,toString:ka};var b,m,e,f,d;if(c=c.match(F)){c[2]&&(e=U(c[2].substring(5),16),m=U(c[2].substring(3,5),16),b=U(c[2].substring(1,3),16));c[3]&&(e=U((d=c[3].charAt(3))+d,16),m=U((d=c[3].charAt(2))+d,16),b=U((d=c[3].charAt(1))+d,16));c[4]&&(d=c[4].split(S),b=K(d[0]),"%"==d[0].slice(-1)&&(b*=2.55),m=K(d[1]),"%"==d[1].slice(-1)&&(m*=2.55),e=K(d[2]),"%"==d[2].slice(-1)&&(e*=2.55),"rgba"==c[1].toLowerCase().slice(0,4)&&(f=K(d[3])),
d[3]&&"%"==d[3].slice(-1)&&(f/=100));if(c[5])return d=c[5].split(S),b=K(d[0]),"%"==d[0].slice(-1)&&(b/=100),m=K(d[1]),"%"==d[1].slice(-1)&&(m/=100),e=K(d[2]),"%"==d[2].slice(-1)&&(e/=100),"deg"!=d[0].slice(-3)&&"\u00b0"!=d[0].slice(-1)||(b/=360),"hsba"==c[1].toLowerCase().slice(0,4)&&(f=K(d[3])),d[3]&&"%"==d[3].slice(-1)&&(f/=100),a.hsb2rgb(b,m,e,f);if(c[6])return d=c[6].split(S),b=K(d[0]),"%"==d[0].slice(-1)&&(b/=100),m=K(d[1]),"%"==d[1].slice(-1)&&(m/=100),e=K(d[2]),"%"==d[2].slice(-1)&&(e/=100),
"deg"!=d[0].slice(-3)&&"\u00b0"!=d[0].slice(-1)||(b/=360),"hsla"==c[1].toLowerCase().slice(0,4)&&(f=K(d[3])),d[3]&&"%"==d[3].slice(-1)&&(f/=100),a.hsl2rgb(b,m,e,f);b=Q(I.round(b),255);m=Q(I.round(m),255);e=Q(I.round(e),255);f=Q(P(f,0),1);c={r:b,g:m,b:e,toString:ka};c.hex="#"+(16777216|e|m<<8|b<<16).toString(16).slice(1);c.opacity=y(f,"finite")?f:1;return c}return{r:-1,g:-1,b:-1,hex:"none",error:1,toString:ka}},a);a.hsb=A(function(c,b,m){return a.hsb2rgb(c,b,m).hex});a.hsl=A(function(c,b,m){return a.hsl2rgb(c,
b,m).hex});a.rgb=A(function(c,a,b,m){if(y(m,"finite")){var e=I.round;return"rgba("+[e(c),e(a),e(b),+m.toFixed(2)]+")"}return"#"+(16777216|b|a<<8|c<<16).toString(16).slice(1)});var T=function(c){var a=G.doc.getElementsByTagName("head")[0]||G.doc.getElementsByTagName("svg")[0];T=A(function(c){if("red"==c.toLowerCase())return"rgb(255, 0, 0)";a.style.color="rgb(255, 0, 0)";a.style.color=c;c=G.doc.defaultView.getComputedStyle(a,aa).getPropertyValue("color");return"rgb(255, 0, 0)"==c?null:c});return T(c)},
qa=function(){return"hsb("+[this.h,this.s,this.b]+")"},ra=function(){return"hsl("+[this.h,this.s,this.l]+")"},ka=function(){return 1==this.opacity||null==this.opacity?this.hex:"rgba("+[this.r,this.g,this.b,this.opacity]+")"},D=function(c,b,m){null==b&&y(c,"object")&&"r"in c&&"g"in c&&"b"in c&&(m=c.b,b=c.g,c=c.r);null==b&&y(c,string)&&(m=a.getRGB(c),c=m.r,b=m.g,m=m.b);if(1<c||1<b||1<m)c/=255,b/=255,m/=255;return[c,b,m]},oa=function(c,b,m,e){c=I.round(255*c);b=I.round(255*b);m=I.round(255*m);c={r:c,
g:b,b:m,opacity:y(e,"finite")?e:1,hex:a.rgb(c,b,m),toString:ka};y(e,"finite")&&(c.opacity=e);return c};a.color=function(c){var b;y(c,"object")&&"h"in c&&"s"in c&&"b"in c?(b=a.hsb2rgb(c),c.r=b.r,c.g=b.g,c.b=b.b,c.opacity=1,c.hex=b.hex):y(c,"object")&&"h"in c&&"s"in c&&"l"in c?(b=a.hsl2rgb(c),c.r=b.r,c.g=b.g,c.b=b.b,c.opacity=1,c.hex=b.hex):(y(c,"string")&&(c=a.getRGB(c)),y(c,"object")&&"r"in c&&"g"in c&&"b"in c&&!("error"in c)?(b=a.rgb2hsl(c),c.h=b.h,c.s=b.s,c.l=b.l,b=a.rgb2hsb(c),c.v=b.b):(c={hex:"none"},
c.r=c.g=c.b=c.h=c.s=c.v=c.l=-1,c.error=1));c.toString=ka;return c};a.hsb2rgb=function(c,a,b,m){y(c,"object")&&"h"in c&&"s"in c&&"b"in c&&(b=c.b,a=c.s,c=c.h,m=c.o);var e,h,d;c=360*c%360/60;d=b*a;a=d*(1-Y(c%2-1));b=e=h=b-d;c=~~c;b+=[d,a,0,0,a,d][c];e+=[a,d,d,a,0,0][c];h+=[0,0,a,d,d,a][c];return oa(b,e,h,m)};a.hsl2rgb=function(c,a,b,m){y(c,"object")&&"h"in c&&"s"in c&&"l"in c&&(b=c.l,a=c.s,c=c.h);if(1<c||1<a||1<b)c/=360,a/=100,b/=100;var e,h,d;c=360*c%360/60;d=2*a*(0.5>b?b:1-b);a=d*(1-Y(c%2-1));b=e=
h=b-d/2;c=~~c;b+=[d,a,0,0,a,d][c];e+=[a,d,d,a,0,0][c];h+=[0,0,a,d,d,a][c];return oa(b,e,h,m)};a.rgb2hsb=function(c,a,b){b=D(c,a,b);c=b[0];a=b[1];b=b[2];var m,e;m=P(c,a,b);e=m-Q(c,a,b);c=((0==e?0:m==c?(a-b)/e:m==a?(b-c)/e+2:(c-a)/e+4)+360)%6*60/360;return{h:c,s:0==e?0:e/m,b:m,toString:qa}};a.rgb2hsl=function(c,a,b){b=D(c,a,b);c=b[0];a=b[1];b=b[2];var m,e,h;m=P(c,a,b);e=Q(c,a,b);h=m-e;c=((0==h?0:m==c?(a-b)/h:m==a?(b-c)/h+2:(c-a)/h+4)+360)%6*60/360;m=(m+e)/2;return{h:c,s:0==h?0:0.5>m?h/(2*m):h/(2-2*
m),l:m,toString:ra}};a.parsePathString=function(c){if(!c)return null;var b=a.path(c);if(b.arr)return a.path.clone(b.arr);var m={a:7,c:6,o:2,h:1,l:2,m:2,r:4,q:4,s:4,t:2,v:1,u:3,z:0},e=[];y(c,"array")&&y(c[0],"array")&&(e=a.path.clone(c));e.length||J(c).replace(W,function(c,a,b){var h=[];c=a.toLowerCase();b.replace(Z,function(c,a){a&&h.push(+a)});"m"==c&&2<h.length&&(e.push([a].concat(h.splice(0,2))),c="l",a="m"==a?"l":"L");"o"==c&&1==h.length&&e.push([a,h[0] ]);if("r"==c)e.push([a].concat(h));else for(;h.length>=
m[c]&&(e.push([a].concat(h.splice(0,m[c]))),m[c]););});e.toString=a.path.toString;b.arr=a.path.clone(e);return e};var O=a.parseTransformString=function(c){if(!c)return null;var b=[];y(c,"array")&&y(c[0],"array")&&(b=a.path.clone(c));b.length||J(c).replace(ma,function(c,a,m){var e=[];a.toLowerCase();m.replace(Z,function(c,a){a&&e.push(+a)});b.push([a].concat(e))});b.toString=a.path.toString;return b};a._.svgTransform2string=d;a._.rgTransform=RegExp("^[a-z][\t\n\x0B\f\r \u00a0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*-?\\.?\\d",
"i");a._.transform2matrix=f;a._unit2px=b;a._.getSomeDefs=u;a._.getSomeSVG=p;a.select=function(c){return x(G.doc.querySelector(c))};a.selectAll=function(c){c=G.doc.querySelectorAll(c);for(var b=(a.set||Array)(),m=0;m<c.length;m++)b.push(x(c[m]));return b};setInterval(function(){for(var c in E)if(E[h](c)){var a=E[c],b=a.node;("svg"!=a.type&&!b.ownerSVGElement||"svg"==a.type&&(!b.parentNode||"ownerSVGElement"in b.parentNode&&!b.ownerSVGElement))&&delete E[c]}},1E4);(function(c){function m(c){function a(c,
b){var m=v(c.node,b);(m=(m=m&&m.match(d))&&m[2])&&"#"==m.charAt()&&(m=m.substring(1))&&(f[m]=(f[m]||[]).concat(function(a){var m={};m[b]=ca(a);v(c.node,m)}))}function b(c){var a=v(c.node,"xlink:href");a&&"#"==a.charAt()&&(a=a.substring(1))&&(f[a]=(f[a]||[]).concat(function(a){c.attr("xlink:href","#"+a)}))}var e=c.selectAll("*"),h,d=/^\s*url\(("|'|)(.*)\1\)\s*$/;c=[];for(var f={},l=0,E=e.length;l<E;l++){h=e[l];a(h,"fill");a(h,"stroke");a(h,"filter");a(h,"mask");a(h,"clip-path");b(h);var t=v(h.node,
"id");t&&(v(h.node,{id:h.id}),c.push({old:t,id:h.id}))}l=0;for(E=c.length;l<E;l++)if(e=f[c[l].old])for(h=0,t=e.length;h<t;h++)e[h](c[l].id)}function e(c,a,b){return function(m){m=m.slice(c,a);1==m.length&&(m=m[0]);return b?b(m):m}}function d(c){return function(){var a=c?"<"+this.type:"",b=this.node.attributes,m=this.node.childNodes;if(c)for(var e=0,h=b.length;e<h;e++)a+=" "+b[e].name+'="'+b[e].value.replace(/"/g,'\\"')+'"';if(m.length){c&&(a+=">");e=0;for(h=m.length;e<h;e++)3==m[e].nodeType?a+=m[e].nodeValue:
1==m[e].nodeType&&(a+=x(m[e]).toString());c&&(a+="</"+this.type+">")}else c&&(a+="/>");return a}}c.attr=function(c,a){if(!c)return this;if(y(c,"string"))if(1<arguments.length){var b={};b[c]=a;c=b}else return k("snap.util.getattr."+c,this).firstDefined();for(var m in c)c[h](m)&&k("snap.util.attr."+m,this,c[m]);return this};c.getBBox=function(c){if(!a.Matrix||!a.path)return this.node.getBBox();var b=this,m=new a.Matrix;if(b.removed)return a._.box();for(;"use"==b.type;)if(c||(m=m.add(b.transform().localMatrix.translate(b.attr("x")||
0,b.attr("y")||0))),b.original)b=b.original;else var e=b.attr("xlink:href"),b=b.original=b.node.ownerDocument.getElementById(e.substring(e.indexOf("#")+1));var e=b._,h=a.path.get[b.type]||a.path.get.deflt;try{if(c)return e.bboxwt=h?a.path.getBBox(b.realPath=h(b)):a._.box(b.node.getBBox()),a._.box(e.bboxwt);b.realPath=h(b);b.matrix=b.transform().localMatrix;e.bbox=a.path.getBBox(a.path.map(b.realPath,m.add(b.matrix)));return a._.box(e.bbox)}catch(d){return a._.box()}};var f=function(){return this.string};
c.transform=function(c){var b=this._;if(null==c){var m=this;c=new a.Matrix(this.node.getCTM());for(var e=n(this),h=[e],d=new a.Matrix,l=e.toTransformString(),b=J(e)==J(this.matrix)?J(b.transform):l;"svg"!=m.type&&(m=m.parent());)h.push(n(m));for(m=h.length;m--;)d.add(h[m]);return{string:b,globalMatrix:c,totalMatrix:d,localMatrix:e,diffMatrix:c.clone().add(e.invert()),global:c.toTransformString(),total:d.toTransformString(),local:l,toString:f}}c instanceof a.Matrix?this.matrix=c:n(this,c);this.node&&
("linearGradient"==this.type||"radialGradient"==this.type?v(this.node,{gradientTransform:this.matrix}):"pattern"==this.type?v(this.node,{patternTransform:this.matrix}):v(this.node,{transform:this.matrix}));return this};c.parent=function(){return x(this.node.parentNode)};c.append=c.add=function(c){if(c){if("set"==c.type){var a=this;c.forEach(function(c){a.add(c)});return this}c=x(c);this.node.appendChild(c.node);c.paper=this.paper}return this};c.appendTo=function(c){c&&(c=x(c),c.append(this));return this};
c.prepend=function(c){if(c){if("set"==c.type){var a=this,b;c.forEach(function(c){b?b.after(c):a.prepend(c);b=c});return this}c=x(c);var m=c.parent();this.node.insertBefore(c.node,this.node.firstChild);this.add&&this.add();c.paper=this.paper;this.parent()&&this.parent().add();m&&m.add()}return this};c.prependTo=function(c){c=x(c);c.prepend(this);return this};c.before=function(c){if("set"==c.type){var a=this;c.forEach(function(c){var b=c.parent();a.node.parentNode.insertBefore(c.node,a.node);b&&b.add()});
this.parent().add();return this}c=x(c);var b=c.parent();this.node.parentNode.insertBefore(c.node,this.node);this.parent()&&this.parent().add();b&&b.add();c.paper=this.paper;return this};c.after=function(c){c=x(c);var a=c.parent();this.node.nextSibling?this.node.parentNode.insertBefore(c.node,this.node.nextSibling):this.node.parentNode.appendChild(c.node);this.parent()&&this.parent().add();a&&a.add();c.paper=this.paper;return this};c.insertBefore=function(c){c=x(c);var a=this.parent();c.node.parentNode.insertBefore(this.node,
c.node);this.paper=c.paper;a&&a.add();c.parent()&&c.parent().add();return this};c.insertAfter=function(c){c=x(c);var a=this.parent();c.node.parentNode.insertBefore(this.node,c.node.nextSibling);this.paper=c.paper;a&&a.add();c.parent()&&c.parent().add();return this};c.remove=function(){var c=this.parent();this.node.parentNode&&this.node.parentNode.removeChild(this.node);delete this.paper;this.removed=!0;c&&c.add();return this};c.select=function(c){return x(this.node.querySelector(c))};c.selectAll=
function(c){c=this.node.querySelectorAll(c);for(var b=(a.set||Array)(),m=0;m<c.length;m++)b.push(x(c[m]));return b};c.asPX=function(c,a){null==a&&(a=this.attr(c));return+b(this,c,a)};c.use=function(){var c,a=this.node.id;a||(a=this.id,v(this.node,{id:a}));c="linearGradient"==this.type||"radialGradient"==this.type||"pattern"==this.type?r(this.type,this.node.parentNode):r("use",this.node.parentNode);v(c.node,{"xlink:href":"#"+a});c.original=this;return c};var l=/\S+/g;c.addClass=function(c){var a=(c||
"").match(l)||[];c=this.node;var b=c.className.baseVal,m=b.match(l)||[],e,h,d;if(a.length){for(e=0;d=a[e++];)h=m.indexOf(d),~h||m.push(d);a=m.join(" ");b!=a&&(c.className.baseVal=a)}return this};c.removeClass=function(c){var a=(c||"").match(l)||[];c=this.node;var b=c.className.baseVal,m=b.match(l)||[],e,h;if(m.length){for(e=0;h=a[e++];)h=m.indexOf(h),~h&&m.splice(h,1);a=m.join(" ");b!=a&&(c.className.baseVal=a)}return this};c.hasClass=function(c){return!!~(this.node.className.baseVal.match(l)||[]).indexOf(c)};
c.toggleClass=function(c,a){if(null!=a)return a?this.addClass(c):this.removeClass(c);var b=(c||"").match(l)||[],m=this.node,e=m.className.baseVal,h=e.match(l)||[],d,f,E;for(d=0;E=b[d++];)f=h.indexOf(E),~f?h.splice(f,1):h.push(E);b=h.join(" ");e!=b&&(m.className.baseVal=b);return this};c.clone=function(){var c=x(this.node.cloneNode(!0));v(c.node,"id")&&v(c.node,{id:c.id});m(c);c.insertAfter(this);return c};c.toDefs=function(){u(this).appendChild(this.node);return this};c.pattern=c.toPattern=function(c,
a,b,m){var e=r("pattern",u(this));null==c&&(c=this.getBBox());y(c,"object")&&"x"in c&&(a=c.y,b=c.width,m=c.height,c=c.x);v(e.node,{x:c,y:a,width:b,height:m,patternUnits:"userSpaceOnUse",id:e.id,viewBox:[c,a,b,m].join(" ")});e.node.appendChild(this.node);return e};c.marker=function(c,a,b,m,e,h){var d=r("marker",u(this));null==c&&(c=this.getBBox());y(c,"object")&&"x"in c&&(a=c.y,b=c.width,m=c.height,e=c.refX||c.cx,h=c.refY||c.cy,c=c.x);v(d.node,{viewBox:[c,a,b,m].join(" "),markerWidth:b,markerHeight:m,
orient:"auto",refX:e||0,refY:h||0,id:d.id});d.node.appendChild(this.node);return d};var E=function(c,a,b,m){"function"!=typeof b||b.length||(m=b,b=L.linear);this.attr=c;this.dur=a;b&&(this.easing=b);m&&(this.callback=m)};a._.Animation=E;a.animation=function(c,a,b,m){return new E(c,a,b,m)};c.inAnim=function(){var c=[],a;for(a in this.anims)this.anims[h](a)&&function(a){c.push({anim:new E(a._attrs,a.dur,a.easing,a._callback),mina:a,curStatus:a.status(),status:function(c){return a.status(c)},stop:function(){a.stop()}})}(this.anims[a]);
return c};a.animate=function(c,a,b,m,e,h){"function"!=typeof e||e.length||(h=e,e=L.linear);var d=L.time();c=L(c,a,d,d+m,L.time,b,e);h&&k.once("mina.finish."+c.id,h);return c};c.stop=function(){for(var c=this.inAnim(),a=0,b=c.length;a<b;a++)c[a].stop();return this};c.animate=function(c,a,b,m){"function"!=typeof b||b.length||(m=b,b=L.linear);c instanceof E&&(m=c.callback,b=c.easing,a=b.dur,c=c.attr);var d=[],f=[],l={},t,ca,n,T=this,q;for(q in c)if(c[h](q)){T.equal?(n=T.equal(q,J(c[q])),t=n.from,ca=
n.to,n=n.f):(t=+T.attr(q),ca=+c[q]);var la=y(t,"array")?t.length:1;l[q]=e(d.length,d.length+la,n);d=d.concat(t);f=f.concat(ca)}t=L.time();var p=L(d,f,t,t+a,L.time,function(c){var a={},b;for(b in l)l[h](b)&&(a[b]=l[b](c));T.attr(a)},b);T.anims[p.id]=p;p._attrs=c;p._callback=m;k("snap.animcreated."+T.id,p);k.once("mina.finish."+p.id,function(){delete T.anims[p.id];m&&m.call(T)});k.once("mina.stop."+p.id,function(){delete T.anims[p.id]});return T};var T={};c.data=function(c,b){var m=T[this.id]=T[this.id]||
{};if(0==arguments.length)return k("snap.data.get."+this.id,this,m,null),m;if(1==arguments.length){if(a.is(c,"object")){for(var e in c)c[h](e)&&this.data(e,c[e]);return this}k("snap.data.get."+this.id,this,m[c],c);return m[c]}m[c]=b;k("snap.data.set."+this.id,this,b,c);return this};c.removeData=function(c){null==c?T[this.id]={}:T[this.id]&&delete T[this.id][c];return this};c.outerSVG=c.toString=d(1);c.innerSVG=d()})(e.prototype);a.parse=function(c){var a=G.doc.createDocumentFragment(),b=!0,m=G.doc.createElement("div");
c=J(c);c.match(/^\s*<\s*svg(?:\s|>)/)||(c="<svg>"+c+"</svg>",b=!1);m.innerHTML=c;if(c=m.getElementsByTagName("svg")[0])if(b)a=c;else for(;c.firstChild;)a.appendChild(c.firstChild);m.innerHTML=aa;return new l(a)};l.prototype.select=e.prototype.select;l.prototype.selectAll=e.prototype.selectAll;a.fragment=function(){for(var c=Array.prototype.slice.call(arguments,0),b=G.doc.createDocumentFragment(),m=0,e=c.length;m<e;m++){var h=c[m];h.node&&h.node.nodeType&&b.appendChild(h.node);h.nodeType&&b.appendChild(h);
"string"==typeof h&&b.appendChild(a.parse(h).node)}return new l(b)};a._.make=r;a._.wrap=x;s.prototype.el=function(c,a){var b=r(c,this.node);a&&b.attr(a);return b};k.on("snap.util.getattr",function(){var c=k.nt(),c=c.substring(c.lastIndexOf(".")+1),a=c.replace(/[A-Z]/g,function(c){return"-"+c.toLowerCase()});return pa[h](a)?this.node.ownerDocument.defaultView.getComputedStyle(this.node,null).getPropertyValue(a):v(this.node,c)});var pa={"alignment-baseline":0,"baseline-shift":0,clip:0,"clip-path":0,
"clip-rule":0,color:0,"color-interpolation":0,"color-interpolation-filters":0,"color-profile":0,"color-rendering":0,cursor:0,direction:0,display:0,"dominant-baseline":0,"enable-background":0,fill:0,"fill-opacity":0,"fill-rule":0,filter:0,"flood-color":0,"flood-opacity":0,font:0,"font-family":0,"font-size":0,"font-size-adjust":0,"font-stretch":0,"font-style":0,"font-variant":0,"font-weight":0,"glyph-orientation-horizontal":0,"glyph-orientation-vertical":0,"image-rendering":0,kerning:0,"letter-spacing":0,
"lighting-color":0,marker:0,"marker-end":0,"marker-mid":0,"marker-start":0,mask:0,opacity:0,overflow:0,"pointer-events":0,"shape-rendering":0,"stop-color":0,"stop-opacity":0,stroke:0,"stroke-dasharray":0,"stroke-dashoffset":0,"stroke-linecap":0,"stroke-linejoin":0,"stroke-miterlimit":0,"stroke-opacity":0,"stroke-width":0,"text-anchor":0,"text-decoration":0,"text-rendering":0,"unicode-bidi":0,visibility:0,"word-spacing":0,"writing-mode":0};k.on("snap.util.attr",function(c){var a=k.nt(),b={},a=a.substring(a.lastIndexOf(".")+
1);b[a]=c;var m=a.replace(/-(\w)/gi,function(c,a){return a.toUpperCase()}),a=a.replace(/[A-Z]/g,function(c){return"-"+c.toLowerCase()});pa[h](a)?this.node.style[m]=null==c?aa:c:v(this.node,b)});a.ajax=function(c,a,b,m){var e=new XMLHttpRequest,h=V();if(e){if(y(a,"function"))m=b,b=a,a=null;else if(y(a,"object")){var d=[],f;for(f in a)a.hasOwnProperty(f)&&d.push(encodeURIComponent(f)+"="+encodeURIComponent(a[f]));a=d.join("&")}e.open(a?"POST":"GET",c,!0);a&&(e.setRequestHeader("X-Requested-With","XMLHttpRequest"),
e.setRequestHeader("Content-type","application/x-www-form-urlencoded"));b&&(k.once("snap.ajax."+h+".0",b),k.once("snap.ajax."+h+".200",b),k.once("snap.ajax."+h+".304",b));e.onreadystatechange=function(){4==e.readyState&&k("snap.ajax."+h+"."+e.status,m,e)};if(4==e.readyState)return e;e.send(a);return e}};a.load=function(c,b,m){a.ajax(c,function(c){c=a.parse(c.responseText);m?b.call(m,c):b(c)})};a.getElementByPoint=function(c,a){var b,m,e=G.doc.elementFromPoint(c,a);if(G.win.opera&&"svg"==e.tagName){b=
e;m=b.getBoundingClientRect();b=b.ownerDocument;var h=b.body,d=b.documentElement;b=m.top+(g.win.pageYOffset||d.scrollTop||h.scrollTop)-(d.clientTop||h.clientTop||0);m=m.left+(g.win.pageXOffset||d.scrollLeft||h.scrollLeft)-(d.clientLeft||h.clientLeft||0);h=e.createSVGRect();h.x=c-m;h.y=a-b;h.width=h.height=1;b=e.getIntersectionList(h,null);b.length&&(e=b[b.length-1])}return e?x(e):null};a.plugin=function(c){c(a,e,s,G,l)};return G.win.Snap=a}();C.plugin(function(a,k,y,M,A){function w(a,d,f,b,q,e){null==
d&&"[object SVGMatrix]"==z.call(a)?(this.a=a.a,this.b=a.b,this.c=a.c,this.d=a.d,this.e=a.e,this.f=a.f):null!=a?(this.a=+a,this.b=+d,this.c=+f,this.d=+b,this.e=+q,this.f=+e):(this.a=1,this.c=this.b=0,this.d=1,this.f=this.e=0)}var z=Object.prototype.toString,d=String,f=Math;(function(n){function k(a){return a[0]*a[0]+a[1]*a[1]}function p(a){var d=f.sqrt(k(a));a[0]&&(a[0]/=d);a[1]&&(a[1]/=d)}n.add=function(a,d,e,f,n,p){var k=[[],[],[] ],u=[[this.a,this.c,this.e],[this.b,this.d,this.f],[0,0,1] ];d=[[a,
e,n],[d,f,p],[0,0,1] ];a&&a instanceof w&&(d=[[a.a,a.c,a.e],[a.b,a.d,a.f],[0,0,1] ]);for(a=0;3>a;a++)for(e=0;3>e;e++){for(f=n=0;3>f;f++)n+=u[a][f]*d[f][e];k[a][e]=n}this.a=k[0][0];this.b=k[1][0];this.c=k[0][1];this.d=k[1][1];this.e=k[0][2];this.f=k[1][2];return this};n.invert=function(){var a=this.a*this.d-this.b*this.c;return new w(this.d/a,-this.b/a,-this.c/a,this.a/a,(this.c*this.f-this.d*this.e)/a,(this.b*this.e-this.a*this.f)/a)};n.clone=function(){return new w(this.a,this.b,this.c,this.d,this.e,
this.f)};n.translate=function(a,d){return this.add(1,0,0,1,a,d)};n.scale=function(a,d,e,f){null==d&&(d=a);(e||f)&&this.add(1,0,0,1,e,f);this.add(a,0,0,d,0,0);(e||f)&&this.add(1,0,0,1,-e,-f);return this};n.rotate=function(b,d,e){b=a.rad(b);d=d||0;e=e||0;var l=+f.cos(b).toFixed(9);b=+f.sin(b).toFixed(9);this.add(l,b,-b,l,d,e);return this.add(1,0,0,1,-d,-e)};n.x=function(a,d){return a*this.a+d*this.c+this.e};n.y=function(a,d){return a*this.b+d*this.d+this.f};n.get=function(a){return+this[d.fromCharCode(97+
a)].toFixed(4)};n.toString=function(){return"matrix("+[this.get(0),this.get(1),this.get(2),this.get(3),this.get(4),this.get(5)].join()+")"};n.offset=function(){return[this.e.toFixed(4),this.f.toFixed(4)]};n.determinant=function(){return this.a*this.d-this.b*this.c};n.split=function(){var b={};b.dx=this.e;b.dy=this.f;var d=[[this.a,this.c],[this.b,this.d] ];b.scalex=f.sqrt(k(d[0]));p(d[0]);b.shear=d[0][0]*d[1][0]+d[0][1]*d[1][1];d[1]=[d[1][0]-d[0][0]*b.shear,d[1][1]-d[0][1]*b.shear];b.scaley=f.sqrt(k(d[1]));
p(d[1]);b.shear/=b.scaley;0>this.determinant()&&(b.scalex=-b.scalex);var e=-d[0][1],d=d[1][1];0>d?(b.rotate=a.deg(f.acos(d)),0>e&&(b.rotate=360-b.rotate)):b.rotate=a.deg(f.asin(e));b.isSimple=!+b.shear.toFixed(9)&&(b.scalex.toFixed(9)==b.scaley.toFixed(9)||!b.rotate);b.isSuperSimple=!+b.shear.toFixed(9)&&b.scalex.toFixed(9)==b.scaley.toFixed(9)&&!b.rotate;b.noRotation=!+b.shear.toFixed(9)&&!b.rotate;return b};n.toTransformString=function(a){a=a||this.split();if(+a.shear.toFixed(9))return"m"+[this.get(0),
this.get(1),this.get(2),this.get(3),this.get(4),this.get(5)];a.scalex=+a.scalex.toFixed(4);a.scaley=+a.scaley.toFixed(4);a.rotate=+a.rotate.toFixed(4);return(a.dx||a.dy?"t"+[+a.dx.toFixed(4),+a.dy.toFixed(4)]:"")+(1!=a.scalex||1!=a.scaley?"s"+[a.scalex,a.scaley,0,0]:"")+(a.rotate?"r"+[+a.rotate.toFixed(4),0,0]:"")}})(w.prototype);a.Matrix=w;a.matrix=function(a,d,f,b,k,e){return new w(a,d,f,b,k,e)}});C.plugin(function(a,v,y,M,A){function w(h){return function(d){k.stop();d instanceof A&&1==d.node.childNodes.length&&
("radialGradient"==d.node.firstChild.tagName||"linearGradient"==d.node.firstChild.tagName||"pattern"==d.node.firstChild.tagName)&&(d=d.node.firstChild,b(this).appendChild(d),d=u(d));if(d instanceof v)if("radialGradient"==d.type||"linearGradient"==d.type||"pattern"==d.type){d.node.id||e(d.node,{id:d.id});var f=l(d.node.id)}else f=d.attr(h);else f=a.color(d),f.error?(f=a(b(this).ownerSVGElement).gradient(d))?(f.node.id||e(f.node,{id:f.id}),f=l(f.node.id)):f=d:f=r(f);d={};d[h]=f;e(this.node,d);this.node.style[h]=
x}}function z(a){k.stop();a==+a&&(a+="px");this.node.style.fontSize=a}function d(a){var b=[];a=a.childNodes;for(var e=0,f=a.length;e<f;e++){var l=a[e];3==l.nodeType&&b.push(l.nodeValue);"tspan"==l.tagName&&(1==l.childNodes.length&&3==l.firstChild.nodeType?b.push(l.firstChild.nodeValue):b.push(d(l)))}return b}function f(){k.stop();return this.node.style.fontSize}var n=a._.make,u=a._.wrap,p=a.is,b=a._.getSomeDefs,q=/^url\(#?([^)]+)\)$/,e=a._.$,l=a.url,r=String,s=a._.separator,x="";k.on("snap.util.attr.mask",
function(a){if(a instanceof v||a instanceof A){k.stop();a instanceof A&&1==a.node.childNodes.length&&(a=a.node.firstChild,b(this).appendChild(a),a=u(a));if("mask"==a.type)var d=a;else d=n("mask",b(this)),d.node.appendChild(a.node);!d.node.id&&e(d.node,{id:d.id});e(this.node,{mask:l(d.id)})}});(function(a){k.on("snap.util.attr.clip",a);k.on("snap.util.attr.clip-path",a);k.on("snap.util.attr.clipPath",a)})(function(a){if(a instanceof v||a instanceof A){k.stop();if("clipPath"==a.type)var d=a;else d=
n("clipPath",b(this)),d.node.appendChild(a.node),!d.node.id&&e(d.node,{id:d.id});e(this.node,{"clip-path":l(d.id)})}});k.on("snap.util.attr.fill",w("fill"));k.on("snap.util.attr.stroke",w("stroke"));var G=/^([lr])(?:\(([^)]*)\))?(.*)$/i;k.on("snap.util.grad.parse",function(a){a=r(a);var b=a.match(G);if(!b)return null;a=b[1];var e=b[2],b=b[3],e=e.split(/\s*,\s*/).map(function(a){return+a==a?+a:a});1==e.length&&0==e[0]&&(e=[]);b=b.split("-");b=b.map(function(a){a=a.split(":");var b={color:a[0]};a[1]&&
(b.offset=parseFloat(a[1]));return b});return{type:a,params:e,stops:b}});k.on("snap.util.attr.d",function(b){k.stop();p(b,"array")&&p(b[0],"array")&&(b=a.path.toString.call(b));b=r(b);b.match(/[ruo]/i)&&(b=a.path.toAbsolute(b));e(this.node,{d:b})})(-1);k.on("snap.util.attr.#text",function(a){k.stop();a=r(a);for(a=M.doc.createTextNode(a);this.node.firstChild;)this.node.removeChild(this.node.firstChild);this.node.appendChild(a)})(-1);k.on("snap.util.attr.path",function(a){k.stop();this.attr({d:a})})(-1);
k.on("snap.util.attr.class",function(a){k.stop();this.node.className.baseVal=a})(-1);k.on("snap.util.attr.viewBox",function(a){a=p(a,"object")&&"x"in a?[a.x,a.y,a.width,a.height].join(" "):p(a,"array")?a.join(" "):a;e(this.node,{viewBox:a});k.stop()})(-1);k.on("snap.util.attr.transform",function(a){this.transform(a);k.stop()})(-1);k.on("snap.util.attr.r",function(a){"rect"==this.type&&(k.stop(),e(this.node,{rx:a,ry:a}))})(-1);k.on("snap.util.attr.textpath",function(a){k.stop();if("text"==this.type){var d,
f;if(!a&&this.textPath){for(a=this.textPath;a.node.firstChild;)this.node.appendChild(a.node.firstChild);a.remove();delete this.textPath}else if(p(a,"string")?(d=b(this),a=u(d.parentNode).path(a),d.appendChild(a.node),d=a.id,a.attr({id:d})):(a=u(a),a instanceof v&&(d=a.attr("id"),d||(d=a.id,a.attr({id:d})))),d)if(a=this.textPath,f=this.node,a)a.attr({"xlink:href":"#"+d});else{for(a=e("textPath",{"xlink:href":"#"+d});f.firstChild;)a.appendChild(f.firstChild);f.appendChild(a);this.textPath=u(a)}}})(-1);
k.on("snap.util.attr.text",function(a){if("text"==this.type){for(var b=this.node,d=function(a){var b=e("tspan");if(p(a,"array"))for(var f=0;f<a.length;f++)b.appendChild(d(a[f]));else b.appendChild(M.doc.createTextNode(a));b.normalize&&b.normalize();return b};b.firstChild;)b.removeChild(b.firstChild);for(a=d(a);a.firstChild;)b.appendChild(a.firstChild)}k.stop()})(-1);k.on("snap.util.attr.fontSize",z)(-1);k.on("snap.util.attr.font-size",z)(-1);k.on("snap.util.getattr.transform",function(){k.stop();
return this.transform()})(-1);k.on("snap.util.getattr.textpath",function(){k.stop();return this.textPath})(-1);(function(){function b(d){return function(){k.stop();var b=M.doc.defaultView.getComputedStyle(this.node,null).getPropertyValue("marker-"+d);return"none"==b?b:a(M.doc.getElementById(b.match(q)[1]))}}function d(a){return function(b){k.stop();var d="marker"+a.charAt(0).toUpperCase()+a.substring(1);if(""==b||!b)this.node.style[d]="none";else if("marker"==b.type){var f=b.node.id;f||e(b.node,{id:b.id});
this.node.style[d]=l(f)}}}k.on("snap.util.getattr.marker-end",b("end"))(-1);k.on("snap.util.getattr.markerEnd",b("end"))(-1);k.on("snap.util.getattr.marker-start",b("start"))(-1);k.on("snap.util.getattr.markerStart",b("start"))(-1);k.on("snap.util.getattr.marker-mid",b("mid"))(-1);k.on("snap.util.getattr.markerMid",b("mid"))(-1);k.on("snap.util.attr.marker-end",d("end"))(-1);k.on("snap.util.attr.markerEnd",d("end"))(-1);k.on("snap.util.attr.marker-start",d("start"))(-1);k.on("snap.util.attr.markerStart",
d("start"))(-1);k.on("snap.util.attr.marker-mid",d("mid"))(-1);k.on("snap.util.attr.markerMid",d("mid"))(-1)})();k.on("snap.util.getattr.r",function(){if("rect"==this.type&&e(this.node,"rx")==e(this.node,"ry"))return k.stop(),e(this.node,"rx")})(-1);k.on("snap.util.getattr.text",function(){if("text"==this.type||"tspan"==this.type){k.stop();var a=d(this.node);return 1==a.length?a[0]:a}})(-1);k.on("snap.util.getattr.#text",function(){return this.node.textContent})(-1);k.on("snap.util.getattr.viewBox",
function(){k.stop();var b=e(this.node,"viewBox");if(b)return b=b.split(s),a._.box(+b[0],+b[1],+b[2],+b[3])})(-1);k.on("snap.util.getattr.points",function(){var a=e(this.node,"points");k.stop();if(a)return a.split(s)})(-1);k.on("snap.util.getattr.path",function(){var a=e(this.node,"d");k.stop();return a})(-1);k.on("snap.util.getattr.class",function(){return this.node.className.baseVal})(-1);k.on("snap.util.getattr.fontSize",f)(-1);k.on("snap.util.getattr.font-size",f)(-1)});C.plugin(function(a,v,y,
M,A){function w(a){return a}function z(a){return function(b){return+b.toFixed(3)+a}}var d={"+":function(a,b){return a+b},"-":function(a,b){return a-b},"/":function(a,b){return a/b},"*":function(a,b){return a*b}},f=String,n=/[a-z]+$/i,u=/^\s*([+\-\/*])\s*=\s*([\d.eE+\-]+)\s*([^\d\s]+)?\s*$/;k.on("snap.util.attr",function(a){if(a=f(a).match(u)){var b=k.nt(),b=b.substring(b.lastIndexOf(".")+1),q=this.attr(b),e={};k.stop();var l=a[3]||"",r=q.match(n),s=d[a[1] ];r&&r==l?a=s(parseFloat(q),+a[2]):(q=this.asPX(b),
a=s(this.asPX(b),this.asPX(b,a[2]+l)));isNaN(q)||isNaN(a)||(e[b]=a,this.attr(e))}})(-10);k.on("snap.util.equal",function(a,b){var q=f(this.attr(a)||""),e=f(b).match(u);if(e){k.stop();var l=e[3]||"",r=q.match(n),s=d[e[1] ];if(r&&r==l)return{from:parseFloat(q),to:s(parseFloat(q),+e[2]),f:z(r)};q=this.asPX(a);return{from:q,to:s(q,this.asPX(a,e[2]+l)),f:w}}})(-10)});C.plugin(function(a,v,y,M,A){var w=y.prototype,z=a.is;w.rect=function(a,d,k,p,b,q){var e;null==q&&(q=b);z(a,"object")&&"[object Object]"==
a?e=a:null!=a&&(e={x:a,y:d,width:k,height:p},null!=b&&(e.rx=b,e.ry=q));return this.el("rect",e)};w.circle=function(a,d,k){var p;z(a,"object")&&"[object Object]"==a?p=a:null!=a&&(p={cx:a,cy:d,r:k});return this.el("circle",p)};var d=function(){function a(){this.parentNode.removeChild(this)}return function(d,k){var p=M.doc.createElement("img"),b=M.doc.body;p.style.cssText="position:absolute;left:-9999em;top:-9999em";p.onload=function(){k.call(p);p.onload=p.onerror=null;b.removeChild(p)};p.onerror=a;
b.appendChild(p);p.src=d}}();w.image=function(f,n,k,p,b){var q=this.el("image");if(z(f,"object")&&"src"in f)q.attr(f);else if(null!=f){var e={"xlink:href":f,preserveAspectRatio:"none"};null!=n&&null!=k&&(e.x=n,e.y=k);null!=p&&null!=b?(e.width=p,e.height=b):d(f,function(){a._.$(q.node,{width:this.offsetWidth,height:this.offsetHeight})});a._.$(q.node,e)}return q};w.ellipse=function(a,d,k,p){var b;z(a,"object")&&"[object Object]"==a?b=a:null!=a&&(b={cx:a,cy:d,rx:k,ry:p});return this.el("ellipse",b)};
w.path=function(a){var d;z(a,"object")&&!z(a,"array")?d=a:a&&(d={d:a});return this.el("path",d)};w.group=w.g=function(a){var d=this.el("g");1==arguments.length&&a&&!a.type?d.attr(a):arguments.length&&d.add(Array.prototype.slice.call(arguments,0));return d};w.svg=function(a,d,k,p,b,q,e,l){var r={};z(a,"object")&&null==d?r=a:(null!=a&&(r.x=a),null!=d&&(r.y=d),null!=k&&(r.width=k),null!=p&&(r.height=p),null!=b&&null!=q&&null!=e&&null!=l&&(r.viewBox=[b,q,e,l]));return this.el("svg",r)};w.mask=function(a){var d=
this.el("mask");1==arguments.length&&a&&!a.type?d.attr(a):arguments.length&&d.add(Array.prototype.slice.call(arguments,0));return d};w.ptrn=function(a,d,k,p,b,q,e,l){if(z(a,"object"))var r=a;else arguments.length?(r={},null!=a&&(r.x=a),null!=d&&(r.y=d),null!=k&&(r.width=k),null!=p&&(r.height=p),null!=b&&null!=q&&null!=e&&null!=l&&(r.viewBox=[b,q,e,l])):r={patternUnits:"userSpaceOnUse"};return this.el("pattern",r)};w.use=function(a){return null!=a?(make("use",this.node),a instanceof v&&(a.attr("id")||
a.attr({id:ID()}),a=a.attr("id")),this.el("use",{"xlink:href":a})):v.prototype.use.call(this)};w.text=function(a,d,k){var p={};z(a,"object")?p=a:null!=a&&(p={x:a,y:d,text:k||""});return this.el("text",p)};w.line=function(a,d,k,p){var b={};z(a,"object")?b=a:null!=a&&(b={x1:a,x2:k,y1:d,y2:p});return this.el("line",b)};w.polyline=function(a){1<arguments.length&&(a=Array.prototype.slice.call(arguments,0));var d={};z(a,"object")&&!z(a,"array")?d=a:null!=a&&(d={points:a});return this.el("polyline",d)};
w.polygon=function(a){1<arguments.length&&(a=Array.prototype.slice.call(arguments,0));var d={};z(a,"object")&&!z(a,"array")?d=a:null!=a&&(d={points:a});return this.el("polygon",d)};(function(){function d(){return this.selectAll("stop")}function n(b,d){var f=e("stop"),k={offset:+d+"%"};b=a.color(b);k["stop-color"]=b.hex;1>b.opacity&&(k["stop-opacity"]=b.opacity);e(f,k);this.node.appendChild(f);return this}function u(){if("linearGradient"==this.type){var b=e(this.node,"x1")||0,d=e(this.node,"x2")||
1,f=e(this.node,"y1")||0,k=e(this.node,"y2")||0;return a._.box(b,f,math.abs(d-b),math.abs(k-f))}b=this.node.r||0;return a._.box((this.node.cx||0.5)-b,(this.node.cy||0.5)-b,2*b,2*b)}function p(a,d){function f(a,b){for(var d=(b-u)/(a-w),e=w;e<a;e++)h[e].offset=+(+u+d*(e-w)).toFixed(2);w=a;u=b}var n=k("snap.util.grad.parse",null,d).firstDefined(),p;if(!n)return null;n.params.unshift(a);p="l"==n.type.toLowerCase()?b.apply(0,n.params):q.apply(0,n.params);n.type!=n.type.toLowerCase()&&e(p.node,{gradientUnits:"userSpaceOnUse"});
var h=n.stops,n=h.length,u=0,w=0;n--;for(var v=0;v<n;v++)"offset"in h[v]&&f(v,h[v].offset);h[n].offset=h[n].offset||100;f(n,h[n].offset);for(v=0;v<=n;v++){var y=h[v];p.addStop(y.color,y.offset)}return p}function b(b,k,p,q,w){b=a._.make("linearGradient",b);b.stops=d;b.addStop=n;b.getBBox=u;null!=k&&e(b.node,{x1:k,y1:p,x2:q,y2:w});return b}function q(b,k,p,q,w,h){b=a._.make("radialGradient",b);b.stops=d;b.addStop=n;b.getBBox=u;null!=k&&e(b.node,{cx:k,cy:p,r:q});null!=w&&null!=h&&e(b.node,{fx:w,fy:h});
return b}var e=a._.$;w.gradient=function(a){return p(this.defs,a)};w.gradientLinear=function(a,d,e,f){return b(this.defs,a,d,e,f)};w.gradientRadial=function(a,b,d,e,f){return q(this.defs,a,b,d,e,f)};w.toString=function(){var b=this.node.ownerDocument,d=b.createDocumentFragment(),b=b.createElement("div"),e=this.node.cloneNode(!0);d.appendChild(b);b.appendChild(e);a._.$(e,{xmlns:"http://www.w3.org/2000/svg"});b=b.innerHTML;d.removeChild(d.firstChild);return b};w.clear=function(){for(var a=this.node.firstChild,
b;a;)b=a.nextSibling,"defs"!=a.tagName?a.parentNode.removeChild(a):w.clear.call({node:a}),a=b}})()});C.plugin(function(a,k,y,M){function A(a){var b=A.ps=A.ps||{};b[a]?b[a].sleep=100:b[a]={sleep:100};setTimeout(function(){for(var d in b)b[L](d)&&d!=a&&(b[d].sleep--,!b[d].sleep&&delete b[d])});return b[a]}function w(a,b,d,e){null==a&&(a=b=d=e=0);null==b&&(b=a.y,d=a.width,e=a.height,a=a.x);return{x:a,y:b,width:d,w:d,height:e,h:e,x2:a+d,y2:b+e,cx:a+d/2,cy:b+e/2,r1:F.min(d,e)/2,r2:F.max(d,e)/2,r0:F.sqrt(d*
d+e*e)/2,path:s(a,b,d,e),vb:[a,b,d,e].join(" ")}}function z(){return this.join(",").replace(N,"$1")}function d(a){a=C(a);a.toString=z;return a}function f(a,b,d,h,f,k,l,n,p){if(null==p)return e(a,b,d,h,f,k,l,n);if(0>p||e(a,b,d,h,f,k,l,n)<p)p=void 0;else{var q=0.5,O=1-q,s;for(s=e(a,b,d,h,f,k,l,n,O);0.01<Z(s-p);)q/=2,O+=(s<p?1:-1)*q,s=e(a,b,d,h,f,k,l,n,O);p=O}return u(a,b,d,h,f,k,l,n,p)}function n(b,d){function e(a){return+(+a).toFixed(3)}return a._.cacher(function(a,h,l){a instanceof k&&(a=a.attr("d"));
a=I(a);for(var n,p,D,q,O="",s={},c=0,t=0,r=a.length;t<r;t++){D=a[t];if("M"==D[0])n=+D[1],p=+D[2];else{q=f(n,p,D[1],D[2],D[3],D[4],D[5],D[6]);if(c+q>h){if(d&&!s.start){n=f(n,p,D[1],D[2],D[3],D[4],D[5],D[6],h-c);O+=["C"+e(n.start.x),e(n.start.y),e(n.m.x),e(n.m.y),e(n.x),e(n.y)];if(l)return O;s.start=O;O=["M"+e(n.x),e(n.y)+"C"+e(n.n.x),e(n.n.y),e(n.end.x),e(n.end.y),e(D[5]),e(D[6])].join();c+=q;n=+D[5];p=+D[6];continue}if(!b&&!d)return n=f(n,p,D[1],D[2],D[3],D[4],D[5],D[6],h-c)}c+=q;n=+D[5];p=+D[6]}O+=
D.shift()+D}s.end=O;return n=b?c:d?s:u(n,p,D[0],D[1],D[2],D[3],D[4],D[5],1)},null,a._.clone)}function u(a,b,d,e,h,f,k,l,n){var p=1-n,q=ma(p,3),s=ma(p,2),c=n*n,t=c*n,r=q*a+3*s*n*d+3*p*n*n*h+t*k,q=q*b+3*s*n*e+3*p*n*n*f+t*l,s=a+2*n*(d-a)+c*(h-2*d+a),t=b+2*n*(e-b)+c*(f-2*e+b),x=d+2*n*(h-d)+c*(k-2*h+d),c=e+2*n*(f-e)+c*(l-2*f+e);a=p*a+n*d;b=p*b+n*e;h=p*h+n*k;f=p*f+n*l;l=90-180*F.atan2(s-x,t-c)/S;return{x:r,y:q,m:{x:s,y:t},n:{x:x,y:c},start:{x:a,y:b},end:{x:h,y:f},alpha:l}}function p(b,d,e,h,f,n,k,l){a.is(b,
"array")||(b=[b,d,e,h,f,n,k,l]);b=U.apply(null,b);return w(b.min.x,b.min.y,b.max.x-b.min.x,b.max.y-b.min.y)}function b(a,b,d){return b>=a.x&&b<=a.x+a.width&&d>=a.y&&d<=a.y+a.height}function q(a,d){a=w(a);d=w(d);return b(d,a.x,a.y)||b(d,a.x2,a.y)||b(d,a.x,a.y2)||b(d,a.x2,a.y2)||b(a,d.x,d.y)||b(a,d.x2,d.y)||b(a,d.x,d.y2)||b(a,d.x2,d.y2)||(a.x<d.x2&&a.x>d.x||d.x<a.x2&&d.x>a.x)&&(a.y<d.y2&&a.y>d.y||d.y<a.y2&&d.y>a.y)}function e(a,b,d,e,h,f,n,k,l){null==l&&(l=1);l=(1<l?1:0>l?0:l)/2;for(var p=[-0.1252,
0.1252,-0.3678,0.3678,-0.5873,0.5873,-0.7699,0.7699,-0.9041,0.9041,-0.9816,0.9816],q=[0.2491,0.2491,0.2335,0.2335,0.2032,0.2032,0.1601,0.1601,0.1069,0.1069,0.0472,0.0472],s=0,c=0;12>c;c++)var t=l*p[c]+l,r=t*(t*(-3*a+9*d-9*h+3*n)+6*a-12*d+6*h)-3*a+3*d,t=t*(t*(-3*b+9*e-9*f+3*k)+6*b-12*e+6*f)-3*b+3*e,s=s+q[c]*F.sqrt(r*r+t*t);return l*s}function l(a,b,d){a=I(a);b=I(b);for(var h,f,l,n,k,s,r,O,x,c,t=d?0:[],w=0,v=a.length;w<v;w++)if(x=a[w],"M"==x[0])h=k=x[1],f=s=x[2];else{"C"==x[0]?(x=[h,f].concat(x.slice(1)),
h=x[6],f=x[7]):(x=[h,f,h,f,k,s,k,s],h=k,f=s);for(var G=0,y=b.length;G<y;G++)if(c=b[G],"M"==c[0])l=r=c[1],n=O=c[2];else{"C"==c[0]?(c=[l,n].concat(c.slice(1)),l=c[6],n=c[7]):(c=[l,n,l,n,r,O,r,O],l=r,n=O);var z;var K=x,B=c;z=d;var H=p(K),J=p(B);if(q(H,J)){for(var H=e.apply(0,K),J=e.apply(0,B),H=~~(H/8),J=~~(J/8),U=[],A=[],F={},M=z?0:[],P=0;P<H+1;P++){var C=u.apply(0,K.concat(P/H));U.push({x:C.x,y:C.y,t:P/H})}for(P=0;P<J+1;P++)C=u.apply(0,B.concat(P/J)),A.push({x:C.x,y:C.y,t:P/J});for(P=0;P<H;P++)for(K=
0;K<J;K++){var Q=U[P],L=U[P+1],B=A[K],C=A[K+1],N=0.001>Z(L.x-Q.x)?"y":"x",S=0.001>Z(C.x-B.x)?"y":"x",R;R=Q.x;var Y=Q.y,V=L.x,ea=L.y,fa=B.x,ga=B.y,ha=C.x,ia=C.y;if(W(R,V)<X(fa,ha)||X(R,V)>W(fa,ha)||W(Y,ea)<X(ga,ia)||X(Y,ea)>W(ga,ia))R=void 0;else{var $=(R*ea-Y*V)*(fa-ha)-(R-V)*(fa*ia-ga*ha),aa=(R*ea-Y*V)*(ga-ia)-(Y-ea)*(fa*ia-ga*ha),ja=(R-V)*(ga-ia)-(Y-ea)*(fa-ha);if(ja){var $=$/ja,aa=aa/ja,ja=+$.toFixed(2),ba=+aa.toFixed(2);R=ja<+X(R,V).toFixed(2)||ja>+W(R,V).toFixed(2)||ja<+X(fa,ha).toFixed(2)||
ja>+W(fa,ha).toFixed(2)||ba<+X(Y,ea).toFixed(2)||ba>+W(Y,ea).toFixed(2)||ba<+X(ga,ia).toFixed(2)||ba>+W(ga,ia).toFixed(2)?void 0:{x:$,y:aa}}else R=void 0}R&&F[R.x.toFixed(4)]!=R.y.toFixed(4)&&(F[R.x.toFixed(4)]=R.y.toFixed(4),Q=Q.t+Z((R[N]-Q[N])/(L[N]-Q[N]))*(L.t-Q.t),B=B.t+Z((R[S]-B[S])/(C[S]-B[S]))*(C.t-B.t),0<=Q&&1>=Q&&0<=B&&1>=B&&(z?M++:M.push({x:R.x,y:R.y,t1:Q,t2:B})))}z=M}else z=z?0:[];if(d)t+=z;else{H=0;for(J=z.length;H<J;H++)z[H].segment1=w,z[H].segment2=G,z[H].bez1=x,z[H].bez2=c;t=t.concat(z)}}}return t}
function r(a){var b=A(a);if(b.bbox)return C(b.bbox);if(!a)return w();a=I(a);for(var d=0,e=0,h=[],f=[],l,n=0,k=a.length;n<k;n++)l=a[n],"M"==l[0]?(d=l[1],e=l[2],h.push(d),f.push(e)):(d=U(d,e,l[1],l[2],l[3],l[4],l[5],l[6]),h=h.concat(d.min.x,d.max.x),f=f.concat(d.min.y,d.max.y),d=l[5],e=l[6]);a=X.apply(0,h);l=X.apply(0,f);h=W.apply(0,h);f=W.apply(0,f);f=w(a,l,h-a,f-l);b.bbox=C(f);return f}function s(a,b,d,e,h){if(h)return[["M",+a+ +h,b],["l",d-2*h,0],["a",h,h,0,0,1,h,h],["l",0,e-2*h],["a",h,h,0,0,1,
-h,h],["l",2*h-d,0],["a",h,h,0,0,1,-h,-h],["l",0,2*h-e],["a",h,h,0,0,1,h,-h],["z"] ];a=[["M",a,b],["l",d,0],["l",0,e],["l",-d,0],["z"] ];a.toString=z;return a}function x(a,b,d,e,h){null==h&&null==e&&(e=d);a=+a;b=+b;d=+d;e=+e;if(null!=h){var f=Math.PI/180,l=a+d*Math.cos(-e*f);a+=d*Math.cos(-h*f);var n=b+d*Math.sin(-e*f);b+=d*Math.sin(-h*f);d=[["M",l,n],["A",d,d,0,+(180<h-e),0,a,b] ]}else d=[["M",a,b],["m",0,-e],["a",d,e,0,1,1,0,2*e],["a",d,e,0,1,1,0,-2*e],["z"] ];d.toString=z;return d}function G(b){var e=
A(b);if(e.abs)return d(e.abs);Q(b,"array")&&Q(b&&b[0],"array")||(b=a.parsePathString(b));if(!b||!b.length)return[["M",0,0] ];var h=[],f=0,l=0,n=0,k=0,p=0;"M"==b[0][0]&&(f=+b[0][1],l=+b[0][2],n=f,k=l,p++,h[0]=["M",f,l]);for(var q=3==b.length&&"M"==b[0][0]&&"R"==b[1][0].toUpperCase()&&"Z"==b[2][0].toUpperCase(),s,r,w=p,c=b.length;w<c;w++){h.push(s=[]);r=b[w];p=r[0];if(p!=p.toUpperCase())switch(s[0]=p.toUpperCase(),s[0]){case "A":s[1]=r[1];s[2]=r[2];s[3]=r[3];s[4]=r[4];s[5]=r[5];s[6]=+r[6]+f;s[7]=+r[7]+
l;break;case "V":s[1]=+r[1]+l;break;case "H":s[1]=+r[1]+f;break;case "R":for(var t=[f,l].concat(r.slice(1)),u=2,v=t.length;u<v;u++)t[u]=+t[u]+f,t[++u]=+t[u]+l;h.pop();h=h.concat(P(t,q));break;case "O":h.pop();t=x(f,l,r[1],r[2]);t.push(t[0]);h=h.concat(t);break;case "U":h.pop();h=h.concat(x(f,l,r[1],r[2],r[3]));s=["U"].concat(h[h.length-1].slice(-2));break;case "M":n=+r[1]+f,k=+r[2]+l;default:for(u=1,v=r.length;u<v;u++)s[u]=+r[u]+(u%2?f:l)}else if("R"==p)t=[f,l].concat(r.slice(1)),h.pop(),h=h.concat(P(t,
q)),s=["R"].concat(r.slice(-2));else if("O"==p)h.pop(),t=x(f,l,r[1],r[2]),t.push(t[0]),h=h.concat(t);else if("U"==p)h.pop(),h=h.concat(x(f,l,r[1],r[2],r[3])),s=["U"].concat(h[h.length-1].slice(-2));else for(t=0,u=r.length;t<u;t++)s[t]=r[t];p=p.toUpperCase();if("O"!=p)switch(s[0]){case "Z":f=+n;l=+k;break;case "H":f=s[1];break;case "V":l=s[1];break;case "M":n=s[s.length-2],k=s[s.length-1];default:f=s[s.length-2],l=s[s.length-1]}}h.toString=z;e.abs=d(h);return h}function h(a,b,d,e){return[a,b,d,e,d,
e]}function J(a,b,d,e,h,f){var l=1/3,n=2/3;return[l*a+n*d,l*b+n*e,l*h+n*d,l*f+n*e,h,f]}function K(b,d,e,h,f,l,n,k,p,s){var r=120*S/180,q=S/180*(+f||0),c=[],t,x=a._.cacher(function(a,b,c){var d=a*F.cos(c)-b*F.sin(c);a=a*F.sin(c)+b*F.cos(c);return{x:d,y:a}});if(s)v=s[0],t=s[1],l=s[2],u=s[3];else{t=x(b,d,-q);b=t.x;d=t.y;t=x(k,p,-q);k=t.x;p=t.y;F.cos(S/180*f);F.sin(S/180*f);t=(b-k)/2;v=(d-p)/2;u=t*t/(e*e)+v*v/(h*h);1<u&&(u=F.sqrt(u),e*=u,h*=u);var u=e*e,w=h*h,u=(l==n?-1:1)*F.sqrt(Z((u*w-u*v*v-w*t*t)/
(u*v*v+w*t*t)));l=u*e*v/h+(b+k)/2;var u=u*-h*t/e+(d+p)/2,v=F.asin(((d-u)/h).toFixed(9));t=F.asin(((p-u)/h).toFixed(9));v=b<l?S-v:v;t=k<l?S-t:t;0>v&&(v=2*S+v);0>t&&(t=2*S+t);n&&v>t&&(v-=2*S);!n&&t>v&&(t-=2*S)}if(Z(t-v)>r){var c=t,w=k,G=p;t=v+r*(n&&t>v?1:-1);k=l+e*F.cos(t);p=u+h*F.sin(t);c=K(k,p,e,h,f,0,n,w,G,[t,c,l,u])}l=t-v;f=F.cos(v);r=F.sin(v);n=F.cos(t);t=F.sin(t);l=F.tan(l/4);e=4/3*e*l;l*=4/3*h;h=[b,d];b=[b+e*r,d-l*f];d=[k+e*t,p-l*n];k=[k,p];b[0]=2*h[0]-b[0];b[1]=2*h[1]-b[1];if(s)return[b,d,k].concat(c);
c=[b,d,k].concat(c).join().split(",");s=[];k=0;for(p=c.length;k<p;k++)s[k]=k%2?x(c[k-1],c[k],q).y:x(c[k],c[k+1],q).x;return s}function U(a,b,d,e,h,f,l,k){for(var n=[],p=[[],[] ],s,r,c,t,q=0;2>q;++q)0==q?(r=6*a-12*d+6*h,s=-3*a+9*d-9*h+3*l,c=3*d-3*a):(r=6*b-12*e+6*f,s=-3*b+9*e-9*f+3*k,c=3*e-3*b),1E-12>Z(s)?1E-12>Z(r)||(s=-c/r,0<s&&1>s&&n.push(s)):(t=r*r-4*c*s,c=F.sqrt(t),0>t||(t=(-r+c)/(2*s),0<t&&1>t&&n.push(t),s=(-r-c)/(2*s),0<s&&1>s&&n.push(s)));for(r=q=n.length;q--;)s=n[q],c=1-s,p[0][q]=c*c*c*a+3*
c*c*s*d+3*c*s*s*h+s*s*s*l,p[1][q]=c*c*c*b+3*c*c*s*e+3*c*s*s*f+s*s*s*k;p[0][r]=a;p[1][r]=b;p[0][r+1]=l;p[1][r+1]=k;p[0].length=p[1].length=r+2;return{min:{x:X.apply(0,p[0]),y:X.apply(0,p[1])},max:{x:W.apply(0,p[0]),y:W.apply(0,p[1])}}}function I(a,b){var e=!b&&A(a);if(!b&&e.curve)return d(e.curve);var f=G(a),l=b&&G(b),n={x:0,y:0,bx:0,by:0,X:0,Y:0,qx:null,qy:null},k={x:0,y:0,bx:0,by:0,X:0,Y:0,qx:null,qy:null},p=function(a,b,c){if(!a)return["C",b.x,b.y,b.x,b.y,b.x,b.y];a[0]in{T:1,Q:1}||(b.qx=b.qy=null);
switch(a[0]){case "M":b.X=a[1];b.Y=a[2];break;case "A":a=["C"].concat(K.apply(0,[b.x,b.y].concat(a.slice(1))));break;case "S":"C"==c||"S"==c?(c=2*b.x-b.bx,b=2*b.y-b.by):(c=b.x,b=b.y);a=["C",c,b].concat(a.slice(1));break;case "T":"Q"==c||"T"==c?(b.qx=2*b.x-b.qx,b.qy=2*b.y-b.qy):(b.qx=b.x,b.qy=b.y);a=["C"].concat(J(b.x,b.y,b.qx,b.qy,a[1],a[2]));break;case "Q":b.qx=a[1];b.qy=a[2];a=["C"].concat(J(b.x,b.y,a[1],a[2],a[3],a[4]));break;case "L":a=["C"].concat(h(b.x,b.y,a[1],a[2]));break;case "H":a=["C"].concat(h(b.x,
b.y,a[1],b.y));break;case "V":a=["C"].concat(h(b.x,b.y,b.x,a[1]));break;case "Z":a=["C"].concat(h(b.x,b.y,b.X,b.Y))}return a},s=function(a,b){if(7<a[b].length){a[b].shift();for(var c=a[b];c.length;)q[b]="A",l&&(u[b]="A"),a.splice(b++,0,["C"].concat(c.splice(0,6)));a.splice(b,1);v=W(f.length,l&&l.length||0)}},r=function(a,b,c,d,e){a&&b&&"M"==a[e][0]&&"M"!=b[e][0]&&(b.splice(e,0,["M",d.x,d.y]),c.bx=0,c.by=0,c.x=a[e][1],c.y=a[e][2],v=W(f.length,l&&l.length||0))},q=[],u=[],c="",t="",x=0,v=W(f.length,
l&&l.length||0);for(;x<v;x++){f[x]&&(c=f[x][0]);"C"!=c&&(q[x]=c,x&&(t=q[x-1]));f[x]=p(f[x],n,t);"A"!=q[x]&&"C"==c&&(q[x]="C");s(f,x);l&&(l[x]&&(c=l[x][0]),"C"!=c&&(u[x]=c,x&&(t=u[x-1])),l[x]=p(l[x],k,t),"A"!=u[x]&&"C"==c&&(u[x]="C"),s(l,x));r(f,l,n,k,x);r(l,f,k,n,x);var w=f[x],z=l&&l[x],y=w.length,U=l&&z.length;n.x=w[y-2];n.y=w[y-1];n.bx=$(w[y-4])||n.x;n.by=$(w[y-3])||n.y;k.bx=l&&($(z[U-4])||k.x);k.by=l&&($(z[U-3])||k.y);k.x=l&&z[U-2];k.y=l&&z[U-1]}l||(e.curve=d(f));return l?[f,l]:f}function P(a,
b){for(var d=[],e=0,h=a.length;h-2*!b>e;e+=2){var f=[{x:+a[e-2],y:+a[e-1]},{x:+a[e],y:+a[e+1]},{x:+a[e+2],y:+a[e+3]},{x:+a[e+4],y:+a[e+5]}];b?e?h-4==e?f[3]={x:+a[0],y:+a[1]}:h-2==e&&(f[2]={x:+a[0],y:+a[1]},f[3]={x:+a[2],y:+a[3]}):f[0]={x:+a[h-2],y:+a[h-1]}:h-4==e?f[3]=f[2]:e||(f[0]={x:+a[e],y:+a[e+1]});d.push(["C",(-f[0].x+6*f[1].x+f[2].x)/6,(-f[0].y+6*f[1].y+f[2].y)/6,(f[1].x+6*f[2].x-f[3].x)/6,(f[1].y+6*f[2].y-f[3].y)/6,f[2].x,f[2].y])}return d}y=k.prototype;var Q=a.is,C=a._.clone,L="hasOwnProperty",
N=/,?([a-z]),?/gi,$=parseFloat,F=Math,S=F.PI,X=F.min,W=F.max,ma=F.pow,Z=F.abs;M=n(1);var na=n(),ba=n(0,1),V=a._unit2px;a.path=A;a.path.getTotalLength=M;a.path.getPointAtLength=na;a.path.getSubpath=function(a,b,d){if(1E-6>this.getTotalLength(a)-d)return ba(a,b).end;a=ba(a,d,1);return b?ba(a,b).end:a};y.getTotalLength=function(){if(this.node.getTotalLength)return this.node.getTotalLength()};y.getPointAtLength=function(a){return na(this.attr("d"),a)};y.getSubpath=function(b,d){return a.path.getSubpath(this.attr("d"),
b,d)};a._.box=w;a.path.findDotsAtSegment=u;a.path.bezierBBox=p;a.path.isPointInsideBBox=b;a.path.isBBoxIntersect=q;a.path.intersection=function(a,b){return l(a,b)};a.path.intersectionNumber=function(a,b){return l(a,b,1)};a.path.isPointInside=function(a,d,e){var h=r(a);return b(h,d,e)&&1==l(a,[["M",d,e],["H",h.x2+10] ],1)%2};a.path.getBBox=r;a.path.get={path:function(a){return a.attr("path")},circle:function(a){a=V(a);return x(a.cx,a.cy,a.r)},ellipse:function(a){a=V(a);return x(a.cx||0,a.cy||0,a.rx,
a.ry)},rect:function(a){a=V(a);return s(a.x||0,a.y||0,a.width,a.height,a.rx,a.ry)},image:function(a){a=V(a);return s(a.x||0,a.y||0,a.width,a.height)},line:function(a){return"M"+[a.attr("x1")||0,a.attr("y1")||0,a.attr("x2"),a.attr("y2")]},polyline:function(a){return"M"+a.attr("points")},polygon:function(a){return"M"+a.attr("points")+"z"},deflt:function(a){a=a.node.getBBox();return s(a.x,a.y,a.width,a.height)}};a.path.toRelative=function(b){var e=A(b),h=String.prototype.toLowerCase;if(e.rel)return d(e.rel);
a.is(b,"array")&&a.is(b&&b[0],"array")||(b=a.parsePathString(b));var f=[],l=0,n=0,k=0,p=0,s=0;"M"==b[0][0]&&(l=b[0][1],n=b[0][2],k=l,p=n,s++,f.push(["M",l,n]));for(var r=b.length;s<r;s++){var q=f[s]=[],x=b[s];if(x[0]!=h.call(x[0]))switch(q[0]=h.call(x[0]),q[0]){case "a":q[1]=x[1];q[2]=x[2];q[3]=x[3];q[4]=x[4];q[5]=x[5];q[6]=+(x[6]-l).toFixed(3);q[7]=+(x[7]-n).toFixed(3);break;case "v":q[1]=+(x[1]-n).toFixed(3);break;case "m":k=x[1],p=x[2];default:for(var c=1,t=x.length;c<t;c++)q[c]=+(x[c]-(c%2?l:
n)).toFixed(3)}else for(f[s]=[],"m"==x[0]&&(k=x[1]+l,p=x[2]+n),q=0,c=x.length;q<c;q++)f[s][q]=x[q];x=f[s].length;switch(f[s][0]){case "z":l=k;n=p;break;case "h":l+=+f[s][x-1];break;case "v":n+=+f[s][x-1];break;default:l+=+f[s][x-2],n+=+f[s][x-1]}}f.toString=z;e.rel=d(f);return f};a.path.toAbsolute=G;a.path.toCubic=I;a.path.map=function(a,b){if(!b)return a;var d,e,h,f,l,n,k;a=I(a);h=0;for(l=a.length;h<l;h++)for(k=a[h],f=1,n=k.length;f<n;f+=2)d=b.x(k[f],k[f+1]),e=b.y(k[f],k[f+1]),k[f]=d,k[f+1]=e;return a};
a.path.toString=z;a.path.clone=d});C.plugin(function(a,v,y,C){var A=Math.max,w=Math.min,z=function(a){this.items=[];this.bindings={};this.length=0;this.type="set";if(a)for(var f=0,n=a.length;f<n;f++)a[f]&&(this[this.items.length]=this.items[this.items.length]=a[f],this.length++)};v=z.prototype;v.push=function(){for(var a,f,n=0,k=arguments.length;n<k;n++)if(a=arguments[n])f=this.items.length,this[f]=this.items[f]=a,this.length++;return this};v.pop=function(){this.length&&delete this[this.length--];
return this.items.pop()};v.forEach=function(a,f){for(var n=0,k=this.items.length;n<k&&!1!==a.call(f,this.items[n],n);n++);return this};v.animate=function(d,f,n,u){"function"!=typeof n||n.length||(u=n,n=L.linear);d instanceof a._.Animation&&(u=d.callback,n=d.easing,f=n.dur,d=d.attr);var p=arguments;if(a.is(d,"array")&&a.is(p[p.length-1],"array"))var b=!0;var q,e=function(){q?this.b=q:q=this.b},l=0,r=u&&function(){l++==this.length&&u.call(this)};return this.forEach(function(a,l){k.once("snap.animcreated."+
a.id,e);b?p[l]&&a.animate.apply(a,p[l]):a.animate(d,f,n,r)})};v.remove=function(){for(;this.length;)this.pop().remove();return this};v.bind=function(a,f,k){var u={};if("function"==typeof f)this.bindings[a]=f;else{var p=k||a;this.bindings[a]=function(a){u[p]=a;f.attr(u)}}return this};v.attr=function(a){var f={},k;for(k in a)if(this.bindings[k])this.bindings[k](a[k]);else f[k]=a[k];a=0;for(k=this.items.length;a<k;a++)this.items[a].attr(f);return this};v.clear=function(){for(;this.length;)this.pop()};
v.splice=function(a,f,k){a=0>a?A(this.length+a,0):a;f=A(0,w(this.length-a,f));var u=[],p=[],b=[],q;for(q=2;q<arguments.length;q++)b.push(arguments[q]);for(q=0;q<f;q++)p.push(this[a+q]);for(;q<this.length-a;q++)u.push(this[a+q]);var e=b.length;for(q=0;q<e+u.length;q++)this.items[a+q]=this[a+q]=q<e?b[q]:u[q-e];for(q=this.items.length=this.length-=f-e;this[q];)delete this[q++];return new z(p)};v.exclude=function(a){for(var f=0,k=this.length;f<k;f++)if(this[f]==a)return this.splice(f,1),!0;return!1};
v.insertAfter=function(a){for(var f=this.items.length;f--;)this.items[f].insertAfter(a);return this};v.getBBox=function(){for(var a=[],f=[],k=[],u=[],p=this.items.length;p--;)if(!this.items[p].removed){var b=this.items[p].getBBox();a.push(b.x);f.push(b.y);k.push(b.x+b.width);u.push(b.y+b.height)}a=w.apply(0,a);f=w.apply(0,f);k=A.apply(0,k);u=A.apply(0,u);return{x:a,y:f,x2:k,y2:u,width:k-a,height:u-f,cx:a+(k-a)/2,cy:f+(u-f)/2}};v.clone=function(a){a=new z;for(var f=0,k=this.items.length;f<k;f++)a.push(this.items[f].clone());
return a};v.toString=function(){return"Snap\u2018s set"};v.type="set";a.set=function(){var a=new z;arguments.length&&a.push.apply(a,Array.prototype.slice.call(arguments,0));return a}});C.plugin(function(a,v,y,C){function A(a){var b=a[0];switch(b.toLowerCase()){case "t":return[b,0,0];case "m":return[b,1,0,0,1,0,0];case "r":return 4==a.length?[b,0,a[2],a[3] ]:[b,0];case "s":return 5==a.length?[b,1,1,a[3],a[4] ]:3==a.length?[b,1,1]:[b,1]}}function w(b,d,f){d=q(d).replace(/\.{3}|\u2026/g,b);b=a.parseTransformString(b)||
[];d=a.parseTransformString(d)||[];for(var k=Math.max(b.length,d.length),p=[],v=[],h=0,w,z,y,I;h<k;h++){y=b[h]||A(d[h]);I=d[h]||A(y);if(y[0]!=I[0]||"r"==y[0].toLowerCase()&&(y[2]!=I[2]||y[3]!=I[3])||"s"==y[0].toLowerCase()&&(y[3]!=I[3]||y[4]!=I[4])){b=a._.transform2matrix(b,f());d=a._.transform2matrix(d,f());p=[["m",b.a,b.b,b.c,b.d,b.e,b.f] ];v=[["m",d.a,d.b,d.c,d.d,d.e,d.f] ];break}p[h]=[];v[h]=[];w=0;for(z=Math.max(y.length,I.length);w<z;w++)w in y&&(p[h][w]=y[w]),w in I&&(v[h][w]=I[w])}return{from:u(p),
to:u(v),f:n(p)}}function z(a){return a}function d(a){return function(b){return+b.toFixed(3)+a}}function f(b){return a.rgb(b[0],b[1],b[2])}function n(a){var b=0,d,f,k,n,h,p,q=[];d=0;for(f=a.length;d<f;d++){h="[";p=['"'+a[d][0]+'"'];k=1;for(n=a[d].length;k<n;k++)p[k]="val["+b++ +"]";h+=p+"]";q[d]=h}return Function("val","return Snap.path.toString.call(["+q+"])")}function u(a){for(var b=[],d=0,f=a.length;d<f;d++)for(var k=1,n=a[d].length;k<n;k++)b.push(a[d][k]);return b}var p={},b=/[a-z]+$/i,q=String;
p.stroke=p.fill="colour";v.prototype.equal=function(a,b){return k("snap.util.equal",this,a,b).firstDefined()};k.on("snap.util.equal",function(e,k){var r,s;r=q(this.attr(e)||"");var x=this;if(r==+r&&k==+k)return{from:+r,to:+k,f:z};if("colour"==p[e])return r=a.color(r),s=a.color(k),{from:[r.r,r.g,r.b,r.opacity],to:[s.r,s.g,s.b,s.opacity],f:f};if("transform"==e||"gradientTransform"==e||"patternTransform"==e)return k instanceof a.Matrix&&(k=k.toTransformString()),a._.rgTransform.test(k)||(k=a._.svgTransform2string(k)),
w(r,k,function(){return x.getBBox(1)});if("d"==e||"path"==e)return r=a.path.toCubic(r,k),{from:u(r[0]),to:u(r[1]),f:n(r[0])};if("points"==e)return r=q(r).split(a._.separator),s=q(k).split(a._.separator),{from:r,to:s,f:function(a){return a}};aUnit=r.match(b);s=q(k).match(b);return aUnit&&aUnit==s?{from:parseFloat(r),to:parseFloat(k),f:d(aUnit)}:{from:this.asPX(e),to:this.asPX(e,k),f:z}})});C.plugin(function(a,v,y,C){var A=v.prototype,w="createTouch"in C.doc;v="click dblclick mousedown mousemove mouseout mouseover mouseup touchstart touchmove touchend touchcancel".split(" ");
var z={mousedown:"touchstart",mousemove:"touchmove",mouseup:"touchend"},d=function(a,b){var d="y"==a?"scrollTop":"scrollLeft",e=b&&b.node?b.node.ownerDocument:C.doc;return e[d in e.documentElement?"documentElement":"body"][d]},f=function(){this.returnValue=!1},n=function(){return this.originalEvent.preventDefault()},u=function(){this.cancelBubble=!0},p=function(){return this.originalEvent.stopPropagation()},b=function(){if(C.doc.addEventListener)return function(a,b,e,f){var k=w&&z[b]?z[b]:b,l=function(k){var l=
d("y",f),q=d("x",f);if(w&&z.hasOwnProperty(b))for(var r=0,u=k.targetTouches&&k.targetTouches.length;r<u;r++)if(k.targetTouches[r].target==a||a.contains(k.targetTouches[r].target)){u=k;k=k.targetTouches[r];k.originalEvent=u;k.preventDefault=n;k.stopPropagation=p;break}return e.call(f,k,k.clientX+q,k.clientY+l)};b!==k&&a.addEventListener(b,l,!1);a.addEventListener(k,l,!1);return function(){b!==k&&a.removeEventListener(b,l,!1);a.removeEventListener(k,l,!1);return!0}};if(C.doc.attachEvent)return function(a,
b,e,h){var k=function(a){a=a||h.node.ownerDocument.window.event;var b=d("y",h),k=d("x",h),k=a.clientX+k,b=a.clientY+b;a.preventDefault=a.preventDefault||f;a.stopPropagation=a.stopPropagation||u;return e.call(h,a,k,b)};a.attachEvent("on"+b,k);return function(){a.detachEvent("on"+b,k);return!0}}}(),q=[],e=function(a){for(var b=a.clientX,e=a.clientY,f=d("y"),l=d("x"),n,p=q.length;p--;){n=q[p];if(w)for(var r=a.touches&&a.touches.length,u;r--;){if(u=a.touches[r],u.identifier==n.el._drag.id||n.el.node.contains(u.target)){b=
u.clientX;e=u.clientY;(a.originalEvent?a.originalEvent:a).preventDefault();break}}else a.preventDefault();b+=l;e+=f;k("snap.drag.move."+n.el.id,n.move_scope||n.el,b-n.el._drag.x,e-n.el._drag.y,b,e,a)}},l=function(b){a.unmousemove(e).unmouseup(l);for(var d=q.length,f;d--;)f=q[d],f.el._drag={},k("snap.drag.end."+f.el.id,f.end_scope||f.start_scope||f.move_scope||f.el,b);q=[]};for(y=v.length;y--;)(function(d){a[d]=A[d]=function(e,f){a.is(e,"function")&&(this.events=this.events||[],this.events.push({name:d,
f:e,unbind:b(this.node||document,d,e,f||this)}));return this};a["un"+d]=A["un"+d]=function(a){for(var b=this.events||[],e=b.length;e--;)if(b[e].name==d&&(b[e].f==a||!a)){b[e].unbind();b.splice(e,1);!b.length&&delete this.events;break}return this}})(v[y]);A.hover=function(a,b,d,e){return this.mouseover(a,d).mouseout(b,e||d)};A.unhover=function(a,b){return this.unmouseover(a).unmouseout(b)};var r=[];A.drag=function(b,d,f,h,n,p){function u(r,v,w){(r.originalEvent||r).preventDefault();this._drag.x=v;
this._drag.y=w;this._drag.id=r.identifier;!q.length&&a.mousemove(e).mouseup(l);q.push({el:this,move_scope:h,start_scope:n,end_scope:p});d&&k.on("snap.drag.start."+this.id,d);b&&k.on("snap.drag.move."+this.id,b);f&&k.on("snap.drag.end."+this.id,f);k("snap.drag.start."+this.id,n||h||this,v,w,r)}if(!arguments.length){var v;return this.drag(function(a,b){this.attr({transform:v+(v?"T":"t")+[a,b]})},function(){v=this.transform().local})}this._drag={};r.push({el:this,start:u});this.mousedown(u);return this};
A.undrag=function(){for(var b=r.length;b--;)r[b].el==this&&(this.unmousedown(r[b].start),r.splice(b,1),k.unbind("snap.drag.*."+this.id));!r.length&&a.unmousemove(e).unmouseup(l);return this}});C.plugin(function(a,v,y,C){y=y.prototype;var A=/^\s*url\((.+)\)/,w=String,z=a._.$;a.filter={};y.filter=function(d){var f=this;"svg"!=f.type&&(f=f.paper);d=a.parse(w(d));var k=a._.id(),u=z("filter");z(u,{id:k,filterUnits:"userSpaceOnUse"});u.appendChild(d.node);f.defs.appendChild(u);return new v(u)};k.on("snap.util.getattr.filter",
function(){k.stop();var d=z(this.node,"filter");if(d)return(d=w(d).match(A))&&a.select(d[1])});k.on("snap.util.attr.filter",function(d){if(d instanceof v&&"filter"==d.type){k.stop();var f=d.node.id;f||(z(d.node,{id:d.id}),f=d.id);z(this.node,{filter:a.url(f)})}d&&"none"!=d||(k.stop(),this.node.removeAttribute("filter"))});a.filter.blur=function(d,f){null==d&&(d=2);return a.format('<feGaussianBlur stdDeviation="{def}"/>',{def:null==f?d:[d,f]})};a.filter.blur.toString=function(){return this()};a.filter.shadow=
function(d,f,k,u,p){"string"==typeof k&&(p=u=k,k=4);"string"!=typeof u&&(p=u,u="#000");null==k&&(k=4);null==p&&(p=1);null==d&&(d=0,f=2);null==f&&(f=d);u=a.color(u||"#000");return a.format('<feGaussianBlur in="SourceAlpha" stdDeviation="{blur}"/><feOffset dx="{dx}" dy="{dy}" result="offsetblur"/><feFlood flood-color="{color}"/><feComposite in2="offsetblur" operator="in"/><feComponentTransfer><feFuncA type="linear" slope="{opacity}"/></feComponentTransfer><feMerge><feMergeNode/><feMergeNode in="SourceGraphic"/></feMerge>',
{color:u,dx:d,dy:f,blur:k,opacity:p})};a.filter.shadow.toString=function(){return this()};a.filter.grayscale=function(d){null==d&&(d=1);return a.format('<feColorMatrix type="matrix" values="{a} {b} {c} 0 0 {d} {e} {f} 0 0 {g} {b} {h} 0 0 0 0 0 1 0"/>',{a:0.2126+0.7874*(1-d),b:0.7152-0.7152*(1-d),c:0.0722-0.0722*(1-d),d:0.2126-0.2126*(1-d),e:0.7152+0.2848*(1-d),f:0.0722-0.0722*(1-d),g:0.2126-0.2126*(1-d),h:0.0722+0.9278*(1-d)})};a.filter.grayscale.toString=function(){return this()};a.filter.sepia=
function(d){null==d&&(d=1);return a.format('<feColorMatrix type="matrix" values="{a} {b} {c} 0 0 {d} {e} {f} 0 0 {g} {h} {i} 0 0 0 0 0 1 0"/>',{a:0.393+0.607*(1-d),b:0.769-0.769*(1-d),c:0.189-0.189*(1-d),d:0.349-0.349*(1-d),e:0.686+0.314*(1-d),f:0.168-0.168*(1-d),g:0.272-0.272*(1-d),h:0.534-0.534*(1-d),i:0.131+0.869*(1-d)})};a.filter.sepia.toString=function(){return this()};a.filter.saturate=function(d){null==d&&(d=1);return a.format('<feColorMatrix type="saturate" values="{amount}"/>',{amount:1-
d})};a.filter.saturate.toString=function(){return this()};a.filter.hueRotate=function(d){return a.format('<feColorMatrix type="hueRotate" values="{angle}"/>',{angle:d||0})};a.filter.hueRotate.toString=function(){return this()};a.filter.invert=function(d){null==d&&(d=1);return a.format('<feComponentTransfer><feFuncR type="table" tableValues="{amount} {amount2}"/><feFuncG type="table" tableValues="{amount} {amount2}"/><feFuncB type="table" tableValues="{amount} {amount2}"/></feComponentTransfer>',{amount:d,
amount2:1-d})};a.filter.invert.toString=function(){return this()};a.filter.brightness=function(d){null==d&&(d=1);return a.format('<feComponentTransfer><feFuncR type="linear" slope="{amount}"/><feFuncG type="linear" slope="{amount}"/><feFuncB type="linear" slope="{amount}"/></feComponentTransfer>',{amount:d})};a.filter.brightness.toString=function(){return this()};a.filter.contrast=function(d){null==d&&(d=1);return a.format('<feComponentTransfer><feFuncR type="linear" slope="{amount}" intercept="{amount2}"/><feFuncG type="linear" slope="{amount}" intercept="{amount2}"/><feFuncB type="linear" slope="{amount}" intercept="{amount2}"/></feComponentTransfer>',
{amount:d,amount2:0.5-d/2})};a.filter.contrast.toString=function(){return this()}});return C});

]]> </script>
<script> <![CDATA[

(function (glob, factory) {
    // AMD support
    if (typeof define === "function" && define.amd) {
        // Define as an anonymous module
        define("Gadfly", ["Snap.svg"], function (Snap) {
            return factory(Snap);
        });
    } else {
        // Browser globals (glob is window)
        // Snap adds itself to window
        glob.Gadfly = factory(glob.Snap);
    }
}(this, function (Snap) {

var Gadfly = {};

// Get an x/y coordinate value in pixels
var xPX = function(fig, x) {
    var client_box = fig.node.getBoundingClientRect();
    return x * fig.node.viewBox.baseVal.width / client_box.width;
};

var yPX = function(fig, y) {
    var client_box = fig.node.getBoundingClientRect();
    return y * fig.node.viewBox.baseVal.height / client_box.height;
};


Snap.plugin(function (Snap, Element, Paper, global) {
    // Traverse upwards from a snap element to find and return the first
    // note with the "plotroot" class.
    Element.prototype.plotroot = function () {
        var element = this;
        while (!element.hasClass("plotroot") && element.parent() != null) {
            element = element.parent();
        }
        return element;
    };

    Element.prototype.svgroot = function () {
        var element = this;
        while (element.node.nodeName != "svg" && element.parent() != null) {
            element = element.parent();
        }
        return element;
    };

    Element.prototype.plotbounds = function () {
        var root = this.plotroot()
        var bbox = root.select(".guide.background").node.getBBox();
        return {
            x0: bbox.x,
            x1: bbox.x + bbox.width,
            y0: bbox.y,
            y1: bbox.y + bbox.height
        };
    };

    Element.prototype.plotcenter = function () {
        var root = this.plotroot()
        var bbox = root.select(".guide.background").node.getBBox();
        return {
            x: bbox.x + bbox.width / 2,
            y: bbox.y + bbox.height / 2
        };
    };

    // Emulate IE style mouseenter/mouseleave events, since Microsoft always
    // does everything right.
    // See: http://www.dynamic-tools.net/toolbox/isMouseLeaveOrEnter/
    var events = ["mouseenter", "mouseleave"];

    for (i in events) {
        (function (event_name) {
            var event_name = events[i];
            Element.prototype[event_name] = function (fn, scope) {
                if (Snap.is(fn, "function")) {
                    var fn2 = function (event) {
                        if (event.type != "mouseover" && event.type != "mouseout") {
                            return;
                        }

                        var reltg = event.relatedTarget ? event.relatedTarget :
                            event.type == "mouseout" ? event.toElement : event.fromElement;
                        while (reltg && reltg != this.node) reltg = reltg.parentNode;

                        if (reltg != this.node) {
                            return fn.apply(this, event);
                        }
                    };

                    if (event_name == "mouseenter") {
                        this.mouseover(fn2, scope);
                    } else {
                        this.mouseout(fn2, scope);
                    }
                }
                return this;
            };
        })(events[i]);
    }


    Element.prototype.mousewheel = function (fn, scope) {
        if (Snap.is(fn, "function")) {
            var el = this;
            var fn2 = function (event) {
                fn.apply(el, [event]);
            };
        }

        this.node.addEventListener(
            /Firefox/i.test(navigator.userAgent) ? "DOMMouseScroll" : "mousewheel",
            fn2);

        return this;
    };


    // Snap's attr function can be too slow for things like panning/zooming.
    // This is a function to directly update element attributes without going
    // through eve.
    Element.prototype.attribute = function(key, val) {
        if (val === undefined) {
            return this.node.getAttribute(key, val);
        } else {
            return this.node.setAttribute(key, val);
        }
    };
});


// When the plot is moused over, emphasize the grid lines.
Gadfly.plot_mouseover = function(event) {
    var root = this.plotroot();
    init_pan_zoom(root);

    var xgridlines = root.select(".xgridlines"),
        ygridlines = root.select(".ygridlines");

    xgridlines.data("unfocused_strokedash",
                    xgridlines.attr("stroke-dasharray").replace(/px/g, "mm"))
    ygridlines.data("unfocused_strokedash",
                    ygridlines.attr("stroke-dasharray").replace(/px/g, "mm"))

    // emphasize grid lines
    var destcolor = root.data("focused_xgrid_color");
    xgridlines.attr("stroke-dasharray", "none")
              .selectAll("path")
              .animate({stroke: destcolor}, 250);

    destcolor = root.data("focused_ygrid_color");
    ygridlines.attr("stroke-dasharray", "none")
              .selectAll("path")
              .animate({stroke: destcolor}, 250);

    // reveal zoom slider
    root.select(".zoomslider")
        .animate({opacity: 1.0}, 250);
};


// Unemphasize grid lines on mouse out.
Gadfly.plot_mouseout = function(event) {
    var root = this.plotroot();
    var xgridlines = root.select(".xgridlines"),
        ygridlines = root.select(".ygridlines");

    var destcolor = root.data("unfocused_xgrid_color");

    xgridlines.attr("stroke-dasharray", xgridlines.data("unfocused_strokedash"))
              .selectAll("path")
              .animate({stroke: destcolor}, 250);

    destcolor = root.data("unfocused_ygrid_color");
    ygridlines.attr("stroke-dasharray", ygridlines.data("unfocused_strokedash"))
              .selectAll("path")
              .animate({stroke: destcolor}, 250);

    // hide zoom slider
    root.select(".zoomslider")
        .animate({opacity: 0.0}, 250);
};


var set_geometry_transform = function(root, tx, ty, scale) {
    var xscalable = root.hasClass("xscalable"),
        yscalable = root.hasClass("yscalable");

    var old_scale = root.data("scale");

    var xscale = xscalable ? scale : 1.0,
        yscale = yscalable ? scale : 1.0;

    tx = xscalable ? tx : 0.0;
    ty = yscalable ? ty : 0.0;

    var t = new Snap.Matrix().translate(tx, ty).scale(xscale, yscale);

    root.selectAll(".geometry, image")
        .forEach(function (element, i) {
            element.transform(t);
        });

    bounds = root.plotbounds();

    if (yscalable) {
        var xfixed_t = new Snap.Matrix().translate(0, ty).scale(1.0, yscale);
        root.selectAll(".xfixed")
            .forEach(function (element, i) {
                element.transform(xfixed_t);
            });

        root.select(".ylabels")
            .transform(xfixed_t)
            .selectAll("text")
            .forEach(function (element, i) {
                if (element.attribute("gadfly:inscale") == "true") {
                    var cx = element.asPX("x"),
                        cy = element.asPX("y");
                    var st = element.data("static_transform");
                    unscale_t = new Snap.Matrix();
                    unscale_t.scale(1, 1/scale, cx, cy).add(st);
                    element.transform(unscale_t);

                    var y = cy * scale + ty;
                    element.attr("visibility",
                        bounds.y0 <= y && y <= bounds.y1 ? "visible" : "hidden");
                }
            });
    }

    if (xscalable) {
        var yfixed_t = new Snap.Matrix().translate(tx, 0).scale(xscale, 1.0);
        var xtrans = new Snap.Matrix().translate(tx, 0);
        root.selectAll(".yfixed")
            .forEach(function (element, i) {
                element.transform(yfixed_t);
            });

        root.select(".xlabels")
            .transform(yfixed_t)
            .selectAll("text")
            .forEach(function (element, i) {
                if (element.attribute("gadfly:inscale") == "true") {
                    var cx = element.asPX("x"),
                        cy = element.asPX("y");
                    var st = element.data("static_transform");
                    unscale_t = new Snap.Matrix();
                    unscale_t.scale(1/scale, 1, cx, cy).add(st);

                    element.transform(unscale_t);

                    var x = cx * scale + tx;
                    element.attr("visibility",
                        bounds.x0 <= x && x <= bounds.x1 ? "visible" : "hidden");
                    }
            });
    }

    // we must unscale anything that is scale invariance: widths, raiduses, etc.
    var size_attribs = ["font-size"];
    var unscaled_selection = ".geometry, .geometry *";
    if (xscalable) {
        size_attribs.push("rx");
        unscaled_selection += ", .xgridlines";
    }
    if (yscalable) {
        size_attribs.push("ry");
        unscaled_selection += ", .ygridlines";
    }

    root.selectAll(unscaled_selection)
        .forEach(function (element, i) {
            // circle need special help
            if (element.node.nodeName == "circle") {
                var cx = element.attribute("cx"),
                    cy = element.attribute("cy");
                unscale_t = new Snap.Matrix().scale(1/xscale, 1/yscale,
                                                        cx, cy);
                element.transform(unscale_t);
                return;
            }

            for (i in size_attribs) {
                var key = size_attribs[i];
                var val = parseFloat(element.attribute(key));
                if (val !== undefined && val != 0 && !isNaN(val)) {
                    element.attribute(key, val * old_scale / scale);
                }
            }
        });
};


// Find the most appropriate tick scale and update label visibility.
var update_tickscale = function(root, scale, axis) {
    if (!root.hasClass(axis + "scalable")) return;

    var tickscales = root.data(axis + "tickscales");
    var best_tickscale = 1.0;
    var best_tickscale_dist = Infinity;
    for (tickscale in tickscales) {
        var dist = Math.abs(Math.log(tickscale) - Math.log(scale));
        if (dist < best_tickscale_dist) {
            best_tickscale_dist = dist;
            best_tickscale = tickscale;
        }
    }

    if (best_tickscale != root.data(axis + "tickscale")) {
        root.data(axis + "tickscale", best_tickscale);
        var mark_inscale_gridlines = function (element, i) {
            var inscale = element.attr("gadfly:scale") == best_tickscale;
            element.attribute("gadfly:inscale", inscale);
            element.attr("visibility", inscale ? "visible" : "hidden");
        };

        var mark_inscale_labels = function (element, i) {
            var inscale = element.attr("gadfly:scale") == best_tickscale;
            element.attribute("gadfly:inscale", inscale);
            element.attr("visibility", inscale ? "visible" : "hidden");
        };

        root.select("." + axis + "gridlines").selectAll("path").forEach(mark_inscale_gridlines);
        root.select("." + axis + "labels").selectAll("text").forEach(mark_inscale_labels);
    }
};


var set_plot_pan_zoom = function(root, tx, ty, scale) {
    var old_scale = root.data("scale");
    var bounds = root.plotbounds();

    var width = bounds.x1 - bounds.x0,
        height = bounds.y1 - bounds.y0;

    // compute the viewport derived from tx, ty, and scale
    var x_min = -width * scale - (scale * width - width),
        x_max = width * scale,
        y_min = -height * scale - (scale * height - height),
        y_max = height * scale;

    var x0 = bounds.x0 - scale * bounds.x0,
        y0 = bounds.y0 - scale * bounds.y0;

    var tx = Math.max(Math.min(tx - x0, x_max), x_min),
        ty = Math.max(Math.min(ty - y0, y_max), y_min);

    tx += x0;
    ty += y0;

    // when the scale change, we may need to alter which set of
    // ticks is being displayed
    if (scale != old_scale) {
        update_tickscale(root, scale, "x");
        update_tickscale(root, scale, "y");
    }

    set_geometry_transform(root, tx, ty, scale);

    root.data("scale", scale);
    root.data("tx", tx);
    root.data("ty", ty);
};


var scale_centered_translation = function(root, scale) {
    var bounds = root.plotbounds();

    var width = bounds.x1 - bounds.x0,
        height = bounds.y1 - bounds.y0;

    var tx0 = root.data("tx"),
        ty0 = root.data("ty");

    var scale0 = root.data("scale");

    // how off from center the current view is
    var xoff = tx0 - (bounds.x0 * (1 - scale0) + (width * (1 - scale0)) / 2),
        yoff = ty0 - (bounds.y0 * (1 - scale0) + (height * (1 - scale0)) / 2);

    // rescale offsets
    xoff = xoff * scale / scale0;
    yoff = yoff * scale / scale0;

    // adjust for the panel position being scaled
    var x_edge_adjust = bounds.x0 * (1 - scale),
        y_edge_adjust = bounds.y0 * (1 - scale);

    return {
        x: xoff + x_edge_adjust + (width - width * scale) / 2,
        y: yoff + y_edge_adjust + (height - height * scale) / 2
    };
};


// Initialize data for panning zooming if it isn't already.
var init_pan_zoom = function(root) {
    if (root.data("zoompan-ready")) {
        return;
    }

    // The non-scaling-stroke trick. Rather than try to correct for the
    // stroke-width when zooming, we force it to a fixed value.
    var px_per_mm = root.node.getCTM().a;

    // Drag events report deltas in pixels, which we'd like to convert to
    // millimeters.
    root.data("px_per_mm", px_per_mm);

    root.selectAll("path")
        .forEach(function (element, i) {
        sw = element.asPX("stroke-width") * px_per_mm;
        if (sw > 0) {
            element.attribute("stroke-width", sw);
            element.attribute("vector-effect", "non-scaling-stroke");
        }
    });

    // Store ticks labels original tranformation
    root.selectAll(".xlabels > text, .ylabels > text")
        .forEach(function (element, i) {
            var lm = element.transform().localMatrix;
            element.data("static_transform",
                new Snap.Matrix(lm.a, lm.b, lm.c, lm.d, lm.e, lm.f));
        });

    if (root.data("tx") === undefined) root.data("tx", 0);
    if (root.data("ty") === undefined) root.data("ty", 0);
    if (root.data("scale") === undefined) root.data("scale", 1.0);
    if (root.data("xtickscales") === undefined) {

        // index all the tick scales that are listed
        var xtickscales = {};
        var ytickscales = {};
        var add_x_tick_scales = function (element, i) {
            xtickscales[element.attribute("gadfly:scale")] = true;
        };
        var add_y_tick_scales = function (element, i) {
            ytickscales[element.attribute("gadfly:scale")] = true;
        };

        root.select(".xgridlines").selectAll("path").forEach(add_x_tick_scales);
        root.select(".ygridlines").selectAll("path").forEach(add_y_tick_scales);
        root.select(".xlabels").selectAll("text").forEach(add_x_tick_scales);
        root.select(".ylabels").selectAll("text").forEach(add_y_tick_scales);

        root.data("xtickscales", xtickscales);
        root.data("ytickscales", ytickscales);
        root.data("xtickscale", 1.0);
    }

    var min_scale = 1.0, max_scale = 1.0;
    for (scale in xtickscales) {
        min_scale = Math.min(min_scale, scale);
        max_scale = Math.max(max_scale, scale);
    }
    for (scale in ytickscales) {
        min_scale = Math.min(min_scale, scale);
        max_scale = Math.max(max_scale, scale);
    }
    root.data("min_scale", min_scale);
    root.data("max_scale", max_scale);

    // store the original positions of labels
    root.select(".xlabels")
        .selectAll("text")
        .forEach(function (element, i) {
            element.data("x", element.asPX("x"));
        });

    root.select(".ylabels")
        .selectAll("text")
        .forEach(function (element, i) {
            element.data("y", element.asPX("y"));
        });

    // mark grid lines and ticks as in or out of scale.
    var mark_inscale = function (element, i) {
        element.attribute("gadfly:inscale", element.attribute("gadfly:scale") == 1.0);
    };

    root.select(".xgridlines").selectAll("path").forEach(mark_inscale);
    root.select(".ygridlines").selectAll("path").forEach(mark_inscale);
    root.select(".xlabels").selectAll("text").forEach(mark_inscale);
    root.select(".ylabels").selectAll("text").forEach(mark_inscale);

    // figure out the upper ond lower bounds on panning using the maximum
    // and minum grid lines
    var bounds = root.plotbounds();
    var pan_bounds = {
        x0: 0.0,
        y0: 0.0,
        x1: 0.0,
        y1: 0.0
    };

    root.select(".xgridlines")
        .selectAll("path")
        .forEach(function (element, i) {
            if (element.attribute("gadfly:inscale") == "true") {
                var bbox = element.node.getBBox();
                if (bounds.x1 - bbox.x < pan_bounds.x0) {
                    pan_bounds.x0 = bounds.x1 - bbox.x;
                }
                if (bounds.x0 - bbox.x > pan_bounds.x1) {
                    pan_bounds.x1 = bounds.x0 - bbox.x;
                }
            }
        });

    root.select(".ygridlines")
        .selectAll("path")
        .forEach(function (element, i) {
            if (element.attribute("gadfly:inscale") == "true") {
                var bbox = element.node.getBBox();
                if (bounds.y1 - bbox.y < pan_bounds.y0) {
                    pan_bounds.y0 = bounds.y1 - bbox.y;
                }
                if (bounds.y0 - bbox.y > pan_bounds.y1) {
                    pan_bounds.y1 = bounds.y0 - bbox.y;
                }
            }
        });

    // nudge these values a little
    pan_bounds.x0 -= 5;
    pan_bounds.x1 += 5;
    pan_bounds.y0 -= 5;
    pan_bounds.y1 += 5;
    root.data("pan_bounds", pan_bounds);

    // Set all grid lines at scale 1.0 to visible. Out of bounds lines
    // will be clipped.
    root.select(".xgridlines")
        .selectAll("path")
        .forEach(function (element, i) {
            if (element.attribute("gadfly:inscale") == "true") {
                element.attr("visibility", "visible");
            }
        });

    root.select(".ygridlines")
        .selectAll("path")
        .forEach(function (element, i) {
            if (element.attribute("gadfly:inscale") == "true") {
                element.attr("visibility", "visible");
            }
        });

    root.data("zoompan-ready", true)
};


// Panning
Gadfly.guide_background_drag_onmove = function(dx, dy, x, y, event) {
    var root = this.plotroot();
    var px_per_mm = root.data("px_per_mm");
    dx /= px_per_mm;
    dy /= px_per_mm;

    var tx0 = root.data("tx"),
        ty0 = root.data("ty");

    var dx0 = root.data("dx"),
        dy0 = root.data("dy");

    root.data("dx", dx);
    root.data("dy", dy);

    dx = dx - dx0;
    dy = dy - dy0;

    var tx = tx0 + dx,
        ty = ty0 + dy;

    set_plot_pan_zoom(root, tx, ty, root.data("scale"));
};


Gadfly.guide_background_drag_onstart = function(x, y, event) {
    var root = this.plotroot();
    root.data("dx", 0);
    root.data("dy", 0);
    init_pan_zoom(root);
};


Gadfly.guide_background_drag_onend = function(event) {
    var root = this.plotroot();
};


Gadfly.guide_background_scroll = function(event) {
    if (event.shiftKey) {
        var root = this.plotroot();
        init_pan_zoom(root);
        var new_scale = root.data("scale") * Math.pow(2, 0.002 * event.wheelDelta);
        new_scale = Math.max(
            root.data("min_scale"),
            Math.min(root.data("max_scale"), new_scale))
        update_plot_scale(root, new_scale);
        event.stopPropagation();
    }
};


Gadfly.zoomslider_button_mouseover = function(event) {
    this.select(".button_logo")
         .animate({fill: this.data("mouseover_color")}, 100);
};


Gadfly.zoomslider_button_mouseout = function(event) {
     this.select(".button_logo")
         .animate({fill: this.data("mouseout_color")}, 100);
};


Gadfly.zoomslider_zoomout_click = function(event) {
    var root = this.plotroot();
    init_pan_zoom(root);
    var min_scale = root.data("min_scale"),
        scale = root.data("scale");
    Snap.animate(
        scale,
        Math.max(min_scale, scale / 1.5),
        function (new_scale) {
            update_plot_scale(root, new_scale);
        },
        200);
};


Gadfly.zoomslider_zoomin_click = function(event) {
    var root = this.plotroot();
    init_pan_zoom(root);
    var max_scale = root.data("max_scale"),
        scale = root.data("scale");

    Snap.animate(
        scale,
        Math.min(max_scale, scale * 1.5),
        function (new_scale) {
            update_plot_scale(root, new_scale);
        },
        200);
};


Gadfly.zoomslider_track_click = function(event) {
    // TODO
};


Gadfly.zoomslider_thumb_mousedown = function(event) {
    this.animate({fill: this.data("mouseover_color")}, 100);
};


Gadfly.zoomslider_thumb_mouseup = function(event) {
    this.animate({fill: this.data("mouseout_color")}, 100);
};


// compute the position in [0, 1] of the zoom slider thumb from the current scale
var slider_position_from_scale = function(scale, min_scale, max_scale) {
    if (scale >= 1.0) {
        return 0.5 + 0.5 * (Math.log(scale) / Math.log(max_scale));
    }
    else {
        return 0.5 * (Math.log(scale) - Math.log(min_scale)) / (0 - Math.log(min_scale));
    }
}


var update_plot_scale = function(root, new_scale) {
    var trans = scale_centered_translation(root, new_scale);
    set_plot_pan_zoom(root, trans.x, trans.y, new_scale);

    root.selectAll(".zoomslider_thumb")
        .forEach(function (element, i) {
            var min_pos = element.data("min_pos"),
                max_pos = element.data("max_pos"),
                min_scale = root.data("min_scale"),
                max_scale = root.data("max_scale");
            var xmid = (min_pos + max_pos) / 2;
            var xpos = slider_position_from_scale(new_scale, min_scale, max_scale);
            element.transform(new Snap.Matrix().translate(
                Math.max(min_pos, Math.min(
                         max_pos, min_pos + (max_pos - min_pos) * xpos)) - xmid, 0));
    });
};


Gadfly.zoomslider_thumb_dragmove = function(dx, dy, x, y) {
    var root = this.plotroot();
    var min_pos = this.data("min_pos"),
        max_pos = this.data("max_pos"),
        min_scale = root.data("min_scale"),
        max_scale = root.data("max_scale"),
        old_scale = root.data("old_scale");

    var px_per_mm = root.data("px_per_mm");
    dx /= px_per_mm;
    dy /= px_per_mm;

    var xmid = (min_pos + max_pos) / 2;
    var xpos = slider_position_from_scale(old_scale, min_scale, max_scale) +
                   dx / (max_pos - min_pos);

    // compute the new scale
    var new_scale;
    if (xpos >= 0.5) {
        new_scale = Math.exp(2.0 * (xpos - 0.5) * Math.log(max_scale));
    }
    else {
        new_scale = Math.exp(2.0 * xpos * (0 - Math.log(min_scale)) +
                        Math.log(min_scale));
    }
    new_scale = Math.min(max_scale, Math.max(min_scale, new_scale));

    update_plot_scale(root, new_scale);
};


Gadfly.zoomslider_thumb_dragstart = function(event) {
    var root = this.plotroot();
    init_pan_zoom(root);

    // keep track of what the scale was when we started dragging
    root.data("old_scale", root.data("scale"));
};


Gadfly.zoomslider_thumb_dragend = function(event) {
};


var toggle_color_class = function(root, color_class, ison) {
    var guides = root.selectAll(".guide." + color_class + ",.guide ." + color_class);
    var geoms = root.selectAll(".geometry." + color_class + ",.geometry ." + color_class);
    if (ison) {
        guides.animate({opacity: 0.5}, 250);
        geoms.animate({opacity: 0.0}, 250);
    } else {
        guides.animate({opacity: 1.0}, 250);
        geoms.animate({opacity: 1.0}, 250);
    }
};


Gadfly.colorkey_swatch_click = function(event) {
    var root = this.plotroot();
    var color_class = this.data("color_class");

    if (event.shiftKey) {
        root.selectAll(".colorkey text")
            .forEach(function (element) {
                var other_color_class = element.data("color_class");
                if (other_color_class != color_class) {
                    toggle_color_class(root, other_color_class,
                                       element.attr("opacity") == 1.0);
                }
            });
    } else {
        toggle_color_class(root, color_class, this.attr("opacity") == 1.0);
    }
};


return Gadfly;

}));


//@ sourceURL=gadfly.js

(function (glob, factory) {
    // AMD support
      if (typeof require === "function" && typeof define === "function" && define.amd) {
        require(["Snap.svg", "Gadfly"], function (Snap, Gadfly) {
            factory(Snap, Gadfly);
        });
      } else {
          factory(glob.Snap, glob.Gadfly);
      }
})(window, function (Snap, Gadfly) {
    var fig = Snap("#fig-513a44c54ef244079cf52ea51c3ae086");
fig.select("#fig-513a44c54ef244079cf52ea51c3ae086-element-4")
   .mouseenter(Gadfly.plot_mouseover)
.mouseleave(Gadfly.plot_mouseout)
.mousewheel(Gadfly.guide_background_scroll)
.drag(Gadfly.guide_background_drag_onmove,
      Gadfly.guide_background_drag_onstart,
      Gadfly.guide_background_drag_onend)
;
fig.select("#fig-513a44c54ef244079cf52ea51c3ae086-element-7")
   .plotroot().data("unfocused_xgrid_color", "#D0D0E0")
;
fig.select("#fig-513a44c54ef244079cf52ea51c3ae086-element-7")
   .plotroot().data("focused_xgrid_color", "#A0A0A0")
;
fig.select("#fig-513a44c54ef244079cf52ea51c3ae086-element-8")
   .plotroot().data("unfocused_ygrid_color", "#D0D0E0")
;
fig.select("#fig-513a44c54ef244079cf52ea51c3ae086-element-8")
   .plotroot().data("focused_ygrid_color", "#A0A0A0")
;
fig.select("#fig-513a44c54ef244079cf52ea51c3ae086-element-13")
   .data("mouseover_color", "#cd5c5c")
;
fig.select("#fig-513a44c54ef244079cf52ea51c3ae086-element-13")
   .data("mouseout_color", "#6a6a6a")
;
fig.select("#fig-513a44c54ef244079cf52ea51c3ae086-element-13")
   .click(Gadfly.zoomslider_zoomin_click)
.mouseenter(Gadfly.zoomslider_button_mouseover)
.mouseleave(Gadfly.zoomslider_button_mouseout)
;
fig.select("#fig-513a44c54ef244079cf52ea51c3ae086-element-15")
   .data("max_pos", 120.42)
;
fig.select("#fig-513a44c54ef244079cf52ea51c3ae086-element-15")
   .data("min_pos", 103.42)
;
fig.select("#fig-513a44c54ef244079cf52ea51c3ae086-element-15")
   .click(Gadfly.zoomslider_track_click);
fig.select("#fig-513a44c54ef244079cf52ea51c3ae086-element-16")
   .data("max_pos", 120.42)
;
fig.select("#fig-513a44c54ef244079cf52ea51c3ae086-element-16")
   .data("min_pos", 103.42)
;
fig.select("#fig-513a44c54ef244079cf52ea51c3ae086-element-16")
   .data("mouseover_color", "#cd5c5c")
;
fig.select("#fig-513a44c54ef244079cf52ea51c3ae086-element-16")
   .data("mouseout_color", "#6a6a6a")
;
fig.select("#fig-513a44c54ef244079cf52ea51c3ae086-element-16")
   .drag(Gadfly.zoomslider_thumb_dragmove,
     Gadfly.zoomslider_thumb_dragstart,
     Gadfly.zoomslider_thumb_dragend)
.mousedown(Gadfly.zoomslider_thumb_mousedown)
.mouseup(Gadfly.zoomslider_thumb_mouseup)
;
fig.select("#fig-513a44c54ef244079cf52ea51c3ae086-element-17")
   .data("mouseover_color", "#cd5c5c")
;
fig.select("#fig-513a44c54ef244079cf52ea51c3ae086-element-17")
   .data("mouseout_color", "#6a6a6a")
;
fig.select("#fig-513a44c54ef244079cf52ea51c3ae086-element-17")
   .click(Gadfly.zoomslider_zoomout_click)
.mouseenter(Gadfly.zoomslider_button_mouseover)
.mouseleave(Gadfly.zoomslider_button_mouseout)
;
    });
]]> </script>
</svg>





    
