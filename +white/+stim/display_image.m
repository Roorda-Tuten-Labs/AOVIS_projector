function display_image(window, cal, params, image_matrix)    
    % 
    % USAGE
    % display_image(window, cal, params, image_matrix) 
    %

    if nargin < 4 || isempty(image_matrix)
        % no image passed, so none to show. 
        params.add_image_flag = 0; 
        image_matrix = [];
    end
    import white.*
    
    % ---------- Image Display ---------- 
    % 1. Colors the entire window gray.
    Screen('FillRect', window, params.background);

    % 2. Load image if desired
    if params.add_fundus_image_flag && ~isempty(image_matrix)
        [ysize, xsize, ~] = size(image_matrix);
        rect = [0, 0, params.fundus_img_scale * xsize, ...
            params.fundus_img_scale * ysize];
        rect = CenterRectOnPoint(rect, params.fundus_img_offset_x, ...
            params.fundus_img_offset_y);
        % check to see if rectangle is off left or upper side of screen and
        % adjust accordingly if so.
        if rect(1) < 0
            desiredsize = params.fundus_img_scale * xsize;
            maxsize = desiredsize + rect(1);
            size_diff_rel = maxsize / desiredsize;
            image_matrix = image_matrix(:, xsize - floor(xsize * size_diff_rel):end);
            rect(1) = 0;
        end        
        if rect(2) < 0
            desiredsize = params.fundus_img_scale * ysize;
            maxsize = desiredsize + rect(2);
            size_diff_rel = maxsize / desiredsize;
            image_matrix = image_matrix(ysize - floor(ysize * size_diff_rel):end, :);
            rect(2) = 0;
        end
        
        image_matrix = imrotate(image_matrix, params.image_rot, 'crop');        
        Screen('PutImage', window, fliplr(image_matrix), rect);
    end
    
    % 3a. Create stimulus
    rect = [0, 0, params.img_x, params.img_y];
    rect = CenterRectOnPoint(rect, params.img_offset_x, ...
        params.img_offset_y);
    
    % 3b. Add eccentricity grid lines if desired.
    if params.add_grid_lines_flag
        stim.add_grid_lines(window, params, rect);
    end
    
    % 3c. Add stimulus to screen
    if params.add_square_flag
        xyY = [params.x params.y params.LUM];
        rgb = convert.chrom_to_projector_RGB(cal, xyY, params.color_space);
        if strcmp(params.stimulus_shape, 'circle')
            Screen('FillOval', window, rgb, rect);

        elseif strcmp(params.stimulus_shape, 'rectangle')  
            Screen('FillRect', window, rgb, rect);
        end
    end
    
    if params.add_match_flag
        rect = CenterRectOnPoint(rect, params.img_offset_x + params.img_x + 10, ...
            params.img_offset_y);
        xyY = [params.match_CIEx params.match_CIEy params.match_LUM];
        rgb = convert.chrom_to_projector_RGB(cal, xyY, params.color_space);
        
        Screen('FillRect', window, rgb, rect);
    end
    
    if params.add_pins_flag && ~isempty(params.pin_locations)
        for p = 1:length(params.pin_locations(:, 1))
            pin = params.pin_locations(p, :);
            rect = [0, 0, 4, 4]; % pin size set here (index 3&4).
            rect = CenterRectOnPoint(rect, pin(1), pin(2));
            Screen('FillOval', window, [200 200 200], rect); % 3rd arg = color.
        end
    end
    
	% 4. Fixation cross
    stim.add_cross_hairs(window, params.fixation_size, ...
        [params.fixation_offset_x, params.fixation_offset_y], 2, 255);

    
    % 5. Write text to the window.
    currentTextRow = 0;
    if params.add_match_flag
        left = [num2str(round(params.match_CIEx * 1000) / 1000) ', ' ...
            num2str(round(params.match_CIEy * 1000) / 1000)];
        right = num2str(round(params.match_LUM * 1000) / 1000);
    else
        left = [num2str(round(params.x * 1000) / 1000) ', ' ...
            num2str(round(params.y * 1000) / 1000)];
        right = num2str(round(params.LUM * 1000) / 1000);
    end
    Screen('DrawText', window, ...
        sprintf([params.color_space(1:2) ' = %s, Lum = %s'], ...
        left, right), 0, currentTextRow, 150);

    % 6. Updates the screen to reflect our changes to the window.
    Screen('Flip', window);
        
end