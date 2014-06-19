function [params, xyz] = run_adjustment_exp(window, params)
    import stim.show_stimulus
    import stim.display_black_screen
    import stim.cleanup
    import stim.show_text
    import fil.save_to_file
    import convert.CIE_from_Angle
    import plot.plot_method_of_adjustment
    
    data_record = zeros(params.nrepeats, 3);
    try
        black = BlackIndex(window);
  
        for i=1:params.nrepeats
            %%% choose a new random starting point each time.
            angle = Randi(360);
            [a, b] = CIE_from_Angle(angle, params.RHO, ...
                params.color_space);
            data_record(i, 4:5) = [a, b]; % record starting position
            [xyz, params] = show_stimulus([a b params.LUM], params, ...
                window, 0);
            
            if strcmp(xyz, 'end')
                return;
            end
            data_record(i, 1:3) = xyz;
            
            display_black_screen(window, black, params);
            
            pause(1);
        end
        % ---- indicate program is complete
        show_text(window, 'finish', '', 40);
        pause(4);
        
        % ---- show final gray point ----
        disp('SEM:'); disp(std(data_record(:, 1:3), 1) / ...
            sqrt(params.nrepeats));
        xyz = mean(data_record(:, 1:3), 1)';
        xyY = XYZToxyY(xyz);
        uv = xyTouv([xyY(1) xyY(2)]');
        show_stimulus([uv(1) uv(2) params.LUM], params, window, 0);
        KbWait();
        
        % ---- cleanup ----
        cleanup();
        
        % ---- plot results ----
        plot_method_of_adjustment(data_record, params);
        
    catch  %#ok<*CTCH>
        cleanup();
        psychrethrow(psychlasterror);
    end
    % ---- null out values that done exist in this method
    params.blu = 'NA';
    params.blue_abc = 'NA';
    params.yel = 'NA';
    params.yellow_abc = 'NA';
    params.white_abc = 'NA';
    params.angles = 'NA';
    params.ncolors = 'NA';
        
    % save the file to csv and json
    save_to_file(data_record, params.subject, 'white', params);
    
end