%% Load Data
clear;
close all;

load('lab3_calibration_data.mat')

enc = alldata(:,2);
idx = find(~isnan(enc));

t = alldata(idx,1);
enc = alldata(idx,2);
sg = alldata(idx,3);
accel = alldata(idx,4);
lvdt_in = alldata(idx,5);
lvdt_out = alldata(idx,6);

%% Calibration
close all

% ------------------- MODIFY THIS PART -------------------- %

% Find a best-fit curve
[pfit_sg,S_sg] = polyfit(enc,sg,1);

% Evaluate best-fit curve and standard error
[sg_fit,delta] = polyval(pfit_sg,enc,S_sg);

% 95% confidence interval = approximately 2 standard deviations
unc_sg = 2*delta;

%% Plotting

figure
hold on

% Raw data
s = scatter(enc,sg);
s.MarkerEdgeAlpha = 0.01;

% Best-fit curve
plot(enc,sg_fit,'LineWidth',2);

% 95% confidence interval
plot(enc,sg_fit + unc_sg,'--', ...
     enc,sg_fit - unc_sg,'--');

xlabel('Encoder Displacement (m)');
ylabel('Strain Gauge Output');

legend('Raw Data', ...
       'Best-Fit Curve', ...
       '95% Confidence Interval');

title('Strain Gauge Calibration');

grid on
hold off

% --------------------------------------------------------- %