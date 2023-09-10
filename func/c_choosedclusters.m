function [cWorkers_d,wIdx] = c_choosedclusters(cWorkers,d)
% Written by Doyeon Kim @ Jul. 2022
% IEEE Trans. on Information Theory
% choose d clusters 

numClusters = length(unique(cWorkers));
clustSize = zeros(1,numClusters);
workerIdx = cell(1,numClusters);

for j = 1:numClusters
    clustSize(1,j) = length(find(cWorkers == j));
    workerIdx{1,j} = find(cWorkers == j);
end

[~,idx] = sort(clustSize, 'descend');

for j = 1:d
    if j == 1
        wIdx = workerIdx{1,idx(j)};
        cWorkers_d = j * ones(length(wIdx),1);
    else
        tmp = workerIdx{1,idx(j)};
        cWorkers_d = [cWorkers_d; j * ones(length(tmp),1)];
        wIdx = [wIdx; tmp];
    end
end

end
