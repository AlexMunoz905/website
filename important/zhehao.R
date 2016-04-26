library(Matrix)
library(sna)

# Arbitrarily Set up Data Q, M=-Q
n<-10
W<-as.matrix(forceSymmetric(matrix(abs(rnorm(n^2,0,1)),n)))

# Matrix with 0,1 only
n<-10
spar<-0.2
x<-rbinom(choose(n,2),1,spar)
W<-matrix(0,n,n)
W[upper.tri(W)]<-x
W<-forceSymmetric(W)
for(i in 1:n)
  if(all(W[i,]==0)){
    j<-sample(setdiff(1:n,i),1)
    W[i,j]<-1
    W[j,i]<-1
  }
W<-as.matrix(W)

# Set up data with clusters
n1<-4
n2<-6
mu1<-10
mu2<-10
Wfirst<-as.matrix(forceSymmetric(matrix(abs(rnorm(n1^2,mu1,1)),n1)))
Wsecond<-as.matrix(forceSymmetric(matrix(abs(rnorm(n2^2,mu2,1)),n2)))
Wmiddle<-as.matrix(matrix(abs(rnorm(n1*n2)),n1))
W<-rbind(cbind(Wfirst,Wmiddle),cbind(t(Wmiddle),Wsecond))

plot.sociomatrix(W,drawlab=F,asp=1)
Q<-diag(1/sqrt(rowSums(W)))%*%W%*%diag(1/sqrt(colSums(W)))
M<--Q

# Positive Definite Check
is.positive.definite<-function(M){
  all(eigen(M)$values>=0)
}

# The objective is to
# min uMu+rho|u|
# or max uQu-rho|u|
f<-function(M,rho,u) t(u)%*%M%*%u+rho*norm(u,'1')
g<-function(M,rho,u) t(u)%*%M%*%u+rho*sum(u!=0)
h<-function(M,rho,u,thres=0.1) t(u)%*%M%*%u+rho*sum(abs(u)>=thres)

# RSA (Random Searching Algorithm)
# Randomly select N candidate u(s)
# Return all value, print maximum value
rsa<-function(M,rho,N,method=c('l1','l0','thres')){
  getmet<-match.arg(method)
  if(getmet=='l1') func<-f
  if(getmet=='l0') func<-g
  if(getmet=='thres') func<-h
  storeu<-matrix(rnorm(n*N,0,1),n)
  storeu<-storeu%*%diag(apply(storeu,2,function(x) 1/norm(as.matrix(x),'F')))
  storef<-apply(storeu,2,function(x) func(M,rho,as.matrix(x)))
  list(allu=storeu,allf=storef,minf=min(storef),minu=storeu[,which.min(storef)])
}


zhehao<-function(Q,rho,N){
  n<-nrow(Q)
  u<-rep(1/sqrt(n),n)
  for(iter in 1:N){
    z<-Q%*%u
    z<-z/sqrt(sum(z^2))
    sortres<-sort(z,decreasing=T,index.return=T)
    sortind<-sortres$ix
    sortz<-sortres$x
    absz<-abs(sortz)
    test<-1
    while(test<n){
      if(absz[test+1]<=sqrt(rho^2+2*rho*sum(sapply(1:test,function(i) absz[i]^2))) ) break
      test<-test+1
    }
    zlh<-sqrt(sum(sortz[1:test]^2))
    print(u<-c(sortz[1:test]/zlh,rep(0,n-test))[sortind])
    cat('\n')
  }
  print(nonzero<-which(u!=0))
  u
}

# result interpretation
# rho<-0.05
# N<-100
# res<-zhehao(W,rho,N)

# Brute Force Algorithm
givenspar<-function(k){
  allcomb<-combn(n,k)
  maxind<-which.max(apply(allcomb,2,function(x) max(eigen(Q[x,x])$values)))
  res<-eigen(Q[allcomb[,maxind],allcomb[,maxind]])
  list(maxeigen=max(res$values),corvector=res$vectors[,which.max(res$values)],maxind=allcomb[,maxind])
}

bfzhehao<-function(Q,rho){
  n<-nrow(Q)
  allres<-sapply(1:n,function(i) givenspar(i))
  maxnum<-which.max(sapply(1:n,function(i) as.numeric(allres[1,i])-rho*i))
  temp2<-allres[2,maxnum][[1]]
  temp3<-allres[3,maxnum][[1]]
  maxu<-rep(0,n)
  for(i in 1:length(temp3)) maxu[temp3[i]]<-temp2[i]
  as.matrix(maxu)
}

# Objective
# min f(u)=u^TMu+rho||u||_1, s.t. u^Tu=1
# Method 1
# min f(u)=u^TMu/u^Tu+rho||u||_1/sqrt(u^Tu)
lone<-function(M,rho,N,Const=10){
  # Objective Function
  f<-function(u) t(u)%*%M%*%u/sum(u^2)+rho*norm(u,'1')/norm(u,'F')
  # Initialize the vector
  eigenM<-eigen(M)
  u<-as.matrix(eigenM$vectors[,which.min(eigenM$values)])
  for(i in 1:N){
    x<-Q%*%u
    y<-norm(u,'F')
    localder<--2*x/y^2+as.numeric(2*t(u)%*%x)*u/y^4+rho*sign(u)/y-rho*norm(u,'1')*u/y^3
    temp<-which.min(sapply(seq(0.01,1,0.01),function(lambda) f(u-lambda*localder)))
    newu<-u-0.01*temp*localder
    print(f(newu))
    print(newu)
    newu
  }
  for(i in 1:N) u<-updateu(u)
  u
}

ista<-function(Q,rho,N,Const=10){
  # Objective Function
  f<-function(u) -t(u)%*%Q%*%u+rho*norm(u,'1')
  # Initialize the vector
  eigenQ<-eigen(Q)
  u<-as.matrix(eigenQ$vectors[,which.max(eigenQ$values)])
  for(i in 1:N){
    lambda<-1/(i+Const)
    u<-u+2*lambda*Q%*%u-rho*lambda*sign(u)
    u<-u/norm(u,'F')
    print(f(u))
    u
  }
  u
}

# max f(u)=uQu-rho|u|_0
ruibin<-function(Q,rho){
  eigenQ<-eigen(Q)
  u<-eigenQ$vectors[,which.max(eigenQ$values)]
  absurank<-rank(-abs(u),ties.method='first')
  allresults<-rep(NA,n)
  for(k in 1:n){
    subsetind<-which(absurank<=k)
    allresults[k]<-max(eigen(Q[subsetind,subsetind])$values)
  }
  k<-which.min(allresults-rho*(1:n))
  subsetind<-which(absurank<=k)
  bestu<-rep(0,n)
  eigenQsubset<-eigen(Q[subsetind,subsetind])
  bestu[subsetind]<-eigenQsubset$vectors[,which.max(eigenQsubset$values)]
  bestu
}

