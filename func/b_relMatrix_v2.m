function [Q,phiQ,pm,pu] = b_relMatrix_v2(eps_gap,s_prob,s_ratio,d)
% Written by Doyeon Kim @ Jul. 2022
% IEEE Trans. on Information Theory
% Construct a worker reliability matrix Q (spammer/non-spammer)

phiQ = zeros(d,d);
pmpu_gap = 0.05;

while(1)
    Q = zeros(d,d);
    numHammer = round(d*s_ratio);
    numSpammer = d - numHammer;
    tmp = sum((eps_gap+s_prob+(1-s_prob-eps_gap)*rand(numHammer,1)).^2);
    const_one = 0;
    const_two = 0;
    const_thr = 0;
    for ii = 1:d
        spammerIdx = datasample((1:d)',numSpammer,'replace',false);
        hammerIdx = setdiff((1:d)',spammerIdx);
        tmpVec = (s_prob+eps_gap)+(1-s_prob-eps_gap)*rand(numHammer,1);
        tmpVecNorm = norm(tmpVec,2);
        tmpVec = tmpVec / tmpVecNorm * sqrt(tmp);
        Q(hammerIdx,ii) = tmpVec;
        Q(spammerIdx,ii) = 0.5*ones(numSpammer,1);
    end
    for ii = 1:d
        hammerIdx = find(Q(:,ii)~=0.5);
        if Q(ii,:) == 0.5*ones(1,d)
            const_one = 1;
        end
        if sum(Q(hammerIdx,ii)<(eps_gap+s_prob)) >= 1 || sum(Q(hammerIdx,ii)>1) >= 1
            const_thr = 1;
        end
    end
    phiQ = b_cqcMatrix(Q,d);
    [pm,pu] = b_pmpuCompute(phiQ,d);
    if pm < pu + pmpu_gap
        const_two = 1;
    end
    if (const_two == 0) && (const_one == 0) && (sum(sum(Q>=1))==0) && (const_thr == 0)
        break;
    end
end

end

