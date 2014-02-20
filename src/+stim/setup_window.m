function [window, oldVisualDebugLevel, oldSupressAllWarnings] = ...
    setup_window(whichScreen, textSize)
    
    if nargin < 1
        % Find out how many screens and use largest screen number.
        whichScreen = max(Screen('Screens'));
    end
    if nargin < 2
        textSize = 20;
    end
    
	% ---------- Window Setup ----------
	% Supress checking behavior
	oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
    oldSupressAllWarnings = Screen('Preference', 'SuppressAllWarnings', 1);
    
	% Hides the mouse cursor
	HideCursor;
	
	% Opens a graphics window on the main monitor (screen 0).
	window = Screen('OpenWindow', whichScreen);
    
    Screen('TextSize', window, textSize);
    
    LoadIdentityClut(window);
end