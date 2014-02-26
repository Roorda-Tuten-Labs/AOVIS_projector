function [x, y] = CIE_from_Angle(deg, rho, color_space)

import convert.deg2rad

if nargin < 3
    color_space = 'Luv';
end

white_point = [1/3 1/3];


if strcmp(color_space, 'Luv')
    white_point = xyTouv(white_point');
end

[x, y] = pol2cart(deg2rad(deg), rho);
x = x + white_point(1);
y = y + white_point(2);

end