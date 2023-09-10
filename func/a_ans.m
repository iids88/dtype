function [A] = a_ans(N)
% Written by Doyeon Kim @ Jul. 2022
% IEEE Trans. on Information Theory
% return true values of each task 

numLines = size(N,1);

for ii = 1:numLines
    task = N{ii,1};
    worker = N{ii,2};
    answer = N{ii,3};
    A(task,worker) = answer;
end


end


