function [points, EV] = optKASimpleP (u, k, a, P10, P01)
% Find optimal (k,a)-simple strategy when p11=0
% Input:
%   u: payoff matrix, 4 x number of actions
%   k: source (1 or 2)
%   a: action (column number in matrix u())
%   P10, P01: two n x m matrices that correspond to 2-D grid coordinates (all rows of P10 are identical and correspond to x-axes, all columns of P01 are identical and correspond to y-axes)
% Output:
%   points: n x m matrix that corresponds to the optimal (k,a)-strategy, each element is either 0 (= no learning), or k (= use source k)
%   EV: n x m matrix that corresponds to the expected value from the optimal (k,a)-strategy
if k = 1
  delta_u = max(u(ind(1,0),:)) - u(ind(1,0),a);
  p = P10; 
else
  delta_u = max(u(ind(0,1),:)) - u(ind(0,1),a);
  p = P01;
end
cont_region = p*delta_u>=1;
points = zeros(size(p)); points(cont_region) = k;
EV = P10*u(ind(1,0),a) + P01*u(ind(0,1),a) + (1-P10-P01)*u(ind(0,0),a);
EV(cont_region) = EV(cont_region) + p(cont_region)*delta_u - 1 - (1-p(cont_region)).*log((delta_u-1)./(1./p(cont_region)-1));
end
