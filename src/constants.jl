m = 21          # The number of 'space' nodes
n = 401         # The number of 'time' nodes
tau = 10/(n-1)  # Time step size
h = 1/(m-1)     # Space step size

lamb = 0.3
taubyh = tau/h

x = linrange(0,1,m)
t = linrange(0,10,n)
