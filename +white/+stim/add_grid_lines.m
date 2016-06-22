function add_grid_lines(window, params, rect)

    white = WhiteIndex(window); %rgb values for white
    
    % Find the center of the raster.
   	[raster_center_x, raster_center_y] = RectCenter(rect);
    raster_center = [raster_center_x, raster_center_y];
    
    % Get the size of the on screen window
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    
    rect_x_size = abs(rect(1) - rect(3));
    rect_y_size = abs(rect(2) - rect(4));
    
    rect_size = mean([rect_x_size rect_y_size]);
    params.pix_per_deg = 50;

    line_width_pix = 1;
    for deg = -20:1:20
        pix_loc = deg * params.pix_per_deg;
        xcoords = [-screenXpixels, screenXpixels pix_loc pix_loc];
        ycoords = [pix_loc pix_loc -screenYpixels, screenYpixels];
    
        all_coords = [xcoords; ycoords];
    
        Screen('DrawLines', window, all_coords, line_width_pix, ...
            white - 150, raster_center);
        
        txt = num2str(deg);
        Screen('DrawText', window, sprintf('%s', txt), ...
            raster_center(1) + deg * params.pix_per_deg, raster_center(2), 125);
        Screen('DrawText', window, sprintf('%s', txt), ...
            raster_center(1), raster_center(2) + deg * params.pix_per_deg, 125);    
    end

end