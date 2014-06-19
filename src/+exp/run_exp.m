function run_exp(params)

import gen.gen_hue_order
import fil.check_for_data_dir
import exp.run_forced_choice_exp
import exp.run_adjustment_exp
import stim.setup_window
import stim.show_stimulus
import stim.cleanup

KbName('UnifyKeyNames');

% ---- Set up window
[window, oldVisualDebugLevel, oldSupressAllWarnings] = setup_window(...
    params.screen);
    
if strcmp(params.psych_method, 'forced choice')

    % ---- Randomize the order of blue, yellow settings.
    [first, second] = gen_hue_order();
    try
        % ---- Present first set of stimuli
        [params, ~] = run_forced_choice_exp(window, params, first);

        % ---- Present second set of stimuli
        [params, ~] = run_forced_choice_exp(window, params, second);

        % ---- Present achromatic stimuli
        [params, xyz] = run_forced_choice_exp(window, params, 'white');

        % ---- Show final stimulus
        show_stimulus([xyz(1) xyz(2) params.LUM]', params, window, 0);

        cleanup(oldVisualDebugLevel, oldSupressAllWarnings);

    catch  %#ok<*CTCH>

        cleanup(oldVisualDebugLevel, oldSupressAllWarnings);
        psychrethrow(psychlasterror);
    end

elseif strcmp(params.psych_method, 'adjustment')
    
    [params, xyz] = run_adjustment_exp(window, params);
        
end

if ~strcmp(xyz, 'end')
    % ---- Print xyz result for white
    disp('Lum:'); disp(params.LUM);
    disp('xyz:'); disp(xyz);
    disp('uv:'); disp(xyTouv(xyz(1:2)));
else
    cleanup(oldVisualDebugLevel, oldSupressAllWarnings);
end