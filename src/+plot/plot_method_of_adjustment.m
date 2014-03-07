function plot_method_of_adjustment(data, params)

import gen.gen_hue_specific_params
import gen.gen_image_sequence
import convert.CIE_from_Angle

if ~isfield(params, 'cal_file')
    params.cal_file = 'Feb13_2014a';
end

cal = LoadCalFile(params.cal_file);
T_xyz1931 = csvread('ciexyz31.csv')';
S_xyz1931 = [380, 5, 81];

xyz = diag(1 ./ sum(T_xyz1931, 1)) * T_xyz1931';
fig = figure('visible','off');
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

for i=1:params.nrepeats
    
    a = data(i, 4);
    b = data(i, 5);
    
    if strcmp(params.color_space, 'xyY')
        tmp = xyTouv([a b]');
        a = tmp(1); b = tmp(2);
    end

    % Convert to RGB:
    xy = uvToxy([a b]');
    xyY = [xy(1, :), xy(2, :) params.LUM]';

    XYZ = xyYToXYZ(xyY);
    RGB = SensorToSettings(cal, XYZ);

    subplot(1, 2, 1);
    plot(a, b, '.', 'MarkerSize', 25,  'color', RGB);
    subplot(1, 2, 2);
    xyz = XYZ / sum(XYZ);
    plot(xyz(1, :), xyz(2, :), '.', 'MarkerSize', 25, 'color', RGB);

end

% ---- Plot measured mean and SEM ----
data_xyz = data(:, 1:3);
data_uv = XYZTouv(data_xyz')';
data_xy = XYZToxyY(data_xyz')';

mean_xy = mean(data_xy(:, 1:2), 1);
std_xy = std(data_xy(:, 1:2), 1);
sem_xy = std_xy / sqrt(params.nrepeats);

mean_uv = mean(data_uv, 1);
std_uv = std(data_uv, 1);
sem_uv = std_uv / sqrt(params.nrepeats);

subplot(1, 2, 1);
    import plot.errorbarxy
    errorbarxy(mean_uv(1), mean_uv(2), sem_uv(1), sem_uv(2), ...
        {'k.', 'k', 'k'});
    
    axis square
    set(gca,'fontsize', 20, 'linewidth', 1, 'TickDir', 'out', ...
        'TickLength', [0.05 0.0]);
    box off;
    xlabel('u');
    ylabel('v');

subplot(1, 2, 2);
    errorbarxy(mean_xy(1), mean_xy(2), sem_xy(1), sem_xy(2), ...
        {'k.', 'k', 'k'});

    axis square
    set(gca,'fontsize', 20, 'linewidth', 1, 'TickDir', 'out', ...
        'TickLength', [0.05 0.0]);
    box off;
    xlabel('x');
    ylabel('y');
    
trial = 1;
save_name = ['../img/' params.subject '_' params.uniqueHue '_' ...
    num2str(trial) '.eps'];
while exist(save_name, 'file') == 2
    trial = trial + 1;
    save_name = ['../img/' params.subject '_' params.uniqueHue '_' ...
        num2str(trial) '.eps'];
end
saveas(fig, save_name, 'epsc');
close(fig);

end