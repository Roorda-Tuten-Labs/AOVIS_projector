function params = load_params(subject_id)
    params = load(['./param/' subject_id '_params.mat']);
    params = params.params;
end