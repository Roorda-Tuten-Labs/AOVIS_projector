function [data_record] = get_key_input(cal, data_record, params, trial)

    import white.*

    % Handle keyboards properly
    KbName('UnifyKeyNames');
    keyboard_index = white.fil.find_keyboard_index();

    keyisdown = 0;
    while ~keyisdown
        [~, keycode, ~] = KbWait(keyboard_index);
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

        elseif strcmp(keyname, 'ESCAPE')|| strcmp(keyname, 'escape')
            % ---------- Exit program if 'escape' key is pressed.
            stim.cleanup();
            keyisdown = 1;
            data_record = 'end';

        else
            %%%% keep looping if not left or right arrow key
            keyisdown = 0;
        end
    end

end