%% Load Data
clear;
close all;

load('lab3_calibration_data.mat')

enc = alldata(:,2);
idx=find(~isnan(enc));

t = alldata(idx,1);
enc = alldata(idx,2);
sg = alldata(idx,3);
acc = alldata(idx,4);
lvdt_in = alldata(idx,5);
lvdt_out = alldata(idx,6);

%% Differentiate
% To effectively differentiate data, it usually needs to be smoothed (zoom
% into the raw encoder data to see why). 

t_smoothed = [];
acc_smoothed = [];
enc_acc_smoothed = [];

% Smooth displacement
for i = 1:Ntrials

    % Take one trial
    enc_disp = enc((i-1)*N+1:i*N);
    t_i = t((i-1)*N+1:i*N);
    acc_i = acc((i-1)*N+1:i*N);
    
    % -------------------- MODIFY THIS PART -------------------- %
    % Smooth displacement data
    % Play around with the span to make sure data is appropriately smoothed
    % without attenuation
    span = 500; 
    enc_disp_smooth = smoothdata(enc_disp,span);

    % Check span
    figure
    hold on
    scatter(t_i,enc_disp)
    scatter(t_i,enc_disp_smooth)

    % Differentiate (hint: try using the diff function)
    enc_vel = diff(enc_disp_smooth)./diff(t_i);       % FILL IN
    % ---------------------------------------------------------- %

    % Truncate
    % When the data is smoothed, the first span/2 data points don't have
    % enough data to be properly smoothed (why is that?). When the data is
    % differentiated, one data point is lost (why is that?)
    enc_vel = enc_vel(span/2:end-span/2);
    t_i = t_i(span/2:end-span/2-1);
    acc_i = acc_i(span/2:end-span/2-1);

    % -------------------- MODIFY THIS PART -------------------- %
    % Smooth velocity data
    % Play around with the span to make sure data is appropriately smoothed
    % without attenuation
    span = 400;
    enc_vel_smooth = smoothdata(enc_vel,span);
    
    % Check span
    figure
    hold on
    scatter(t_i,enc_vel)
    scatter(t_i,enc_vel_smooth)

    % Differentiate (hint: try using the diff function)
    enc_acc = diff(enc_vel_smooth)./diff(t_i);     % FILL IN
    % ---------------------------------------------------------- %

    % Truncate again
    enc_acc = enc_acc(span/2:end-span/2);
    t_i = t_i(span/2:end-span/2-1);
    acc_i = acc_i(span/2:end-span/2-1);

    % Smooth Accel
    % Play around with the span to make sure data is appropriately smoothed
    % without attenuation
    span = 300;
    enc_acc_smooth = smoothdata(enc_acc,span);

    figure
    hold on
    scatter(t_i,enc_acc)
    scatter(t_i,enc_acc_smooth)

    % Store
    t_smoothed = vertcat(t_smoothed,t_i);
    acc_smoothed = vertcat(acc_smoothed,acc_i);
    enc_acc_smoothed = vertcat(enc_acc_smoothed,enc_acc_smooth);


end

%% Calibrate

close all;

% ------------------- MODIFY THIS PART -------------------- %
% Find best linear fit (hint: try using the polyfit function)

[pfit_acc,S_acc] = polyfit(enc_acc_smoothed,acc_smoothed,1);       % FILL IN



% Determine the 95% confidence interval (2 standard deviations)
% (hint: try using the polyval function)

[acc_expect,delta] = polyval(pfit_acc,enc_acc_smoothed,S_acc);     % FILL IN
unc_acc = 2* delta;                         % FILL IN

%% Plotting

figure
hold on
scatter(); % Use a scatter plot for your raw data
plot();    % Plot your best-fit curve
plot();    % Plot the 95% confidence interval

xlabel(); % Label your axes, ...
ylabel();
legend(); % create a legend, ...
title();  % and title your plot.
% --------------------------------------------------------- %