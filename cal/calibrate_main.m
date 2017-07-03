clearvars;
close all;

% Create calibration structure;
cal = [];

% Script parameters
cal.describe.whichScreen = 0; % Enter screen
cal.describe.nAverage = 1; % currently only handles 1. should add this option in the future.
cal.describe.nMeas = 65; % should be power of 2 + 1 (i.e. 9, 17, 33, 65)
cal.nDevices = 3; % LEDs
cal.nPrimaryBases = 1; % No idea what this does
cal.describe.S = [380 4 101]; % default for PR650
cal.manual.use = 0; % use automated routine
cal.manual.photometer = 0;
cal.describe.gamma.fitType = 'sigmoid';

% Find out about screen
cal.describe.dacsize = ScreenDacBits(cal.describe.whichScreen);
% This is used below when cubic interpolating the LUT. Must be based on the
%  bit depth of the graphics card.
nLevels = 2 ^ cal.describe.dacsize;

% --- Fill in descriptive information --- %
computerInfo = Screen('Computer');
hz = Screen('NominalFrameRate', cal.describe.whichScreen);
cal.describe.caltype = 'monitor';
if isfield(computerInfo, 'consoleUserName')
    cal.describe.computer = sprintf('%s''s %s, %s', ...
        computerInfo.consoleUserName, computerInfo.machineName, ...
        computerInfo.system);
else
    % Better than nothing:
    cal.describe.computer = OSName;
end
cal.describe.driver = sprintf('%s %s','unknown_driver','unknown_driver_version');
cal.describe.hz = hz;
cal.describe.program = sprintf('calibration.m, background set to [%g,%g,%g]',...
                               cal.bgColor(1), cal.bgColor(2), cal.bgColor(3));
cal.describe.who = input('Enter your name: ','s');

% Fitting parameters
cal.describe.gamma.fitType = 'cubic interpolation';
% -------------------------------------- %

% ---- Get input from user ---- %
cal.describe.monitor = input('Enter monitor name: ','s');
cal.describe.date = sprintf('%s %s',date,datestr(now,14));
cal.describe.comment = input('Describe the calibration: ','s');

% name of the calibration that will be used for saving
defaultFileName = 'monitor';
thePrompt = sprintf('Enter calibration filename (for saving) [%s]: ',...
    defaultFileName);
newFileName = input(thePrompt,'s');
if isempty(newFileName)
    newFileName = defaultFileName;
end

% Get distance from meter to screen.
% NOTE: for Maxwellian view, need to consider what to write here. This is
% presumably important for luminance computation.
defDistance = 1;
% theDataPrompt = sprintf(...
%     'Enter distance from meter to screen (in meters): [%g]: ', defDistance);
cal.describe.meterDistance = []; %input(theDataPrompt);
if isempty(cal.describe.meterDistance)
  cal.describe.meterDistance = defDistance;
end

% Prompt for background values.  The default is a guess as to what
% produces one-half of maximum output for a typical CRT.
% NOTE: Not sure exactly what this is used for.
defBgColor = [190 190 190]' / 255;
% thePrompt = sprintf(...
% 'Enter RGB values for background (range 0-1) as a row vector [%0.3f %0.3f %0.3f]: ',...
%                     defBgColor(1), defBgColor(2), defBgColor(3));
while 1
	cal.bgColor = []; %input(thePrompt)';
	if isempty(cal.bgColor)
		cal.bgColor = defBgColor;
	end
	[m, n] = size(cal.bgColor);
	if m ~= 3 || n ~= 1
		fprintf(...
        '\nMust enter values as a row vector (in brackets).  Try again.\n');
    elseif (any(defBgColor > 1) || any(defBgColor < 0))
        fprintf('\nValues must be in range (0-1) inclusive.  Try again.\n');
    else
		break;
	end
end

% -------------------------------------- %
% This is where the measurements happen.
[cal_data, input_RGB] = collect_calibration(cal.describe.nMeas);

% Now analyze the measurements
% ---- fill in ambient parameters
ambient_index = ~any(input_RGB, 2);
mean_ambient = mean(cal_data(:, ambient_index), 2);

% ---- Subtract off ambient light from each measurment
corrected_data = zeros(cal.describe.S(3), cal.describe.nMeas * 3);
non_ambient = any(input_RGB, 2);
for j=1:cal.describe.nMeas * 3
    corrected_data(:, j) = cal_data(:, j) - mean_ambient;
end

% change into a n by 3 matrix.
corrected_data = reshape(corrected_data, ...
    cal.describe.S(3) * cal.describe.nMeas, cal.nDevices);

% Pre-process data to get rid of negative values.
corrected_data = EnforcePos(corrected_data);
cal.rawdata.mon = corrected_data;

cal.P_ambient = mean_ambient;
cal.S_ambient = cal.S_device;
cal.T_ambient = eye(cal.describe.S(3));

% Use data to compute best spectra according to desired
% linear model.  We use SVD to find the best linear model,
% then scale to best approximate maximum
disp('Computing linear models');
cal = CalibrateFitLinMod(cal);

% ------- Fit gamma functions. -------- %
if strcmp(cal.describe.gamma.fitType, 'interp')
    % Define input settings for the measurements
    mGammaInputRaw = linspace(0, 1, cal.describe.nMeas+1)';
    mGammaInputRaw = mGammaInputRaw(2:end);

    %cal.rawdata.rawGammaInput = mGammaInputRaw;

    mGammaMassaged = cal.rawdata.rawGammaTable(:,1:cal.nDevices);
    for i = 1:cal.nDevices
        mGammaMassaged(:,i) = MakeGammaMonotonic(HalfRect(mGammaMassaged(:,i)));
    end

    mGammaMassaged = NormalizeGamma(mGammaMassaged);
    %cal = CalibrateFitGamma(cal, 2^cal.describe.dacsize);

    %Gamma function fittings
    gammaInputFit = linspace(0, 1, nLevels)';
    % append 0 at beginning so cubic fitting goes to 0
    r_table = interp1([0 mGammaInputRaw']', [0 mGammaMassaged(:, 1)'], ...
        gammaInputFit, 'pchip');
    g_table = interp1([0 mGammaInputRaw']', [0 mGammaMassaged(:, 2)']', ...
        gammaInputFit, 'pchip');
    b_table = interp1([0 mGammaInputRaw']', [0 mGammaMassaged(:, 3)']', ...
        gammaInputFit, 'pchip');

    cal.gammaInput = gammaInputFit;
    cal.gammaTable = [r_table g_table b_table];
else
    cal = CalibrateFitGamma(cal, nLevels);
end

fprintf(1, '\nSaving to %s.mat\n', newFileName);
%SaveCalFile(cal, newFileName);
SaveCalFile(cal, newFileName, 'files');
    
plot_cal_data(cal);

