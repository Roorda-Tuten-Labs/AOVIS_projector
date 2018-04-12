function [params, xyz] = run_adjustment_exp(window, params, cal)
    import white.*
    
    data_record = zeros(params.nrepeats, 3);
    try
        black = BlackIndex(window);
  
        for i=1:params.nrepeats
            %%% choose a new random starting point each time.
            angle = Randi(360);
            [a, b] = convert.CIE_from_Angle(angle, params.RHO, ...
                params.color_space);
            data_record(i, 4:5) = [a, b]; % record starting position
            [xyz, params] = stim.control_image(params, cal, window, 0);
            
            if strcmp(xyz, 'end')
                return;
            end
            data_record(i, 1:3) = xyz;
            
            stim.display_black_screen(window, black, params);
            
            pause(1);
        end
        % ---- indicate program is complete
        stim.show_text(window, 'finish', '', 40);
        pause(4);
        
        % ---- show final gray point ----
        disp('SEM:'); disp(std(data_record(:, 1:3), 1) / ...
            sqrt(params.nrepeats));

        stim.control_image(params, cal, window, 0);
        KbWait();
        
        % ---- cleanup ----
        stim.cleanup();
        
        % ---- plot results ----
        plot.method_of_adjustment(data_record, params);
        
    catch  %#ok<*CTCH>
        stim.cleanup();
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
    fil.save_to_file(data_record, params.subject, 'white', params);
    
end