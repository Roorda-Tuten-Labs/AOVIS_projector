function run_exp(params)

import gen.gen_hue_order
import fil.check_for_data_dir
import exp.run_forced_choice_exp
import exp.run_adjustment_exp
import stim.setup_window
import stim.show_stimulus
import stim.cleanup

KbName('UnifyKeyNames');

% ---- Make sure directories exist for saving data
check_for_data_dir(params.subject);
    
% ---- Set up window
[window, oldVisualDebugLevel, oldSupressAllWarnings] = setup_window(...
    params.screen);

% Load default calibration file:
cal = LoadCalFile(params.cal_file, [], params.cal_dir);
T_xyz1931 = csvread('ciexyz31.csv')';
S_xyz1931 = [380, 5, 81];
T_xyz1931 = 683 * T_xyz1931;
cal = SetSensorColorSpace(cal, T_xyz1931, S_xyz1931);
cal = SetGammaMethod(cal,0);

if strcmp(params.psych_method, 'forced choice')

    % ---- Randomize the order of blue, yellow settings.
    [first, second] = gen_hue_order();
    try
        % ---- Present first set of stimuli
        [params, ~] = run_forced_choice_exp(window, params, cal, first);

        % ---- Present second set of stimuli
        [params, ~] = run_forced_choice_exp(window, params, cal, second);

        % ---- Present achromatic stimuli
        [params, xyz] = run_forced_choice_exp(window, params, cal, 'white');

        % ---- Show final stimulus
        show_stimulus([xyz(1) xyz(2) params.LUM]', params, window, 0, cal);

        cleanup(params, oldVisualDebugLevel, oldSupressAllWarnings);

    catch  %#ok<*CTCH>

        cleanup(params, oldVisualDebugLevel, oldSupressAllWarnings);
        psychrethrow(psychlasterror);
    end

elseif strcmp(params.psych_method, 'adjustment')
    
    [params, xyz] = run_adjustment_exp(window, params, cal);

elseif strcmp(params.psych_method, 'display')
    [xyz, params] = show_stimulus([params.x params.y params.LUM], ...
        params, cal, window, 1);
end

if ~strcmp(xyz, 'end')
    % ---- Print xyz result for white
    disp('Lum:'); disp(params.LUM);
    disp('xyz:'); disp(xyz);
    disp('uv:'); disp(xyTouv(xyz(1:2)));
else
    cleanup(params, oldVisualDebugLevel, oldSupressAllWarnings);
end