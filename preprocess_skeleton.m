%% Load Data and preliminary processing
clear

% ------------- FILL IN ------------- %
Ntrials = 10;
% ----------------------------------- %

N = 40000;    % Datapoints
Ts = 1/40000; % Time between samples
T = N*Ts;     % Runtime
fs = 1/Ts;    % Sampling frequency

alldata = zeros(Ntrials*N,6);
for i = 1:Ntrials
    % -------------- MODIFY THIS PART -------------- %
    % Load file
    filename = strcat('lab3_calibration',num2str(i),'.xlsx');
    data_i = readmatrix(filename);
    
    % Zero encoder data
    data_i(:,2) = data_i(:,2) - mean(data_i(:,2));             % FILL IN
    
    % Convert encoder data to meters
    data_i(:,2) = data_i(:,2) * 0.0254 ;             % FILL IN
    
    % Add current trial data to all data
    alldata((i-1)*N+1:i*N,:) = data_i;
    % ---------------------------------------------- %
end

clearvars -except alldata N T fs Ts Ntrials

% Saving data so that it can be loaded later
save('lab3_calibration_data.mat');

