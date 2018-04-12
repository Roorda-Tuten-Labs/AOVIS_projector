function [monitor, input_RGB] = collect_calibration(numMeasures)
    % Collect calibration data.
    % To specify COM port, save a file called CMPreferredPort.txt with
    % portstring.
    %
    % USAGE
    % monitor, input_RGB] = collect_calibration(numMeasures)
    %

    if nargin < 1   
        numMeasures = 17; % should be 1 + power of 2 (9, 17, 33, ...)
    end
    bits_sharp = 1;

    % default value for PR650
    S = [380 4 101];

    % ------- Calibrate monitor -------------
    units = 1;
    repeats = 1;
    USBcomPORT = 'COM4';
    [port, status] = PR650_Init(units, repeats, USBcomPORT);
    disp(status);
    

    % Supress checking behavior
    % oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
    % oldSupressAllWarnings = Screen('Preference', 'SuppressAllWarnings', 1)

    psychlasterror('reset');

    % ------ Gamma correction measurement ---------
    % log time
    tic = clock;
    % output
    monitor = zeros(S(3), numMeasures * 3);    
    try
        % Find out how many screens and use largest screen number.
        if ~bits_sharp
            whichScreen = max(Screen('Screens'));
        else
            whichScreen = 2;
        end
        
        % Hides the mouse cursor
        %HideCursor;
       
        if ~bits_sharp
            % Open black window:
            win = Screen('OpenWindow', whichScreen, 0);
            Screen('FillRect', win, [255 255 255]);        
            
        else            
            % bits# specific
            mode = 0;
            PsychImaging('PrepareConfiguration');
            PsychImaging('AddTask', 'General', 'FloatPoint32Bit');
            PsychImaging('AddTask', 'General', 'EnableBits++Color++Output', mode);
            win = PsychImaging('OpenWindow', whichScreen);
            Screen('FillRect', win, 1);
        end 

        % display white screen for user to setup photometer.
        
        Screen('Flip', win);        
        
        % set up voltages.
        maxLevel = Screen('ColorRange', win);

        if ~bits_sharp
            inputV = [0:(maxLevel + 1) / (numMeasures - 1):(maxLevel+1)]; %#ok<NBRAK>
            inputV(end) = maxLevel;
        else
            inputV = linspace(0, 1, numMeasures);
        end

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
            Screen('FillRect', win, input_RGB(ind, :));
            Screen('Flip', win);

            % take the measurement. put it into index corresponding to RGB.
            %monitor(:, ind) = MeasSpd(S, 1, 'off');
            data = PR650_MeasureAll(port, repeats);
            monitor(:, ind) = data.spectral_data;

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