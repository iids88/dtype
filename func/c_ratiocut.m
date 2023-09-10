function [rEdge] = c_ratiocut(A,cWorkers)
% Written by Doyeon Kim @ Jul. 2022
% IEEE Trans. on Information Theory
% ratio-cut

n = size(A,1);
d = length(unique(cWorkers));
rEdge = 0;
vol = zeros(1,d);
cut = zeros(1,d);

% volume
for ii = 1:d
    idx = find(cWorkers == ii);    
    vol(1,ii) = length(idx);
end

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
    rEdge = rEdge + cut(1,ii) / vol(1,ii);
end

end

