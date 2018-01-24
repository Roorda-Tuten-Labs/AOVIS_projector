function [window, oldVisualDebugLevel, oldSupressAllWarnings] = ...
    setup_window(whichScreen, textSize, hide_cursor, debug_mode, bits_sharp)
    
    if nargin < 1
        % Find out how many screens and use largest screen number.
        whichScreen = max(Screen('Screens'));
    end
    if nargin < 2
        textSize = 20;
    end
    if nargin < 3
        hide_cursor = 1;
    end
    if nargin < 4
        debug_mode = 1;
    end
    if nargin < 5
        bits_sharp = 0;
    end
    
	% ---------- Window Setup ----------
	% Supress checking behavior
	oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
    oldSupressAllWarnings = Screen('Preference', 'SuppressAllWarnings', 1);
    
	% Hides the mouse cursor
    if hide_cursor
        HideCursor;
    end

    if bits_sharp == 1
        % bits# specific
        mode = 0;
        PsychImaging('PrepareConfiguration');
        PsychImaging('AddTask', 'General', 'FloatPoint32Bit');
        PsychImaging('AddTask', 'General', 'EnableBits++Color++Output', mode);
    end
    
	% Opens a graphics window on the main monitor (screen 0).
    if debug_mode
        window = Screen('OpenWindow', whichScreen, [], [0, 0, ...
                            640, 480]);
    else
        
        if bits_sharp
            window = PsychImaging('OpenWindow', whichScreen, 0.5);
        else
            window = Screen('OpenWindow', whichScreen);
        end
    end    
    
    Screen('TextSize', window, textSize);
    
    LoadIdentityClut(window);
end