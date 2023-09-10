function [types] = a_typeGen(num,d,priorDis,typeCase)
% Written by Doyeon Kim @ Jul. 2022
% IEEE Trans. on Information Theory
% Return type vector

types = zeros(num,1);
for ii = 1:num
    if typeCase == "bal"
        types(ii,1) = floor((ii-1)/(num/d))+1;
    else        
        for jj = 1:d
            if rand < priorDis(jj)
                types(ii,1) = jj;
                break
            else
                continue
            end
        end
    end
end
types = sort(types);

end