function [tasks_mv] = d_mv_real(labels)
% Written by Doyeon Kim @ Jul. 2022
% IEEE Trans. on Information Theory
% Majority Voting
fprintf('Majority Voting\n')
m = size(labels,1);
n = size(labels,2);
tmp_label = zeros(m,n);
for i = 1:m
    for j = 1:n
        if labels(i,j) == 2
            tmp_label(i,j) = 1;
        elseif labels(i,j) == 1
            tmp_label(i,j) = -1;
        end
    end
end

tasks_mv = zeros(m,1);

for i = 1:m
    answers = tmp_label(i,:);
    tmpMV = sum(answers);
    if tmpMV > 0
        tasks_mv(i,1) = 2;
    elseif tmpMV < 0
        tasks_mv(i,1) = 1;
    else
        tasks_mv(i,1) = 1+(rand<0.5);
    end
end
end

