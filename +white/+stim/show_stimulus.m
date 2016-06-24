function [xyz, params] = show_stimulus(xyY, params, cal, window, ...
    close_at_end, disable_spacebar)

import white.*

if nargin < 1
    xyY = input('xyY coordinate to display [default = 1/3 1/3 40]');
    if isempty(xyY)
        xyY = [1/3 1/3 40];
    end
    close_at_end = 1;
end
if nargin < 2
    params = gen.default_params();
end
if nargin < 4
    window = stim.setup_window(params.screen, params.textsize, ...
        params.debug_mode);
end
if nargin < 3
    cal = gen.cal_struct(params.cal_file, params.cal_dir);
end
if nargin < 5 && nargin > 1
    close_at_end = 0;
end
if nargin < 6
    disable_spacebar = 0;
end

% ---- Make sure key names are the same across systems
KbName('UnifyKeyNames');

% ---------- Gen image sequence --------
params.ntrials = 1;
params.nrepeats = 1;
params.ncolors = 1;
params.angles = 0;
params.uniqueHue = 'white';
params.x = xyY(1);
params.y = xyY(2);
params.LUM = xyY(3);
params = gen.image_sequence(cal, params);

if ~strcmp(params.fundus_image_file, '')
    fundus_image = imread(params.fundus_image_file);
    fundus_image = fundus_image(:, :, 1);
end
%params.image_rot = 0; % always assume an image rotation of 0.
params.add_fundus_image_flag = 0; % start with fundus image off.

params.add_grid_lines_flag = 0;
params.add_square_flag = 1;

% In case matching stimulus is added, keep track of which to change.
match = 0;
match_params = params;
match_params.img_offset_x = params.img_offset_x + 50;
match_params.img_offset_y = params.img_offset_y + 50;

