library(rgl)
library(fields)

A<-function(n,k,l,p=0.1) sum(sapply(0:l,function(u) choose(k,l-u)*choose(n-k,u)*p^u))

O<-function(n=20,k=5,l,p=0.1) k*(A(n-1,k-1,l-1,p)/A(n,k,l,p))^2+(n-k)*(p*A(n-1,k,l-1,p)/A(n,k,l,p))^2


Oapprox<-function(n=20,k=5,l,p=0.1) k*(A(n-1,k-1,l-1,p)/A(n,k,l,p))^2
Oerror<-function(n=20,k=5,l,p=0.1) (n-k)*(p*A(n-1,k,l-1,p)/A(n,k,l,p))^2
Oscalederror<-function(n=20,k=5,l,p=0.1) Oerror(n,k,l,p)/l
Oscaled<-function(n=100,k=10,l,p=0.05) O(n,k,l,p)/l
Oscaledapprox<-function(n=20,k=5,l,p=0.1) Oapprox(n,k,l,p)/l
Oharshscale<-function(n=100,k=10,l,p=0.05,pow=2) O(n,k,l,p)/(l^pow)
errorperc<-function(n=1000,k=10,l,p=0.005) (n-k)/k*(p*A(n-1,k,l-1,p)/A(n-1,k-1,l-1,p))^2

test<-function(rangep=2,n=1000,k=10,method=c('Scaled','Exact','Approximate','Scaled Approximate','Harsh Scale'),pow=2){
  method<-match.arg(method)
  if(method=='Scaled') usef<-Oscaled
  if(method=='Exact') usef<-O
  if(method=='Approximate') usef<-Oapprox
  if(method=='Scaled Approximate') usef<-Oscaledapprox
  basis<-1/n
  x<-1:(2*k)
  y<-setdiff(seq(0,basis*rangep,length.out=20),0)
  temp<-merge(x,y)
  if(method=='Harsh Scale'){
    temp<-cbind(temp,sapply(1:nrow(temp),function(i) Oharshscale(n,k,temp[i,1],temp[i,2],pow)))
    print(rbind(sapply(y,function(j) which.max(sapply(x,function(x) Oharshscale(n,k,x,j,pow)))),y/basis))
  }else{
    temp<-cbind(temp,sapply(1:nrow(temp),function(i) usef(n,k,temp[i,1],temp[i,2])))
    print(rbind(sapply(y,function(j) which.max(sapply(x,function(x) usef(n,k,x,j)))),y/basis))
  }
  plot3d(temp,type='l',xlab='l',ylab='p',zlab='O(l,p)',main=paste(method,':n=',n,',k=',k,sep=''))
}

