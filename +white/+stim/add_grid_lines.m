function add_grid_lines(window, params, rect)

    % set up the RGB for the white lines (don't make it too bright)
    if params.bits_sharp
        white_RGB = [0.5 0.5 0.5];
    else
        % too bright so tone it down (subtract 150)
        white_RGB = WhiteIndex(window) - 150;         
    end
    
    % Find the center of the raster.
   	[raster_center_x, raster_center_y] = RectCenter(rect);
    raster_center = [raster_center_x, raster_center_y];
    
    % Get the size of the on screen window
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    
    line_width_pix = 1;
    for deg = -20:1:20
        pix_loc_y = deg * params.pix_per_deg;
        if params.bits_sharp
            pix_loc_x = deg * params.pix_per_deg / 2;
        else
            pix_loc_x = deg * params.pix_per_deg;
        end
        xcoords = [-screenXpixels, screenXpixels pix_loc_x pix_loc_x];
        ycoords = [pix_loc_y pix_loc_y -screenYpixels, screenYpixels];
    
        all_coords = [xcoords; ycoords];
    
        Screen('DrawLines', window, all_coords, line_width_pix, ...
            white_RGB, raster_center);
        
        txt = num2str(deg);
        Screen('DrawText', window, sprintf('%s', txt), ...
            raster_center(1) + pix_loc_x, raster_center(2), 125);
        Screen('DrawText', window, sprintf('%s', txt), ...
            raster_center(1), raster_center(2) - pix_loc_y, 125);    
    end

end