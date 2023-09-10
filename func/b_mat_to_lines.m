function [lines] = b_mat_to_lines(label_mat)
% Written by Doyeon Kim @ Jul. 2022
% IEEE Trans. on Information Theory
[i,j,k] = find(label_mat);
lineNum = length(i);
lines = zeros(lineNum,3);
lines(:,1) = i;
lines(:,2) = j;
lines(:,3) = k;
end

