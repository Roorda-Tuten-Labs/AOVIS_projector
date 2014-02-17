function [x, y] = CIE_from_Angle(deg, rho, white_point)

import convert.deg2rad

if nargin < 3
    white_point = [1/3 1/3];
end

[x, y] = pol2cart(deg2rad(deg), rho);
x = x + white_point(1);
y = y + white_point(2);

end