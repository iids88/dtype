function [newLabel] = b_truncAns(label,iIdx,minAnsNum,d)
% Written by Doyeon Kim @ Jul. 2022
% IEEE Trans. on Information Theory

newIdx = find(iIdx == 1);
m = length(newIdx);
n = size(label,2);
newLabel = zeros(m,n);

for ii = 1:length(newIdx)
    tmp = find(label(newIdx(ii),:)~=0);
    cIdx = datasample(tmp,d*minAnsNum(newIdx(ii)),'replace',false);
    newLabel(ii,cIdx) = label(newIdx(ii),cIdx);
end

end

