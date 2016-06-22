function display_image(window, background, params, color, left, right, ... 
    left_label, right_label)    
    if nargin < 7
        left_label = 'left';
    end
    if nargin < 8
        right_label = 'right';
    end
    if nargin < 6
        num_of_print = 1;
    else 
        num_of_print = 2;
    end
    import white.*
    
    % ---------- Image Display ---------- 
    % 1. Colors the entire window gray.
    Screen('FillRect', window, background);
    
    % 2a. Create stimulus
    rect = [0, 0, params.img_x, params.img_y];
    rect = CenterRectOnPoint(rect, params.img_offset_x, ...
        params.img_offset_y);

     % 2b. Add eccentricity grid lines if desired.
    if params.add_grid_lines_flag
        stim.add_grid_lines(window, params, rect);
    end
    
    % 2c. Add stimulus to screen
    if params.add_square_flag
        if strcmp(params.stimulus_shape, 'circle')
            Screen('FillOval', window, color, rect);

        elseif strcmp(params.stimulus_shape, 'rectangle')  
            Screen('FillRect', window, color, rect);
        end
    end
    
	% 4. Fixation point
    rect = [0, 0, params.fixation_size, params.fixation_size];
    rect = CenterRectOnPoint(rect, params.fixation_offset_x, ...
        params.fixation_offset_y);
    Screen('FillOval', window, [180 180 180], rect);
    
    % 5. Write text to the window.
    currentTextRow = 0;
    if num_of_print == 2
        Screen('DrawText', window, ...
            sprintf([left_label ' = %s, ' right_label  '= %s'], left, ... 
            right), 0, currentTextRow, 150);
    elseif num_of_print == 1
        Screen('DrawText', window, ...
            sprintf([left_label ' = %s'], left), ...
                0, currentTextRow, 150);       
    end
    
    % 6. Updates the screen to reflect our changes to the window.
    Screen('Flip', window);
        
end