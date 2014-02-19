function show_text(window, text1, text2)
    if nargin < 3
        show_2_texts = 0;
    else
        show_2_texts = 1;
    end
    % Retrieves the CLUT color code for black.
    black = BlackIndex(window);
    
    % ---------- Image Display ---------- 
    % Colors the entire window black.
    Screen('FillRect', window, black);
    
    % Writes text to the window.
    Screen('DrawText', window, ...
        sprintf('%s', text1), 150, 150, 150);
    if show_2_texts
        Screen('DrawText', window, ...
            sprintf('%s', text2), 150, 200, 150);     
    end
    % Updates the screen to reflect our changes to the window.
    Screen('Flip', window);
        
end