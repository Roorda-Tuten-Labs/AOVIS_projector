function [params, xyz] = show_stimulus_set(window, params, hue)
    % import local files
    import gen.gen_hue_specific_params
    import stim.show_text
    import stim.run_program
    import fil.save_to_file
    
    % update hue specific parameters
    params = gen_hue_specific_params(hue, params); 
    
    % display a message before running the program
    message1 = ['please indicate if the stimulus is ' params.left ...
        ' or ' params.right ' with the left and right arrow keys'];
    message2 = 'press any key to start';
    show_text(window, message1, message2);
    
    % wait for user to advance
    KbWait();
    
    % make sure there are no stickey key presses.
    pause(0.2); 
    
    % run the program
    [data_record, hue_angle, abc] = run_program(window, params);
    
    % record the blue and yellow angles for use with white later
    if strcmp(hue, 'blue')
        params.blu = hue_angle(1);
        params.blue_abc = abc;
    elseif strcmp(hue, 'yellow')
        params.yel = hue_angle(1);
        params.yellow_abc = abc;
    elseif strcmp(hue, 'white')
        params.white_abc = xyz;
    end
    
    % save the file to csv and json
    save_to_file(data_record, params.subject, hue, params);
    
end