%%% unique white
clear all; close all;
%%% To Do:
%%% compute angle of fixation programmatically
%%% add in method of adjustment option, use Luv space.
%%% add in offset term.
%%% compute chromatic angle in DLK space 
%%% compute dominant wavelength

% ---- Import local files
import fil.add_depend
import gen.gen_params
import fil.check_for_data_dir
import stim.run_exp
import stim.cleanup

% ---- Add external dependencies to path
add_depend();

% ---- Generate default parameters
params = gen_params();

% ---- Call User Interface to change parameters
params = white_gui(params);

% ---- Make sure directories exist for saving data
check_for_data_dir(params.subject);

run_exp(params);

cleanup();