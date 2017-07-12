function whitepath = get_path_to_white_dir()
    % 
    % USAGE
    % whitepath = get_path_to_white_dir()

    whitepath = fileparts(fileparts(fileparts(which('white.gui.disp'))));
end