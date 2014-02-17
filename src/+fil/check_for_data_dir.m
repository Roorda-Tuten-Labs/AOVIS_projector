function check_for_data_dir(subject)

    if ~exist('data', 'dir')
        mkdir('data/')
    end
    if ~exist(['data/' subject], 'dir')
        mkdir(['data/' subject])
    end

end