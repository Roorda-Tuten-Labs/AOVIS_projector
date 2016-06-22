clearvars; close all;

debug_mode = 0;
%%% compute dominant wavelength
%%% inverted sine wave

% ---- Import local files
import white.*

% ---- Add external dependencies to path
fil.add_depend();

% ---- Get parameters for experiment or display stimulus

%params = gui.main();
params = gui.disp(); % only disp stimulus
params.debug_mode = debug_mode;

exp.run(params);