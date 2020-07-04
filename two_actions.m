function two_actions()
tic
fig = 1;

u11Y_u11X=-1; u00Y_u00X=-100; u10Y_u10X=10; u01Y_u01X=5;  
u = payoff_matrix (u11Y_u11X, u00Y_u00X, u10Y_u10X, u01Y_u01X);
% plot optimal strategy when all pij>0
eta0 = 0; eta1 = 0; eta2 = 0;
xi=0; fig = plot_optimal_strategy (u, [xi, eta0, eta1, eta2], fig);

toc
end

function u = payoff_matrix (u11Y_u11X, u00Y_u00X, u10Y_u10X, u01Y_u01X)
u00X=0; u01X=0; u10X=0; u11X=0;
u00Y=u00Y_u00X; u10Y=u10Y_u10X; u01Y=u01Y_u01X; u11Y=u11Y_u11X;
u00=[u00X,u00Y]; u10=[u10X,u10Y]; u01=[u01X,u01Y]; u11=[u11X,u11Y];

% general part (do not modify)
u=zeros(4,length(u00));
u(ind(0,0),:)=u00; u(ind(1,0),:)=u10; u(ind(0,1),:)=u01; u(ind(1,1),:)=u11;
end