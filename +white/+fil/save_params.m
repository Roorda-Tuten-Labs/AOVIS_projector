function save_params(params, subject_id)
    % 
    % USAGE
    % save_params(params, subject_id)
    %
    
    filename = [subject_id '_params.mat'];   
    
    % save the param files in white/param directory
    whitedir = white.fil.get_path_to_white_dir();
    savename = fullfile(whitedir, 'param', filename);
    save(savename, 'params');
    
    % additionally save params in save_dir if that field is passed in
    % params.save_dir
    if isfield(params, 'save_dir')
        save_dir = params.save_dir;
        if ~isempty(save_dir) && ischar(save_dir)
            % check that directory exists, create one if it doesn't.
            util.check_for_dir(save_dir);
            % full name for saving
            savename = fullfile(save_dir, filename);            
            % save
            save(savename, 'params');
        end
    end    

end