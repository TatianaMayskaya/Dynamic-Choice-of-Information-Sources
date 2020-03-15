function disagreement_example()
tic
fig = 1;

alpha = 60; gamma = 0.5; 
uE = payoff_matrix (alpha, gamma, "ecologists");
uC = payoff_matrix (alpha, gamma, "companies");
% plot optimal strategy when p11=0
fig = plot_optimal_strategy (uE, 1, fig);
fig = plot_optimal_strategy (uC, 1, fig);

toc
end

function u = payoff_matrix (alpha, gamma, group)
if group == "ecologists"
    u01R=alpha; u00R=alpha; u10R=0;
    u01H=0; u00H=0; u10H=gamma*alpha;
end
if group == "companies"
    u10R=0; u00R=0; u01R=gamma*alpha;
    u10H=alpha; u00H=alpha; u01H=0;
end
u11R=0; u11H=0;
u00=[u00R,u00H]; u10=[u10R,u10H]; u01=[u01R,u01H]; u11=[u11R,u11H];

% general part (do not modify)
u=zeros(4,length(u00));
u(ind(0,0),:)=u00; u(ind(1,0),:)=u10; u(ind(0,1),:)=u01; u(ind(1,1),:)=u11;
end