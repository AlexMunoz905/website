library(lpSolve)
library(sna)

# Multiple Value Genetic Algorithm with New Scoring Scheme
# New Criteria
new_score<-function(columns,M){
  if(length(columns)==1){
    temp<-M[,columns]
  }else{
    temp<-rowSums(M[,columns])
  }
  cover<-sum(temp!=0)
  exclu<-sum(temp==1)
  if(cover==0) return(0)
  return(cover/nrow(M)+exclu/cover)
}

score_of_vectors<-function(labelvec,M) sum(sapply(1:max(labelvec),function(rho) new_score(which(labelvec==rho),M)))

crossprod<-function(father,mother,kmin,kmax,mutationrate,optimizef){
  t<-max(father)
  n<-length(father)
  avail<-father+mother>0
  temp<-cbind(sapply(1:n,function(i) sapply(1:t,function(rho) (mother[i]==rho)-(father[i]==rho))),rep(0,t))
  f.obj<-rep(c(0,1),c(n,1))
  f.con<-rbind(c(2*avail,-1),c(2*avail,1),temp,temp)
  f.dir<-c('<=','>=',rep(c('<=','>='),c(t,t)))
  ccoef<-sapply(1:t,function(rho) sum(sapply(1:n,function(i) father[i]==rho)))
  f.rhs<-c(sum(avail),sum(avail),kmax-ccoef,kmin-ccoef)
  ones<-lp('min',f.obj,f.con,f.dir,f.rhs,binary.vec=1:n)$solution[-n-1]
  nones<-rep(0,n)
  nones[which(avail==1)[which(ones==1)]]<-1
  solution<-(1-ones)*father+ones*mother
  score1<-optimizef(solution)
  retres<-solution
  retscr<-score1
  if(runif(1)<=mutationrate){
    samplein<-sample(which(solution==0),1)
    sampleout<-sample(which(solution!=0),1)
    candidate<-solution
    candidate[samplein]<-candidate[sampleout]
    candidate[sampleout]<-0
    score2<-optimizef(candidate)
    if(score2>score1){
      retres<-candidate
      retscr<-score2
    }
  }
  return(list(child=retres,score=retscr))
}


mvga<-function(crossproduct,scoring,n,t,population,maxiter){
  generation<-list()
  for(p in 1:population){
    temp<-rep(1:t,sample(kmin:kmax,t,replace=T))
    temp[(length(temp)+1):n]<-0
    generation[[p]]<-temp[sample.int(n)]
  }
  scores<-sapply(generation,scoring)
  for(i in 1:maxiter){
    print(i)
    allscores<-c(scores,rep(0,population))
    allvectors<-generation
    for(p in 1:population){
      parents<-sample.int(population,2,prob=scores)
      temp<-crossproduct(generation[[parents[1]]],generation[[parents[2]]])
      allscores[population+p]<-temp$score
      allvectors[[population+p]]<-temp$child
    }
    nextgen<-sort(allscores,decreasing=T,index.return=T)$ix[1:population]
    scores<-allscores[nextgen]
    generation<-lapply(1:population,function(j) allvectors[[nextgen[j]]])
  }
  return(list(scores=scores,candidates=generation,
              representative=generation[[1]],score=scores[1]))
}

newcrit<-function(M,kmin=2,kmax=4,t=3,
                  population=1000,maxiter=200,mutationrate=0.1){
  n<-ncol(M)
  scoring<-function(label) score_of_vectors(label,M)
  crossproduct<-function(father,mother) crossprod(father,mother,kmin,kmax,mutationrate,scoring)
  return(mvga(crossproduct,scoring,n,t,population,maxiter))
}

searchrange<-function(testf=function(gt,kmin=5,kmax=7,t=10,scorethreshold=1.8) list(pmax(round(rnorm(gt,(kmin+kmax)/2,(kmax-kmin)/2)),1),pmin(c(rnorm(min(t,gt),scorethreshold+0.5,0.5),rnorm(max(gt-t,0),scorethreshold-0.5,0.5)),2)),
                      scorethreshold=1.8,maxiter=20,
                      tmin=3,tmax=20,gkmin=2,gkmax=15,q=0.1){
  temp<-sapply(tmin:tmax,function(t) mean(sapply(1:maxiter,function(i) sum(testf(t,gkmin,gkmax)[[2]]>scorethreshold)))/t)
  difference<-abs(diff(temp))
  t<-which.max(difference[-1]/difference[-length(difference)])+1
  alllength<-c(sapply(1:maxiter,function(i) testf(t)[[1]]))
  # Maximize Well Fit
  likelihood<-function(kmin,kmax) prod(sapply(alllength,function(x) (x>=gkmin&&x<kmin)*q/(kmin-gkmin)+(kmin<=x&&x<=kmax)*(1-2*q)/(kmax-kmin+1)+(x>kmax&&x<=gkmax)*q/(gkmax-kmax)))
  tempmat<-matrix(0,choose(gkmax-gkmin,2),3)
  tempind<-1
  for(i in (gkmin+1):(gkmax-1)){
    for(j in (i+1):(gkmax-1)){
      tempmat[tempind,]<-c(i,j,likelihood(i,j))
      tempind<-tempind+1
    }
  }
  return(c(tempmat[which.max(tempmat[,3]),1:2],t))
}

# Simulation Study
groupdata<-function(m=50,n=200,t=3,kmin=4,kmax=6,distribution=function(I) rep(c(0.1,1,0.1,0),c(1,1,1,I-2)),mutationrate=0.02){
  alllength<-sample(kmin:kmax,t,replace=T)
  datamatrix<-matrix(rbinom(m*(n-sum(alllength)),1,mutationrate),m)
  for(x in 1:t){
    I<-alllength[x]
    driverpart<-matrix(0,m,I)
    for(i in 1:m)
      driverpart[i,sample.int(alllength[x],sample(0:I,1,prob=distribution(I)))]<-1
    datamatrix<-cbind(driverpart,datamatrix)
  }
  plot.sociomatrix(datamatrix,drawlab=F)
  return(list(data=datamatrix,lengths=alllength))
}

temp<-groupdata()
A<-temp$data
result<-temp$lengths
resvec<-rep(1:3,result)
resvec[length(resvec)+1:ncol(A)]<-0


test<-searchrange(function(t,kmin,kmax) newcrit(A,kmin,kmax,t,20,10),tmin=2,tmax=4,gkmin=3,gkmax=7,maxiter=10)


