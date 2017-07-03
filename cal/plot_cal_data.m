function plot_cal_data(cal)
% Plot the gamut, gamma and wavelength spectrum from a cal file organized
% in the typical Psychtoolbox format.
%
% USAGE
% plot_cal_data(cal)
%
% INPUT
% cal   cal can be either a structure or the name of a cal structure in the
%       files directory that will be loaded.
%
% EXAMPLE
% cal = LoadCalFile('RoordaLab_projector_9June2017', 1, 'files');
% plot_cal_data(cal);
% 
% RETURNS
% Three plots. Each is saved in img directory as an svg file.
%
if nargin < 1
    cal = LoadCalFile('Feb13_2014a', 1, 'files');
end

if ischar(cal)
    cal = LoadCalFile(cal, 1, 'files');
end

% save location in img dir. based on monitor name and date of calibration.
if isfield(cal.describe, 'date')
    %measure_date = strsplit(cal.describe.date);
    endind = strfind(cal.describe.date, ' ');
    measure_date = cal.describe.date(1:endind(1)-1);
else
    measure_date = {'unknown'};
end
if isfield(cal.describe, 'monitor')
    monitor_name = strrep(cal.describe.monitor, ' ', '_');
else
    monitor_name = 'unknown';
end
basedir = fullfile('img', monitor_name, measure_date);
%basedir = fullfile('img', monitor_name, measure_date{1});

% for color of RGB measurements.
colorCycle = [1 0 0; 0 0.6 0; 0 0 1];

% -------- PLOTS --------- %
% 1. spectrum of primaries
fig = figure(1);

% Change to new colors.
set(gca, 'ColorOrder', colorCycle, ...
    'NextPlot', 'replacechildren');

plot(SToWls(cal.S_device), cal.P_device, 'LineWidth', 2.5);

title('Primaries', 'Fontsize', 20, 'Fontname', 'helvetica');
axis([380, 780, 0, Inf]);

plots.nice_axes('wavelength (nm)', 'power', 20, 0)
plots.save_fig(fullfile(basedir, 'primaries'), fig, 1, 'pdf')

% 2. CIE plot of gamut
fig = figure(2);

T_xyz1931 = csvread('data/ciexyz31.csv')';
S_xyz1931 = [380, 5, 81];

CMFs = SplineCmf(S_xyz1931, T_xyz1931, cal.S_device);
%wvlens = SToWls(cal.S_device);

cor_xyz = cal.P_device' * CMFs';        
gun_xyz  = diag(1 ./ sum(cor_xyz, 2)) * cor_xyz;

xyz = diag(1 ./ sum(CMFs, 1)) * CMFs';

plot(xyz(:, 1), xyz(:, 2), 'k-', 'LineWidth', 2); hold on;
plot(gun_xyz(:, 1), gun_xyz(:, 2), 'k.', 'MarkerSize', 30);
plot(gun_xyz(:, 1), gun_xyz(:, 2), 'k--', 'LineWidth', 2.5);
plot([gun_xyz(1, 1) gun_xyz(3, 1)], ...
    [gun_xyz(1, 2) gun_xyz(3, 2)], 'k--', 'LineWidth', 2.5);
    
axis square
xlim([0, 0.9]);
ylim([0, 0.9]);

plots.nice_axes('CIE x', 'CIE y', 20, 0)
plots.save_fig(fullfile(basedir, 'CIExy_plot'), fig, 1, 'pdf')

% 3. Gamma functions
fig = figure(3);

set(gca, 'ColorOrder', colorCycle, ...
    'NextPlot', 'replacechildren');
plot(cal.rawdata.rawGammaInput, cal.rawdata.rawGammaTable, '+', ...
    'MarkerSize', 20);
hold on;
plot(cal.gammaInput, cal.gammaTable, 'LineWidth', 2);

title('Gamma functions', 'Fontsize', 20, 'Fontname', 'helvetica');

xlim([0 1.0]);
ylim([0 1.0]);

plots.nice_axes('input value', 'normalized output', 20, 0);
plots.save_fig(fullfile(basedir, 'gamma_functions'), fig, 1, 'pdf')
