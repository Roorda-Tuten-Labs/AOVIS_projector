clear all; close all;

%%% compute dominant wavelength
%%% inverted sine wave

% ---- Import local files
import fil.add_depend
import gen.gen_params
import exp.run_exp
import gui.gui_exp
import gui.gui_disp
import gui.gui_main

% ---- Add external dependencies to path
add_depend();

% ---- Generate default parameters
params = gen_params();

% ---- Get user decision to display single stim or run experiment
decision = gui_main();

% ---- Call User Interface to change parameters
if strcmp(decision, 'experiment')
    
    params = gui_exp(params);

elseif strcmp(decision, 'display')
    
    params = gui_disp(params);
end

run_exp(params);