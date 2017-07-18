function save_last_subject(subject_id)

    fid = fopen(fullfile(white.fil.get_path_to_white_dir, 'param', ...
        'last_subject.txt'), 'w');
    fprintf(fid, subject_id);
    fclose(fid);

end