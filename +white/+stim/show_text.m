function show_text(window, text1, text2, textSize)
    if nargin < 3
        show_2_texts = 0;
    else
        show_2_texts = 1;
    end
    if nargin < 4
        textSize = 20;
    end
    
    % Retrieves the CLUT color code for black.
    black = BlackIndex(window);
    
    % ---------- Image Display ---------- 
    % Colors the entire window black.
    Screen('FillRect', window, black);
    
    % change text size
    oldTextSize = Screen('TextSize', window, textSize);
    
    % Writes text to the window.
    Screen('DrawText', window, ...
        sprintf('%s', text1), 150, 150, 150);
    if show_2_texts
        Screen('DrawText', window, ...
            sprintf('%s', text2), 150, 200, 150);     
    end
    
    % Updates the screen to reflect our changes to the window.
    Screen('Flip', window);
    
    % reset text size default
    Screen('TextSize', window , oldTextSize);
end