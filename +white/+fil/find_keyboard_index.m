function keyboard_index = find_keyboard_index
    % Looks for Logitech USB keyboard. If it is not found, goes with default
    % and prints out warning.
    
    if ismac
        % use Logitech external keyboard if it is plugged in. First find ID
        [keyboard_index, name, infos] = GetKeyboardIndices('USB Receiver');
        % check that it is correct
        if isempty(infos)
            keyboard_index = -1;
            warning(['Logitech USB keybard not found. ' ...
                'Using default -1 instead. This cause the program to' ...
                ' check all plugged in keyboards.']);

        elseif ~strcmpi(infos{1}.manufacturer, 'logitech') || ...
                ~strcmpi(name, 'USB Receiver')
            % shouldn't ever get to here, but just double check
            [keyboard_index, name, ~] = GetKeyboardIndices();
            warning(['Logitech USB keybard not found. Using ' name ...
                ' instead.']);
        end
    else ispc
        keyboard_index = -1;
    end
    