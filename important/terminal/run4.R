kmin<-1
kmax<-10
t<-4
N<-20
test<-permtest(A,N,0.9,t,kmin,kmax,shuffle='column')
temp<-test$perm
if(is.vector(temp)) sorttemp<-sort(temp) else sorttemp<-apply(temp,2,sort)
tempscore<-scorecalculator(A,t,kmin,kmax)
print(tempscore)

jpeg('fig4.png')
matplot(t(sorttemp),ylim=c(min(temp,tempscore),max(temp,tempscore)),type='l',main=paste('t=',t,sep=''))
abline(h=tempscore)
dev.off()

write.table(temp,'temp4.txt')



