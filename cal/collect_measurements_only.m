function monitor = collect_measurements_only(numMeasures)
    % Collect calibration data.
    %
    % USAGE
    % monitor, input_RGB] = collect_calibration(numMeasures)
    %

    if nargin < 1   
        numMeasures = 9; % should be 1 + power of 2 (9, 17, 33, ...)
    end

    % default value for PR650
    S = [380 4 101];

    % ------- Calibrate monitor -------------
    CMCheckInit(1);

    % Supress checking behavior
    % oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
    % oldSupressAllWarnings = Screen('Preference', 'SuppressAllWarnings', 1);

    
    disp('Press button to begin each measurement');


    % ------ Gamma correction measurement ---------

    % output
    monitor = zeros(S(3), numMeasures * 3);

    % the main loop. take measurements.
    for j = 1:size(monitor, 2)

        % wait for user input
        input('');
        disp(['beginning ' num2str(j) ' of ' num2str(numMeasures * 3)]);

        % take the measurement. put it into index corresponding to RGB.
        monitor(:, j) = MeasSpd(S, 1, 'off');
        
        disp('completed measurement');

    end
        
    save('data/aaxa_HD_13July2017manual2', 'monitor')
end