function xyz = mean_angle_to_xyz(params, mu)

import white.*

    if ~strcmp(params.uniqueHue, 'white')
        [x, y] = convert.CIE_from_Angle(mu, params.RHO);

    else
        blue = params.blue_xyz;
        yellow = params.yellow_xyz;
       	x = mu * (yellow(1) - blue(1)) + blue(1);
        y = interp1([blue(1) yellow(1)], [blue(2) yellow(2)], x, 'linear');
    end
    
    XYZ = xyYToXYZ([x y params.LUM]');
    xyz = XYZ / sum(XYZ);
    
end