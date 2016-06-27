function calibrate_raster_pix_deg(raster_size)
% This function calibrates the pixels per degree assumed in
% stim.add_grid_lines function. 
%
%  To calibrate, bring AOSLO raster and external projector into focus. Then
% adjust the position and size of the cross-hair drawn by the projector. To
% do so use arrow keys and 'a' 'w' 's' 'z' keys. Hit space bar when you are
% satisfied with the size match. Escape will terminate the program without
% saving the pix_per_deg value.
%

if nargin < 1
    disp('Assuming a raster size of 1.2 degrees. Abort if not true');
    raster_size = 1.2;
end

% ---- Import local files
import white.*

% ---- Get parameters for experiment or display stimulus
params = gui.disp(); % only disp stimulus
params.debug_mode = 0;


try
    % ---- Set up window
    [window, oldVisualDebugLevel, oldSupressAllWarnings] = stim.setup_window(...
        params.screen, params.textsize, params.debug_mode);

    % Color the entire window gray.
    Screen('FillRect', window, params.background);
    
    line_width_pix = 4;

    forward = 0;
    while ~forward
        
        [~, keycode, ~] = KbWait(-1);
        keyname = KbName(keycode);
        [forward, params] = process_keys(keyname, params);
        if forward == 0
            x_pixels = params.img_x;
            y_pixels = params.img_y;
            loc = [params.img_offset_x, params.img_offset_y];
            
            % Draw cross-hairs
            stim.add_cross_hairs(window, [x_pixels, y_pixels], loc, ...
                line_width_pix, 125);

            Screen('Flip', window)
        end
        pause(0.15);
    end
    % compute size of raster in pixels by meaning x and y dimension.
    disp([x_pixels y_pixels]);
    pixels = mean([x_pixels y_pixels]);
    params.pix_per_deg = pixels / raster_size;
    disp(['pix/deg: ' num2str(params.pix_per_deg)]);
    
    % cleanup and save new params
    stim.cleanup(params);
    
catch  %#ok<*CTCH>
   
	stim.cleanup();

	% We throw the error again so the user sees the error description.
	psychrethrow(psychlasterror);
    
end


    function [forward, active_params] = process_keys(keyname, active_params)
        import white.*
        
        size_step = 1;
        forward = 0;
        
        if strcmp(keyname, 'left') || strcmp(keyname, 'LeftArrow') 
            active_params.img_x = active_params.img_x - size_step;
        elseif strcmp(keyname, 'RightArrow')|| strcmp(keyname, 'right')
            active_params.img_x = active_params.img_x + size_step;
        elseif strcmp(keyname, 'UpArrow')|| strcmp(keyname, 'up')
            active_params.img_y = active_params.img_y + size_step;
        elseif strcmp(keyname, 'DownArrow')|| strcmp(keyname, 'down')
            active_params.img_y = active_params.img_y - size_step;            

        elseif strcmp(keyname, 'w')|| strcmp(keyname, 'W')
            active_params.img_offset_y = active_params.img_offset_y  - size_step;
        elseif strcmp(keyname, 'z')|| strcmp(keyname, 'Z')
            active_params.img_offset_y = active_params.img_offset_y  + size_step;
        elseif strcmp(keyname, 'a')|| strcmp(keyname, 'A')
            active_params.img_offset_x = active_params.img_offset_x  - size_step;
        elseif strcmp(keyname, 's')|| strcmp(keyname, 'S')
            active_params.img_offset_x = active_params.img_offset_x  + size_step;

        elseif strcmp(keyname, 'ESCAPE')|| strcmp(keyname, 'escape')
            forward = 1;
            stim.cleanup();
            
        elseif strcmp(keyname, 'space')
            forward = 1;
        end

    end

end
