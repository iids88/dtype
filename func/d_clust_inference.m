function [tasks_ss,tasks_sdp_ss,tasks_alg3,tasks_alg2,typeHat_sdp,typeHat_ss,theta_hat,inferIdx_sdp,minAnsNum_sdp] = d_clust_inference(label,cWorkers_sdp,cWorkers_ss,d,tTypes)
% Written by Doyeon Kim @ Jul. 2022
% IEEE Trans. on Information Theory
% task inference
fprintf('Proposed Algorithm \n')
m = size(label,1);
n = size(label,2);
tmp_label = zeros(m,n);
for ii = 1:m
    for jj = 1:n
        if label(ii,jj) == 2
            tmp_label(ii,jj) = 1;
        elseif label(ii,jj) == 1
            tmp_label(ii,jj) = -1;
        end
    end
end
tasks_ss = zeros(m,1);
tasks_sdp_ss = zeros(m,1);
tasks_alg3 = zeros(m,1);
tasks_alg2 = zeros(m,1);
typeHat_sdp  = zeros(m,1);
typeHat_ss = zeros(m,1);
theta_hat = zeros(d,d);
minL = 3;
canWorkers_sdp = cell(m,d);
canWorkersNum_sdp = zeros(m,d);
canWorkers_ss = cell(m,d);
canWorkersNum_ss = zeros(m,d);
d_ss = length(unique(cWorkers_ss));
inferIdx_sdp = zeros(m,1);
ansSum_sdp = zeros(m,d);
ansForTheta = cell(d,d);
minAnsNum_sdp = zeros(m,1);
ansSum_ss = zeros(m,d_ss);
meanAnsFromCluster = zeros(d,d);
stdAnsFromCluster = zeros(d,d);

for ii = 1:m
   answeredWorkers = find(label(ii,:)~=0);
   for jj = 1:d
       tmp = find(cWorkers_sdp == jj);
       canWorkers_sdp{ii,jj} = intersect(answeredWorkers,tmp);
       canWorkersNum_sdp(ii,jj) = length(canWorkers_sdp{ii,jj});
   end
   minAnsNum_sdp(ii,1) = min(canWorkersNum_sdp(ii,:));
   if minAnsNum_sdp(ii,1) >= minL
       inferIdx_sdp(ii,1) = 1;
   end
   for jj = 1:d_ss
       tmp = find(cWorkers_ss == jj);
       canWorkers_ss{ii,jj} = intersect(answeredWorkers,tmp);
       canWorkersNum_ss(ii,jj) = length(canWorkers_ss{ii,jj});
   end

end

for ii = 1:m
    if inferIdx_sdp(ii,1) == 0
        continue
    else
        tType = tTypes(ii,1);
        for jj = 1:d
            tmpIdx = datasample(canWorkers_sdp{ii,jj},minAnsNum_sdp(ii,1),'replace',false);
            ansSum_sdp(ii,jj) = sum(tmp_label(ii,tmpIdx));
            ansForTheta{tType,jj} = [ansForTheta{tType,jj} abs(ansSum_sdp(ii,jj))];
        end
        for jj = 1:d_ss
            if canWorkersNum_ss(ii,jj) >= minAnsNum_sdp(ii,1)
                tmpIdx = datasample(canWorkers_ss{ii,jj},minAnsNum_sdp(ii,1),'replace',false);
                ansSum_ss(ii,jj) = sum(tmp_label(ii,tmpIdx));
            end
        end
        % type matching (alg3)
        [tmpMax_sdp,tmpIdx_sdp] = max(abs(ansSum_sdp(ii,:)));
        maxIdx_sdp = find(tmpMax_sdp == abs(ansSum_sdp(ii,:)));
        if length(maxIdx_sdp) == 1
            typeHat_sdp(ii,1) = tmpIdx_sdp;
        elseif length(maxIdx_sdp) == 0
            typeHat_sdp(ii,1) = datasample(1:d,1);
        else
            typeHat_sdp(ii,1) = datasample(maxIdx_sdp,1);
        end
        % Type matching (ss)
        [tmpMax_ss,tmpIdx_ss] = max(abs(ansSum_ss(ii,:)));
        maxIdx_ss = find(tmpMax_ss == abs(ansSum_ss(ii,:)));
        if length(maxIdx_ss) == 1
            typeHat_ss(ii,1) = tmpIdx_ss;
        elseif length(maxIdx_ss) == 0
            typeHat_ss(ii,1) = datasample(1:d_ss,1);
        else
            typeHat_ss(ii,1) = datasample(maxIdx_ss,1);
        end
        % subset selection
        tmpSS = ansSum_ss(ii,typeHat_ss(ii,1));
        if tmpSS > 0
            tasks_ss(ii,1) = 2;
        elseif tmpSS < 0
            tasks_ss(ii,1) = 1;
        else
            tasks_ss(ii,1) = 1+(rand<0.5);
        end
        % Algorithm 3
        notMaxIdx = find(1:d ~= typeHat_sdp(ii,1));
        tmpAlg3 = sum(ansSum_sdp(ii,typeHat_sdp(ii,1))) + (1/sqrt(d-1)) * sum(ansSum_sdp(ii,notMaxIdx));
        if tmpAlg3 > 0
            tasks_alg3(ii,1) = 2;
        elseif tmpAlg3 < 0
            tasks_alg3(ii,1) = 1;
        else
            tasks_alg3(ii,1) = 1+(rand<0.5);
        end
        % SDP-SS
        tmpSDPSS = sum(ansSum_sdp(ii,typeHat_sdp(ii,1)));
        if tmpSDPSS > 0
            tasks_sdp_ss(ii,1) = 2;
        elseif tmpSDPSS < 0
            tasks_sdp_ss(ii,1) = 1;
        else
            tasks_sdp_ss(ii,1) = 1+(rand<0.5);
        end
    end    
end

% Algorithm 2
for ii = 1:d
    for jj = 1:d
        meanAnsFromCluster(ii,jj) = mean(ansForTheta{ii,jj});
        stdAnsFromCluster(ii,jj) = std(ansForTheta{ii,jj});
    end
end

for ii = 1:d
    [maxMean,~] = max(meanAnsFromCluster(ii,:));
    [minMean,~] = min(meanAnsFromCluster(ii,:));
    [maxStd,~] = max(stdAnsFromCluster(ii,:));
    for jj = 1:d
        if meanAnsFromCluster(ii,jj) >= (maxMean + minMean)/2
            theta_hat(ii,jj) = 1;
        end
    end
end

for ii = 1:m
    if inferIdx_sdp(ii,1) == 0
        continue
    else
        tType = tTypes(ii,1);
        sum_alg2 = sum(ansSum_sdp(ii,:) .* theta_hat(tType,:));
        if sum_alg2 > 0
            tasks_alg2(ii,1) = 2;
        elseif sum_alg2 < 0
            tasks_alg2(ii,1) = 1;
        else
            tasks_alg2(ii,1) = 1+(rand<0.5);
        end
    end
end

end