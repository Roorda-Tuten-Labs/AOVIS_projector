function plot_stimuli(hues, params, fig_num)

import gen.gen_hue_specific_params
import gen.gen_image_sequence
import convert.CIE_from_Angle

if nargin < 1
    hues = {'yellow' 'blue' 'white'};
end
if nargin < 3
    fig_num = 3;
end

if ~isfield(params, 'cal_file')
    params.cal_file = 'Feb13_2014a';
end

if strcmp(params.color_space, 'Luv')
    params.blue_abc = [0.17, 0.425]';
    params.yellow_abc = [0.2, 0.54]';
elseif strcmp(params.color_space, 'xyY')
    params.blue_abc = [0.28 0.28]';
    params.yellow_abc = [0.32 0.4]';
end

cal = LoadCalFile(params.cal_file);
T_xyz1931 = csvread('ciexyz31.csv')';
S_xyz1931 = [380, 5, 81];

xyz = diag(1 ./ sum(T_xyz1931, 1)) * T_xyz1931';
fig = figure(fig_num);
set(fig, 'Position', [100, 100, 800, 400]);

subplot(1, 2, 1);
    uv = xyTouv(xyz(:, 1:2)')';
    plot(uv(:, 1), uv(:, 2), 'k-', 'LineWidth', 2); hold on;
    xlim([0, 0.62]);
    ylim([0, 0.62]);
    xlabel('u*');
    ylabel('v*');
    plot(params.white(1), params.white(2), 'k.', 'Markersize', 15);

    guns = cal.P_device;
    CMFs = SplineCmf(S_xyz1931, T_xyz1931, cal.S_device);
    guns_xyz = guns' * CMFs';
    guns_xyz = diag(1 ./ sum(guns_xyz, 2)) * guns_xyz;  

    guns = xyTouv(guns_xyz(:, 1:2)')';
    plot(guns(:, 1), guns(:, 2), 'k.', 'MarkerSize', 30);
    plot(guns(:, 1), guns(:, 2), 'k--', 'LineWidth', 2.5);
    plot([guns(1, 1) guns(3, 1)], ...
        [guns(1, 2) guns(3, 2)], 'k--', 'LineWidth', 2.5);
    
subplot(1, 2, 2);
    plot(xyz(:, 1), xyz(:, 2), 'k-', 'LineWidth', 2); hold on;
    xlim([0, 0.9]);
    ylim([0, 0.9]);
    xlabel('x');
    ylabel('y');
    plot(1/3, 1/3, 'k.', 'Markersize', 15); 
    
    guns = guns_xyz(:, 1:2);
    plot(guns(:, 1), guns(:, 2), 'k.', 'MarkerSize', 30);
    plot(guns(:, 1), guns(:, 2), 'k--', 'LineWidth', 2.5);
    plot([guns(1, 1) guns(3, 1)], ...
        [guns(1, 2) guns(3, 2)], 'k--', 'LineWidth', 2.5);

T_xyz1931 = 683 * T_xyz1931; % lm/W (CIE recommendation for self-luminous)
cal = SetSensorColorSpace(cal, T_xyz1931, S_xyz1931);
cal = SetGammaMethod(cal,0);

for hue=hues
    params = gen_hue_specific_params(hue, params);
    
    for i=1:params.ncolors
        if strcmp(params.uniqueHue, 'yellow') || ...
                strcmp(params.uniqueHue, 'blue')
            % iterate through each color in chromaticities above
            [a, b] = CIE_from_Angle(params.angles(i), params.RHO, ...
                params.color_space);
        else
            a = params.x(i);
            b = params.y(i);
        end
        
        if strcmp(params.color_space, 'xyY')
            tmp = xyTouv([a b]');
            a = tmp(1); b = tmp(2);
        end
        
        % Convert to RGB:
        xy = uvToxy([a b]');
        xyY = [xy(1, :), xy(2, :) params.LUM]';

        XYZ = xyYToXYZ(xyY);
        [RGB, outOfRangePixels] = SensorToSettings(cal, XYZ);
        % Check for out-of-range non-displayable color values:
        if any(outOfRangePixels)
            fprintf('WARNING: Out of range RGB values!\n');
            fprintf('pix = %f\n', outOfRangePixels);
            fprintf('rgb = %f\n', RGB);
        end
        
        subplot(1, 2, 1);
        plot(a, b, '.', 'MarkerSize', 25,  'color', RGB);
        subplot(1, 2, 2);
        xyz = XYZ / sum(XYZ);
        plot(xyz(1, :), xyz(2, :), '.', 'MarkerSize', 25, 'color', RGB);

    end
end

subplot(1, 2, 1);
    axis square
    set(gca,'fontsize', 20, 'linewidth', 1, 'TickDir', 'out', ...
        'TickLength', [0.05 0.0]);
    box off;
    xlabel('u');
    ylabel('v');

subplot(1, 2, 2);

    axis square
    set(gca,'fontsize', 20, 'linewidth', 1, 'TickDir', 'out', ...
        'TickLength', [0.05 0.0]);
    box off;
    xlabel('x');
    ylabel('y');
end