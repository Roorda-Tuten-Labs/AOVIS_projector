function show_text(window, black, text)

    % ---------- Image Display ---------- 
    % Colors the entire window gray.
    Screen('FillRect', window, black);
    % Writes text to the window.
    currentTextRow = 0;
    Screen('DrawText', window, ...
        sprintf('%s', text), 150, 150, 150);
    % Updates the screen to reflect our changes to the window.
    Screen('Flip', window);
        
end