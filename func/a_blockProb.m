function [blockProb,wTypes,Q] = a_blockProb(A,gt,tTypes,d)
% Written by Doyeon Kim @ Jul. 2022
% IEEE Trans. on Information Theory
% return empirical probabilities for each type

n = size(A,2);
blockProb = zeros(d,n);
wTypes = zeros(n,1);
Q = zeros(d,d);

for i = 1:n
    totalAnsIdx = find(A(:,i)~=0);
    for j = 1:d
        ansIdx = intersect(find(tTypes==j), totalAnsIdx);
        if length(ansIdx) == 0
            continue
        else
            blockProb(j,i) = mean(gt(ansIdx,1) == A(ansIdx,i));
        end
    end
    tmpMax = max(blockProb(:,i));
    maxIdx = find(blockProb(:,i) == tmpMax);
    if length(maxIdx) == 1
        wTypes(i,1) = maxIdx;
    elseif length(maxIdx) == 0
        wTypes(i,1) = datasample(1:d,1);
    else
        wTypes(i,1) = datasample(maxIdx,1);
    end
end

for ii = 1:d
    wIdx = find(wTypes == ii)';
    Q(:,ii) = mean(blockProb(:,wIdx),2);
end

end

