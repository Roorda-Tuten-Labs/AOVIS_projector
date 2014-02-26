function show_stimulus(xyY, params)

import gen.gen_image_sequence
import gen.gen_image_mat
import gen.gen_show_img
import stim.display_image
import stim.cleanup

if nargin < 1
    xyY = input('xyY coordinate to display [default = 1/3 1/3 40]', 's');
    if isempty(xyY)
        xyY = [1/3 1/3 40]';
    end
end
if nargin < 2
    params = [];
end

xy_step = 0.0025;
LUM_step = 2;
cal_file = 'Feb13_2014a';

% Load default calibration file:
cal = LoadCalFile(cal_file);
T_xyz1931 = csvread('ciexyz31.csv')';
S_xyz1931 = [380, 5, 81];

T_xyz1931 = 683 * T_xyz1931;
cal = SetSensorColorSpace(cal, T_xyz1931, S_xyz1931);
cal = SetGammaMethod(cal,0);

% ---------- Gen image sequence --------
params.ntrials = 1;
params.nrepeats = 1;
params.ncolors = 1;
params.angles = 0;
params.uniqueHue = 'white';
params.x = xyY(1);
params.y = xyY(2);
params.LUM = xyY(3);
params = gen_image_sequence(cal, params);

% ---------- Image Setup ----------
% Stores the image in a three dimensional matrix.
img = gen_image_mat(0);

try
	% ---------- Window Setup ----------
	% Supress checking behavior
	oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
    oldSupressAllWarnings = Screen('Preference', 'SuppressAllWarnings', 1);
   	%Screen('Preference', 'SkipSyncTests', 1);
    % Find out how many screens and use largest screen number.
    whichScreen = max(Screen('Screens'));
    
	% Hides the mouse cursor
	HideCursor;
	
	% Opens a graphics window on the main monitor (screen 0).
	window = Screen('OpenWindow', whichScreen);
    LoadIdentityClut(window);
    
    % Retrieves color codes for black and white and gray.
    black = BlackIndex(window);  % Retrieves the CLUT color code for black.

    showimg = gen_show_img(img, params.color_sequence, 2);
    
    a = num2str(round(xyY(1:2)' * 1000) / 1000);
    b = num2str(round(xyY(3) * 1000) / 1000);
    display_image(window, black, showimg, a, b, 'xy', 'LUM');
    
    forward = 0;
    while ~forward
        [~, keycode, ~] = KbWait();
        keyname = KbName(keycode);
        if strcmp(keyname, 'left') || strcmp(keyname, 'LeftArrow') 
            params.x = params.x - xy_step;
            redraw_image(window, black, cal, img, params);
            
        elseif strcmp(keyname, 'RightArrow')|| strcmp(keyname, 'right')
            params.x = params.x + xy_step;
            redraw_image(window, black, cal, img, params);
            
        elseif strcmp(keyname, 'UpArrow')|| strcmp(keyname, 'up')
            params.y = params.y + xy_step;
            redraw_image(window, black, cal, img, params);
            
        elseif strcmp(keyname, 'DownArrow')|| strcmp(keyname, 'down')
            params.y = params.y - xy_step;
            redraw_image(window, black, cal, img, params);

        elseif strcmp(keyname, 'Return')|| strcmp(keyname, 'ENTER')
            params.LUM = params.LUM + LUM_step;
            redraw_image(window, black, cal, img, params);
            
        elseif strcmp(keyname, 'RightShift')|| strcmp(keyname, 'shift')
            params.LUM = params.LUM - LUM_step;
            redraw_image(window, black, cal, img, params);
            
        else
            forward = 1;
        end
    end
    
    % ---------- End the experiment and cleanup window --------
    cleanup(oldVisualDebugLevel, oldSupressAllWarnings)

catch  %#ok<*CTCH>
   
	cleanup(oldVisualDebugLevel, oldSupressAllWarnings);

	% We throw the error again so the user sees the error description.
	psychrethrow(psychlasterror);
    
end
end

function redraw_image(window, black, cal, img, params)
    import gen.gen_image_sequence
    import gen.gen_show_img
    import stim.display_image
    params = gen_image_sequence(cal, params);
    xyY = [params.x params.y params.LUM];
    showimg = gen_show_img(img, params.color_sequence, 2);
    a = num2str(round(xyY(1:2) * 1000) / 1000);
    b = num2str(round(xyY(3) * 1000) / 1000);
    display_image(window, black, showimg, a, b, 'xy', 'LUM');
    pause(0.2); % prevent 'sticky keys'
end
