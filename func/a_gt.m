function [truth,tTypes] = a_gt(M,data)
% Written by Doyeon Kim @ Jul. 2022
% IEEE Trans. on Information Theory
% return true values of each task

m = size(M,1);
truth = zeros(m,1);
tTypes = zeros(m,1);
if isequal(data,'athlete')
    types = {'Football','Baseball','Soccer','Basketball'};
elseif isequal(data,'netflix')
    types = {'Action','Romance','Thriller','SF'};
end

for ii = 1:m
    truth(ii,1) = M{ii,1};
    for jj = 1:length(types)
        if isequal(M{ii,2},types{1,jj})
            tTypes(ii,1) = jj;
        end
    end
end

end


