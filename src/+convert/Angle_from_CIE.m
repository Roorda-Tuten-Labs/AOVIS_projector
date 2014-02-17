function [theta, rho] = Angle_from_CIE(xyz, white_point)

if nargin < 3
    white_point = [1/3 1/3];
end

x = xyz(1) - white_point(1);
y = xyz(2) - white_point(2);

[theta, rho] = cart2pol(x, y);


end