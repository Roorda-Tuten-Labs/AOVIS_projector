function decision = main()
    % display Brief description of GUI.
    decision = '';
    
    %  Construct the components
    
    % ---- Figure handle
    f = figure('Visible','on','Name','parameters',...
            'Position',[500, 500, 200, 200], 'Toolbar', 'none');
    
    % ---- Panel
    ph = uipanel('Parent',f, 'Title', 'Run experiment or display?',...
            'Position',[.05 .05 .9 .9]);

    % ---- Buttons
    uicontrol(ph,'Style','pushbutton','String','experiment',...
            'Units','normalized',...
            'Position', [.05 .5 .9 .3], ...
            'Callback', @experiment);

    uicontrol(ph,'Style','pushbutton','String','display',...
            'Units','normalized',...
            'Position', [.05 .05 .9 .3], ...
            'Callback', @display);

    uiwait(f);

    function experiment(~, ~)
        uiresume(f);
        decision = 'experiment';
    end
    function display(~, ~)
        uiresume(f);
        decision = 'display';
    end

    close all;

end