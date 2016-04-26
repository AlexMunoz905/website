function max_geneset=LP_matlab(A,k,exclusion)
%
% This function uses the MATLAB interface of CPLEX to solve the Binary Linear Program (BLP) problem. 
% Before running this funciton, please make sure you have installed CPLEX software in your computer.
%
% A : m (sample) x n (genes) mutation matrix
%
% k : number of desired genes 
%
% exclusion : the genes which are to be excluded from the results
%
% max_geneset : output vector with k+2 column;
%               it records the information of the optimal solution; 
%               max_geneset(1:k) records the selected genes;
%               max_geneset(k+1) records the weight of this gene set;
%               max_geneset(k+2) records the significance level. 
%

if ~isempty(exclusion)
    A(:,exclusion)=0;
end
[m n]=size(A);

f=zeros(m+n,1);   % Vector containing the coefficients of the linear objective function
f(1:m)=-2;
f(m+1:m+n)=sum(A);

B=zeros(m,m+n);   % Matrix containing the coefficients of the linear inequality constraints
B(:,1:m)=diag(ones(1,m));
B(:,m+1:m+n)=-A;
b=zeros(m,1);     % Vector corresponding to the right-hand side of the linear inequality constraints
Aeq=zeros(1,m+n); % Matrix containing the coefficients of the linear equality constraints
Aeq(m+1:m+n)=1;
beq=k;            % Vector containing the constants of the linear equality constraints

[X maxweight]= cplexbilp(f,B,b,Aeq,beq) ;

max_geneset(1:k)=find(X(m+1:m+n)==1);
max_geneset(k+1)=-maxweight;
max_geneset(k+2)=significance_A(A,max_geneset(1:k));


function p=significance_A(A,subset)
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

