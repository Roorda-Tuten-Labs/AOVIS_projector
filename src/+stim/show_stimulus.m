function [xyz, params] = show_stimulus(xyY, params, window, close_at_end, cal)

import gen.gen_image_sequence
import stim.display_image
import stim.cleanup

if nargin < 1
    xyY = input('xyY coordinate to display [default = 1/3 1/3 40]');
    if isempty(xyY)
        xyY = [1/3 1/3 40];
    end
    close_at_end = 1;
end
if nargin < 2
    import gen.gen_params
    params = gen_params();
end
if nargin < 3
    import stim.setup_window
    window = setup_window(params.screen);
end
if nargin < 4 && nargin > 1
    close_at_end = 0;
end
if nargin < 5
    % Load default calibration file:
    cal = LoadCalFile(params.cal_file);
    T_xyz1931 = csvread('ciexyz31.csv')';
    S_xyz1931 = [380, 5, 81];

    T_xyz1931 = 683 * T_xyz1931;
    cal = SetSensorColorSpace(cal, T_xyz1931, S_xyz1931);
    cal = SetGammaMethod(cal,0);
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
params = gen_image_sequence(cal, params);

try 
    % Retrieves the CLUT color code for background.
    background = params.background;
    
    % showimg = gen_show_img(img, params.color_sequence, params);
    
    [a, b] = format_numbers(xyY);
    
    display_image(window, background, params, params.color_sequence(1, 1:3), ...
        a, b, 'ab', 'LUM');
    
    forward = 0;
    while ~forward
        [~, keycode, ~] = KbWait();
        keyname = KbName(keycode);
        forward = process_keys(keyname);
        
    end
    if close_at_end
        cleanup();
    end

catch  %#ok<*CTCH>
   
	cleanup();

	% We throw the error again so the user sees the error description.
	psychrethrow(psychlasterror);
    
end

    % --- subroutines ---
    function redraw_image(window, background, cal, params)
        import gen.gen_image_sequence
        import stim.display_image
        params = gen_image_sequence(cal, params);
        xyY = [params.x params.y params.LUM];
        %showimg_ = gen_show_img(img, params.color_sequence, params);
        [a_, b_] = format_numbers(xyY);
        display_image(window, background, params, params.color_sequence(1, 1:3), ...
            a_, b_, 'ab', 'LUM');
        pause(0.2); % prevent 'sticky keys'

    end

    function [a, b] = format_numbers(abc)
        a = num2str(round(abc(1:2) * 1000) / 1000);
        b = num2str(round(abc(3) * 1000) / 1000);
    end

    function [forward] = process_keys(keyname)

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

        elseif strcmp(keyname, 'Shift')|| strcmp(keyname, 'right_shift')
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
            import stim.cleanup
            cleanup(window);
            
        elseif strcmp(keyname, 'space')
            % ---- Compute xyz result for white
            if strcmp(params.color_space, 'xyY')
                xyz = xyYToXYZ([params.x params.y params.LUM]');
                xyz = xyz / sum(xyz);
            elseif strcmp(params.color_space, 'Luv')
                xy = uvToxy([params.x params.y]');
                xyz = xyYToXYZ([xy(1) xy(2) params.LUM]');
                xyz = xyz / sum(xyz);
            end 
            forward = 1;
        end
    end

end
