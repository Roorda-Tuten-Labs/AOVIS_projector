function [params] = default_params(uniqueHue, subject, color_space)

import white.*

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

params.cal_file = 'RoordaLabMarch12_2014b.mat';
params.cal_dir = './cal/files/';
params.pause_time = 1.0; % in sec
params.screen = 0; % which screen to display.
params.textsize = 20; % size of text on screen.

% ---------- Color Setup ----------
% Gets color values.
params.LUM = 10;
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
    Params.angle_bounds.y1 = 70;
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

% CIE xy coords
params.x = 0.3;
params.y = 0.3;

params.img_x = 220;
params.img_y = 190;

params.img_offset_x = 328;
params.img_offset_y = 234;

params.stimulus_shape = 'rectangle';
params.psych_method = 'adjustment';

params.fixation_offset_x = params.pixel_width / 2; % center it
params.fixation_offset_y = params.pixel_height / 2; % center it

params.background = [0, 0, 0]; % defaults to black

params.save_params = 0;

params = gen.hue_specific_params(params.uniqueHue, params);

end
