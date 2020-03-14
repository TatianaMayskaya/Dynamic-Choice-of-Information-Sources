function EV = W (u, k, q, eta0, eta)
% Expected payoff from a jump from source k
% Input:
%   u: payoff matrix, 4 x number of actions
%   k: source (1 or 2)
%   q: fixed coordinate (q2 if k=1, q1 if k=2), n x m matrix
%   eta0\in{0,1}, eta\in{0,1}: space parameters, 
%                              eta=eta2 if k=1, eta=eta1 if k=2
% Output:
%   EV=W_k(q,eta0,eta): expected payoff from a jump from source k, 
%                       n x m matrix
u = shiftdim(u,-1); % now size(u)=1x4x(number of actions)
if k==1
    uu = u(1,ind(1,0),:);
else
    uu = u(1,ind(0,1),:);
end
R = korn (ones(size(q)), max(u(1,ind(1,1),:)) - u(1,ind(1,1),:) - 1);
UU = kron (ones(size(q)), uu); Q = kron (q, ones(size(uu)));
f = -R./Q - log(Q);  f(R>Q) = -log(R(R>Q)) - 1;  f = f + UU;
B = q./(1+q).*(max(f,3)+log(q)+(max(u(1,ind(1,1),:))-1)./q);
EV = (1+eta0+eta) * B - eta0 * max(uu) - eta * max(u(1,ind(1,1),:));
end