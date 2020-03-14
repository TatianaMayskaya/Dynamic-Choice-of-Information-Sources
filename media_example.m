function media_example()

% parameters
beta=20; delta=0.5;
u00I=beta+delta; u01I=beta+delta; u10I=delta; u11I=delta;
u00O=beta; u10O=beta; u01O=0; u11O=0;
u00=[u00I,u00O]; u10=[u10I,u10O]; u01=[u01I,u01O]; u11=[u11I,u11O];

% general part (do not modify)
u=zeros(4,length(u00));
u(ind(0,0),:)=u00; u(ind(1,0),:)=u10; u(ind(0,1),:)=u01; u(ind(1,1),:)=u11;
fig = 1;

% plot (1,I)-simple strategy when p11=0
k = 1; a = 1; fig = plotKASimpleP (u, k, a, fig);
% plot optimal simple strategy when p11=0
fig = plotSimpleP (u, fig);
% plot optimal strategy when p11=0
fig = plotP (u, fig);
end
