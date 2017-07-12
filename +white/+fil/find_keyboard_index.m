function keyboard_index = find_keyboard_index
    % Looks for Logitech USB keyboard. If it is not found, goes with default
    % and prints out warning.

    % use Logitech external keyboard if it is plugged in. First find ID
    [keyboard_index, name, infos] = GetKeyboardIndices('USB Receiver');
    % check that it is correct
    if ~strcmpi(infos{1}.manufacturer, 'logitech') || ...
            ~strcmpi(name, 'USB Receiver')
        [keyboard_index, name, ~] = GetKeyboardIndices();
        warning(['Logitech USB keybard not found. Using ' name ' instead.']);
    end