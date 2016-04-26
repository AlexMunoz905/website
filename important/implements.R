library(sna)
library(plyr)
library(permute)

# Import Data
HNSCC<-read.table('D:/undergraduate thesis/biological data/data/HNSCC/A.txt',header=T)
HNSCC<-HNSCC[,!colnames(HNSCC)%in%c('TP53','TTN')]
retrieve_gene_name<-function(i) colnames(HNSCC)[i]
retrieve_number<-function(g) match(g,colnames(HNSCC))

LC<-read.table('D:/undergraduate thesis/biological data/data/LC/A.txt',header=T)
OC<-read.table('D:/undergraduate thesis/biological data/data/OC/A.txt',header=T)
OCe<-read.table('D:/undergraduate thesis/biological data/data/OC/E.txt',header=T)

# Main
# penalty function given the big matrix, the column index and penalty mode
penalty_of_submatrix<-function(columns,M=mutationmatrix,penalty=function(x,k) abs(x-1),weight=1){
  submat<-M[,columns]
  if(length(columns)==1) subsums<-submat
  else subsums<-rowSums(submat)
  k<-length(columns)
  return(sum(weight*penalty(subsums,k)))
}

product<-function(father,mother,fixed,penalt,mutationrate,totalnum){
  must<-intersect(father,mother)
  might<-union(father,mother)
  probable<-setdiff(might,must)
  if(length(probable)){
    if(fixed)
      child<-union(sample(probable,length(probable)/2),must)
    else
      child<-union(sample(probable,sample.int(length(probable),1)),must)
  }else{
    child<-must
  }
  res1<-penalt(child)
  if(runif(1)<=mutationrate){
    candidate<-union(sample(setdiff(1:totalnum,child),1),
                     setdiff(child,sample(child,1)))
    res2<-penalt(candidate)
    if(res1>res2){
      child<-candidate
      res1<-res2
    }
  }
  return(list(child=child,penalt=res1))
}

weightga<-function(M,penalty=function(x,k) abs(x-1),
                   weighted=F,fixed=T,initial=10,
                   population=1000,maxiter=200,mutationrate=0.1){
  if(weighted) weight<-(1/rowSums(M)) else weight<-1
  penalt<-function(columns) penalty_of_submatrix(columns,M,penalty,weight)
  produce<-function(father,mother) product(father,mother,fixed,penalt,mutationrate,ncol(M))
  elites<-lapply(1:population,function(x) sample.int(ncol(M),initial))
  scores<-sapply(elites,penalt)
  children<-list()
  tempgen<-list()
  for(iter in 1:maxiter){
    print(iter)
    print(elites[[1]])
    print(scores[[1]])
    sranks<-rank(-scores)
    scorepool<-scores
    for(p in 1:population){
      couplenum<-sample.int(population,2,prob=sranks)
      father<-elites[[couplenum[1]]]
      mother<-elites[[couplenum[2]]]
      production<-produce(father,mother)
      child<-production$child
      children[[p]]<-child
      scorepool[population+p]<-production$penalt
    }
    nextgen<-sort(scorepool,index.return=T)$ix[1:population]
    for(i in 1:population){
      index<-nextgen[i]
      if(index<=population)
        tempgen[[i]]<-elites[[index]]
      if(index>population)
        tempgen[[i]]<-children[[index-population]]
      scores[i]<-scorepool[index]
    }
    elites<-tempgen
    if(sum(sapply(1:(length(elites)-1),function(x) setequal(elites[[x]],elites[[x+1]])))>=0.9*population)
      break
  }
  return(list(scores=scores,candidates=elites,iteration=iter,
              representative=elites[[1]],score=scores[1]))
}

# temp<-weightga(HNSCC,fixed=T,penalty=function(x,k) sqrt(abs(x-1)),initial=4,population=2000,maxiter=300)
# sapply(temp$representative,retrieve_gene_name)
# print(penalty_of_submatrix(sapply(c('ANO4','CDKN2A','NFE2L2','NOTCH1','SLIT3','SYNE1','TP63'),retrieve_number),HNSCC,weight=1,penalty=function(x,k) abs(x-1)))

# Simulation Study
gendata<-function(m=50,n=200,I=10,distribution=rep(c(0.1,1,0.1,0),c(1,1,1,I-2)),mutationrate=0.02){
  mutationpart<-matrix(rbinom(m*(n-I),1,mutationrate),m)
  driverpart<-matrix(0,m,I)
  for(i in 1:m)
    driverpart[i,sample.int(I,sample(0:I,1,prob=distribution))]<-1
  datamatrix<-cbind(driverpart,mutationpart)
  plot.sociomatrix(datamatrix,drawlab=F)
  return(datamatrix)
}

M<-gendata(m=100,n=1000,maxiter=200)

# Original Strategy
original<-weightga(M,maxiter=1000)
# New Criteria
newcriteria<-newcrit(M,maxiter=1000)

