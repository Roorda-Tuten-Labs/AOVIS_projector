function [params] = default_params(uniqueHue, subject, color_space)

import white.*

params = [];
if nargin < 1
    params.uniqueHue = 'white';
else
    params.uniqueHue = uniqueHue;
end
if nargin < 2
    params.subject = 'sample';
else
    params.subject = subject;
end
if nargin < 3
    params.color_space = 'xyY';
else
    params.color_space = color_space;
end

params.subject_id = 'default';
params.debug_mode = 0;

params.fixation_size = 4; % in pixels

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

params.add_grid_lines_flag = 0;
params.add_square_flag = 1;

params.add_fundus_image_flag = 0; % start with fundus image off.
params.fundus_img_offset_x = 400;
params.fundus_img_offset_y = 500;
params.fundus_img_scale = 0.6;

params.pix_per_deg = 49.5;

params.image_rot = 0;
params.fundus_image_file = '';

params.stimulus_shape = 'rectangle';
params.psych_method = 'display';

params.fixation_offset_x = params.pixel_width / 2; % center it
params.fixation_offset_y = params.pixel_height / 2; % center it

params.background = [0, 0, 0]; % defaults to black

end
