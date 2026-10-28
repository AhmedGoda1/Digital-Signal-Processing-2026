fs = 1000;
t = 0:1/fs:1-1/fs;

%% Task 1 %%

A1 = 1;
f1 = 5;
y1 = A1 * sin(2*pi*f1*t);

figure('Name','Task1: Basic sine wave')
plot(t, y1, 'b', 'LineWidth', 1.5);
title('5 Hz Sine wave (Task 1)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

%% Task 2 Compare Different Frequencies %%
f_low = 2;
f_mid = 5;
f_high = 10;
yLow = sin(2*pi*f_low*t);
yMid = sin(2*pi*f_mid*t);
yHigh = sin(2*pi*f_high*t);

fig_freq = figure('Name', 'Task2: Frequency Comparison');

subplot(3, 1, 1);
plot(t, yLow, 'r', 'LineWidth', 1.2);
title('2 Hz Sine Wave');
xlabel('Time(s)');
ylabel('Amplitude');
grid on;

subplot(3, 1, 2);
plot(t, yMid, 'r', 'LineWidth', 1.2);
title('5 Hz Sine Wave');
xlabel('Time(s)');
ylabel('Amplitude');
grid on;

subplot(3, 1, 3);
plot(t, yHigh, 'r', 'LineWidth', 1.2);
title('10 Hz Sine Wave');
xlabel('Time(s)');
ylabel('Amplitude');
grid on;

%% --- Task 3: Compare Different Amplitudes ---
A_small = 0.5;
A_medium = 1.0;
A_large = 2.0;
f_const = 5;            % Same frequency for all

y_A05 = A_small * sin(2 * pi * f_const * t);
y_A10 = A_medium * sin(2 * pi * f_const * t);
y_A20 = A_large * sin(2 * pi * f_const * t);

fig_amp = figure('Name', 'Task 3: Amplitude Comparison');
subplot(3, 1, 1);
plot(t, y_A05, 'm', 'LineWidth', 1.2);
title('Amplitude = 0.5 (5 Hz)');
xlabel('Time (s)');
ylabel('Amplitude');
ylim([-2.5 2.5]);
grid on;

subplot(3, 1, 2);
plot(t, y_A10, 'c', 'LineWidth', 1.2);
title('Amplitude = 1.0 (5 Hz)');
xlabel('Time (s)');
ylabel('Amplitude');
ylim([-2.5 2.5]);
grid on;

subplot(3, 1, 3);
plot(t, y_A20, 'k', 'LineWidth', 1.2);
title('Amplitude = 2.0 (5 Hz)');
xlabel('Time (s)');
ylabel('Amplitude');
ylim([-2.5 2.5]);
grid on;

%% --- Task 4: Add Noise ---
clean_signal = sin(2 * pi * 5 * t);
noise = 0.4 * randn(size(t));      % Zero-mean Gaussian random noise
noisy_signal = clean_signal + noise;

fig_noise = figure('Name', 'Task 4: Clean vs Noisy Signal');
subplot(2, 1, 1);
plot(t, clean_signal, 'b', 'LineWidth', 1.5);
title('Clean 5 Hz Sine Wave');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(2, 1, 2);
plot(t, noisy_signal, 'r', 'LineWidth', 1.2);
title('Noisy Sine Wave (Clean + Gaussian Noise)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

%% --- Task 5: Save Figures ---
saveas(fig_freq, 'frequency_comparison.png');
saveas(fig_amp, 'amplitude_comparison.png');
saveas(fig_noise, 'clean_vs_noisy_signal.png');

disp('All tasks completed and figures saved successfully.');