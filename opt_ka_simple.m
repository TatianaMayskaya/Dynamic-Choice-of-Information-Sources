function [points, EV] = opt_ka_simple (u, k, a, X, Y, space_parameters)
% Find optimal (k,a)-simple strategy
% Input:
%   u: payoff matrix, 4 x number of actions
%   k: source (1 or 2)
%   a: action (column number in matrix u())
%   X, Y: two n x m matrices that correspond to 2-D grid coordinates 
%   space_parameters: either 1 or [xi, eta0, eta1, eta2]
%       * if space_parameters = 1, then X=P10, Y=P01 and p11=0
%       * if space_parameters = [xi, eta0, eta1, eta2], with xi>=-1,
%                               eta0\in{0,-1}, eta1\in{0,-1}, eta2\in{0,-1},
%                               then X=Q1/(1+Q1), Y=Q2/(1+Q2)
% Output:
%   points: n x m matrix that corresponds to the optimal (k,a)-simple
%           strategy, each element is either 0 (= no learning), or k (= use
%           source k)
%   EV: n x m matrix that corresponds to the expected value from the
%       optimal (k,a)-simple strategy
if length(space_parameters) == 1
    P10 = X; P01 = Y;
    if k == 1
        delta_u = max(u(ind(1,0),:)) - u(ind(1,0),a);
        p = P10; 
    else
        delta_u = max(u(ind(0,1),:)) - u(ind(0,1),a);
        p = P01;
    end
    cont_region = (p*delta_u>=1) & (P10+P01<=1);
    points = zeros(size(p)); points(cont_region) = k;
    EV = P10*u(ind(1,0),a) + P01*u(ind(0,1),a) + (1-P10-P01)*u(ind(0,0),a);
    p_cont = p(cont_region);
    EV(cont_region) = EV(cont_region) + p_cont*delta_u ...
        - 1 - (1-p_cont).*log((delta_u-1)./(1./p_cont-1));
else
    Q1 = X./(1-X); Q2 = Y./(1-Y); xi = space_parameters(1); 
    eta0 = space_parameters(2); eta1 = space_parameters(3);
    eta2 = space_parameters(4);
    if k == 1
        q = Q1; q_fixed = Q2; mult = 1+eta1+(1+xi)*Q2;
    else
        q = Q2; q_fixed = Q1; mult = 1+eta2+(1+xi)*Q1; 
    end
    q_bar = Q (u, k, a, q_fixed, xi, eta0, eta1, eta2);
    cont_region = q<=q_bar;
    points = zeros(size(q)); points(cont_region) = k;
    EV = (1+eta0)*u(ind(1,1),a)+(1+eta1)*Q1*u(ind(0,1),a)...
        +(1+eta2)*Q2*u(ind(1,0),a)+(1+xi)*Q1.*Q2*u(ind(0,0),a);
    q_cont = q(cont_region); q_bar_cont = q_bar(cont_region);
    EV(cont_region) = EV(cont_region) + ...
        mult(cont_region).*(q_bar_cont-q_cont+q_cont.*log(q_cont./q_bar_cont));
    EV = EV./(1+eta0+(1+eta1)*Q1+(1+eta2)*Q2+(1+xi)*Q1.*Q2);
end
end

function res = Q (u, k, a, q, xi, eta0, eta1, eta2)
% Threshold for optimal (k,a)-simple strategy
% Input: 
%   u: payoff matrix, 4 x number of actions
%   k: source (1 or 2)
%   a: action (column number in matrix u())
%   q: fixed coordinate (q2 if k=1, q1 if k=2), n x m matrix
%   xi>=-1, eta0\in{0,-1}, eta1\in{0,-1}, eta2\in{0,-1}: space parameters
% Output:
%   res=Q_k(rho\q_k,a): threshold for qk, n x m matrix
if k==1
    eta_num = eta2; eta_den = eta1; uu = u(ind(1,0),a);
else
    eta_num = eta1; eta_den = eta2; uu = u(ind(0,1),a);
end
res = (1+eta0+(1+eta_num)*q).*(W(u,k,q,eta0,eta_num)-1)...
    -(1+eta_num)*q*uu-(1+eta0)*u(ind(1,1),a);
res = res./(1+eta_den+(1+xi)*q);
end
