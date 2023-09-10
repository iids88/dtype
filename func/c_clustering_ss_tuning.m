function [cWorkers_mincut,zeta] = c_clustering_ss_tuning(S,d)
% Clustering workers by SL18 algorithm with hyper-parameter tuning
% Written by Doyeon Kim, @ Sep, 2021.

fprintf('SS tuning\n')


r = size(S,1);
n = size(S,2);
tmpS = zeros(r,n);
tuning = 0.2:0.001:0.7;
cWorkers = zeros(n,length(tuning));
crossEdge = zeros(1,length(tuning));
nClusters = 0;
candidates_tuning = [];

for i = 1:r
    for j = 1:n
        if S(i,j) == 2
            tmpS(i,j) = 1;
        elseif S(i,j) == 1
            tmpS(i,j) = -1;
        end
    end
end

A = tmpS'*tmpS;
A = A - diag(diag(A));


for i = 1:length(tuning)
    for j = 1:n
        tIdx1 = find(S(:,j) ~= 0);
        if j == 1
            cWorkers(j,i) = 1;
            nClusters = 1;
        else
            for k = 1:nClusters
                a = 0;
                sIdx_workers = find(cWorkers(:,i) == k);
                nwic = length(sIdx_workers);                
                for t = 1:nwic
                    tIdx2 = find(S(:,sIdx_workers(t))~=0);
                    tIdx = intersect(tIdx1,tIdx2);
                    if length(find(S(tIdx,sIdx_workers(t)) == S(tIdx,j))) > length(tIdx) * tuning(i)
                        a = a+1;
                        continue
                    else
                        break
                    end
                end
                if a == nwic
                    cWorkers(j,i) = k;
                    break
                elseif k ~= nClusters
                    continue
                else                    
                    cWorkers(j,i) = nClusters + 1;
                    nClusters = nClusters + 1;                 
                end
            end
        end        
    end   
end

for i = 1:length(tuning)
    tmp = length(unique(cWorkers(:,i)));
    if tmp == d
        [candidates_tuning] = [candidates_tuning i];
        crossEdge(1,i) = c_ncut(A,cWorkers(:,i));
    else
        crossEdge(1,i) = Inf;
    end
end


[~,idx]=min(crossEdge);
cWorkers_mincut = cWorkers(:,idx);
zeta = tuning(idx);



end

