function F = f(u, k, q)
% Function f_k(q,a) used to calculate the expected payoff when theta_k=1
% Input:
%   u: payoff matrix, 4 x number of actions
%   k: source (1 or 2)
%   q: state variable, equal to Prob(theta_{3-k}=0)/Prob(theta_{3-k}=1)
%      (q2 if k=1, q1 if k=2), n x m matrix
% Output:
%   F=f_k(q,a): n x m x (number of actions)
%               (calculated for each action)
u = shiftdim(u,-1); % now size(u)=1x4x(number of actions)
if k==1
    uu = u(1,ind(1,0),:);
else
    uu = u(1,ind(0,1),:);
end
R = korn (ones(size(q)), max(u(1,ind(1,1),:)) - u(1,ind(1,1),:) - 1);
UU = kron (ones(size(q)), uu); Q = kron (q, ones(size(uu)));
F = -R./Q - log(Q);  F(R>Q) = -log(R(R>Q)) - 1;  F = F + UU;
end