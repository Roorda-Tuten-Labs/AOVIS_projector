function [window, oldVisualDebugLevel, oldSupressAllWarnings] = ...
    setup_window(params)
    
    % Find out how many screens and use largest screen number.
    % whichScreen = max(Screen('Screens'));    

	% ---------- Window Setup ----------
	% Supress checking behavior
	oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
    oldSupressAllWarnings = Screen('Preference', 'SuppressAllWarnings', 1);
    
	% Hides the mouse cursor
    if params.hide_cursor
        HideCursor;
    end

    if params.bits_sharp == 1
        % bits# specific
        mode = 0;
        PsychImaging('PrepareConfiguration');
        PsychImaging('AddTask', 'General', 'FloatPoint32Bit');
        PsychImaging('AddTask', 'General', 'EnableBits++Color++Output', mode);
    end
    
	% Opens a graphics window on the main monitor (screen 0).
    if params.debug_mode
        window = Screen('OpenWindow', 0, [], [0, 0, ...
                            640, 480]);
        ShowCursor;
    else        
        if params.bits_sharp
            window = PsychImaging('OpenWindow', params.screen, 0.5);
        else
            window = Screen('OpenWindow', params.screen);
        end
    end    
    
    Screen('TextSize', window, params.textsize);
    
    LoadIdentityClut(window);
end