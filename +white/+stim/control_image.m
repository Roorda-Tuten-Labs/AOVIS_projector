function [xyz, params] = control_image(params, cal, window, ...
    close_at_end, disable_spacebar)

import white.*

if nargin < 1
    params = gen.default_params();
end
if nargin < 3
    window = stim.setup_window(params.screen, params.textsize, 1, ...
        params.debug_mode);
end
if nargin < 2
    cal = gen.cal_struct(params.cal_file, params.cal_dir, params.bits_sharp);
end
if nargin < 4
    close_at_end = 0;
end
if nargin < 5
    disable_spacebar = 0;
end


% ---- Make sure key names are the same across systems
KbName('UnifyKeyNames');
keyboard_index = white.fil.find_keyboard_index();

if ~strcmp(params.fundus_image_file, '')
    % get correct file name and directory.
    [~, fname, ext] = fileparts(params.fundus_image_file);
    directory = white.fil.get_path_to_white_dir();
    full_fname = fullfile(directory, 'img', [fname ext]);
    % now read
    fundus_image = imread(full_fname);    
    fundus_image = fundus_image(:, :, 1);
else
    fundus_image = []; %empty matrix
end

%params.image_rot = 0; % always assume an image rotation of 0.
params.add_fundus_image_flag = 0; % start with fundus image off.
params.add_pins_flag = 0; % pins are set to zero and off.

% In case matching stimulus is added, keep track of which to change.
params.add_match_flag = 0;
params.match_CIEx = params.x;
params.match_CIEy = params.y;
params.match_LUM = params.LUM;

big_steps = 1;
try 
    
    % draw first image
    draw_image(window, cal, params, fundus_image);
    
    forward = 0;
    while ~forward
        [~, keycode, ~] = KbWait(keyboard_index);
        if sum(keycode) == 1
            keyname = KbName(keycode);
            [forward, params] = process_keys(keyname, params);
            if forward ~= 1
                draw_image(window, cal, params, fundus_image);
            end
        end
        
    end
    if close_at_end
        stim.cleanup();
    end

catch  %#ok<*CTCH>
   
	stim.cleanup();

	% We throw the error again so the user sees the error description.
	psychrethrow(psychlasterror);
    
