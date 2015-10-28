function [data_record, fit_params, xyz] = forced_choice_trial(window, ...
    params, cal, close_at_end)
% uniqueHues
%%% white computation (linear spacing) - less yellow bias.

if nargin < 4
    close_at_end = 0;
end

% ---------- import functions from other modules
import white.*

% ---------- Parameter Setup ----------
% Prevents MATLAB from reprinting the source code when the program runs.
echo off

if params.show_plot
    plot_stimuli({'blue' 'yellow' 'white'}, params);
else

% ---------- Gen image sequence --------
params = gen.image_sequence(cal, params);

try 
    % Retrieves the CLUT color code for background.
    background = params.background;  
    
    % ---------- Run the experiment --------
    data_record = zeros(params.ntrials, 5);
    for trial=1:params.ntrials
        
        % 1. display image
        stim.display_image(window, background, params, ...
            params.color_sequence(trial, 1:3), params.left, params.right);
        
        % 2. either present flash or constant stimulus
        if params.constant_stim
            % 2a. get user input
            data_record = exp.get_key_input(cal, data_record, params, trial);
            if strcmp(data_record, 'end')
                fit_params = 'end'; xyz = 'end'; return;
            end
            
            % 2b. show a background screen in between trials
            stim.display_black_screen(window, background, params);
            
            % 2c. keep background screen up for length of pause time
            pause(params.pause_time);
        else
            % 2a. keep stim up for length of pause time
            pause(params.pause_time);
            
            % 2b. show a background screen in between trials
            stim.display_black_screen(window, background, params);
            
            % 2c. show background until user input received.
            data_record = exp.get_key_input(cal, data_record, params, trial);
            if strcmp(data_record, 'end')
                fit_params = 'end'; xyz = 'end'; return;
            end
        end
        
    end
    % ---------- End the experiment and cleanup window --------
    if close_at_end
        stim.cleanup();
    end

    %----------- Fit cum gaussian to estimate mean and sigma -------
    [fit_params, too_short] = fit.gaussian(data_record, params.nrepeats, ...
        params.invert);
    
    %----------- Plot the data -------
    plot.data(data_record, too_short, fit_params, params);
    
    %----------- Compute xyz from mean angle -------
    disp(fit_params);
    mu = fit_params(1);
    xyz = comp.mean_angle_to_xyz(params, mu);
    
catch  %#ok<*CTCH>
   
	% ---------- Error Handling ---------- 
	% If there is an error in our code, we will end up here.
	stim.cleanup();

	% We throw the error again so the user sees the error description.
	psychrethrow(psychlasterror);
    
end
end
end

