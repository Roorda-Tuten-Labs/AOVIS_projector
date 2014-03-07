function [params, xyz] = run_adjustment_exp(window, params)
    import stim.show_stimulus
    import stim.display_black_screen
    import stim.cleanup
    import gen.gen_image_mat
    import fil.save_to_file
    
    data_record = zeros(params.nrepeats, 3);
    try
        img = gen_image_mat(params);
        black = BlackIndex(window);
        
        for i=1:params.nrepeats
            %%% choose a new random starting point each time.
            xyz = show_stimulus([0.1825 0.3225 params.LUM], params, ...
                window, 0);
            data_record(i, :) = xyz;
            
            display_black_screen(window, black, img, params);
            
            pause(1);
        end
        cleanup();
        xyz = mean(data_record, 1)';
        
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