function display_image(window, black, showimg, left, right)

    % ---------- Image Display ---------- 
    % Colors the entire window gray.
    Screen('FillRect', window, black);
    % Writes the image to the window.
    Screen('PutImage', window, showimg);
    % Writes text to the window.
    currentTextRow = 0;
    Screen('DrawText', window, ...
        sprintf('left = %s, right = %s', left, right), ...
            0, currentTextRow, 150);
    % Updates the screen to reflect our changes to the window.
    Screen('Flip', window);
        
end