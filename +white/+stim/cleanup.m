function cleanup(params, oldVisualDebugLevel, oldSupressAllWarnings)

    if nargin < 3
        oldSupressAllWarnings = 0;
    end
    if nargin < 2
        oldVisualDebugLevel = 4;
    end
    if nargin < 1
        save_params = 0;    
    else
        save_params = params.save_params;
    end
    
    if save_params == 1
        save ./param/default_params.mat params
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