%% Exercise 3: Investigate Spectral Leakage
clear; clc; close all;

d = 4;   % <--- REPLACE 4 WITH THE LAST DIGIT OF YOUR STUDENT NUMBER (0-9)
f1 = 15;
f2 = 13.2 + 0.17*d;
fs = 200;

% Helper function for single-sided spectrum
compute_spectrum = @(sig, N_fft) deal( ...
    fs*(0:(N_fft/2))/N_fft, ...
    [abs(fft(sig, N_fft)/length(sig)); ] );

%% Case 1: 1-second recording (N = 200)
T1 = 1;
t1 = 0:1/fs:T1-1/fs;
x1 = 0.8*sin(2*pi*f1*t1) + 0.4*sin(2*pi*f2*t1);

N1 = length(x1);
Y1 = fft(x1);
P2_1 = abs(Y1/N1);
P1_1 = P2_1(1:N1/2+1);
P1_1(2:end-1) = 2*P1_1(2:end-1);
freq1 = fs*(0:N1/2)/N1;

%% Case 2: 4-second recording (N = 800)
T4 = 4;
t4 = 0:1/fs:T4-1/fs;
x4 = 0.8*sin(2*pi*f1*t4) + 0.4*sin(2*pi*f2*t4);

N4 = length(x4);
Y4 = fft(x4);
P2_4 = abs(Y4/N4);
P1_4 = P2_4(1:N4/2+1);
P1_4(2:end-1) = 2*P1_4(2:end-1);
freq4 = fs*(0:N4/2)/N4;

%% Case 3: 1-second recording with 4x zero-padding (N_fft = 800)
N_zp = 4 * N1;
Y_zp = fft(x1, N_zp);
P2_zp = abs(Y_zp/N1); % Normalize by actual signal length N1
P1_zp = P2_zp(1:N_zp/2+1);
P1_zp(2:end-1) = 2*P1_zp(2:end-1);
freq_zp = fs*(0:N_zp/2)/N_zp;

%% Plot Comparison
fig = figure('Name', 'Spectral Leakage Comparison', 'Color', 'w', 'Position', [100 100 950 720]);

subplot(3, 1, 1);
stem(freq1, P1_1, 'b', 'filled', 'MarkerSize', 4);
xlim([0 30]); ylim([0 0.9]); grid on;
xlabel('Frequency (Hz)'); ylabel('Amplitude');
title(sprintf('1-Second Recording (\\Deltaf = 1.0 Hz, f_2 = %.2f Hz)', f2));

subplot(3, 1, 2);
stem(freq4, P1_4, 'g', 'filled', 'MarkerSize', 4);
xlim([0 30]); ylim([0 0.9]); grid on;
xlabel('Frequency (Hz)'); ylabel('Amplitude');
title(sprintf('4-Second Recording (\\Deltaf = 0.25 Hz, f_2 = %.2f Hz)', f2));

subplot(3, 1, 3);
plot(freq_zp, P1_zp, 'r-', 'LineWidth', 1.3);
hold on;
stem(freq1, P1_1, 'b', 'filled', 'MarkerSize', 4);
hold off;
xlim([0 30]); ylim([0 0.9]); grid on;
xlabel('Frequency (Hz)'); ylabel('Amplitude');
title('1-Second Recording with 4x Zero-Padding (Interpolated Spectrum)');
legend('Zero-Padded (N_{fft}=800)', 'Original 1s Bins (N=200)');

saveas(fig, 'leakage-comparison.png');
fprintf('Used d = %d -> f2 = %.2f Hz\n', d, f2);