function fig = plotSimpleP (u, fig)
% Plot optimal simple strategy on the belief space (p10,p01) when p11=0
% Input:
%   u: payoff matrix, 4 x number of actions
%   fig: figure number
% Output:
%   fig: next figure number
step = 0.001; [P10, P01] = meshgrid(0:step:1, 0:step:1);
points = optSimpleP (u, P10, P01);
fig = plotStrategy (points, P10, P01, true, fig);
end