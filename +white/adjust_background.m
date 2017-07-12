function [params, window, cal] = adjust_background(subject, save_dir, ...
    close_window_at_end, debug_mode)
%
%
%
if nargin < 1
    subject = '';
end
if nargin < 2 || isempty(save_dir)
    save_dir = '';
end
if nargin < 3
    % default is to clean up and close window
    close_window_at_end = 1;
end   
if nargin < 4
    debug_mode = 0;
end

% ---- Import local files
import white.*

% ---- Get parameters for experiment or display stimulus
params = gui.disp(subject);

% append params structure with additional fields if desired
if ~isempty(save_dir)
    params.save_dir = save_dir;
end
if debug_mode
    params.debug_mode = 1;
end

if params.screen > 0
    hide_cursor = 0;
else
    hide_cursor = 1;   
end

try
    % ---- Set up window
    [window, oldVisualDebugLevel, oldSupressAllWarnings] = stim.setup_window(...
        params.screen, params.textsize, hide_cursor, params.debug_mode);

    % ---- Load calibration file:
    cal = gen.cal_struct(params.cal_file, params.cal_dir);

    % ---- Show stimulus
    [~, params] = stim.control_image(params, cal, window, ...
        close_window_at_end, 1);
        
    if close_window_at_end
        stim.cleanup(params, oldVisualDebugLevel, oldSupressAllWarnings);
    end
    
catch  %#ok<*CTCH>
   
	stim.cleanup(params);

	% We throw the error again so the user sees the error description.
	psychrethrow(psychlasterror);
    
end