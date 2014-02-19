function [params] = gen_hue_specific_params(uniqueHue, params)
    import convert.Angle_from_CIE
    import convert.rad2deg
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
    
    blue_xyz = params.blue_xyz;
    yellow_xyz = params.yellow_xyz;

    params.ncolors = 15; % override default setting to ensure good sampling
    params.x = linspace(blue_xyz(1), yellow_xyz(1), params.ncolors);
    params.y = linspace(blue_xyz(2), yellow_xyz(2), params.ncolors);
    
    params.angles = zeros(params.ncolors);
    
    for i=1:length(params.angles)
        z = 1 - (params.x(i) + params.y(i));
        angle = Angle_from_CIE([params.x(i) params.y(i) z]');
        angle = rad2deg(angle); 
        if angle < 0
            angle = 360 + angle;
        end
        params.angles(i) = angle;
    end
    params.left = 'too blue';
    params.right = 'too yellow';
end
params.ntrials = params.ncolors * params.nrepeats;
end