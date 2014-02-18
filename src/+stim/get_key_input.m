function [data_record] = get_key_input(cal, data_record, params, trial)

    import gen.gen_show_img
    import stim.cleanup
    import stim.display_image

    keyisdown = 0;
    while ~keyisdown
        [~, keycode, ~] = KbWait();
        keyname = KbName(keycode);

        if strcmp(keyname, 'left') || strcmp(keyname, 'right') ...
                || strcmp(keyname, 'LeftArrow') || strcmp( ...
                keyname, 'RightArrow')

            % ---------- Record data
            if strcmp(keyname, 'left') || ...
                    strcmp(keyname, 'LeftArrow')
                data_record(trial, 1) = 0; % too short
            else
                data_record(trial, 1) = 1; % too_long
            end
            col = SettingsToSensor(cal, ...
                params.color_sequence(trial, 1:3)' / 255);
            col = col / sum(col); % make it tristim val.
            data_record(trial, 2:4) = col;
            data_record(trial, 5) = params.color_sequence(trial, 4);

            keyisdown = 1; % Cause while loop to end

        elseif strcmp(keyname, 'q')
            % ---------- Exit program if 'q' key is pressed.
            cleanup();
            keyisdown = 1;

        else
            %%%% keep looping if not left or right arrow key
            keyisdown = 0;
        end
    end

end