function fig = plot_optimal_strategy (u, space_parameters, fig)
% Plot optimal strategy on the belief space
% Input:
%   u: payoff matrix, 4 x number of actions
%   space_parameters: either 1 or [xi, eta0, eta1, eta2]
%       * if space_parameters = 1, then plot on the belief space (p10,p01) when p11=0
%       * if space_parameters = [xi, eta0, eta1, eta2], with xi>=-1,
%                               eta0\in{0,-1}, eta1\in{0,-1}, eta2\in{0,-1},
%                               then plot on (q1/(1+q1), q2/(1+q2)) space
%   fig: figure number
% Output:
%   fig: next figure number
if length(space_parameters) == 1
    p = [0.45:0.005:0.55]; [p10,p01]=meshgrid(p,p);
    q = (1-p10-p01)./p10; x = q./(1+q); 
    step = 0.001; x = unique([x(q(:)>0);(0:step:1)']);
    [X, Y] = meshgrid(x,x); Q1 = X./(1-X); Q2 = Y./(1-Y); 
    xi = 0; eta0 = -1; eta1 = 0; eta2 = 0;
    triangle = true;
    P10 = Q2./(Q1+Q2+Q1.*Q2); X = P10; 
    P01 = Q1./(Q1+Q2+Q1.*Q2); Y = P01;
else
    step = 0.001; [X,Y] = meshgrid(0:step:1, 0:step:1); Q1 = X./(1-X); Q2 = Y./(1-Y); 
    xi = space_parameters(1); eta0 = space_parameters(2); 
    eta1 = space_parameters(3); eta2 = space_parameters(4);
    triangle = false;
end
points = opt (u, Q1, Q2, xi, eta0, eta1, eta2);
fig = plot_strategy (points, X, Y, triangle, fig);
end