function RnD_example()
tic
fig = 1;

% plot optimal strategy when all pij>0
nu1 = 99; nu2 = 100; xi = 0; eta0 = 0; eta1 = 0; eta2 = 0;
delta = 0;   fig = plot_optimal_strategy (payoff_matrix (nu1, nu2, delta), [xi, eta0, eta1, eta2], fig);
delta = 0.5; fig = plot_optimal_strategy (payoff_matrix (nu1, nu2, delta), [xi, eta0, eta1, eta2], fig);
delta = 1;   fig = plot_optimal_strategy (payoff_matrix (nu1, nu2, delta), [xi, eta0, eta1, eta2], fig);

nu1 = 50; nu2 = 50; delta = 0; u = payoff_matrix (nu1, nu2, delta);
eta0 = 0; eta1 = 0; eta2 = 0;
xi = 1;  fig = plot_optimal_strategy (u, [xi, eta0, eta1, eta2], fig);
xi = -1; fig = plot_optimal_strategy (u, [xi, eta0, eta1, eta2], fig);

toc
end

function u = payoff_matrix (nu1, nu2, delta)
u001=0; u011=0; u101=0; u111=0;
u002=0; u102=-nu1; u012=nu2; u112=(1-delta)*(nu2-nu1);
u00=[u001,u002]; u10=[u101,u102]; u01=[u011,u012]; u11=[u111,u112];

% general part (do not modify)
u=zeros(4,length(u00));
u(ind(0,0),:)=u00; u(ind(1,0),:)=u10; u(ind(0,1),:)=u01; u(ind(1,1),:)=u11;
end
