function [cWorkers] = c_clustering_sdp(S,d,eta)
% Written by Doyeon Kim @ Jul. 2022
% IEEE Trans. on Information Theory
% Stage #1: SDP clustering

n = size(S,2);
J = ones(n);

A = S'*S;
A = A - diag(diag(A));
cvx_begin quiet sdp
    variable X(n,n) symmetric
    maximize trace( (A-eta*J)*X )
    subject to
    X == semidefinite(n)
    trace(X) == n
    0 <= X(:) <= 1    
cvx_end
cWorkers = kmedoids(X,d);

end

