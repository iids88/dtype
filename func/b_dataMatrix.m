function [M] = b_dataMatrix(gt,uTypes,wTypes,Q)
% Written by Doyeon Kim @ Jul. 2022
% IEEE Trans. on Information Theory
% return data matrix depending on the reliability matrix which has a type
% structure

n = size(wTypes,1);
m = size(gt,1);
M = zeros(m,n);
for i = 1:m
    for j = 1:n
        M(i,j) = gt(i,1) * (2 * (rand < Q(uTypes(i,1), wTypes(j,1))) - 1);
    end        
end

end
