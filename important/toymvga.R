library(lpSolve)

kmin<-1
kmax<-6
mutationrate<-0.1
list_of_std<-list(1:5,6:10)
n<-20
t<-3
population<-50
maxiter<-20

testscoring<-function(Mrho,list_of_std) n-min(sapply(list_of_std,function(x) length(setdiff(Mrho,x))+length(setdiff(x,Mrho))))
testscore<-function(vec) sum(sapply(1:max(vec),function(i) testscoring(which(vec==i),list_of_std)))

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

mvga<-function(crossproduct,scoring){
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

system.time(
temp<-mvga(crossproduct=function(father,mother) crossprod(father,mother,kmin,kmax,mutationrate,testscore),
           scoring=testscore)
)
print(temp$score)

