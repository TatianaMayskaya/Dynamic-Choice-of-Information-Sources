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
q1_shift = q1(1:end-1,1:end-1); q2_shift = q2(1:end-1,1:end-1);
% index rule:
I1 = I(u,1,q2_shift,eta0,eta2);
I2 = I(u,2,q1_shift,eta0,eta1);
source1_opt = I1 >= I2; source2_opt = I1 <  I2; 

% continuation payoff from using source k until qk-bq
bq1 = q1(1:end-1,2:end); bq2 = q2(2:end,1:end-1);
[mult1, V1cont] = V_cont(u,1,bq1,q1_shift,q2_shift,xi,eta0,eta1,eta2);
[mult2, V2cont] = V_cont(u,2,bq2,q1_shift,q2_shift,xi,eta0,eta1,eta2);

[points, EV] = opt_simple (u, q1./(1+q1), q2./(1+q2), [xi, eta0, eta1, eta2]);
solved = zeros(size(points));
solved(:,end) = 1; solved(end,:) = 1; lineLength = 0;
while sum(1-solved(:)) > 0
    [points, solved, EV] = opt_step (points, solved, EV, source1_opt, source2_opt, mult1, V1cont, mult2, V2cont);
    fprintf(repmat('\b',1,lineLength));
    lineLength = fprintf('Progress bar: %3.1f/100%% or %d/%d',sum(solved(:))/length(solved(:))*100,sum(solved(:)),length(solved(:)));
end
disp(' ')
end

function [points, solved, EV] = opt_step (points, solved, EV, source1_opt, source2_opt, mult1, V1cont, mult2, V2cont)
% Optimization step
% Input: 
%   points: current best strategy, n x m matrix
%   solved: indicator for points where the optimal strategy is found, n x m matrix
%   EV: expected payoff from strategy "points", n x m matrix
%   source1_opt: n-1 x m-1 matrix, indicator for points where source 1
%                index >= source 2 index
%   source2_opt: n-1 x m-1 matrix, indicator for points where source 2
%                index > source 1 index
%   mult1, V1cont, mult2, V2cont: elements for continuation payoff
% Output:
%   points, solved, EV: updated

% points for which optimal strategy is calculated at this optimization step
solved_shift = solved(1:end-1,1:end-1);
treated = (solved_shift==0);
treated1 = treated & source1_opt & (solved(1:end-1,2:end)==1);
treated2 = treated & source2_opt & (solved(2:end,1:end-1)==1);
solved_shift(treated1|treated2) = 1; 
solved(1:end-1,1:end-1) = solved_shift;

% optimization
bV1 = EV(1:end-1,2:end); bV2 = EV(2:end,1:end-1); 
V1 = mult1.*bV1+V1cont; V2 = mult2.*bV2+V2cont;  
Vbase = EV(1:end-1,1:end-1); eps=10^(-6);
j1 = treated1 & (V1>Vbase+eps);
j2 = treated2 & (V2>Vbase+eps);

% points and EV update
EV_shift = Vbase; points_shift = points(1:end-1,1:end-1);
EV_shift(j1) = V1(j1); points_shift(j1) = 1;
EV_shift(j2) = V2(j2); points_shift(j2) = 2;
EV(1:end-1,1:end-1) = EV_shift; points(1:end-1,1:end-1) = points_shift;
end

function res = I (u, k, q, eta0, eta)
% Index of source k (1 or 2)
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

function [mult, EV] = V_cont (u, k, bq, q1, q2, xi, eta0, eta1, eta2)
% Continuation payoff from using source k until qk=bq
% Input:
%   u: payoff matrix, 4 x number of actions
%   k: source (1 or 2)
%   bq: threshold for qk, n x m matrix
%   q1, q2: point at which expected payoff is calculated, two n x m matrices
%   xi>=-1, eta0\in{0,-1}, eta1\in{0,-1}, eta2\in{0,-1}: space parameters
% Output:
%   mult, EV: elements for construction of continuation payoff, 
%             two n x m matrices
%             mult*bV+EV = continuation payoff at point (q1,q2) from using 
%                          source k until qk=bq
%             bV = expected payoff at point qk=bq
if k==1
    mult = q1.*(1+eta0+(1+eta1)*bq+(1+eta2)*q2+(1+xi)*bq.*q2)./bq;
    EV = (bq-q1).*(1+eta0+(1+eta2)*q2).*(W(u,1,q2,eta0,eta2)-1)./bq;
    EV = EV - (q1.*(1+eta1+(1+xi)*q2).*log(bq./q1));
else
    mult = q2.*(1+eta0+(1+eta1)*q1+(1+eta2)*bq+(1+xi)*q1.*bq)./bq;
    EV = (bq-q2).*(1+eta0+(1+eta1)*q1).*(W(u,2,q1,eta0,eta1)-1)./bq;
    EV = EV - (q2.*(1+eta2+(1+xi)*q1).*log(bq./q2));
end
mult = mult./(1+eta0+(1+eta1)*q1+(1+eta2)*q2+(1+xi)*q1.*q2);
EV = EV./(1+eta0+(1+eta1)*q1+(1+eta2)*q2+(1+xi)*q1.*q2);
end