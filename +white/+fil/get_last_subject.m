function last_subject = get_last_subject()

    fid = fopen(fullfile(white.fil.get_path_to_white_dir, 'param', ...
        'last_subject.txt'));
    last_subject = textscan(fid, '%s');
    fclose(fid);
    last_subject = last_subject{1};
    
end