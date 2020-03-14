function points = opt (u, q1, q2, xi, eta0, eta1, eta2)
% Find optimal strategy 
% Input:
%   u: payoff matrix, 4 x number of actions 
%   q1, q2: two n x m matrices that correspond to 2-D grid coordinates (all
%         rows of q1 are identical and correspond to x-axes, all
%         columns of q2 are identical and correspond to y-axes)
%   xi>=-1, eta0\in{0,-1}, eta1\in{0,-1}, eta2\in{0,-1}: space parameters
% Output:
%   points: n x m matrix that corresponds to the optimal strategy, each
%           element is either 0 (= no learning), or 1 (= use source 1), or
%           2 (= use source 2)
[points, EV] = opt_simple (u, q1./(1+q1), q2./(1+q2), [xi, eta0, eta1, eta2]);
solved = zeros(size(points));
solved(:,end) = 1; solved(end,:) = 1; lineLength = 0;
while sum(1-solved(:)) > 0
    [points, solved, EV] = opt_step(points,solved,EV,q1,q2,xi,eta0,eta1,eta2);
    fprintf(repmat('\b',1,lineLength));
    lineLength = fprintf('Progress bar: %3.1f/100%%',sum(solved(:))/length(solved(:))*100);
end
end

function [points, solved, EV] = opt_step (points, solved, EV, u, q1, q2, xi, eta0, eta1, eta2)
% Optimization step
% Input: 
%   points: current best strategy, n x m matrix
%   solved: indicator for points where the optimal strategy is found, n x m matrix
%   EV: expected payoff from strategy "points", n x m matrix
%   u: payoff matrix, 4 x number of actions 
%   q1, q2: two n x m matrices that correspond to 2-D grid coordinates (all
%         rows of q1 are identical and correspond to x-axes, all
%         columns of q2 are identical and correspond to y-axes)
%   xi>=-1, eta0\in{0,-1}, eta1\in{0,-1}, eta2\in{0,-1}: space parameters
% Output:
%   points, solved, EV: updated

q1_shift = q1(1:end-1,1:end-1); q2_shift = q2(1:end-1,1:end-1);

% index rule:
source1_opt = I(u,1,q2_shift,eta0,eta2) >= I(u,2,q1_shift,eta0,eta1); 
source2_opt = I(u,1,q2_shift,eta0,eta2) <  I(u,2,q1_shift,eta0,eta1);

% points for which optimal strategy is calculated at this optimization step
treated1 = (solved(1:end-1,1:end-1)==0) & source1_opt & (solved(1:end-1,2:end)==1);
treated2 = (solved(1:end-1,1:end-1)==0) & source2_opt & (solved(2:end,1:end-1)==1);
solved_shift = solved(1:end-1,1:end-1); solved_shift(treated1|treated2) = 1; 
solved(1:end-1,1:end-1) = solved_shift;

% optimization
bq1 = q1(1:end-1,2:end); bq2 = q2(2:end,1:end-1);
bV1 = EV(1:end-1,2:end); bV2 = EV(2:end,1:end-1); 
V1 = V_cont(u,1,bq1,bV1,q1_shift,q2_shift,xi,eta0,eta1,eta2);
V2 = V_cont(u,2,bq2,bV2,q1_shift,q2_shift,xi,eta0,eta1,eta2);
Vbase = EV(1:end-1,1:end-1); 
j1 = treated1 & (V1>Vbase);
j2 = treated2 & (V2>Vbase);

% points and EV update
EV_shift = Vbase; points_shift = points(1:end-1,1:end-1);
EV_shift(j1) = V1(j1); points_shift(j1) = 1;
EV_shift(j2) = V2(j2); points_shift(j2) = 2;
EV(1:end-1,1:end-1) = EV_shift; points(1:end-1,1:end-1) = points_shift;
end

function res = I (u, k, q, eta0, eta)
% Index of source k
% Input:
%   u: payoff matrix, 4 x number of actions
%   k: source (1 or 2)
%   q: fixed coordinate (q2 if k=1, q1 if k=2), n x m matrix
%   eta0\in{0,-1}, eta\in{0,-1}: space parameters, 
%                              eta=eta2 if k=1, eta=eta1 if k=2
% Output:
%   res=I_k(q)=(1+eta)*q-(1+eta0)*R(a_k((1+eta)*q)): n x m matrix
if eta == -1
    res = 1+eta0;
else
    R = max(u(ind(1,1),:)) - u(ind(1,1),:) - 1;
    [~,a_opt] = max(f(u, k, q),[],3); 
    res=q-(1+eta0)*R(a_opt);
end
end

function EV = V_cont (u, k, bq, bV, q1, q2, xi, eta0, eta1, eta2)
% Continuation payoff from using source k until qk=bq
% Input:
%   u: payoff matrix, 4 x number of actions
%   k: source (1 or 2)
%   bq: threshold for qk, n x m matrix
%   bV: expected payoff at point qk=bq, n x m matrix
%   q1, q2: point at which expected payoff is calculated, two n x m matrices
%   xi>=-1, eta0\in{0,-1}, eta1\in{0,-1}, eta2\in{0,-1}: space parameters
% Output:
%   EV: continuation payoff at point (q1,q2) from using source k until
%       qk=bq, n x m matrix
if k==1
    EV=q1.*(1+eta0+(1+eta1)*bq+(1+eta2)*q2+(1+xi)*bq.*q2).*bV;
    EV=EV+(bq-q1).*(1+eta0+(1+eta2)*q2).*(W(u,1,q2,eta0,eta2)-1);
    EV=EV./bq;
    EV=EV-q1.*(1+eta1+(1+xi)*q2).*log(bq./q1);
else
    EV=q2.*(1+eta0+(1+eta1)*q1+(1+eta2)*bq+(1+xi)*q1.*bq).*bV;
    EV=EV+(bq-q2).*(1+eta0+(1+eta1)*q1).*(W(u,2,q1,eta0,eta1)-1);
    EV=EV./bq;
    EV=EV-q2.*(1+eta2+(1+xi)*q1).*log(bq./q2);
end
EV=EV./(1+eta0+(1+eta1)*q1+(1+eta2)*q2+(1+xi)*q1.*q2);
end