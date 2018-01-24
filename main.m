function main

    % ---- Import local files
    import white.*

    % ---- Get parameters for experiment or display stimulus
    params = gui.disp(); % only disp stimulus    

    try
        % ---- Set up window
        [window, oldVisualDebugLevel, oldSupressAllWarnings] = stim.setup_window(...
            params);

        % ---- Load calibration file:
        cal = gen.cal_struct(params.cal_file, params.cal_dir, params.bits_sharp);

        % ---- Show stimulus
        [~, params] = stim.control_image(params, cal, window, 1, ...
            params.debug_mode);

        stim.cleanup(params, oldVisualDebugLevel, oldSupressAllWarnings);
    catch  %#ok<*CTCH>

        stim.cleanup(params);

        % We throw the error again so the user sees the error description.
        psychrethrow(psychlasterror);

    end

end