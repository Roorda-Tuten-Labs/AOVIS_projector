%%% unique white
clear all; close all;
%%% To Do:
%%% do not exit in between trials.
%%% make better quit function.

% ---- Import local files
import stim.run_program
import fil.save_to_file
import fil.check_for_data_dir
import fil.add_depend
import gen.gen_hue_order
import gen.gen_params
import gen.gen_hue_specific_params

% ---- Add external dependencies to path
add_depend();

% ---- Randomize the order of blue, yellow settings.
[first, second] = gen_hue_order();

% ---- Generate default parameters
params = gen_params();

% ---- Call User Interface to change parameters
params = white_gui(params);
params.ntrials = params.ncolors * params.nrepeats;

% ---- Make sure directories exist for saving data
check_for_data_dir(params.subject);

% ---- Present first set of stimuli
params = gen_hue_specific_params(first, params); % disp(params);
[data_record, first_angle, blu] = run_program(params);
save_to_file(data_record, params.subject, first, params);

% ---- Present second set of stimuli
params= gen_hue_specific_params(second, params);
[data_record, sec_angle, yel] = run_program(params);
save_to_file(data_record, params.subject, second, params);

% ---- Present achromatic stimuli
params = gen_hue_specific_params('white', params);
[data_record, ~, xyz] = run_program(params);
save_to_file(data_record, params.subject, 'white', params);

% ---- Print xyz result
disp(xyz);

