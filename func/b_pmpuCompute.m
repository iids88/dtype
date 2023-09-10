function [pm,pu] = b_pmpuCompute(phiQ,d)
% Written by Doyeon Kim @ Jul. 2022
% IEEE Trans. on Information Theory
% pm: the minimum intra-cluster collective quality correlation
% pu: the maximum inter-cluster collective quality correlation

pm = intmax;
pu = 0;

for a = 1:d
    for b = 1:d
        if (a==b) && (phiQ(a,b) < pm)
            pm = phiQ(a,b);
        elseif (a~=b) && (phiQ(a,b) > pu)
            pu = phiQ(a,b);
        end
    end
end

end

