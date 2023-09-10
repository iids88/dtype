function [pm,pu] = a_pmpu(phiQ)
% Written by Doyeon Kim @ Jul. 2022
% IEEE Trans. on Information Theory
% pm, pu
pm = phiQ(1,1);
pu = phiQ(1,2);
d = size(phiQ,1);
for ii = 1:d
    for jj = 1:d        
        if ii == jj
            if pm > phiQ(ii,jj)
                pm = phiQ(ii,jj);
            end
        else
            if pu < phiQ(ii,jj)
                pu = phiQ(ii,jj);
            end
        end
    end
end

end
