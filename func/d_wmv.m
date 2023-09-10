function [tasks] = d_wmv(A,d,l,tTypes,wTypes,Q)
% Written by Doyeon Kim @ Jul. 2022
% IEEE Trans. on Information Theory
% Strong Oracle Estimator: reliability matrix; types of workers and tasks are all known

fprintf('------- Weighted Majority Voting -------\n')
m = size(A,1);
tasks = zeros(m,length(l));
tasks_assign = cell(m,length(l),d);

for ii = 1:m
    candIdx = find(A(ii,:)~=0);
    for jj = 1:length(l)
        tmpSum = 0;
        for kk = 1:d
            if jj == 1
                matchedIdx = find(wTypes == kk)';
                tmpIdx = intersect(candIdx,matchedIdx);
            else
                tmpIdx = tasks_assign{ii,jj-1,kk};
            end
            if length(tmpIdx) >= l(jj)
                tasks_assign{ii,jj,kk} = datasample(tmpIdx,l(jj),'replace',false);
            else
                if length(tmpIdx) == 0
                    tasks_assign{ii,jj,kk} = [];
                else
%                     tasks_assign{ii,jj,kk} = tmpIdx;
                    tasks_assign{ii,jj,kk} = datasample(tmpIdx,l(jj));
                end
            end
            opt_weight = log( Q(tTypes(ii,1),wTypes(tasks_assign{ii,jj,kk}',1)) ./ (1-Q(tTypes(ii,1),wTypes(tasks_assign{ii,jj,kk}',1))) );
            tmpSum = tmpSum + opt_weight * A(ii,tasks_assign{ii,jj,kk})';
        end
        if tmpSum > 0
            tasks(ii,jj) = 1;
        elseif tmpSum < 0
            tasks(ii,jj) = -1;
        else
            tasks(ii,jj) = 2*(rand<0.5)-1;
        end
    end


end


