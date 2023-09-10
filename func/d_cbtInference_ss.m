function [tasks_ss,typeHat_ss] = d_cbtInference_ss(A,cWorkers_ss,idx_ss,d,l)
% Written by Doyeon Kim @ Jul. 2022
% IEEE Trans. on Information Theory
% Stage #2 of the subset-selection algorithm: inference algorithm 

fprintf('------- Subset Selection ------- \n')
m = size(A,1);
ansSum_ss = zeros(m,length(l),d);
typeHat_ss = zeros(m,length(l));
tasks_ss = zeros(m,length(l));
tasks_assign = cell(m,length(l),d);

for ii = 1:m
    candIdx = find(A(ii,:)~=0);
    for jj = 1:length(l)
        for kk = 1:d
            if jj == 1
                matchedIdx = find(cWorkers_ss == kk)';
                tmpIdx = intersect(candIdx,matchedIdx);
            else
                tmpIdx = tasks_assign{ii,jj-1,kk};
            end
            if length(tmpIdx) >= l(jj)
                tmp = datasample(tmpIdx,l(jj),'replace',false);
                if jj == 1                    
                    tasks_assign{ii,jj,kk} = idx_ss(tmp);
                else
                    tasks_assign{ii,jj,kk} = tmp;
                end
            else
                if length(tmpIdx) == 0
                    tasks_assign{ii,jj,kk} = [];
                else
%                     tmp = tmpIdx;
                    tmp = datasample(tmpIdx,l(jj));
                    if jj == 1
                        tasks_assign{ii,jj,kk} = idx_ss(tmp);
                    else
                        tasks_assign{ii,jj,kk} = tmp;
                    end
                end
            end
            ansSum_ss(ii,jj,kk) = sum(A(ii,tasks_assign{ii,jj,kk}));
        end
        % type matching (ss)
        [tmpMax_ss,tmpIdx_ss] = max(abs(ansSum_ss(ii,jj,:)));
        maxIdx_ss = find(tmpMax_ss == abs(ansSum_ss(ii,jj,:)));
        if length(maxIdx_ss) == 1
            typeHat_ss(ii,jj) = tmpIdx_ss;
        elseif length(maxIdx_ss) == 0
            typeHat_ss(ii,jj) = datasample(1:d,1);
        else
            typeHat_ss(ii,jj) = datasample(maxIdx_ss,1);
        end
        % task inference (ss)
        sum_ss = sum(ansSum_ss(ii,jj,typeHat_ss(ii,jj)));
        if sum_ss > 0
            tasks_ss(ii,jj) = 1;
        elseif sum_ss < 0
            tasks_ss(ii,jj) = -1;        
        else
            tasks_ss(ii,jj) = 2*(rand<0.5)-1;
        end
    end
end


end
