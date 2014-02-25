function plot_data(results, too_short, fit_params, params)

angles = results(:, 5);
unique_angles = unique(angles);

h = figure('visible','off');
plot(unique_angles, too_short, '.', 'color', 'k', ...
    'MarkerSize', 25); hold on;
x = linspace(unique_angles(1), unique_angles(end), 200);
if ~params.invert
    plot(x, normcdf(x, fit_params(1), fit_params(2)), '-', ...
    'color', 'k', 'LineWidth', 2.5);
else
    plot(x, 1 - normcdf(x, fit_params(1), fit_params(2)), '-', ...
        'color', 'k', 'LineWidth', 2.5);
end

axis square
ylim([-0.05, 1.05]);
set(gca,'fontsize', 20, 'linewidth', 1, 'TickDir', 'out', ...
    'TickLength', [0.05 0.0]);
box off;
if ~strcmp(params.uniqueHue, 'white')
    xlabel('chromatic angle');
else
    xlabel('proportion blue');
end
ylabel(params.left);

text(unique_angles(1) * 1.02, 0.35, ['\mu= ' num2str(round(fit_params(1) ...
    * 100) / 100)], 'FontSize', 20);
text(unique_angles(1) * 1.02, 0.25, ['\sigma = ' num2str(round( ...
    fit_params(2) * 100) / 100)], 'FontSize', 20);

trial = 1;
save_name = ['../img/' params.subject '_' params.uniqueHue '_' ...
    num2str(trial) '.eps'];
while exist(save_name, 'file') == 2
    trial = trial + 1;
    save_name = ['../img/' params.subject '_' params.uniqueHue '_' ...
        num2str(trial) '.eps'];
end
saveas(h, save_name, 'epsc');
close(h);

end