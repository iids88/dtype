function [cWorkers,numClusters] = c_clustering_ss(S,xi)
% Written by Doyeon Kim @ Jul. 2022
% IEEE Trans. on Information Theory
% Stage #1: Clustering workers by the subset-selection algorithm

r = size(S,1);
n = size(S,2);

cWorkers = zeros(n,1);
nClusters = 0;

for j = 1:n
    if j == 1
        cWorkers(j,1) = 1;
        nClusters = 1;
    else
        for k = 1:nClusters
            a = 0;
            sIdx_workers = find(cWorkers(:,1) == k);
            nwic = length(sIdx_workers);
            for t = 1:nwic
                if length(find(S(:,sIdx_workers(t)) == S(:,j))) > r * xi
                    a = a+1;
                    continue
                else
                    break
                end
            end
            if a == nwic
                cWorkers(j,1) = k;
                break
            elseif k ~= nClusters
                continue
            else
                cWorkers(j,1) = nClusters+1;
                nClusters = nClusters+1;
            end
        end
    end
end

numClusters = length(unique(cWorkers));

end

