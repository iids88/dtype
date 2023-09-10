function [pi_Q] = a_cqcMatrix(Q,d,taskTypePrior)
% Written by Doyeon Kim @ Jul. 2022
% IEEE Trans. on Information Theory
% collective quality correlation matrix

pi_Q = zeros(d,d);

for a = 1:d
    for b = 1:d
        for t = 1:d
            if t == 1
                priorWeight = taskTypePrior(t);
            else
                priorWeight = taskTypePrior(t) - taskTypePrior(t-1);
            end
            pi_Q(a,b) = pi_Q(a,b) + priorWeight * (2*Q(t,a)-1) * (2*Q(t,b)-1);
        end
    end
end


end

