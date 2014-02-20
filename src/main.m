%%% unique white
clear all; close all;
%%% To Do:
%%% compute angle of fixation programmatically
%%% pixelSize=Screen('PixelSize', windowPtrOrScreenNumber);

% ---- Import local files
import fil.add_depend
import gen.gen_params
import gen.gen_hue_order
import fil.check_for_data_dir
import stim.setup_window
import stim.show_stimulus_set
import stim.show_stimulus
import stim.cleanup

% ---- Add external dependencies to path
add_depend();

% ---- Randomize the order of blue, yellow settings.
[first, second] = gen_hue_order();

% ---- Generate default parameters
params = gen_params();

% ---- Call User Interface to change parameters
params = white_gui(params);

% ---- Make sure directories exist for saving data
check_for_data_dir(params.subject);

% ---- Set up window
[window, oldVisualDebugLevel, oldSupressAllWarnings] = setup_window(...
    params.screen);

try
    % ---- Present first set of stimuli
    [params, ~] = show_stimulus_set(window, params, first);

    % ---- Present second set of stimuli
    [params, ~] = show_stimulus_set(window, params, second);

    % ---- Present achromatic stimuli
    [params, xyz] = show_stimulus_set(window, params, 'white');
    
    % ---- Show final stimulus
    show_stimulus([xyz(1) xyz(2) params.LUM]');
    
    cleanup(oldVisualDebugLevel, oldSupressAllWarnings);
    
catch  %#ok<*CTCH>
    
    cleanup(oldVisualDebugLevel, oldSupressAllWarnings);
    psychrethrow(psychlasterror);
end

% ---- Print xyz result for white
disp(xyz);

