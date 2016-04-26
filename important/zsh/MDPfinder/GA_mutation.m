function maxpop = GA_mutation(A,k,exclusion)
%
% This function uses genetic algorithm to solve the 'Maximum Weight Submatrix problem'.
%
% A : m (sample) x n (genes) mutation matrix.
%
% k : number of desired genes.
%
% exclusion : the genes which are to be excluded from the results.
%
% maxpop : output matrix with k+2 columns.
%          every row indicates the information of one solution; 
%          for row i, maxpop(i,1:k) records the selected genes;
%          maxpop(i,k+1) records the weight of this gene set;
%          maxpop(i,k+2) records the significance level. 

if ~isempty(exclusion)
    A(:,exclusion)=0;
end

[~,n]=size(A);

popsize=100*(floor(n/100)); % the number of individual in one population
nger=1000; % maximal number of iterations, can be adjusted by users

object_value=zeros(1,nger);
pop=zeros(popsize*2,k+2); % population matrix, every row record an individual

% Generate initial population
for i=1:popsize*2
    temp=randperm(n);
    pop(i,1:k)=temp(1:k);
    pop(i,k+1)=fit_A(A,pop(i,1:k));
end
[~,I]=sort(pop(:,k+1),'descend');
pop=pop(I,:);  % sort the population in descending order

R=0; % record whether current optimal solution is trapped in one local optimal solution
i=1;
while(R<10 && i<=nger) % termination
    fit_vector=pop(:,k+1);
    temp_maxweight=max(fit_vector);
    j=1;
    while(j<=popsize)  % generate one new individual
        [index1 index2]=select_order_fitness(fit_vector);
        pop(popsize+j,1:k)=crossover(pop(index1,1:k),pop(index2,1:k),n); % crosscove
        pop(popsize+j,1:k)=mutation_SA(A,pop(popsize+j,1:k),n,1); % mutation
        pop(popsize+j,k+1)=fit_A(A,pop(popsize+j,1:k));
        j=j+1;
     end
    [~,I]=sort(pop(:,k+1),'descend');
    pop=pop(I,:);   % sort the population in descending order, the maximal n individual are transfered to next generation
    object_value(i)=pop(1,k+1);  
    
    
    %use local search to improve the current optimal solution when it is trapped in one local optimal solution
    if R==2
        temp=sort(unique(pop(:,k+1)),'Descend');
        index=find(pop(:,k+1)>=temp(1));
        for j=1:min(length(index),1)
            pop(index(j),1:k)=mutation_SA(A,pop(index(j),1:k),n,sqrt(n));
            pop(index(j),k+1)=fit_A(A,pop(index(j),1:k));
        end
    end
    
    if R==5
        temp=sort(unique(pop(:,k+1)),'Descend');
        index=find(pop(:,k+1)>=temp(1));
        for j=1:min(length(index),1)
            pop(index(j),1:k)=mutation_SA(A,pop(index(j),1:k),n,n);
            pop(index(j),k+1)=fit_A(A,pop(index(j),1:k));
        end
    end
    
    maxweight=max(pop(:,k+1));

    if maxweight==temp_maxweight
        R=R+1;
    else
        R=0;
    end
    
    i=i+1;
end
[~,I]=sort(pop(:,k+1),'descend');
pop=pop(I,:);
maxpop=pop(1:popsize,:);

%delete the repetitive solution
[m,~]=size(maxpop);
i=1;
while(i<m)
    index=zeros(1,m);
    for j=i+1:m
        if all(maxpop(j,:)==maxpop(i,:))
            index(j)=1;
        end
    end
    index=logical(index);
    maxpop(index,:)=[];
    [m,~]=size(maxpop);
    i=i+1;
end

%significance test
[m,~]=size(maxpop);
for i=1:m
    maxpop(i,k+2)=significance_A(A,maxpop(i,1:k));
end


%% The funcitons used in the above main function
function f=fit_A(A,x)        % fitness calculation function
[~,n]=size(A);
temp=zeros(1,n);
temp(x)=1;
x=temp;
index = x==1;
A_index=A(:,index);
A_index_sum=sum(A_index,2);
f=(2*sum(A_index_sum>0)-sum(A_index_sum));


function [index1 index2]=select_order_fitness(fit_vector)   % select two individuals based on rank fitness
n=length(fit_vector);
[~,I]=sort(fit_vector);
p=zeros(1,n);
for i=1:n
    p(I(i))=2*i/(n*(n+1));
end
pp=cumsum(p); 
random_data=rand(1,1);
temp=find(pp>=random_data);
index1=temp(1);
random_data=rand(1,1);
temp=find(pp>=random_data);
index2=temp(1);


function newpop=crossover(parent1,parent2,n)   % crossover function
temp=zeros(1,n);
temp(parent1)=1;
parent1=temp;
temp=zeros(1,n);
temp(parent2)=1;
parent2=temp;
k=sum(parent1);
newpop=zeros(1,n);
index=(parent1+parent2==2);
newpop(index)=1;
parent1(index)=0;
parent2(index)=0;
temp=find(parent1+parent2==1);
index=randperm(sum(parent1+parent2==1));
newpop(temp(index(1:(k-sum(newpop)))))=1;
newpop=find(newpop==1);


function m_x=mutation(x,n)             % mutation function
temp=zeros(1,n);
temp(x)=1;
x=temp;
k=sum(x);
index1=randi(n,1);
while(x(index1)==1)
    index1=randi(n,1);
end
x_nonzero=find(x==1);
index2=x_nonzero(randi(k,1));
m_x=x;
m_x(index1)=1;
m_x(index2)=0;
m_x=find(m_x==1);


function m_x=mutation_SA(A,pop_i,n,N)  % local search
for i=1:N
    pop_j=mutation(pop_i,n);
    if fit_A(A,pop_j)>=fit_A(A,pop_i)
        pop_i=pop_j;
    end
end
m_x=pop_i;


function p=significance_A(A,subset)   % significance test function
[m,~]=size(A);
w=zeros(1,1000);
n=length(subset);
for j=1:100
    A_temp=A;
    A_temp(:,subset)=0;
    for i=1:n
        temp=sum(A(:,subset(i)));
        index = randperm(m,temp);
        A_temp(index,subset(i))=1;
    end
    w(j)=fit_A(A_temp,subset);
end
p=sum(w>=fit_A(A,subset))/1000;

