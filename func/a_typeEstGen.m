function [types] = a_typeEstGen(tTypes,flipRatio)
% Written by Doyeon Kim @ Jul. 2022
% IEEE Trans. on Information Theory
% return type vector

m = size(tTypes,1);
d = length(unique(tTypes));
types = zeros(m,1);
for ii = 1:m
    tmp = rand;
    if tmp > flipRatio
        types(ii,1) = tTypes(ii,1);
    else
        candidateSet = setdiff((1:d),tTypes(ii,1));
        types(ii,1) = datasample(candidateSet,1);
    end
end

end