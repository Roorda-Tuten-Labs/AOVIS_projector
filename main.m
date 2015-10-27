clear all; close all;

%%% compute dominant wavelength
%%% inverted sine wave

% ---- Import local files
import white.*

% ---- Add external dependencies to path
fil.add_depend();

% ---- Get parameters for experiment or display stimulus
params = gui.main();

exp.run(params);