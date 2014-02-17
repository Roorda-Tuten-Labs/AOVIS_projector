%%% unique white

%%% To Do:
%%% do not exit in between trials.
%%% get more user data - write as function.
%%% make stim/show_stimulus adjustable w/ arrow

% ---- Import local files
import stim.uniqueHues
import fil.save_to_file
import fil.check_for_data_dir
import fil.add_depend
import gen.gen_hue_order
import gen.gen_params

% ---- Add external dependencies to path
add_depend();

subject = input('Subject name [default = sample]', 's');
if isempty(subject)
    subject = 'sample';
end
annulus = 0;
show_plot = 0;
constant_stim = 1;
pause_time = 1.0;

% ---- Make sure directories exist for saving data
check_for_data_dir(subject);

% ---- Randomize the order of blue, yellow settings.
[first, second] = gen_hue_order();

% ---- Present first set of stimuli
params = gen_params(first, show_plot, 0, 0, annulus, subject, ...
    constant_stim);
[data_record, blu_angle, blu] = uniqueHues(params);
save_to_file(data_record, subject, first, params);

% ---- Present second set of stimuli
params = gen_params(second, show_plot, 0, 0, annulus, subject, ...
    constant_stim);
[data_record, yel_angle, yel] = uniqueHues(params);
save_to_file(data_record, subject, second, params);

% ---- Present achromatic stimuli
params = gen_params('white', show_plot, blu_angle(1), yel_angle(1), ...
    annulus, subject, constant_stim);
[data_record, ~, xyz] = uniqueHues(params);
save_to_file(data_record, subject, 'white', params);
disp(xyz);

