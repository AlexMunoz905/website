# Relaxation
relaxLP<-function(A=matrix(rbinom(50,1,0.5),5),t=3,kmin=2,kmax=3){
  m<-nrow(A)
  n<-ncol(A)
  # Variables: I_{M_1}(1),I_{M_1}(2),\cdots,I_{M_t}(n)
  #  
  f.obj<-c(rep(-colSums(A),t),rep(2,m*t))
  f.con<-matrix(0,nrow=(m+2)*t+n,ncol=(m+n)*t)
  for(i in 1:m){
    calculate<-A[i,]
    for(rho in 1:t){
      temp<-rep(0,(m+n)*t)
      temp[n*t+(rho-1)*m+i]<--1
      temp[(rho-1)*n+1:n]<-calculate
      f.con[t*(i-1)+rho,]<-temp
    }
  }
  for(j in 1:n) f.con[m*t+j,]<-c(rep(rep(c(0,1,0),c(j-1,1,n-j)),t),rep(0,m*t))
  for(rho in 1:t) f.con[n+rho+t*m,]<-rep(c(0,1,0),c((rho-1)*n,n,(t-rho)*n+m*t))
  for(rho in 1:t) f.con[n+rho+t*(m+1),]<-rep(c(0,1,0),c((rho-1)*n,n,(t-rho)*n+m*t))
  f.con<-rbind(f.con,diag((m+n)*t),diag((m+n)*t))
  plot.sociomatrix(f.con,drawlab=F)
  f.dir<-c(rep(rep(c('>=','<='),2),c(m*t,n,t,t)),rep('>=',(m+n)*t),rep('<=',(m+n)*t))
  f.rhs<-c(rep(c(0,1,kmin,kmax),c(m*t,n,t,t)),rep(0,(m+n)*t),rep(1,(m+n)*t))
  solution<-lp('max',f.obj,f.con,f.dir,f.rhs)
  # Interpret the result
  geneset<-list()
  for(rho in 1:t){
    geneset[[rho]]<-which(solution$solution[(rho-1)*n+1:n]>=0.5)
  }
  return(solution)
}

time1<-system.time(test1<-relaxLP(A,3,3,4))
time2<-system.time(test2<-mILP(A,3,3,4))





