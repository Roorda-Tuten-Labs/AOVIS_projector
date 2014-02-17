function cleanup(oldVisualDebugLevel, oldSupressAllWarnings)
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