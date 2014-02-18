function display_image(window, black, showimg, left, right, left_text, ...
    right_text)
    if nargin < 6
        left_text = 'left';
    end
    if nargin < 7
        right_text = 'right';
    end
    if nargin < 5
        num_of_print = 1;
    else 
        num_of_print = 2;
    end

    
    % ---------- Image Display ---------- 
    % Colors the entire window gray.
    Screen('FillRect', window, black);
    % Writes the image to the window.
    Screen('PutImage', window, showimg);
    % Writes text to the window.
    currentTextRow = 0;
    if num_of_print == 2
        Screen('DrawText', window, ...
            sprintf([left_text ' = %s, ' right_text  '= %s'], left, ... 
            right), 0, currentTextRow, 150);
    elseif num_of_print == 1
        Screen('DrawText', window, ...
            sprintf([left_text ' = %s'], left), ...
                0, currentTextRow, 150);       
    end
    % Updates the screen to reflect our changes to the window.
    Screen('Flip', window);
        
end