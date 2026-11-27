%% Exercise 4: Compare the DTFT and DFT
clear; clc; close all;

x = [1 1 1 1];
n = 0:length(x)-1;

% 1. DTFT over [-pi, pi]
w = linspace(-pi, pi, 1000);
X_dtft = x * exp(-1j * (n.' * w));

% 2. DFT with N = 4 and N = 64 (shifted to [-pi, pi] for direct overlay)
N4 = 4;
X_dft4 = fftshift(fft(x, N4));
w4 = (-N4/2 : N4/2 - 1) * (2*pi / N4);

N64 = 64;
X_dft64 = fftshift(fft(x, N64));
w64 = (-N64/2 : N64/2 - 1) * (2*pi / N64);

% 3. Plot comparison
fig = figure('Name', 'DTFT vs DFT Comparison', 'Color', 'w', 'Position', [100 100 950 620]);

subplot(2, 1, 1);
plot(w, abs(X_dtft), 'b-', 'LineWidth', 1.5);
hold on;
stem(w4, abs(X_dft4), 'ro', 'filled', 'LineWidth', 1.3, 'MarkerSize', 7);
hold off;
grid on;
xlim([-pi pi]);
xticks([-pi -pi/2 0 pi/2 pi]);
xticklabels({'-\pi', '-\pi/2', '0', '\pi/2', '\pi'});
xlabel('Angular frequency \omega (rad/sample)');
ylabel('Magnitude |X|');
title('DTFT vs. 4-Point DFT (fft(x, 4))');
legend('DTFT (Continuous)', '4-Point DFT');

subplot(2, 1, 2);
plot(w, abs(X_dtft), 'b-', 'LineWidth', 1.5);
hold on;
stem(w64, abs(X_dft64), 'g.', 'LineWidth', 1.0, 'MarkerSize', 10);
hold off;
grid on;
xlim([-pi pi]);
xticks([-pi -pi/2 0 pi/2 pi]);
xticklabels({'-\pi', '-\pi/2', '0', '\pi/2', '\pi'});
xlabel('Angular frequency \omega (rad/sample)');
ylabel('Magnitude');
title('DTFT vs. 64-Point DFT (fft(x, 64))');
legend('DTFT (Continuous)', '64-Point DFT');

saveas(fig, 'dtft-dft-comparison.png');