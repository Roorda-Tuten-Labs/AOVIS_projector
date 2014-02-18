function cleanup(oldVisualDebugLevel, oldSupressAllWarnings)

    if nargin < 2
        oldSupressAllWarnings = 0;
    end
    if nargin < 1
        oldVisualDebugLevel = 4;
    end
    
    % Closes all windows.
    Screen('CloseAll');
    
    % Restore normal CLUTS
    RestoreCluts;
    
    % Restores the mouse cursor.
    ShowCursor;

    % Restore preferences
    Screen('Preference', 'VisualDebugLevel', oldVisualDebugLevel);
    Screen('Preference', 'SuppressAllWarnings', oldSupressAllWarnings);
end