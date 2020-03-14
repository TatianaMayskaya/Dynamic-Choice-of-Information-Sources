function fig = plot_ka_simple (u, k, a, space_parameters, fig)
% Plot optimal (k,a)-simple strategy on the belief space 
% Input:
%   u: payoff matrix, 4 x number of actions
%   k: source (1 or 2)
%   a: action (column number in matrix u())
%   space_parameters: either 1 or [xi, eta0, eta1, eta2]
%       * if space_parameters = 1, then plot on the belief space (p10,p01) when p11=0
%       * if space_parameters = [xi, eta0, eta1, eta2], with xi>=-1,
%                               eta0\in{0,-1}, eta1\in{0,-1}, eta2\in{0,-1},
%                               then plot on (q1/(1+q1), q2/(1+q2)) space
%   fig: figure number
% Output:
%   fig: next figure number
step = 0.001; [X, Y] = meshgrid(0:step:1, 0:step:1);
Q1 = X./(1-X); Q2 = Y./(1-Y); F1=f(u, 1, Q2); F2=f(u, 2, Q1);
points = opt_ka_simple (u, k, a, X, Y, space_parameters, F1, F2);
fig = plot_strategy (points, X, Y, length(space_parameters)==1, fig);
end
