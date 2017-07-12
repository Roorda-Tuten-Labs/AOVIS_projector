function add_cross_hairs(window, cross_size, location, line_width_pix, color)

    if nargin < 3
        error('Must enter window, cross_size, location')
    end
    if nargin < 4
        line_width_pix = 1;
    end
    if nargin < 5
        color = 125; % gray rgb value of 125
    end
    
    x_size = cross_size(1);
    if length(cross_size) == 1        
        y_size = cross_size(1);
    else
        y_size = cross_size(2);
    end
    
    
    xcoords = [-x_size / 2, x_size / 2 0 0];
    ycoords = [0 0 -y_size / 2, y_size / 2];
    all_coords = [xcoords; ycoords];

    % Draw cross-hairs
    Screen('DrawLines', window, all_coords, line_width_pix, ...
            color, location);
        
end