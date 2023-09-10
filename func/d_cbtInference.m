function [tasks_alg2,tasks_alg3,tasks_alg3_ss,typeHat] = d_cbtInference(A,cWorkers_sdp,d,l,tEstTypes)
% Written by Doyeon Kim @ Jul. 2022
% IEEE Trans. on Information Theory
% Stage #2 of Algorithm 1: inference algorithm 

fprintf('------- Proposed Algorithms ------- \n')
m = size(A,1);
ansSum = zeros(m,d,length(l));
tasks_assign = cell(m,d,length(l));
typeHat = zeros(m,length(l));
tasks_alg2 = zeros(m,length(l));
tasks_alg3 = zeros(m,length(l));
tasks_alg3_ss = zeros(m,length(l));
theta_hat = zeros(d,d,length(l));
ansForDelta = cell(d,d,length(l));
meanAnsFromCluster = zeros(d,d,length(l));
stdAnsFromCluster = zeros(d,d,length(l));


for ii = 1:m
    candIdx = find(A(ii,:)~=0);
    tEstType = tEstTypes(ii,1);
    for jj = 1:length(l)
        for kk = 1:d
            if jj == 1
                matchedIdx = find(cWorkers_sdp == kk)';
                tmpIdx = intersect(candIdx,matchedIdx);
            else
                tmpIdx = tasks_assign{ii,kk,jj-1};
            end
            if length(tmpIdx) >= l(jj)
                tasks_assign{ii,kk,jj} = datasample(tmpIdx,l(jj),'replace',false);
            else
                if length(tmpIdx) == 0
                    tasks_assign{ii,kk,jj} = [];
                else
%                     tasks_assign{ii,kk,jj} = tmpIdx;
                    tasks_assign{ii,kk,jj} = datasample(tmpIdx,l(jj));
                end
            end
            ansSum(ii,kk,jj) = sum(A(ii,tasks_assign{ii,kk,jj}));
            ansForDelta{tEstType,kk,jj} = [ansForDelta{tEstType,kk,jj} abs(ansSum(ii,kk,jj))];
        end
        % type matching (alg3)
        [tmpMax_alg3,tmpIdx_alg3] = max(abs(ansSum(ii,:,jj)));
        maxIdx_alg3 = find(tmpMax_alg3 == abs(ansSum(ii,:,jj)));
        if length(maxIdx_alg3) == 1
            typeHat(ii,jj) = tmpIdx_alg3;
        elseif length(maxIdx_alg3) == 0
            typeHat(ii,jj) = datasample(1:d,1);
        else
            typeHat(ii,jj) = datasample(maxIdx_alg3,1);
        end
        % task inference (alg3)
        notMaxIdx = find(1:d ~= typeHat(ii,jj));
        sum_alg3 = sum(ansSum(ii,typeHat(ii,jj),jj)) + (1/sqrt(d-1)) * sum(ansSum(ii,notMaxIdx,jj));
        if sum_alg3 > 0
            tasks_alg3(ii,jj) = 1;
        elseif sum_alg3 < 0
            tasks_alg3(ii,jj) = -1;
        else
            tasks_alg3(ii,jj) = 2*(rand<0.5)-1;
        end
        % task inference (sdp-ss)
        sum_alg3_ss = ansSum(ii,typeHat(ii,jj),jj);
        if sum_alg3_ss > 0
            tasks_alg3_ss(ii,jj) = 1;
        elseif sum_alg3_ss < 0
            tasks_alg3_ss(ii,jj) = -1;
        else
            tasks_alg3_ss(ii,jj) = 2*(rand<0.5)-1;
        end
    end    
end

for ii = 1:d    
    for jj = 1:d
        for kk = 1:length(l)
            meanAnsFromCluster(ii,jj,kk) = mean(ansForDelta{ii,jj,kk});
            stdAnsFromCluster(ii,jj,kk) = std(ansForDelta{ii,jj,kk});
        end
    end
end

for ii = 1:d
    for kk = 1:length(l)
        [maxVal,maxIdx] = max(meanAnsFromCluster(ii,:,kk));
        for jj = 1:d            
            if meanAnsFromCluster(ii,jj,kk) >= (maxVal - stdAnsFromCluster(ii,jj,kk)/sqrt(l(kk)))
                theta_hat(ii,jj,kk) = 1;
            end
        end
    end
end

for ii = 1:m
    taskEstType = tEstTypes(ii,1);
    for jj = 1:length(l)
        sum_alg2 = sum(ansSum(ii,:,jj) .* theta_hat(taskEstType,:,jj));        
        if sum_alg2 > 0 
            tasks_alg2(ii,jj) = 1;
        elseif sum_alg2 < 0 
            tasks_alg2(ii,jj) = -1;
        else
            tasks_alg2(ii,jj) = 2*(rand<0.5)-1;
        end
    end
end

end