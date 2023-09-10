function [clusteredWorkers,nu] = c_clustering_sdp_tuning(S,d)
% Written by Doyeon Kim @ Jul. 2022
% IEEE Trans. on Information Theory
% SDP clustering with parameter tuning

fprintf('SDP tuning\n')

m = size(S,1);
n = size(S,2);
tmpS = zeros(m,n);

for i = 1:m
    for j = 1:n
        if S(i,j) == 2
            tmpS(i,j) = 1;
        elseif S(i,j) == 1
            tmpS(i,j) = -1;
        end
    end
end

l = length(find(S(:,1)~=0));

r = m*(l/m)*(l/m);

tuning = 0.10:0.005:0.25;
lambda = r * tuning;
A = tmpS'*tmpS;
A = A - diag(diag(A));
J = ones(n);
cWorkers = zeros(n,length(tuning));
crossEdge = zeros(1,length(tuning));

for i = 1:length(tuning)
    tmp = lambda(i);
    cvx_begin quiet sdp
    variable X(n,n) symmetric
    maximize trace( (A-tmp*J)*X ) 
    subject to
    X == semidefinite(n)
    trace(X) == n    
    0 <= X(:)
    1 >= X(:)
    cvx_end
    cWorkers(:,i) = kmedoids(X,d);
    crossEdge(1,i) = c_ncut(A,cWorkers(:,i));
end
[~,idx] = min(crossEdge);
clusteredWorkers = cWorkers(:,idx);
nu = tuning(idx);
end

