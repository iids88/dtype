function [output] = c_permutation(cWorkers, wTypes,d)
% Written by Doyeon Kim @ Jul. 2022
% IEEE Trans. on Information Theory
% To find a clustering output that gurantees the minimum clustering error.

permCandidates = perms(1:d);
numPerm = size(permCandidates,1);
clusteringErr = zeros(1, numPerm);
numWorkers = length(wTypes);

for i = 1:numPerm
    tmp = zeros(numWorkers,1);
    for j = 1:d
        tmpIdx = find(cWorkers == j);
        tmp(tmpIdx,1) = permCandidates(i,j);
    end
    clusteringErr(1,i) = mean(tmp ~= wTypes);
end
[~,minIdx] = min(clusteringErr);
output = zeros(numWorkers,1);
for j = 1:d
    wIdx = find(cWorkers == j);
    output(wIdx,1) = permCandidates(minIdx,j);
end

end

