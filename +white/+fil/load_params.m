function params = load_params(pathname)
    % 
    % params = load_params(pathname)
    
    params = load(pathname);
    params = params.params;
end