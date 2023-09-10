function [tasks,wRel] = d_KOS(A,m,n)

fprintf('KOS Method\n')
k = 2;
t = zeros(m,k-1);
for l = 1:k-1
    U = zeros(m,n);
    for i = 1:size(A,1)
        U(A(i,1),A(i,2)) = 2*(A(i,3) > l)-1;
    end
    
    B = U - ones(m,1)*(ones(1,m)*U)/m;
    [U S V] = svd(B);
    u = U(:,1);
    v = V(:,1);
    u = u / norm(u);
    v = v / norm(v);
    pos_index = find(v>=0);
    if sum(v(pos_index).^2) >= 1/2
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
wRel = abs(v/max(abs(v)));


end

