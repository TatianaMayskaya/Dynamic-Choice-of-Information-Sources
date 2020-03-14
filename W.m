function EV = W (u, k, q, eta0, eta, F)
% Expected payoff when theta_k=1
% Input:
%   u: payoff matrix, 4 x number of actions
%   k: source (1 or 2)
%   q: fixed coordinate (q2 if k=1, q1 if k=2), n x m matrix
%   eta0\in{0,-1}, eta\in{0,-1}: space parameters, 
%                              eta=eta2 if k=1, eta=eta1 if k=2
%   F=f(u, k, q)
% Output:
%   EV=W_k(q,eta0,eta): expected payoff when theta_k=1, n x m matrix
if k==1
    uu = u(ind(1,0),:);
else
    uu = u(ind(0,1),:);
end
B = q./(1+q).*(max(F,[],3)+log(q)+(max(u(ind(1,1),:))-1)./q);
EV = (1+eta0+eta) * B - eta0 * max(uu) - eta * max(u(ind(1,1),:));
end