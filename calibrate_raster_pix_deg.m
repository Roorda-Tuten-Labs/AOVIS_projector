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
    warning('Assuming a raster size of 0.95 degrees. Abort if not true');
    raster_size = 0.95;
end

% ---- Get parameters for experiment or display stimulus
params = white.gui.disp(); % only disp stimulus

% Handle keyboards properly
KbName('UnifyKeyNames');
keyboard_index = white.fil.find_keyboard_index();

% display some instructions.
disp('use: ar row keys to change size to match the AOSLO raster.');
disp('use: a, w, s, z to move the cross hairs');
disp(' ');
disp('press space bar when you are satisfied with the match')
disp(' ');
disp('press any key to begin...');
KbWait(keyboard_index);

if params.bits_sharp
    bkgd = 0.1;
    whiteRGB = 0.6;
else
    bkgd = params.background;
    whiteRGB = 125;
end

try
    % ---- Set up window
    window = white.stim.setup_window(params);

    % Color the entire window gray.
    Screen('FillRect', window, bkgd);
    
    line_width_pix = 3;

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
            white.stim.add_cross_hairs(window, [x_pixels, y_pixels], loc, ...
                line_width_pix, whiteRGB);

            Screen('Flip', window);
        end
        pause(0.2);
    end
    % compute size of raster in pixels by meaning x and y dimension.
    disp([x_pixels y_pixels]);
    if params.bits_sharp
        % in colorPlusPlus mode, horizontal resolution is halved.
        x_pixels = x_pixels * 2; 
    end
    pixels = mean([x_pixels y_pixels]);
    params.pix_per_deg = pixels / raster_size;
    disp(['pix/deg: ' num2str(params.pix_per_deg)]);

    % save new params
    csvwrite('param/pix_per_deg.txt', params.pix_per_deg);
    
    % cleanup
    white.stim.cleanup();
    
catch  %#ok<*CTCH>
   
	white.stim.cleanup();

	% We throw the error again so the user sees the error description.
	psychrethrow(psychlasterror);
    
end


    function [forward, active_params] = process_keys(keyname, active_params)
        import white.*
        
        if iscell(keyname)
            % two keys were hit at the same time
            keyname = keyname{1}; % just take the first one.
        end
        size_step = 1;
        forward = 0;
        
        if strcmpi(keyname, 'left') || strcmpi(keyname, 'LeftArrow') 
            active_params.img_x = active_params.img_x - size_step;
        elseif strcmpi(keyname, 'RightArrow')|| strcmpi(keyname, 'right')
            active_params.img_x = active_params.img_x + size_step;
        elseif strcmpi(keyname, 'UpArrow')|| strcmpi(keyname, 'up')
            active_params.img_y = active_params.img_y + size_step;
        elseif strcmpi(keyname, 'DownArrow')|| strcmpi(keyname, 'down')
            active_params.img_y = active_params.img_y - size_step;            

        elseif strcmpi(keyname, 'w')
            active_params.img_offset_y = active_params.img_offset_y  - size_step;
        elseif strcmpi(keyname, 'z')
            active_params.img_offset_y = active_params.img_offset_y  + size_step;
        elseif strcmpi(keyname, 'a')
            active_params.img_offset_x = active_params.img_offset_x  - size_step;
        elseif strcmpi(keyname, 's')
            active_params.img_offset_x = active_params.img_offset_x  + size_step;

        elseif strcmpi(keyname, 'escape')
            forward = 1;
            stim.cleanup();
            
        elseif strcmpi(keyname, 'space')
            forward = 1;
        end

    end

end
