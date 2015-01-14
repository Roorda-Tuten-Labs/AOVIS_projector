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
    window = stim.setup_window(params.screen);
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

try 
    % Retrieves the CLUT color code for background.
    background = params.background;
    
    % showimg = gen_show_img(img, params.color_sequence, params);
    
    [a, b] = format_numbers(xyY);
    
    stim.display_image(window, background, params, params.color_sequence(1, 1:3), ...
        a, b, 'ab', 'LUM');
    
    forward = 0;
    while ~forward
        [~, keycode, ~] = KbWait();
        keyname = KbName(keycode);
        forward = process_keys(keyname);
        
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
    function redraw_image(window, background, cal, params)
        import white.*
        params = gen.image_sequence(cal, params);
        xyY = [params.x params.y params.LUM];
        %showimg_ = gen_show_img(img, params.color_sequence, params);
        [a_, b_] = format_numbers(xyY);
        stim.display_image(window, background, params, params.color_sequence(1, 1:3), ...
            a_, b_, 'ab', 'LUM');
        pause(0.2); % prevent 'sticky keys'

    end

    function [a, b] = format_numbers(abc)
        a = num2str(round(abc(1:2) * 1000) / 1000);
        b = num2str(round(abc(3) * 1000) / 1000);
    end

    function [forward] = process_keys(keyname)
        import white.*
        
        xy_step = 0.0025;
        LUM_step = 1;
        off_step = 7;
        size_step = 5;
        forward = 0;
        % handle case of shift on windows OS
        if length(keyname) == 2
            if strcmp(keyname(2), 'right_shift')
                keyname = keyname(2);
            else
                keyname = keyname(1);
            end
        end
        
        if strcmp(keyname, 'left') || strcmp(keyname, 'LeftArrow') 
            params.x = params.x - xy_step;
            redraw_image(window, background, cal, params);

        elseif strcmp(keyname, 'RightArrow')|| strcmp(keyname, 'right')
            params.x = params.x + xy_step;
            redraw_image(window, background, cal, params);

        elseif strcmp(keyname, 'UpArrow')|| strcmp(keyname, 'up')
            params.y = params.y + xy_step;
            redraw_image(window, background, cal, params);

        elseif strcmp(keyname, 'DownArrow')|| strcmp(keyname, 'down')
            params.y = params.y - xy_step;
            redraw_image(window, background, cal, params);

        elseif strcmp(keyname, 'Return')|| strcmp(keyname, 'return')
            params.LUM = params.LUM + LUM_step;
            redraw_image(window, background, cal, params);

        elseif strcmp(keyname, 'Shift') || strcmp(keyname, 'RightShift')
            params.LUM = params.LUM - LUM_step;
            redraw_image(window, background, cal, params);

        elseif strcmp(keyname, 'f')|| strcmp(keyname, 'F')
            params.img_offset_x = params.img_offset_x  - off_step;
            redraw_image(window, background, cal, params);
        elseif strcmp(keyname, 'g')|| strcmp(keyname, 'G')
            params.img_offset_x = params.img_offset_x  + off_step;
            redraw_image(window, background, cal, params);
        elseif strcmp(keyname, 'v')|| strcmp(keyname, 'V')
            params.img_offset_y = params.img_offset_y  + off_step;
            redraw_image(window, background, cal, params);
        elseif strcmp(keyname, 't')|| strcmp(keyname, 'T')
            params.img_offset_y = params.img_offset_y  - off_step;
            redraw_image(window, background, cal, params);

        elseif strcmp(keyname, 'u')|| strcmp(keyname, 'U')
            params.img_x = params.img_x  - size_step;
            redraw_image(window, background, cal, params);
        elseif strcmp(keyname, 'n')|| strcmp(keyname, 'N')
            params.img_x = params.img_x  + size_step;
            redraw_image(window, background, cal, params);
        elseif strcmp(keyname, 'h')|| strcmp(keyname, 'H')
            params.img_y = params.img_y  + size_step;
            redraw_image(window, background, cal, params);
        elseif strcmp(keyname, 'j')|| strcmp(keyname, 'J')
            params.img_y = params.img_y  - size_step;
            redraw_image(window, background, cal, params);

        elseif strcmp(keyname, 'w')|| strcmp(keyname, 'W')
            params.fixation_offset_y = params.fixation_offset_y  - size_step * 4;
            redraw_image(window, background, cal, params);
        elseif strcmp(keyname, 'z')|| strcmp(keyname, 'Z')
            params.fixation_offset_y = params.fixation_offset_y  + size_step * 4;
            redraw_image(window, background, cal, params);
        elseif strcmp(keyname, 'a')|| strcmp(keyname, 'A')
            params.fixation_offset_x = params.fixation_offset_x  - size_step * 4;
            redraw_image(window, background, cal, params);
        elseif strcmp(keyname, 's')|| strcmp(keyname, 'S')
            params.fixation_offset_x = params.fixation_offset_x  + size_step * 4;
            redraw_image(window, background, cal, params);

        elseif strcmp(keyname, 'ESCAPE')|| strcmp(keyname, 'escape')
            xyz = 'end';
            forward = 1;
            stim.cleanup(params);
            
        elseif strcmp(keyname, 'space') && disable_spacebar == 0
            forward = 1;
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
