clear all; close all;

debug = 1;
%%% compute dominant wavelength
%%% inverted sine wave
%%% add debugging switch to this file (params);

% ---- Import local files
import white.*

% ---- Add external dependencies to path
fil.add_depend();

% ---- Get parameters for experiment or display stimulus
params = gui.main();
params.debug = debug;

exp.run(params);