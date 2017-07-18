function params = load_params(subject_id)
    % 
    % params = load_params(subject_id)
    
    whitedir = white.fil.get_path_to_white_dir();    
    n = fullfile(whitedir, 'param', [subject_id '_params.mat']);    
    params = load(n);
    params = params.params;
end