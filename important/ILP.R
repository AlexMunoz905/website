library(sna)
library(lpSolve)

# mdendrix
mILP<-function(A=matrix(rbinom(50,1,0.5),5),t=3,kmin=2,kmax=3,constrained=T){
  m<-nrow(A)
  n<-ncol(A)
  if(!constrained){
    f.obj<-c(rep(-colSums(A),t),rep(2,m*t))
    f.con<-matrix(0,nrow=m*t+n,ncol=(m+n)*t)
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
    f.dir<-rep(c('>=','<='),c(m*t,n))
    f.rhs<-rep(c(0,1),c(m*t,n))
    # Solve the ILP
    solution<-lp('max',f.obj,f.con,f.dir,f.rhs,all.bin=T)
    # Interpret the result
    geneset<-list()
    for(rho in 1:t){
      geneset[[rho]]<-which(solution$solution[(rho-1)*n+1:n]==1)
    }
    return(geneset)
  }
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
  # plot.sociomatrix(f.con,drawlab=F)
  f.dir<-rep(rep(c('>=','<='),2),c(m*t,n,t,t))
  f.rhs<-rep(c(0,1,kmin,kmax),c(m*t,n,t,t))
  # Solve the ILP
  solution<-lp('max',f.obj,f.con,f.dir,f.rhs,all.bin=T)
  # Interpret the result
  geneset<-list()
  for(rho in 1:t){
    geneset[[rho]]<-which(solution$solution[(rho-1)*n+1:n]==1)
  }
  return(geneset)
}

# Iteratively solve t=1 case
iterILP<-function(A=matrix(rbinom(50,1,0.5),5),t=3,kmin=2,kmax=3){
  record<-list()
  datamat<-A
  index<-1:ncol(A)
  for(rho in 1:t){
    solution<-mILP(datamat,t=1,kmin,kmax)[[1]]
    record[[rho]]<-index[solution]
    datamat<-datamat[,-solution]
    index<-index[-solution]
  }
  return(record)
}

penalty_of_submatrix<-function(columns,M=mutationmatrix,penalty=function(x,k) abs(x-1),weight=1){
  submat<-M[,columns]
  if(length(columns)==1) subsums<-submat
  else subsums<-rowSums(submat)
  k<-length(columns)
  return(sum(weight*penalty(subsums,k)))
}

scorecalculator<-function(A,answerlist){
  sapply(answerlist,function(x) penalty_of_submatrix(x,A))
}
