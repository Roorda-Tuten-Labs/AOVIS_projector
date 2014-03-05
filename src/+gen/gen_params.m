function [params] = gen_params(uniqueHue, subject, color_space)

import comp.intersect
import gen.gen_hue_specific_params

params = [];
if nargin < 1
    params.uniqueHue = 'blue';
else
    params.uniqueHue = uniqueHue;
end
if nargin < 2
    params.subject = 'sample';
else
    params.subject = subject;
end
if nargin < 3
    params.color_space = 'Luv';
else
    params.color_space = color_space;
end

params.show_plot = 0;
params.constant_stim = 1;

params.cal_file = 'Feb13_2014a';
params.pause_time = 1.0; % in sec
params.screen = 0; % which screen to display.

% ---------- Color Setup ----------
% Gets color values.
params.LUM = 60;
params.ncolors = 10; 
params.nrepeats = 10;

params.angle_bounds = [];
if strcmp(params.color_space, 'xyY')
    params.white = [1/3 1/3]';
    params.RHO = 0.09;
    params.angle_bounds.y1 = 40;
    params.angle_bounds.y2 = 100;
    params.angle_bounds.b1 = 175;
    params.angle_bounds.b2 = 240;
    params.blu = 210; % chromatic angle in degrees
    params.yel = 78; % chromatic angle in degrees

elseif strcmp(params.color_space, 'Luv')
    params.white = xyTouv([1/3 1/3]');
    params.RHO = 0.072;
    params.angle_bounds.y1 = 70;
    params.angle_bounds.y2 = 130;
    params.angle_bounds.b1 = 195;
    params.angle_bounds.b2 = 255;
    params.blu = 220; % chromatic angle in degrees
    params.yel = 82; % chromatic angle in degrees

end

[params.display_width, params.display_height] = Screen('DisplaySize', ...
    params.screen);
[params.pixel_width, params.pixel_height] = Screen('WindowSize', ...
    params.screen);

params.img_width = 200;
params.img_height = 300;

params.img_offset_width = 0;
params.img_offset_height = 0;

params.stimulus_shape = 'rectangle';

params.psych_method = 'adjustment';

params = gen_hue_specific_params(params.uniqueHue, params);

end
