clearvars; close all;

debug_mode = 0;

% ---- Import local files
import white.*

% ---- Add external dependencies to path
fil.add_depend();

% ---- Get parameters for experiment or display stimulus
params = gui.disp(); % only disp stimulus
params.debug_mode = debug_mode;

try
    % ---- Set up window
    [window, oldVisualDebugLevel, oldSupressAllWarnings] = stim.setup_window(...
        params.screen, params.textsize, params.debug_mode);

    % ---- Load calibration file:
    cal = gen.cal_struct(params.cal_file, params.cal_dir);

    % ---- Show stimulus
    [xyz, params] = stim.show_stimulus([params.x params.y params.LUM], ...
            params, cal, window, 1, 1);
    
catch  %#ok<*CTCH>
   
	stim.cleanup();

	% We throw the error again so the user sees the error description.
	psychrethrow(psychlasterror);
    
end