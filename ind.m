function row = ind (theta1, theta2)
% Map (theta1,theta2) to the row number in payoff matrix
% Input:
%   theta1, theta2: state (00, 01, 10, or 11)
% Output:
%   row: 1, 2, 3 or 4
if theta1 + theta2==0
    row=1;
elseif (theta2==1)&&(theta1==0)
    row=2;
elseif (theta1==1)&&(theta2==0)
    row=3;
else
    row=4;
end
end 