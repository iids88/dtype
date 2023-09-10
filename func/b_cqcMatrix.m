function [pi_Q] = b_cqcMatrix(Q,d)
% Written by Doyeon Kim @ Jul. 2022
% IEEE Trans. on Information Theory
% Collective quality correlation matrix

pi_Q = zeros(d,d);

for a = 1:d
    for b = 1:d
        for t = 1:d
            pi_Q(a,b) = pi_Q(a,b) + (1/d) * (2*Q(t,a)-1) * (2*Q(t,b)-1);
        end
    end
end


end

