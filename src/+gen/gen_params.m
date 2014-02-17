function [params] = gen_params(uniqueHue, ...
    show_plot, blu, yel, ANNULUS, subject, constant_stim)

import convert.CIE_from_Angle
import comp.intersect

params = [];

if nargin < 1
    params.uniqueHue = 'blue';
else
    params.uniqueHue = uniqueHue;
end
if nargin < 4
    params.yel = 78; % chromatic angle in degrees
else 
    params.yel = yel;
end
if nargin < 3
    params.blu = 210; % chromatic angle in degrees
else
    params.blu = blu;
end
if nargin < 2
    params.show_plot = 0;
else
    params.show_plot = show_plot;
end
if nargin < 5
    params.annulus = 0;
else
    params.annulus = ANNULUS;
end
if nargin < 6
    params.subject = 'sample';
else
    params.subject = subject;
end
if nargin < 7
    params.constant_stim = 1;
else
    params.constant_stim = constant_stim;
end
    

params.cal_file = 'Feb13_2014a';
params.pause_time = 1.0; % in sec

% ---------- Color Setup ----------
% Gets color values.
params.LUM = 60;
params.ncolors = 10; 
params.nrepeats = 10;
params.RHO = 0.09;

params.angle_bounds = [];
params.angle_bounds.y1 = 40;
params.angle_bounds.y2 = 100;
params.angle_bounds.b1 = 180;
params.angle_bounds.b2 = 240;

    
if strcmp(uniqueHue, 'yellow') 
    angle_1 = params.angle_bounds.y1; 
    angle_2 = params.angle_bounds.y2;
    params.angles = linspace(angle_1, angle_2, params.ncolors);
    params.left = 'too green';
    params.right = 'too red';
    
elseif strcmp(uniqueHue, 'blue')
    angle_1 = params.angle_bounds.b1; 
    angle_2 = params.angle_bounds.b2;
    params.angles = linspace(angle_1, angle_2, params.ncolors);
    params.left = 'too purple';
    params.right = 'too green';
    
elseif strcmp(uniqueHue, 'white')
    
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

    params.left = 'too blue';
    params.right = 'too yellow';
    
end
params.ntrials = params.ncolors * params.nrepeats;