function [angles, left, right, x, y] = get_params(RHO, ncolors
if strcmp(uniqueHue, 'yellow') 
    angle_1 = 40; 
    angle_2 = 100;
    angles = linspace(angle_1, angle_2, ncolors);
    left = 'too green';
    right = 'too red';
    
elseif strcmp(uniqueHue, 'blue')
    angle_1 = 180; 
    angle_2 = 240;
    angles = linspace(angle_1, angle_2, ncolors);
    left = 'too purple';
    right = 'too green';
    
elseif strcmp(uniqueHue, 'white')
    
    [b_x, b_y] = CIE_from_Angle(blu, RHO);
    [y_x, y_y] = CIE_from_Angle(yel, RHO);
    line1 = [b_x b_y; y_x y_y];
    
    ncolors = 15; % override default setting to ensure good sampling
    angles = linspace(blu - 5, yel + 5, ncolors);
    
    x = zeros(ncolors, 1);
    y = zeros(ncolors, 1);
    for i=1:length(angles)
        [x_, y_] = CIE_from_Angle(angles(i), 0.3);
        line2 = [x_ y_; 1/3 1/3];
        [x(i), y(i)] = intersect(line1, line2);
    end

    left = 'too blue';
    right = 'too yellow'; 
end