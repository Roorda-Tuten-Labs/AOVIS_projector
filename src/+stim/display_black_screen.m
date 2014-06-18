function display_black_screen(window, black, params)   
    % Show black screen in between stim presentations
    
    % ---------- Image Display ---------- 
    % 1. Colors the entire window gray.
    Screen('FillRect', window, black);
    
    gray = GrayIndex(window);
    
    % 2. Fixation point
    rect = [0, 0, 10, 10];
    rect = CenterRectOnPoint(rect, params.fixation_offset_x, ...
        params.fixation_offset_y);
    Screen('FillOval', window, gray, rect);

    
    Screen('Flip', window);
    
end