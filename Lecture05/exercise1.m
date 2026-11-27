%% Exercise 1: Build a Square Wave from Harmonics
clear; clc; close all;

t = linspace(-1, 1, 4000);
H_values = [1, 3, 9, 25];

fig = figure('Name', 'Square Wave Harmonics', 'Color', 'w', 'Position', [100 100 950 650]);

for idx = 1:length(H_values)
    H = H_values(idx);
    x = zeros(size(t));

    for k = 1:2:H
        x = x + (4/pi) * sin(2*pi*k*t) / k;
    end

    subplot(2, 2, idx);
    plot(t, x, 'b', 'LineWidth', 1.3);
    grid on;
    xlabel('Time (s)');
    ylabel('Amplitude');
    ylim([-1.4 1.4]);
    title(sprintf('Square Wave Approximation (H = %d)', H));
end

saveas(fig, 'square-wave-comparison.png');