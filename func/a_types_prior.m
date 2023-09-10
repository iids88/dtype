function [prior] = a_types_prior(tTypes)
% Written by Doyeon Kim @ Jul. 2022
% IEEE Trans. on Information Theory
% return types of tasks

d = length(unique(tTypes));
prior = zeros(d,1);

for ii = 1:d
    tmp = length(find(tTypes == ii));
    prior(ii,1) = tmp;
end

prior = prior / sum(prior);

for ii = 1:d
    if ii == 1
        continue
    else
        prior(ii,1) = prior(ii-1,1) + prior(ii,1);
    end 
end

end