% Written by Doyeon Kim @ Jul. 2022
% IEEE Trans. on Information Theory
% A worker/task d-type specialization model

clear all; close all; clc;
addpath(genpath(pwd));

%% System model: spammer/non-spammer
% parameter setting
m = 15000;  % # of tasks
n = 60;    % # of workers
d = 4;      % # of types
r = m*0.01*2;    % # of randomly chosen tasks for clustering in Stage #1
l = 6:-1:3;     % number of queries per clusters
iter = 20;

% Groundtruth of tasks
priorDis = 0.5; % prior distribution of task values
tasks = a_taskGen(m,priorDis);  % ground truth vectors, {-1,1}^{m}

% task and worker types
tTypes = a_typeGen(m,d,(1/d)*(1:d)',"bal");
wTypes = a_typeGen(n,d,(1/d)*(1:d)',"bal");
% type mismatching ratio: 0 when the type of tasks is fully known
typeMMRatio = 0.05*[0 2];
numMMRatio = length(typeMMRatio);

% Reliability matrix Q
eps_gap = [0.10 0.30];
numEps = length(eps_gap);
s_ratio = 0.50;
s_prob = 0.50;
Q = zeros(d,d,numEps);
% collective quality correlation matrix
phiQ = zeros(d,d,numEps);   
% minimum intra-cluster collective quality correlation,
% and the maximum inter-cluster collective quality correlation
pm = zeros(1,numEps);
pu = zeros(1,numEps);
% tuning parameters
eta = zeros(1,numEps);
xi = zeros(1,numEps);

for ii = 1:numEps
   [Q(:,:,ii),phiQ(:,:,ii),pm(1,ii),pu(1,ii)] = b_relMatrix_v2(eps_gap(ii),s_prob,s_ratio,d);
   eta(1,ii) = (1/2)*r*(pm(1,ii)+pu(1,ii));
   xi(1,ii) = (1/2)*(0.5*(1+pm(1,ii))+0.5*(1+pu(1,ii)));
end

% to store errors
err_clust_sdp = zeros(numEps,iter);
err_clust_ss = zeros(numEps,iter);
err_mv = zeros(numEps,length(l),iter);
err_wmv = zeros(numEps,length(l),iter);
err_ss = zeros(numEps,length(l),iter);
err_alg2 = zeros(numEps,numMMRatio,length(l),iter);
err_alg3 = zeros(numEps,length(l),iter);

% implementation
tStart = tic;
for ii = 1:numEps
    fprintf('------ (1) # of epsilon: %dth / %dth ------\n',ii,numEps)
    for num = 1:iter
        fprintf('------ (2) iterations: %dth / %dth iterations ------\n',num,iter)
        % ----------------- Task selection for clustering -----------------
        cTasks = datasample((1:m)',r,'replace',false);
        uTasks = setdiff((1:m)',cTasks);
        % ------------------------ Data matrix ------------------------
        A_clust = b_dataMatrix(tasks(cTasks,1),tTypes(cTasks,1),wTypes,Q(:,:,ii));
        A = b_dataMatrix(tasks(uTasks,1),tTypes(uTasks,1),wTypes,Q(:,:,ii));
        %%%%%%%%%%%% Task Inference with baseline algorithms %%%%%%%%%%%%%%
        % ---------------------- Majority voting --------------------------
        tasks_mv = d_mv(A,d,l);
        err_mv(ii,:,num) = mean(tasks(uTasks,1) ~= tasks_mv);
        % ------------------- Weighted majority voting --------------------
        tasks_wmv = d_wmv(A,d,l,tTypes(uTasks,1),wTypes,Q(:,:,ii));
        err_wmv(ii,:,num) = mean(tasks(uTasks,1) ~= tasks_wmv);
        % ------------------ Subset selection algorithm -------------------
        % ------------------------- 1.Clustering --------------------------
        [clusteredWorkers_ss,~] = c_clustering_ss(A_clust,xi(1,ii));
        [clusteredWorkers_d,idx_ss] = c_choosedclusters(clusteredWorkers_ss,d);
        cWorkers_ss_perm = c_permutation(clusteredWorkers_d,wTypes(idx_ss,1),d);
        err_clust_ss(ii,num) = mean(cWorkers_ss_perm ~= wTypes(idx_ss,1));
        % ----------------------- 2. Task inference -----------------------
        [tasks_ss,typeHat_ss] = d_cbtInference_ss(A,cWorkers_ss_perm,idx_ss,d,l);
        err_ss(ii,:,num) = mean(tasks(uTasks,1) ~= tasks_ss);
        %%%%%%%%%%%%%%%%%%%%%%%% Proposed algorithm %%%%%%%%%%%%%%%%%%%%%%%
        % ----------------------- 1. Clustering ---------------------------
        clusteredWorkers_sdp = c_clustering_sdp(A_clust,d,eta(1,ii));
        cWorkers_sdp_perm = c_permutation(clusteredWorkers_sdp,wTypes,d);
        err_clust_sdp(ii,num) = mean(cWorkers_sdp_perm ~= wTypes);
        % --------------------- 2. Task inference -------------------------
        for kk = 1:numMMRatio
            tEstTypes = a_typeEstGen(tTypes,typeMMRatio(kk));
            [tasks_alg2,tasks_alg3,tasks_alg3_ss,typeHat_alg3] = ...
                d_cbtInference(A,cWorkers_sdp_perm,d,l,tEstTypes(uTasks,1));
            err_alg2(ii,kk,:,num) = mean(tasks(uTasks,1) ~= tasks_alg2);
            if kk == 1
                err_alg3(ii,:,num) = mean(tasks(uTasks,1) ~= tasks_alg3);
            else
                continue
            end            
        end
    end
end
tEnd = toc(tStart);