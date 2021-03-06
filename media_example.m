function media_example()
tic
fig = 1;

beta = 20; delta = 0.5; u = payoff_matrix(beta,delta);
% plot (1,I)-simple strategy when p11=0
k = 1; a = 1; fig = plot_ka_simple (u, k, a, 1, fig);
% plot optimal simple strategy when p11=0
fig = plot_simple (u, 1, fig);
% plot optimal strategy when p11=0
fig = plot_optimal_strategy (u, 1, fig);
% plot optimal strategy when all pij>0
eta0 = 0; eta1 = 0; eta2 = 0;
xi = -0.8;  fig = plot_optimal_strategy (u, [xi, eta0, eta1, eta2], fig);

beta = 100; delta = 0.5; u = payoff_matrix(beta,delta);
% plot optimal strategy when p11=0
fig = plot_optimal_strategy (u, 1, fig);
% plot optimal strategy when all pij>0
eta0 = 0; eta1 = 0; eta2 = 0;
xi = 1;  fig = plot_optimal_strategy (u, [xi, eta0, eta1, eta2], fig);
xi = 0;  fig = plot_optimal_strategy (u, [xi, eta0, eta1, eta2], fig);
xi = -0.8;  fig = plot_optimal_strategy (u, [xi, eta0, eta1, eta2], fig);

beta = 50; delta = 0.5; u = payoff_matrix(beta,delta);
% plot optimal strategy when all pij>0
eta0 = 0; eta1 = 0; eta2 = 0;
xi = 0;  fig = plot_optimal_strategy (u, [xi, eta0, eta1, eta2], fig);

toc
end

function u = payoff_matrix (beta, delta)
u00I=beta+delta; u01I=beta+delta; u10I=delta; u11I=delta;
u00O=beta; u10O=beta; u01O=0; u11O=0;
u00=[u00I,u00O]; u10=[u10I,u10O]; u01=[u01I,u01O]; u11=[u11I,u11O];

% general part (do not modify)
u=zeros(4,length(u00));
u(ind(0,0),:)=u00; u(ind(1,0),:)=u10; u(ind(0,1),:)=u01; u(ind(1,1),:)=u11;
end