% params to control:
active_params = params;
big_steps = 1;
try 
    % Retrieves the CLUT color code for background.
    background = active_params.background;
    
    [a, b] = format_numbers(xyY);

    stim.display_image(window, background, active_params, active_params.color_sequence(1, 1:3), ...
        a, b, 'ab', 'LUM', fundus_image);
    
    forward = 0;
    while ~forward
        [~, keycode, ~] = KbWait(-1);
        keyname = KbName(keycode);
        [forward, active_params] = process_keys(keyname, active_params);
        if forward ~= 1
            redraw_image(window, background, cal, active_params);
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
    params = active_params;
    
    % --- subroutines ---
    function redraw_image(window, background, cal, active_params)
        import white.*
        
        if match < 0.1
            active_params = gen.image_sequence(cal, active_params);
            xyY = [active_params.x active_params.y active_params.LUM];
            [a_, b_] = format_numbers(xyY);
            stim.display_image(window, background, active_params, ...
                active_params.color_sequence(1, 1:3), ...
                a_, b_, 'ab', 'LUM', fundus_image);
        else
            active_params = gen.image_sequence(cal, active_params);
            xyY = [active_params.x active_params.y active_params.LUM];
            [a_, b_] = format_numbers(xyY);
            
            params = gen.image_sequence(cal, params);
            stim.display_matching_stim(window, background, params, ...
                params.color_sequence(1, 1:3), ...
                active_params, active_params.color_sequence(1, 1:3), ...
                a_, b_, 'ab', 'LUM', fundus_image);   
        end
        
        pause(0.15); % prevent 'sticky keys'

    end

    function [a, b] = format_numbers(abc)
        a = num2str(round(abc(1:2), 3));
        b = num2str(round(abc(3), 3));
    end

    function [forward, active_params] = process_keys(keyname, active_params)
        import white.*
        % --- process a control key: increase/decrease step size
        keyname = lower(keyname);
        if strcmp(keyname, 'control') || strcmp(keyname, 'leftcontrol') ...
                || strcmp(keycode, 'rightcontrol')
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
        
        % handle case of shift on windows OS
        if length(keyname) == 2
            if strcmp(keyname(2), 'right_shift')
                keyname = keyname(2);
            else
                keyname = keyname(1);
            end
        end
        
        % --- background square: color parameters
        if strcmp(keyname, 'left') || strcmp(keyname, 'leftarrow') 
            active_params.x = active_params.x - xy_step;
        elseif strcmp(keyname, 'rightarrow')|| strcmp(keyname, 'right')
            active_params.x = active_params.x + xy_step;
        elseif strcmp(keyname, 'uparrow')|| strcmp(keyname, 'up')
            active_params.y = active_params.y + xy_step;
        elseif strcmp(keyname, 'downarrow')|| strcmp(keyname, 'down')
            active_params.y = active_params.y - xy_step;
          
        elseif strcmp(keyname, 'return')
            active_params.LUM = active_params.LUM + LUM_step;
        elseif strcmp(keyname, 'shift') || strcmp(keyname, 'rightshift')
            active_params.LUM = active_params.LUM - LUM_step;

        % --- background square: size and shape
        elseif strcmp(keyname, 'f')
            active_params.img_offset_x = active_params.img_offset_x  - off_step;
        elseif strcmp(keyname, 'g')
            active_params.img_offset_x = active_params.img_offset_x  + off_step;
        elseif strcmp(keyname, 'v')
            active_params.img_offset_y = active_params.img_offset_y  + off_step;
        elseif strcmp(keyname, 't')
            active_params.img_offset_y = active_params.img_offset_y  - off_step;
            
        elseif strcmp(keyname, 'u')
            active_params.img_x = active_params.img_x  - size_step;
        elseif strcmp(keyname, 'n')
            active_params.img_x = active_params.img_x  + size_step;
        elseif strcmp(keyname, 'h')
            active_params.img_y = active_params.img_y  + size_step;
        elseif strcmp(keyname, 'j')
            active_params.img_y = active_params.img_y  - size_step;
 
        % --- fixation parameters
        elseif strcmp(keyname, 'w')
            active_params.fixation_offset_y = active_params.fixation_offset_y  - size_step * 2;
        elseif strcmp(keyname, 'z')
            active_params.fixation_offset_y = active_params.fixation_offset_y  + size_step * 2;
        elseif strcmp(keyname, 'a')
            active_params.fixation_offset_x = active_params.fixation_offset_x  - size_step * 2;
        elseif strcmp(keyname, 's')
            active_params.fixation_offset_x = active_params.fixation_offset_x  + size_step * 2;

        % --- fundus image parameters
        elseif strcmp(keyname, '0')
            if active_params.add_fundus_image_flag
                active_params.add_fundus_image_flag = 0;
            else
                active_params.add_fundus_image_flag = 1;
            end
            
        elseif strcmp(keyname, '-')
            active_params.fundus_img_scale = active_params.fundus_img_scale - 0.01;
        elseif strcmp(keyname, '=')
            active_params.fundus_img_scale = active_params.fundus_img_scale + 0.01;
            
        elseif strcmp(keyname, '[')
            active_params.image_rot = active_params.image_rot + img_rot_scale;
        elseif strcmp(keyname, ']')
            active_params.image_rot = active_params.image_rot - img_rot_scale;
            
        elseif strcmp(keyname, 'l')
            active_params.fundus_img_offset_x = active_params.fundus_img_offset_x  - off_step;
        elseif strcmp(keyname, ';')
            active_params.fundus_img_offset_x = active_params.fundus_img_offset_x  + off_step;
        elseif strcmp(keyname, 'p')
            active_params.fundus_img_offset_y = active_params.fundus_img_offset_y  - off_step;
        elseif strcmp(keyname, '.')
            active_params.fundus_img_offset_y = active_params.fundus_img_offset_y  + off_step;
        
        % --- Grid line parameters
        elseif strcmp(keyname, '1')
            if active_params.add_grid_lines_flag == 1;
                active_params.add_grid_lines_flag = 0;
            else
                active_params.add_grid_lines_flag = 1;
            end
        elseif strcmp(keyname, '2')
            if active_params.add_square_flag == 1;
                active_params.add_square_flag = 0;
            else
                active_params.add_square_flag = 1;
            end
            
        elseif strcmp(keyname, 'q')
            if match < 0.1
                match = 1;
                params = active_params; % save params
                active_params = match_params;
                
            elseif match > 0.9
                match = 0;
                match_params = active_params; % save match params
                active_params = params;
            end
            
        elseif strcmp(keyname, 'escape')
            xyz = 'end';
            forward = 1;
            stim.cleanup(active_params); % always save params of 'real' rectangle
            
        elseif strcmp(keyname, 'space') && disable_spacebar == 0
            forward = 1;
            
        elseif strcmp(keyname, '~')
            save ./param/default_params.mat active_params
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
