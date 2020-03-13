function fig = plotKASimpleP (u, k, a, fig)
% Plot optimal (k,a)-simple strategy on the belief space (p10,p01) when p11=0
% Input:
%   u: payoff matrix, 4 x number of actions
%   k: source (1 or 2)
%   a: action (column number in matrix u())
%   fig: figure number
% Output:
%   fig: next figure number
step = 0.001; [P10, P01] = meshgrid(0:step:1, 0:step:1);
points = optKASimpleP (u, k, a, P10, P01);
fig = plotStrategy (points, P10, P01, true, fig);
end
