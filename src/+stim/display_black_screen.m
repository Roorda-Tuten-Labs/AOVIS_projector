function display_black_screen(window, black)   
    % Show black screen in between stim presentations
    
    Screen('FillRect', window, black);
    Screen('Flip', window);
    
end