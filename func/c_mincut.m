function [cEdge] = c_mincut(A,cWorkers)
% Written by Doyeon Kim @ Jul. 2022
% IEEE Trans. on Information Theory
% min cut

n = size(A,1);
d = length(unique(cWorkers));
cEdge = 0;
cut = zeros(1,d);

% cut
for ii = 1:d
    idx = find(cWorkers == ii);
    notIdx = find(cWorkers ~= ii);
    tmp = 0;
    for jj = 1:length(idx)
        for kk = 1:length(notIdx)
            tmp = tmp + (0.5)*A(idx(jj),notIdx(kk));
        end
    end
    cut(1,ii) = tmp;
end

for ii = 1:d
    cEdge = cEdge + cut(1,ii);
end

end

