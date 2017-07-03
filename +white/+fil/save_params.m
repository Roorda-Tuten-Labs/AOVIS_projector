function save_params(params, subject_id)
    savename = ['./param/' subject_id '_params.mat'];
    save(savename, 'params');

end