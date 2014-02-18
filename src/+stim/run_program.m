function [data_record, fit_params, xyz] = run_program(params)
% uniqueHues

% ---------- import functions from other modules
import gen.gen_image_mat
import gen.gen_show_img
import gen.gen_image_sequence
import stim.display_image
import stim.show_stimulus
import stim.cleanup
import stim.get_key_input
import stim.display_black_screen
import fit.fit_gaussian
import comp.mean_angle_to_xyz
import plot.plot_data

% ---------- Parameter Setup ----------
% Prevents MATLAB from reprinting the source code when the program runs.
echo off

if params.show_plot
    plot_stimuli({'blue' 'yellow' 'white'}, params);
else
    
% Load default calibration file:
cal = LoadCalFile(params.cal_file);
T_xyz1931 = csvread('ciexyz31.csv')';
S_xyz1931 = [380, 5, 81];

T_xyz1931 = 683 * T_xyz1931;
cal = SetSensorColorSpace(cal, T_xyz1931, S_xyz1931);
cal = SetGammaMethod(cal,0);

% ---------- Gen image sequence --------
params = gen_image_sequence(cal, params);

% ---------- Image Setup ----------
% Stores the image in a three dimensional matrix.
img = gen_image_mat(params.annulus);

try
    
	% ---------- Window Setup ----------
	% Supress checking behavior
	oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
    oldSupressAllWarnings = Screen('Preference', 'SuppressAllWarnings', 1);
    
    % Find out how many screens and use largest screen number.
    whichScreen = max(Screen('Screens'));
    
	% Hides the mouse cursor
	HideCursor;
	
	% Opens a graphics window on the main monitor (screen 0).
	window = Screen('OpenWindow', whichScreen);
    LoadIdentityClut(window);
    
    % Retrieves the CLUT color code for black.
    black = BlackIndex(window);  
    
    % ---------- Run the experiment --------
    data_record = zeros(params.ntrials, 5);
    for trial=1:params.ntrials
        % 1. add color and fixation
        showimg = gen_show_img(img, params.color_sequence(trial, :), ...
            params.annulus);
        
        % 2. display image
        display_image(window, black, showimg, params.left, params.right);
        
        % 3. either present flash or constant stimulus
        if params.constant_stim
            % 3a. get user input
            data_record = get_key_input(cal, data_record, params, trial);

            % 3b. show a black screen in between trials
            display_black_screen(window, black, img, params);
            
            % 3c. keep black screen up for length of pause time
            pause(params.pause_time);
        else
            % 3a. keep stim up for length of pause time
            pause(params.pause_time);
            
            % 3b. show a black screen in between trials
            display_black_screen(window, black, img, params);
            
            % 3c. show black until user input received.
            data_record = get_key_input(cal, data_record, params, trial);
        end
        
    end
    % ---------- End the experiment and cleanup window --------
    cleanup(oldVisualDebugLevel, oldSupressAllWarnings)

    %----------- Fit cum gaussian to estimate mean and sigma -------
    [fit_params, too_short] = fit_gaussian(data_record, params.nrepeats);
    
    %----------- Plot the data
    plot_data(data_record, too_short, fit_params, params.left, ...
        params.subject);
    
    %----------- Compute xyz from mean angle
    disp(fit_params);
    mu = fit_params(1);
    xyz = mean_angle_to_xyz(params, mu);

catch  %#ok<*CTCH>
   
	% ---------- Error Handling ---------- 
	% If there is an error in our code, we will end up here.
	cleanup(oldVisualDebugLevel, oldSupressAllWarnings);

	% We throw the error again so the user sees the error description.
	psychrethrow(psychlasterror);
    
end
end
end

