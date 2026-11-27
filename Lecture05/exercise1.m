%% Exercise 2: Find Two Frequencies with the FFT
clear; clc; close all;

fs = 200;
T = 1;
t = 0:1/fs:T-1/fs;

x = 0.8*sin(2*pi*15*t) + 0.4*sin(2*pi*40*t);

N = length(x);
Y = fft(x);

P2 = abs(Y/N);
P1 = P2(1:N/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = fs*(0:N/2)/N;

fig = figure('Name', 'Two-Frequency Signal and Spectrum', 'Color', 'w', 'Position', [100 100 900 600]);

% Time domain (zoomed to first 0.25s for visual clarity)
subplot(2, 1, 1);
plot(t, x, 'b', 'LineWidth', 1.2);
xlim([0 0.25]);
grid on;
xlabel('Time (s)');
ylabel('Amplitude');
title('Time-Domain Signal (First 0.25 s)');

% Single-sided amplitude spectrum
subplot(2, 1, 2);
stem(f, P1, 'r', 'filled', 'MarkerSize', 4, 'LineWidth', 1.1);
grid on;
xlabel('Frequency (Hz)');
ylabel('Amplitude |P1(f)|');
title('Single-Sided Amplitude Spectrum');

saveas(fig, 'two-frequency-spectrum.png');

% Display bin spacing and peaks
df = fs / N;
fprintf('Frequency bin spacing: %.2f Hz\n', df);
[pks, locs] = findpeaks(P1, f, 'MinPeakHeight', 0.1);
for k = 1:length(pks)
    fprintf('Peak %d: Frequency = %.2f Hz, Amplitude = %.4f\n', k, locs(k), pks(k));
end