function plot_stimuli(hues, params)

if nargin < 1
    hues = {'yellow' 'blue' 'white'};
end

if ~isfield(params, 'cal_file')
    params.cal_file = 'Feb13_2014a';
end

if ~isfield(params, 'LUM')
    LUM = 60;
end
if ~isfield(params, 'ncolors')
    ncolors = 10;
end
if ~isfield(params, 'RHO')
    RHO = 0.09;
end

if ~isfield(params, 'angle_bounds')
    angle_bounds = [];
    angle_bounds.y1 = 40;
    angle_bounds.y2 = 100;
    angle_bounds.b1 = 180;
    angle_bounds.b2 = 240;
end

% assumed blue and yellow loci
if ~isfield(params, 'blue')
    params.blu = 209;
end
if ~isfield(params, 'yel')
    params.yel = 78;
end

cal = LoadCalFile(cal_file);
T_xyz1931 = csvread('ciexyz31.csv')';
S_xyz1931 = [380, 5, 81];

xyz = diag(1 ./ sum(T_xyz1931, 1)) * T_xyz1931';
figure(1); 
plot(xyz(:, 1), xyz(:, 2), 'k-', 'LineWidth', 2); hold on;

T_xyz1931 = 683 * T_xyz1931;
cal = SetSensorColorSpace(cal, T_xyz1931, S_xyz1931);
cal = SetGammaMethod(cal,0);

guns = cal.P_device;
CMFs = SplineCmf(S_xyz1931, T_xyz1931, cal.S_device);
guns_xyz = guns' * CMFs';
guns_xyz = diag(1 ./ sum(guns_xyz, 2)) * guns_xyz;  

plot(guns_xyz(:, 1), guns_xyz(:, 2), 'k.', 'MarkerSize', 30);
plot(guns_xyz(:, 1), guns_xyz(:, 2), 'k--', 'LineWidth', 2.5);
plot([guns_xyz(1, 1) guns_xyz(3, 1)], ...
    [guns_xyz(1, 2) guns_xyz(3, 2)], 'k--', 'LineWidth', 2.5);
plot(1/3, 1/3, 'k.', 'Markersize', 15);
    
for hue=hues
    uniqueHue = hue;
    
    if strcmp(uniqueHue, 'yellow') 
        angle_1 = angle_bounds.y1; 
        angle_2 = angle_bounds.y2;
        angles = linspace(angle_1, angle_2, ncolors);

    elseif strcmp(uniqueHue, 'blue')
        angle_1 = angle_bounds.b1; 
        angle_2 = angle_bounds.b2;
        angles = linspace(angle_1, angle_2, ncolors);

    elseif strcmp(uniqueHue, 'white')

        [b_x, b_y] = CIE_from_Angle(blu, RHO);
        [y_x, y_y] = CIE_from_Angle(yel, RHO);
        line1 = [b_x b_y; y_x y_y];

        ncolors = 15; % override default setting to ensure good sampling
        angles = linspace(blu - 5, yel + 5, ncolors);

        x = zeros(ncolors, 1);
        y = zeros(ncolors, 1);
        for i=1:length(angles)
            [x_, y_] = CIE_from_Angle(angles(i), 0.3);
            line2 = [x_ y_; 1/3 1/3];
            [x(i), y(i)] = intersect(line1, line2);
        end
    end

    for i=1:ncolors
        if strcmp(uniqueHue, 'yellow') || strcmp(uniqueHue, 'blue')
            % iterate through each color in chromaticities above
            [x, y] = CIE_from_Angle(angles(i), RHO);
            xyY = [x y LUM]';
        else
            xyY = [x(i) y(i) LUM]';
        end

        % Convert to RGB:
        XYZ = xyYToXYZ(xyY);
        [RGB, outOfRangePixels] = SensorToSettings(cal, XYZ);

        XYZ = XYZ / sum(XYZ);
        plot(XYZ(1), XYZ(2), '.', 'MarkerSize', 25,  'color', RGB);

    end

end

axis square
xlim([0, 0.9]);
ylim([0, 0.9]);
set(gca,'fontsize', 20, 'linewidth', 1, 'TickDir', 'out', ...
    'TickLength', [0.05 0.0]);
box off;
xlabel('x');
ylabel('y');
    
end