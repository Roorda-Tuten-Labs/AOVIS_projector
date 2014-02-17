
% ------- Calibrate monitor -------------

% Supress checking behavior
oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
oldSupressAllWarnings = Screen('Preference', 'SuppressAllWarnings', 1);
    
% Find out how many screens and use largest screen number.
whichScreen = max(Screen('Screens'));
% Hides the mouse cursor
HideCursor;

% Opens a graphics window on the main monitor (screen 0).
window = Screen('OpenWindow', whichScreen);


% ------ Gamma correction measurement ---------
numMeasures = 17; % should be 1 + power of 2 (9, 17, 33, ...)

input(sprintf(['When black screen appears, point photometer, \n' ...
       'get reading in cd/m^2, input reading using numpad, press enter. \n' ...
       'A screen of higher luminance will be shown. Repeat %d times. ' ...
       'Press enter to start'], numMeasures));

psychlasterror('reset');    
try
    screenid = max(Screen('Screens'));

    % Open black window:
    win = Screen('OpenWindow', screenid, 0);
    maxLevel = Screen('ColorRange', win);

    % Load identity gamma table for calibration:
    LoadIdentityClut(win);

    inputV = [0:(maxLevel + 1) / (numMeasures - 1):(maxLevel+1)]; %#ok<NBRAK>
    inputV(end) = maxLevel;
    
    r_vals = []; b_vals = []; g_vals = [];
    for i = inputV
        Screen('FillRect',win, [i 0 0]);
        Screen('Flip',win);

        fprintf('Value? ');
        resp = GetNumber;
        fprintf('\n');
        r_vals = [r_vals resp]; %#ok<AGROW>
    end

    for i = inputV
        Screen('FillRect',win, [0 i 0]);
        Screen('Flip',win);

        fprintf('Value? ');
        resp = GetNumber;
        fprintf('\n');
        g_vals = [g_vals resp]; %#ok<AGROW>
    end

    for i = inputV
        Screen('FillRect',win, [0 0 i]);
        Screen('Flip',win);

        fprintf('Value? ');
        resp = GetNumber;
        fprintf('\n');
        b_vals = [b_vals resp]; %#ok<AGROW>
    end
    
    % Restore normal gamma table and close down:
    RestoreCluts;
    Screen('CloseAll');
catch %#ok<*CTCH>
    RestoreCluts;
    Screen('CloseAll');
    psychrethrow(psychlasterror);
end

rawGammaTable = [r_vals' g_vals' b_vals'];
inputV = inputV / maxLevel;

for i=1:3
    %Normalize values
    table = rawGammaTable(:, i);
    displayRange = range(table);
    displayBaseline = min(table);
    rawGammaTable(:, i) = (table - displayBaseline) / displayRange;
    
end


% try
%     %%% measure ambient background 3 times. Stay on until press any button.
%     [window, screenRect] = PsychImaging('OpenWindow', ...
%         cal.describe.whichScreen);
%     theClut = Screen('ReadNormalizedGammaTable', window);
%     %theClut(2,:) = [1 0 0]'; %settings(:, i)';
%     Screen('LoadNormalizedGammaTable',window, theClut);
% 
%     %%%% black
%     Screen('FillRect', window, 0);
%     Screen('Flip',win);
%     foo = GetNumber;
%     
%     %%%% white
%     Screen('FillRect', window, 1);
%     Screen('Flip',win);
%     foo = GetNumber;
% 
%     % Restore normal gamma table and close down:
%     RestoreCluts;
%     Screen('CloseAll');
% catch %#ok<*CTCH>
%     RestoreCluts;
%     Screen('CloseAll');
%     psychrethrow(psychlasterror);
% end


try
    %%% measure ambient background 3 times. Stay on until press any button.
    [window, screenRect] = PsychImaging('OpenWindow', ...
        cal.describe.whichScreen);
    theClut = Screen('ReadNormalizedGammaTable', window);
    theClut(2,:) = [1 0 0]'; %settings(:, i)';
    Screen('LoadNormalizedGammaTable',window, theClut);


    % ---------- Image Setup ----------
    % Stores the image in a three dimensional matrix.
    radius = 80; % 8 mm
    img = zeros(radius, radius, 3);
    img(:, :, 1) = imcircle(radius);
    img(:, :, 2) = imcircle(radius);
    img(:, :, 3) = imcircle(radius);
    
    RGB = [1 0 0; 0 1 0; 0 0 1];
    %vals = [];
    for i=1:length(RGB)
        
        showimg = zeros(size(img));
        for k = 1:3
            showimg(:, :, k) = RGB(i, k) * img(:, :, k);
        end
        theClut(2,:) = RGB(i, :)'; %settings(:, i)';
        Screen('LoadNormalizedGammaTable',window, theClut);
        Screen('FillRect', window, 0);
        % Writes the image to the window.
        Screen('PutImage', window, showimg);
        
        % Updates the screen to reflect our changes to the window.
        Screen('Flip', window);

        foo = GetNumber;
        %vals = [vals resp];
    end

    % Restore normal gamma table and close down:
    RestoreCluts;
    Screen('CloseAll');
catch %#ok<*CTCH>
    RestoreCluts;
    Screen('CloseAll');
    psychrethrow(psychlasterror);
end