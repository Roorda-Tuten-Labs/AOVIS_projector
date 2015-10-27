function save_to_file(data_record, subject, color, params)

if nargin < 4
    params = [];
end
today = date;
trial = 1;
%%% check to see if the file already exists, change if it does
file_name = ['./data/' subject '/' color '_' today '_' ...
    num2str(trial) '.csv'];
while exist(file_name, 'file') == 2
    trial = trial + 1;
    file_name = ['./data/' subject '/' color '_' today '_' ...
        num2str(trial) '.csv'];
end
csvwrite(file_name, data_record);

if ~isempty(params)
    % change ending to json
    file_name = [file_name(1:end-4) '.json'];
    % set optional parameters
    opt = [];
    opt.FileName = file_name;
    opt.FloatFormat = '%.10g';
    % save as json
    savejson('params', params, opt);

end
