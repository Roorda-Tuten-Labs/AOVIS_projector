function [params] = gen_params(uniqueHue, ...
    show_plot, blu, yel, ANNULUS, subject, constant_stim)

import convert.CIE_from_Angle
import comp.intersect
import gen.gen_hue_specific_params

params = [];

if nargin < 1
    params.uniqueHue = 'blue';
else
    params.uniqueHue = uniqueHue;
end
if nargin < 2
    params.show_plot = 0;
else
    params.show_plot = show_plot;
end
if nargin < 3
    params.blu = 210; % chromatic angle in degrees
else
    params.blu = blu;
end
if nargin < 4
    params.yel = 78; % chromatic angle in degrees
else 
    params.yel = yel;
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
params.LUM = 50;
params.ncolors = 10; 
params.nrepeats = 10;
params.RHO = 0.09;

params.angle_bounds = [];
params.angle_bounds.y1 = 40;
params.angle_bounds.y2 = 100;
params.angle_bounds.b1 = 180;
params.angle_bounds.b2 = 240;

params = gen_hue_specific_params(params.uniqueHue, params);

end
