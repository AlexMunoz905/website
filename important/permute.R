library(sna)
library(lpSolve)
library(permute)

# Generate Simulation Data
gensim<-function(m=50,n=100,t=3,kmin=4,kmax=6,sp=3){
  alllength<-sample(kmin:kmax,t,replace=T)
  print(alllength)
  datamatrix<-matrix(0,m,n-sum(alllength))
  for(j in 1:ncol(datamatrix)) datamatrix[sample.int(m,sample.int(sp)),j]<-1
  for(x in 1:t){
    I<-alllength[x]
    driverpart<-matrix(0,m,I)
    for(i in 1:m)
      driverpart[i,sample.int(alllength[x],sample(0:I,1,prob=rep(c(0.1,1,0.1,0),c(1,1,1,I-2))))]<-1
    datamatrix<-cbind(driverpart,datamatrix)
  }
  datamatrix
}

# A<-gensim()
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


scorecalc<-function(A,vec=1:ncol(A),method=c('index','ones')){
  met<-match.arg(method)
  if(met=='index') ind<-vec
  if(met=='ones') ind<-which(vec==1)
  sum(sapply(rowSums(A[,ind]),function(x) 1-abs(x-1)))
}

shuffle<-function(A){
  B<-t(A)
  ind<-order(c(col(B)), runif(length(B)))
  print(1)
  matrix(B[ind],nrow=nrow(A),ncol=ncol(A),byrow=T)
}


scorecalculator<-function(A,t,kmin,kmax) sapply(mILP(A,t,kmin,kmax),function(x) scorecalc(A,x))

permtest<-function(A,N=10,percentile=0.9,t=3,kmin=4,kmax=6,shuffle=c('row','column')){
  A<-as.matrix(A)
  shufmet<-match.arg(shuffle)
  trueres<-scorecalculator(A,t,kmin,kmax)
  if(shufmet=='row') resmat<-replicate(N,scorecalculator(shuffle(A),t,kmin,kmax))
  if(shufmet=='column') resmat<-replicate(N,scorecalculator(t(shuffle(t(A))),t,kmin,kmax))
  permq<-sapply(1:t,function(i) quantile(resmat[i,],percentile))
  trues<-sum(trueres)
  return(list(true=trueres,perm=resmat,quantile=permq,truesum=trues))
}


# FDR test
fdr<-function(A,t=3,kmin=4,kmax=6,truth=c(5,4),method=c('row','column')){
  shufmet<-match.arg(method)
  if(shufmet=='row') permmat<-shuffle(A) else permmat<-t(shuffle(t(A)))
  allres<-mILP(permmat,t,kmin,kmax)
  bigtruth<-cumsum(truth)
  smltruth<-c(1,cumsum(truth)+1)[1:length(bigtruth)]
  alltruth<-lapply(1:length(bigtruth),function(i) c(smltruth[i],bigtruth[i]))
  truerate<-sapply(allres,function(x) max(sapply(alltruth,function(y) length(intersect(x,y[1]:y[2]))))/length(x))
  list(permutated=permmat,lpresult=allres,truerate=truerate)
}

A<-gensim(t=2)

require(lpSolve)

testrun<-function(t,kmin=1,kmax=10,N=20,A){
  test<-permtest(A,N,0.9,t,kmin,kmax,shuffle='column')
  temp<-test$perm
  if(is.vector(temp)) sorttemp<-sort(temp) else sorttemp<-apply(temp,2,sort)
  tempscore<-scorecalculator(A,t,kmin,kmax)
  print(tempscore)
  jpeg(paste('fig',t,'.png',sep=''))
  matplot(t(sorttemp),ylim=c(min(temp,tempscore),max(temp,tempscore)),type='l',main=paste('t=',t,sep=''))
  abline(h=tempscore)
  dev.off()  
  write.table(temp,paste('result',t,'.txt',sep=''))
}


