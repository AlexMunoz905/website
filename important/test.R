# Monte Carlo Integration
f<-function(g,N=10000) return(sum(runif(N)<g(runif(N)))/N)



