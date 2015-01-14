clear all; close all;

%%% compute dominant wavelength
%%% inverted sine wave

% ---- Import local files
import white.*

% ---- Add external dependencies to path
fil.add_depend();

% ---- Generate default parameters
params = gen.default_params();

% ---- Get user decision to display single stim or run experiment
decision = gui.main();

% ---- Call User Interface to change parameters
if strcmp(decision, 'experiment')
    
    params = gui.exp(params);

elseif strcmp(decision, 'display')
    
    params = gui.disp(params);
end

exp.run(params);