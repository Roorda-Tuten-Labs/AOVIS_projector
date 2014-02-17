function xyz = mean_angle_to_xyz(params, mu)

import convert.CIE_from_Angle
import comp.intersect

    if ~strcmp(params.uniqueHue, 'white')
        [x, y] = CIE_from_Angle(mu, params.RHO);

    else
        [x, y] = CIE_from_Angle(mu, 0.4);
        [yelx yely] = CIE_from_Angle(params.yel, params.RHO);
        [blux bluy] = CIE_from_Angle(params.blu, params.RHO);
        yel = [yelx yely];
        blu = [blux bluy];
        line1 = [yel; blu];
        line2 = [x y; 1/3 1/3];
        [x, y] = intersect(line1, line2);
    end
    
    XYZ = xyYToXYZ([x y params.LUM]');
    xyz = XYZ / sum(XYZ);
    
end