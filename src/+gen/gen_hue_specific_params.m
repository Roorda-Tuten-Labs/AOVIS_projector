function [params] = gen_hue_specific_params(uniqueHue, params)
    import convert.CIE_from_Angle
    import comp.intersect
    
if strcmp(uniqueHue, 'yellow') 
    params.uniqueHue = 'yellow';
    angle_1 = params.angle_bounds.y1; 
    angle_2 = params.angle_bounds.y2;
    params.angles = linspace(angle_1, angle_2, params.ncolors);
    params.left = 'too green';
    params.right = 'too red';
    
elseif strcmp(uniqueHue, 'blue')
    params.uniqueHue = 'blue';
    angle_1 = params.angle_bounds.b1; 
    angle_2 = params.angle_bounds.b2;
    params.angles = linspace(angle_1, angle_2, params.ncolors);
    params.left = 'too purple';
    params.right = 'too green';
    
elseif strcmp(uniqueHue, 'white')
    params.uniqueHue = 'white';
    
    [b_x, b_y] = CIE_from_Angle(params.blu, params.RHO);
    [y_x, y_y] = CIE_from_Angle(params.yel, params.RHO);
    line1 = [b_x b_y; y_x y_y];

    params.ncolors = 15; % override default setting to ensure good sampling
    params.angles = linspace(params.blu - 5, params.yel + 5, ...
        params.ncolors);
    
    params.x = zeros(params.ncolors, 1);
    params.y = zeros(params.ncolors, 1);
    for i=1:length(params.angles)
        [x_, y_] = CIE_from_Angle(params.angles(i), 0.3);
        line2 = [x_ y_; 1/3 1/3];
        [params.x(i), params.y(i)] = intersect(line1, line2);
    end
    params.ntrials = params.ncolors * params.nrepeats;
    params.left = 'too blue';
    params.right = 'too yellow';
end
params.ntrials = params.ncolors * params.nrepeats;
end