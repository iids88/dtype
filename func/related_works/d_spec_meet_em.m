function [tasks,wRel] = d_spec_meet_em(A,m,n)
% Written By Doyeon Kim
% @ Dec 2020

fprintf('Spectral meet EM\n')

k = 2;
mode = 0;
Nround = 10;

Z = zeros(m,k,n);
for i = 1:size(A,1)
    Z(A(i,1),A(i,3),A(i,2)) = 1;
end


% method of moment
group = mod(1:n,3)+1;
Zg = zeros(m,k,3);
cfg = zeros(k,k,3);
for i = 1:3
    l = find(group == i);
    Zg(:,:,i) = sum(Z(:,:,l),3);
end

x1 = Zg(:,:,1)';
x2 = Zg(:,:,2)';
x3 = Zg(:,:,3)';

muWg = zeros(k,k+1,3);
muWg(:,:,1) = SolveCFG(x2,x3,x1);
muWg(:,:,2) = SolveCFG(x3,x1,x2);
muWg(:,:,3) = SolveCFG(x1,x2,x3);

mu = zeros(k,k,n);
for i = 1:n
    x = Z(:,:,i)';
    x_alt = sum(Zg,3)' - Zg(:,:,group(i))';
    muW_alt = (sum(muWg,3) - muWg(:,:,group(i)));
    mu(:,:,i) = (x*x_alt'/m) / (diag(muW_alt(:,k+1)/2)*muW_alt(:,1:k)');
    
    mu(:,:,i) = max( mu(:,:,i), 10^-6 );
    mu(:,:,i) = AggregateCFG(mu(:,:,i),mode);
    for j = 1:k
        mu(:,j,i) = mu(:,j,i) / sum(mu(:,j,i));
    end
end

% EM update
for iter = 1:Nround
    q = zeros(m,k);
    for j = 1:m
        for c = 1:k
            for i = 1:n
                if Z(j,:,i)*mu(:,c,i) > 0
                    q(j,c) = q(j,c) + log(Z(j,:,i)*mu(:,c,i));
                end
            end
        end
        q(j,:) = exp(q(j,:));
        q(j,:) = q(j,:) / sum(q(j,:));
    end

    for i = 1:n
        mu(:,:,i) = (Z(:,:,i))'*q;
        
        mu(:,:,i) = AggregateCFG(mu(:,:,i),mode);
        for c = 1:k
            mu(:,c,i) = mu(:,c,i)/sum(mu(:,c,i));
        end
    end

    [I J] = max(q');
end
tasks = J';
wRel = zeros(n,1);
for i = 1:n
    wRel(i,1) = (mu(1,1,i) + mu(2,2,i)) / 2;
end

end

