%% Specialization Model with Real Data (athlete, netflix)
clear all; close all; clc;
addpath(genpath(pwd));

%% data processing
% get data
GT = readtable('gt_athlete.csv'); % use 'gt_netflix.csv' for neflix data
ANS = readtable('ans_athlete.csv'); % use 'ans_netflix.csv' for netflix data
savename = 'athlete'; % replace it with 'netflix'

% preparations
m = 500; n = 50; d = 4; HIT = 400;
sampledHIT = 0.1*HIT*[4 5 6 7 8];
iter = 30;

GT_cell = table2cell(GT);
ANS_cell = table2cell(ANS);

[truth,tTypes] = a_gt(GT_cell,savename);
prior_tTypes = a_types_prior(tTypes);
[A] = a_ans(ANS_cell);

[blockProb,wTypes,empQ] = a_blockProb(A,truth,tTypes,d);
phiQ = a_cqcMatrix(empQ,d,prior_tTypes);
[pm,pu] = a_pmpu(phiQ);

numSamples = length(sampledHIT);
theta_hat = zeros(d,d,numSamples,iter);

%% Error rate
err_ss = zeros(numSamples,iter);
err_sdp_ss = zeros(numSamples,iter);
err_alg2 = zeros(numSamples,iter);
err_alg3 = zeros(numSamples,iter);
err_type_sdp = zeros(numSamples,iter);
err_type_ss = zeros(numSamples,iter);
err_clust_ss = zeros(numSamples,iter);
err_clust_sdp = zeros(numSamples,iter);

%% Simulation
tStart = tic;
for ii = 1:iter
    fprintf('========== %d-th itertation is implemented ==========\n',ii)
    %% data matrix
    label = b_ansSampling(A,sampledHIT);
    for jj = 1:numSamples
        fprintf('======= %d-th Hit =======\n',jj)
        %% Proposed Algorithms (Stage 1)
        [cWorkers_ss,zeta] = c_clustering_ss_tuning(label(:,:,jj),d);
        cWorkers_ss_perm = c_permutation(cWorkers_ss,wTypes,d);
        [cWorkers_sdp,nu] = c_clustering_sdp_tuning(label(:,:,jj),d);
        cWorkers_sdp_perm = c_permutation(cWorkers_sdp,wTypes,d);
        %% Clustering Error Calculation
        err_clust_sdp(jj,ii) = mean(cWorkers_sdp_perm~=wTypes);
        err_clust_ss(jj,ii) = mean(cWorkers_ss_perm~=wTypes);
        %% Proposed Algorithms (Stage 2)
        [tasks_ss,tasks_sdp_ss,tasks_alg3,tasks_alg2,type_sdp,type_ss,theta_hat(:,:,jj,ii),iIdx_sdp,minAnsNum] = ...
            d_clust_inference(label(:,:,jj),cWorkers_sdp_perm,cWorkers_ss_perm,d,tTypes);
        checkIdx_sdp = find(iIdx_sdp==1);
        err_ss(jj,ii) = mean(truth(checkIdx_sdp,1) ~= tasks_ss(checkIdx_sdp,1));
        err_sdp_ss(jj,ii) = mean(truth(checkIdx_sdp,1) ~= tasks_sdp_ss(checkIdx_sdp,1));
        err_alg2(jj,ii) = mean(truth(checkIdx_sdp,1) ~= tasks_alg2(checkIdx_sdp,1));
        err_alg3(jj,ii) = mean(truth(checkIdx_sdp,1) ~= tasks_alg3(checkIdx_sdp,1));
        err_type_sdp(jj,ii) = mean(tTypes(checkIdx_sdp,1) ~= type_sdp(checkIdx_sdp,1));
        err_type_ss(jj,ii) = mean(tTypes(checkIdx_sdp,1) ~= type_ss(checkIdx_sdp,1));
    end
end
tEnd = toc(tStart);