end
    
    % --- subroutines ---
    function draw_image(window, cal, params, fundus_image)
        import white.*
      
        stim.display_image(window, cal, params, fundus_image);
        
         % prevent 'sticky keys'
        pause(0.15);

    end

    function [forward, params] = process_keys(keyname, params)
        import white.*
        % --- process a control key: increase/decrease step size
        keyname = lower(keyname);
        if any(strcmp(keyname, 'control') || strcmp(keyname, 'leftcontrol') ...
                || strcmp(keyname, 'rightcontrol'))
            if big_steps == 5
                big_steps = 1;
            else
                big_steps = 5;
            end
        end

        % --- set step sizes
        xy_step = 0.0025 * big_steps;
        LUM_step = 0.5 * big_steps;
        off_step = 2 * big_steps;
        size_step = 1 * big_steps;
        img_rot_scale = 2 * big_steps;
        
        forward = 0;

        % give control to cursor
        if strcmp(keyname, 'tab')
            % Turn cursor back on
            ShowCursor;
            
            % Wait for Click
            [mouseindex, ~, ~] = GetMouseIndices();
            mouseindex = mouseindex(end); % use the highest index
            KbWait(mouseindex);
            [x, y, buttons, ~, ~, ~] = GetMouse();

            % update position of fixation
            if buttons(1)
                params.fixation_offset_x = x;
                params.fixation_offset_y = y;
            elseif buttons(2)
                params.pin_locations = [params.pin_locations; x y];
                params.add_pins_flag = 1;
            else
                disp('button click not understood.');
            end            
                       
            % Turn cursor off and return to program
            HideCursor;
            
        end
        % remove pin locations starting with the last one added
        if any(strcmp(keyname, 'backspace') || strcmp(keyname, 'delete')) ...
                && params.add_pins_flag
            params.pin_locations = params.pin_locations(1:end-1, :);
        end
        
        % turn on/off display of pins
        if strcmp(keyname, '\|') || strcmp(keyname, '\')
            if params.add_pins_flag
                params.add_pins_flag = 0;
            else
                params.add_pins_flag = 1;
            end
        end
        
        % handle case of shift on windows OS
        if length(keyname) == 2
            if strcmp(keyname(2), 'right_shift')
                keyname = keyname(2);
            else
                keyname = keyname(1);
            end
        end
        
        % --- background square: color parameters
        if any(strcmp(keyname, 'left') || strcmp(keyname, 'leftarrow')) && params.add_square_flag
            if params.add_match_flag
                params.match_CIEx = params.match_CIEx - xy_step;
            else
                params.x = params.x - xy_step;
            end
        elseif any(strcmp(keyname, 'rightarrow') || strcmp(keyname, 'right')) && params.add_square_flag
            if params.add_match_flag
                params.match_CIEx = params.match_CIEx + xy_step;
            else
                params.x = params.x + xy_step;
            end
        elseif any(strcmp(keyname, 'uparrow') || strcmp(keyname, 'up')) && params.add_square_flag
            if params.add_match_flag
                params.match_CIEy = params.match_CIEy + xy_step;
            else
                params.y = params.y + xy_step;
            end
        elseif any(strcmp(keyname, 'downarrow') || strcmp(keyname, 'down')) && params.add_square_flag
            if params.add_match_flag
                params.match_CIEy = params.match_CIEy - xy_step;
            else
                params.y = params.y - xy_step;
            end
          
        elseif strcmp(keyname, 'return') && params.add_square_flag
            if params.add_match_flag
                params.match_LUM = params.match_LUM + LUM_step;
            else
                params.LUM = params.LUM + LUM_step;
            end
        elseif any(strcmp(keyname, 'shift') || strcmp(keyname, 'rightshift')) && params.add_square_flag
            if params.add_match_flag
                params.match_LUM = params.match_LUM - LUM_step;
            else
                params.LUM = params.LUM - LUM_step;
            end

        % --- background square: size and shape
        elseif strcmp(keyname, 'f') && params.add_square_flag
            params.img_offset_x = params.img_offset_x  - off_step;
        elseif strcmp(keyname, 'g') && params.add_square_flag
            params.img_offset_x = params.img_offset_x  + off_step;
        elseif strcmp(keyname, 'v') && params.add_square_flag
            params.img_offset_y = params.img_offset_y  + off_step;
        elseif strcmp(keyname, 't') && params.add_square_flag
            params.img_offset_y = params.img_offset_y  - off_step;
            
        elseif strcmp(keyname, 'u') && params.add_square_flag
            params.img_x = params.img_x  - size_step;
        elseif strcmp(keyname, 'n') && params.add_square_flag
            params.img_x = params.img_x  + size_step;
        elseif strcmp(keyname, 'h') && params.add_square_flag
            params.img_y = params.img_y  + size_step;
        elseif strcmp(keyname, 'j') && params.add_square_flag
            params.img_y = params.img_y  - size_step;
 
        % --- fixation parameters
        elseif strcmp(keyname, 'w')
            params.fixation_offset_y = params.fixation_offset_y  - size_step * 2;
        elseif strcmp(keyname, 'z')
            params.fixation_offset_y = params.fixation_offset_y  + size_step * 2;
        elseif strcmp(keyname, 'a')
            params.fixation_offset_x = params.fixation_offset_x  - size_step * 2;
        elseif strcmp(keyname, 's')
            params.fixation_offset_x = params.fixation_offset_x  + size_step * 2;

        % --- fundus image parameters
        elseif strcmp(keyname, '0')
            if params.add_fundus_image_flag
                params.add_fundus_image_flag = 0;
            else
                params.add_fundus_image_flag = 1;
            end
            
        elseif strcmp(keyname, '-') && params.add_fundus_image_flag
            params.fundus_img_scale = params.fundus_img_scale - 0.01;
        elseif strcmp(keyname, '=') && params.add_fundus_image_flag
            params.fundus_img_scale = params.fundus_img_scale + 0.01;
            
        elseif strcmp(keyname, '[') && params.add_fundus_image_flag
            params.image_rot = params.image_rot + img_rot_scale;
        elseif strcmp(keyname, ']') && params.add_fundus_image_flag
            params.image_rot = params.image_rot - img_rot_scale;
            
        elseif strcmp(keyname, 'l') && params.add_fundus_image_flag
            params.fundus_img_offset_x = params.fundus_img_offset_x  - off_step;
        elseif strcmp(keyname, ';') && params.add_fundus_image_flag
            params.fundus_img_offset_x = params.fundus_img_offset_x  + off_step;
        elseif strcmp(keyname, 'p') && params.add_fundus_image_flag
            params.fundus_img_offset_y = params.fundus_img_offset_y  - off_step;
        elseif strcmp(keyname, '.') && params.add_fundus_image_flag
            params.fundus_img_offset_y = params.fundus_img_offset_y  + off_step;
        
        % --- Grid line parameters
        elseif strcmp(keyname, '1')
            if params.add_grid_lines_flag == 1;
                params.add_grid_lines_flag = 0;
            else
                params.add_grid_lines_flag = 1;
            end
        elseif strcmp(keyname, '2')
            if params.add_square_flag == 1;
                params.add_square_flag = 0;
            else
                params.add_square_flag = 1;
            end
            
        elseif strcmp(keyname, '5')
            if params.add_match_flag < 0.1
                params.add_match_flag = 1;
             elseif params.add_match_flag > 0.9
                params.add_match_flag = 0;
            end
            
        elseif strcmp(keyname, 'escape')
            xyz = 'end';
            forward = 1;
            % save params
            fil.save_params(params, params.subject_id);
            fil.save_params(params, 'default');
            % close the screen if desired.
            if close_at_end
                stim.cleanup(params); % always save params of 'real' rectangle
            end
        elseif strcmp(keyname, 'space') && disable_spacebar == 0
            forward = 1;
            
        elseif strcmp(keyname, '`')
            disp('saving active params');
            fil.save_params(params, params.subject_id);
            fil.save_params(params, 'default');
        end

    end

    % ---- Compute xyz result for white
    if strcmp(params.color_space, 'xyY')
        xyz = xyYToXYZ([params.x params.y params.LUM]');
        xyz = xyz / sum(xyz);
    elseif strcmp(params.color_space, 'Luv')
        xy = uvToxy([params.x params.y]');
        xyz = xyYToXYZ([xy(1) xy(2) params.LUM]');
        xyz = xyz / sum(xyz);
    end 
    
end
