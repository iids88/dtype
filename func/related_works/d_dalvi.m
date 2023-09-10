function [tasks,wRel] = d_dalvi(A,m,n)

fprintf('Ratio of Eigenvalue \n')
k = 2;
t = zeros(m,k-1);

for l = 1:k-1
    O = zeros(m,n);
    for i = 1:size(A,1)
        O(A(i,1),A(i,2)) = 2*(A(i,3) > l)-1;
    end
    G = abs(O);
    
    % ========== algorithm 1 =============
    [U S V] = svd(O'*O);
    v1 = U(:,1);
    [U S V] = svd(G'*G);
    v2 = U(:,1);
    v1 = v1./v2;
    u = O*v1;
    % ========== algorithm 2 =============
%     R1 = (O'*O)./(G'*G+10^-8);
%     R2 = (G'*G > 0)+1-1;
%     [U S V] = svd(R1);
%     v1 = U(:,1);
%     [U S V] = svd(R2);
%     v2 = U(:,1);
%     v1 = v1./v2;
%     u = O*v1;
        
    if u'*sum(O,2) >= 0
        t(:,l) = sign(u);
    else
        t(:,l) = -sign(u);
    end
end

J = ones(m,1)*k;
for j = 1:m
    for l = 1:k-1
        if t(j,l) == -1
            J(j) = l;
            break;
        end
    end
end
tasks = J;
wRel = abs(v1/max(abs(v1)));


end


