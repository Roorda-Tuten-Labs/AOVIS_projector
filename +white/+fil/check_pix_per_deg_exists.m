function check_pix_per_deg_exists()
    % Check that pix_per_deg.txt file exists and create one if it does not.
    
    filedir = white.fil.get_path_to_white_dir();        
    fname = fullfile(filedir, 'param', 'pix_per_deg.txt');
    if exist(fname, 'file')
        params.pix_per_deg = csvread(fname);
    else
        % 
        [widthPix, ~] = Screen('WindowSize', params.screen);
        [widthMM, ~] = Screen('DisplaySize', params.screen);
        mm_per_pix = widthMM / widthPix;

        view_distanceMM = 1000; % 1 meter
        pix_per_deg = rad2deg(tan((mm_per_pix / 2) / view_distanceMM) * 2) ^ -1;

        params.pix_per_deg = pix_per_deg;

        disp(['param/pix_per_deg.txt file does not exist. Creating one now.'...
            'Default value: ' num2str(params.pix_per_deg)])
        disp(['This was computed based on the size of your monitor and ' ...
            'assuming a veiwing distance of 1 meter.']);

        % check that the param directory exists and create it if not.
        if ~exist(fullfile(whitedir, 'param'), 'dir')
            mkdir(fullfile(whitedir, 'param'))
        end    
        csvwrite('param/pix_per_deg.txt', params.pix_per_deg);
    end