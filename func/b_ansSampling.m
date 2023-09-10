function [label] = b_ansSampling(A,sampledHIT)
% Written by Doyeon Kim @ Jul. 2022
% IEEE Trans. on Information Theory
% Sample answer data

m = size(A,1);
n = size(A,2);
numSample = length(sampledHIT);

label = zeros(m,n,numSample);

for ii = 1:numSample
    if ii == 1
        nTask = sampledHIT(1,ii);
    else
        nTask = sampledHIT(1,ii) - sampledHIT(1,ii-1);
    end    
    for jj = 1:n
        cIdx = find(A(:,jj)~=0);
        if ii == 1            
            tIdx = datasample(cIdx,nTask,'replace',false);
            label(tIdx,jj,ii) = A(tIdx,jj);
        else
            tmp = setdiff(cIdx,find(label(:,jj,ii-1)~=0));
            tIdx = datasample(tmp,nTask,'replace',false);
            label(:,jj,ii) = label(:,jj,ii-1);
            label(tIdx,jj,ii) = A(tIdx,jj);
        end        
    end
end


end

