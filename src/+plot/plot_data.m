function plot_data(results, too_short, params, ylabel_name, subject)

angles = results(:, 5);
unique_angles = unique(angles);

if nargin < 4
    ylabel_name = 'too short';
end
if nargin < 5
    subject = 'sample';
end

h = figure();
plot(unique_angles, too_short, '.', 'color', 'k', ...
    'MarkerSize', 25); hold on;
x = linspace(unique_angles(1), unique_angles(end), 200);
plot(x, normcdf(x, params(1), params(2)), '-', ...
    'color', 'k', 'LineWidth', 2.5);

text(unique_angles(1) + 1, 0.95, ['\mu= ' num2str(round(params(1) ...
    * 100) / 100)], 'FontSize', 20);
text(unique_angles(1) + 1, 0.85, ['\sigma = ' num2str(round( ...
    params(2) * 100) / 100)], 'FontSize', 20);

axis square
ylim([-0.05, 1.05]);
set(gca,'fontsize', 20, 'linewidth', 1, 'TickDir', 'out', ...
    'TickLength', [0.05 0.0]);
box off;
xlabel('chromatic angle');
ylabel(ylabel_name);

trial = 1;
ylabel_name = strrep(ylabel_name, ' ', '_'); %replace space with underscore
save_name = ['../img/' subject '_' ylabel_name '_' num2str(trial)];
while exist(save_name, 'file') == 2
    trial = trial + 1;
    save_name = ['../img/' subject '_' ylabel_name '_' num2str(trial)];
end
saveas(h, save_name, 'epsc');
    
end