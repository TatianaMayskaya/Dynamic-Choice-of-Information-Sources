function fig = plot_strategy (points, X, Y, triangle, fig)
% Plot a strategy on the belief space
% Input:
%   X, Y: two n x m matrices that correspond to 2-D grid coordinates 
%   points: n x m matrix that corresponds to the strategy, each element is
%           either 0 (= no learning), or 1 (= use source 1), or 2 (= use
%           source 2)
%   triangle: either true (x-axes is p10, y-axes is p01) or false (x-axes
%             is q1/(1+q1), y-axes is q2/(1+q2))
%   fig: figure number
% Output:
%   fig: next figure number
figure(fig); fig=fig+1;
clf; hold on
source1color = 0.8; % source 1 color is light gray
source2color = 0.5; % source 2 color is gray
plot(X(points(:)==1),Y(points(:)==1),'LineStyle','none','Marker','.','Color',[source1color,source1color,source1color])
plot(X(points(:)==2),Y(points(:)==2),'LineStyle','none','Marker','.','Color',[source2color,source2color,source2color])
xlim([0,1]); ylim([0,1]); xticks([]); yticks([])
if triangle
  box off
  plot([0,1],[1,0],'LineWidth',2,'Color','k')
else
  box on
end
end
