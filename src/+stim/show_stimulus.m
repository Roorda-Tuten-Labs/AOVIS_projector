function show_stimulus(xyY)

if nargin < 1
    xyY = input('Subject name [default = sample]', 's');
    if isempty(xyz)
        xyY = [1/3 1/3 40]';
    end
end

cal_file = 'Feb13_2014a';

% Load default calibration file:
cal = LoadCalFile(cal_file);
T_xyz1931 = csvread('ciexyz31.csv')';
S_xyz1931 = [380, 5, 81];

T_xyz1931 = 683 * T_xyz1931;
cal = SetSensorColorSpace(cal, T_xyz1931, S_xyz1931);
cal = SetGammaMethod(cal,0);

%xyY = [x y LUM]';

% Convert to RGB:
XYZ = xyYToXYZ(xyY);
disp(XYZ);
[RGB, outOfRangePixels] = SensorToSettings(cal, XYZ);

% Check for out-of-range non-displayable color values:
if any(outOfRangePixels)
    fprintf('WARNING: Out of range RGB values!\n');
    fprintf('pix = %f\n', outOfRangePixels);
    fprintf('rgb = %f\n', RGB);
end

color_sequence = RGB * 255;
disp(color_sequence);

% ---------- Image Setup ----------
% Stores the image in a three dimensional matrix.
radius = 88; % 10 px / mm. 25 cm viewing distance = 2 deg of vis angle.
img = zeros(radius, radius, 3);
img(:, :, 1) = imcircle(radius);
img(:, :, 2) = imcircle(radius);
img(:, :, 3) = imcircle(radius);

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

    showimg = zeros(size(img));
    for k = 1:3
        showimg(:, :, k) = color_sequence(k) * img(:, :, k);
    end

    display_image(window, black, showimg);
    
    KbWait();
    
    % ---------- End the experiment and cleanup window --------
    cleanup(oldVisualDebugLevel, oldSupressAllWarnings)

catch  %#ok<*CTCH>
   
	cleanup(oldVisualDebugLevel, oldSupressAllWarnings);

	% We throw the error again so the user sees the error description.
	psychrethrow(psychlasterror);
    
end
end

function display_image(window, black, showimg)

    % ---------- Image Display ---------- 
    % Colors the entire window gray.
    Screen('FillRect', window, black);
    % Writes the image to the window.
    Screen('PutImage', window, showimg);
    % Writes text to the window.
    currentTextRow = 0;
    Screen('DrawText', window, ...
        sprintf('%s', 'press any key'), ...
            0, currentTextRow, 150);
    % Updates the screen to reflect our changes to the window.
    Screen('Flip', window);
        
end
