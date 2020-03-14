function [points, EV] = optSimpleP (u, P10, P01)
% Find optimal simple strategy when p11=0 
% Input:
%   u: payoff matrix, 4 x number of actions 
%   P10, P01: two n x m matrices that correspond to 2-D grid coordinates
%             (all rows of P10 are identical and correspond to x-axes, all
%             columns of P01 are identical and correspond to y-axes)
% Output:
%   points: n x m matrix that corresponds to the optimal simple strategy,
%           each element is either 0 (= no learning), or 1 (= use source
%           1), or 2 (= use source 2)
%   EV: n x m matrix that corresponds to the expected value from the
%       optimal simple strategy
[points, EV] = optKASimpleP (u, 1, 1, P10, P01);
for a = 1 : size(u, 2)
for k = 1 : 2
    [points_, EV_] = optKASimpleP (u, k, a, P10, P01);
    points(EV<EV_) = points_(EV<EV_); EV(EV<EV_) = EV_(EV<EV_);
end
end
end