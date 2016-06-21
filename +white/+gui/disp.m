function params = disp()
    import white.*

    % display Brief description of GUI.
    if exist('./param/default_params.mat', 'file') == 2
        load ./param/default_params.mat
    else
        params = gen.default_params();
    end

    %  Construct the components
    
    % ---- Figure handle
    f = figure('Visible','on','Name','parameters',...
            'Position',[500, 500, 300, 385], 'Toolbar', 'none');
    
    % ---- Panel
    ph = uipanel('Parent',f, 'Title', 'Experiment parameters',...
            'Position',[.05 .05 .9 .9]);

    % ---- Text boxes
    uicontrol(ph,'Style','text',...
                'String','CIE x',...
                'Units','normalized',...
                'Position',[.05 .8 .4 .15]);
            
    x_coord = uicontrol(ph,'Style','edit',...
            'Units','normalized',...
            'String', num2str(params.x),...
            'Position', [.05 .75 .4 .15]);

    uicontrol(ph,'Style','text',...
                'String','CIE y',...
                'Units','normalized',...
                'Position', [.05 .6 .4 .15]);
            
    y_coord = uicontrol(ph,'Style','edit',...
            'Units','normalized',...
            'String', num2str(params.y),...
            'Position', [.05 .55 .4 .15]); 
        
    uicontrol(ph,'Style','text',...
                'String','luminance (Y)',...
                'Units','normalized',...
                'Position',[.05 .4 .4 .15]);
            
    LUM = uicontrol(ph,'Style','edit',...
            'Units','normalized',...
            'String', num2str(params.LUM),...
            'Position', [.05 .35 .4 .15]); 
        
    uicontrol(ph,'Style','text',...
                'String','calibration file',...
                'Units','normalized',...
                'Position',[.55 .8 .4 .15]);    
            
    cal_file = uicontrol(ph,'Style','edit',...
            'Units','normalized',...
            'String', num2str(params.cal_file),...
            'Position', [.55 .75 .4 .15], ...
            'Enable', 'Inactive', ...
            'ButtonDownFcn', @get_cal_file);

    uicontrol(ph,'Style','text',...
                'String','screen',...
                'Units','normalized',...
                'Position',[.55 .6 .4 .15]);
            
    screen = uicontrol(ph,'Style','edit',...
            'Units','normalized',...
            'String', num2str(params.screen),...
            'Position', [.55 .55 .4 .15]);

    uicontrol(ph,'Style','text',...
                'String','fixation size (px)',...
                'Units','normalized',...
                'Position',[.55 .4 .4 .15]);
            
    fixation_size = uicontrol(ph,'Style','edit',...
                'Units','normalized',...
                'String', num2str(params.fixation_size),...
                'Position', [.55 .35 .4 .15]);
        
    % ---- Buttons

    uicontrol(ph,'Style','pushbutton','String','start',...
            'Units','normalized',...
            'Position', [.05 .05 .9 .15], ...
            'Callback', 'uiresume(gcbf)');

    uiwait(f);
    
    get_current_params();
    
    function get_cal_file(~, ~)
        [fname, directory] = uigetfile({'*.mat'; }, ...
            'Select the calibration file', './cal/files/');
        params.cal_file = fname;
        params.cal_dir = directory;
        set(cal_file,'String', params.cal_file);
    end

    function get_current_params()
        params.x = str2double(get(x_coord,'String'));
        params.y = str2double(get(y_coord,'String'));
        params.LUM = str2double(get(LUM,'String'));

        params.screen = str2double(get(screen,'String'));
   
        %%% image params
        [params.display_width, params.display_height] = Screen('DisplaySize', ...
            params.screen);
        [params.pixel_width, params.pixel_height] = Screen('WindowSize', ...
            params.screen);
        
        params.save_params = 1;
        params.fixation_size = str2double(get(fixation_size, 'String'));

        params.psych_method = 'display';
        
    end

    close all;

end