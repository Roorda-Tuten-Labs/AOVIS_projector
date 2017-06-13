function [monitor, input_RGB] = collect_calibration(numMeasures)
    % Collect calibration data.
    %
    % USAGE
    % monitor, input_RGB] = collect_calibration(numMeasures)
    %

    if nargin < 1   
        numMeasures = 17; % should be 1 + power of 2 (9, 17, 33, ...)
    end

    % default value for PR650
    S = [380 4 101];

    % ------- Calibrate monitor -------------
    CMCheckInit(1);

    % Supress checking behavior
    % oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
    % oldSupressAllWarnings = Screen('Preference', 'SuppressAllWarnings', 1);

    
    input(sprintf(['When white screen appears, setup photometer, \n' ...
           'When ready press any button to start. You will have. \n' ...
           '10 sec to leave the room if desired'], numMeasures*3));

    psychlasterror('reset');

    % ------ Gamma correction measurement ---------
    % log time
    tic = clock;
    % output
    monitor = zeros(S(3), numMeasures * 3);    
    try
        % Find out how many screens and use largest screen number.
        whichScreen = max(Screen('Screens'));
        % Hides the mouse cursor
        HideCursor;

        % Open black window:
        win = Screen('OpenWindow', whichScreen, 0);

        % display white screen for user to setup photometer.
        Screen('FillRect', win, [255 255 255]);
        Screen('Flip', win);        
        
        % wait for user input
        input('');
        
        % wait for user to leave room
        pause(10.0);
        
        % set up voltages.
        maxLevel = Screen('ColorRange', win);

        inputV = [0:(maxLevel + 1) / (numMeasures - 1):(maxLevel+1)]; %#ok<NBRAK>
        inputV(end) = maxLevel;

        % set up RGB values to measure.
        input_RGB = zeros(length(inputV) * 3, 3);
        for rgb = 1:3
            input_RGB(1 + ((rgb - 1) * length(inputV)):length(inputV) *...
                rgb, rgb) = inputV;
        end

        % Load identity gamma table for calibration:
        LoadIdentityClut(win);

        % the main loop. cycle through voltages and take measurements.
        randomindex = randperm(size(input_RGB, 1));
        for j = 1:size(input_RGB, 1)
            % randomize which RGB to display
            ind = randomindex(j);
            
            % display RGB values
            Screen('FillRect',win, input_RGB(ind, :));
            Screen('Flip', win);

            % take the measurement. put it into index corresponding to RGB.
            monitor(:, ind) = MeasSpd(S, 1, 'off');

        end

        % Restore normal gamma table and close down:
        RestoreCluts;
        Screen('CloseAll');
        

    % Report time
    toc = clock;
    fprintf('CalibrateMonDrvr measurements took %g minutes\n', ...
        etime(toc, tic) / 60);

    catch %#ok<*CTCH>
        RestoreCluts;
        Screen('CloseAll');
        psychrethrow(psychlasterror);
    end

end