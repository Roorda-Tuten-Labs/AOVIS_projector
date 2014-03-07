function [params, xyz] = run_adjustment_exp(window, params)
    import stim.show_stimulus
    import stim.display_black_screen
    import stim.cleanup
    import stim.show_text
    import gen.gen_image_mat
    import fil.save_to_file
    import convert.CIE_from_Angle
    
    data_record = zeros(params.nrepeats, 3);
    try
        img = gen_image_mat(params);
        black = BlackIndex(window);
        
        for i=1:params.nrepeats
            %%% choose a new random starting point each time.
            angle = Randi(360);
            [a, b] = CIE_from_Angle(angle, params.RHO, ...
                params.color_space);
            
            xyz = show_stimulus([a b params.LUM], params, ...
                window, 0);
            data_record(i, :) = xyz;
            
            display_black_screen(window, black, img, params);
            
            pause(1);
        end
        % ---- indicate program is complete
        show_text(window, 'finish', '', 40);
        pause(4);
        
        % ---- show final gray point ----
        disp('SEM:'); disp(std(data_record, 1) / sqrt(params.nrepeats));
        xyz = mean(data_record, 1)';
        xyY = XYZToxyY(xyz);
        uv = xyTouv([xyY(1) xyY(2)]');
        show_stimulus([uv(1) uv(2) params.LUM], params, window, 0);
        KbWait();
        
        % ---- cleanup ----
        cleanup();
        
    catch  %#ok<*CTCH>
        cleanup();
        psychrethrow(psychlasterror);
    end

    params.blu = '';
    params.blue_abc = '';
    params.yel = '';
    params.yellow_abc = '';
    params.white_abc = '';
        
    % save the file to csv and json
    save_to_file(data_record, params.subject, 'white', params);
    
end