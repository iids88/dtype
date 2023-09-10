function [Q] = b_relMatrix_v1(pmin,qmax,d)
% Written by Doyeon Kim @ Jul. 2022
% IEEE Trans. on Information Theory
% Construct a worker reliability matrix Q

Q = zeros(d,d);
for i = 1:d
    for j = 1:d
        if i == j
            Q(i,j) = pmin+(1-pmin)*rand;
        else
            Q(i,j) = 0.5+(qmax-0.5)*rand;
        end        
    end
end

end

