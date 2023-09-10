function [tasks] = a_taskGen(m, prior)
% Written by Doyeon Kim @ Jul. 2022
% IEEE Trans. on Information Theory
% Ground truth of tasks (task vector)

tasks = zeros(m,1);
for ii = 1:m
    tasks(ii,1) = 2 * (rand < prior) - 1; 
end

