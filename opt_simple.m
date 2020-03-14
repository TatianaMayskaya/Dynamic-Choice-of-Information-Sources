function [points, EV] = opt_simple (u, X, Y, space_parameters)
% Find optimal simple strategy
% Input:
%   u: payoff matrix, 4 x number of actions 
%   X, Y: two n x m matrices that correspond to 2-D grid coordinates (all
%         rows of X are identical and correspond to x-axes, all
%         columns of Y are identical and correspond to y-axes)
%   space_parameters: either 1 or [xi, eta0, eta1, eta2]
%       * if space_parameters = 1, then X=P10, Y=P01 and p11=0
%       * if space_parameters = [xi, eta0, eta1, eta2], with xi>=-1,
%                               eta0\in{0,1}, eta1\in{0,1}, eta2\in{0,1},
%                               then X=Q1/(1+Q1), Y=Q2/(1+Q2)
% Output:
%   points: n x m matrix that corresponds to the optimal simple strategy,
%           each element is either 0 (= no learning), or 1 (= use source
%           1), or 2 (= use source 2)
%   EV: n x m matrix that corresponds to the expected value from the
%       optimal simple strategy
[points, EV] = opt_ka_simple (u, 1, 1, X, Y, space_parameters);
for a = 1 : size(u, 2)
for k = 1 : 2
    [points_, EV_] = opt_ka_simple (u, k, a, X, Y, space_parameters);
    points(EV<EV_) = points_(EV<EV_); EV(EV<EV_) = EV_(EV<EV_);
end
end
end