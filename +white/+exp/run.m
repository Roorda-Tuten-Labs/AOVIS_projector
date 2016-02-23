function run(params)

import white.*

% ---- Make sure key names are the same across systems
KbName('UnifyKeyNames');

% ---- Make sure directories exist for saving data
fil.check_for_data_dir(params.subject);
    
% ---- Set up window
[window, oldVisualDebugLevel, oldSupressAllWarnings] = stim.setup_window(...
    params.screen, params.textsize, params.debug);

% ---- Load calibration file:
cal = gen.cal_struct(params.cal_file, params.cal_dir);

if strcmp(params.psych_method, 'forced choice')

    % ---- Randomize the order of blue, yellow settings.
    [first, second] = gen.hue_order();
    try
        % ---- Present first set of stimuli
        [params, ~] = exp.run_forced_choice_exp(window, params, cal, first);

        % ---- Present second set of stimuli
        [params, ~] = exp.run_forced_choice_exp(window, params, cal, second);

        % ---- Present achromatic stimuli
        [params, xyz] = exp.run_forced_choice_exp(window, params, cal, 'white');

        % ---- Show final stimulus
        stim.show_stimulus([xyz(1) xyz(2) params.LUM]', params, window, 0, cal);

        stim.cleanup(params, oldVisualDebugLevel, oldSupressAllWarnings);

    catch  %#ok<*CTCH>

        stim.cleanup(params, oldVisualDebugLevel, oldSupressAllWarnings);
        psychrethrow(psychlasterror);
    end

elseif strcmp(params.psych_method, 'adjustment')
    
    [params, xyz] = exp.run_adjustment_exp(window, params, cal);

elseif strcmp(params.psych_method, 'display')
    [xyz, params] = stim.show_stimulus([params.x params.y params.LUM], ...
        params, cal, window, 1, 1);
end

if ~strcmp(xyz, 'end')
    % ---- Print xyz result for white
    disp('Lum:'); disp(params.LUM);
    disp('xyz:'); disp(xyz);
    disp('uv:'); disp(xyTouv(xyz(1:2)));
else
    stim.cleanup(params, oldVisualDebugLevel, oldSupressAllWarnings);
end