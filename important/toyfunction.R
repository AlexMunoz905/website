# Toy example
f<-function(x) exp(-x^2)

firstpopulation<-runif(10,-5,5)

for(k in 1:200){
score<-f(firstpopulation)

nextgen<-sapply(1:10,function(p){
  child<-mean(sample(firstpopulation,2,prob=score))
  if(runif(1)<0.1){
    mutant<-child+rnorm(1,0,0.5)
    if(f(mutant)>f(child))
      child<-mutant
  }
  return(child)
})
pool<-union(firstpopulation,nextgen)
firstpopulation<-pool[sort(f(pool),decreasing=T,index.return=T)$ix[1:10]]
}


