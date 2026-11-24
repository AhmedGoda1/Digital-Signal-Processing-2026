%% Lecture 3
rng(1);

%% Create a clean discrete-time signal
n = 0:100;
clean = sin(0.1*pi*n);

%% Add noise
noise = 0.4*randn(size(n));
measured = clean + noise;

%% Display the clean and noisy signals
figure('Name', 'Initial Signals', 'Color', 'w');
plot(n, clean, 'b', 'LineWidth', 1.5);
hold on;
plot(n, measured, 'Color', [0.6 0.6 0.6]);
grid on;
xlabel('Sample index n');
ylabel('Amplitude');
title('Clean and Noisy Signals');
legend('Clean Signal', 'Noisy Signal');

%% --- Task 1: Amplitude Scaling & Task 2: Signal Delay ---
% Task 1: Multiply the noisy signal by 2
scaled = 2 * measured;

% Task 2: Delay the noisy signal by 5 samples (zero-padding at the start)
delay = 5;
delayed = [zeros(1, delay), measured];

n_measured = 0:length(measured)-1;
n_delayed = 0:length(delayed)-1;

% Plot Task 1 and Task 2 together and save as signal_operations.png
fig_ops = figure('Name', 'Signal Operations', 'Color', 'w');

% Subplot 1: Amplitude Scaling
subplot(2, 1, 1);
plot(n, measured, 'Color', [0.6 0.6 0.6], 'LineWidth', 1.2);
hold on;
plot(n, scaled, 'r', 'LineWidth', 1.2);
hold off;
grid on;
title('Task 1: Amplitude Scaling (Factor = 2)');
xlabel('Sample index n');
ylabel('Amplitude');
legend('Original Noisy Signal', 'Scaled Signal (2x)', 'Location', 'northeast');

% Subplot 2: Signal Delay
subplot(2, 1, 2);
plot(n_measured, measured, 'Color', [0.6 0.6 0.6], 'LineWidth', 1.2);
hold on;
plot(n_delayed, delayed, 'm--', 'LineWidth', 1.4);
hold off;
grid on;
title('Task 2: Signal Delay (5 Samples)');
xlabel('Sample index n');
ylabel('Amplitude');
legend('Original Noisy Signal', 'Delayed Signal (+5 samples)', 'Location', 'northeast');

saveas(fig_ops, 'signal_operations.png');

%% --- Task 3: Five-Point Moving-Average Filter ---
h5 = ones(1, 5) / 5;
filtered5 = conv(measured, h5, 'same');

fig_filt5 = figure('Name', '5-Point Moving Average', 'Color', 'w');
plot(n, clean, 'b', 'LineWidth', 1.5);
hold on;
plot(n, measured, 'Color', [0.7 0.7 0.7], 'LineWidth', 1.0);
plot(n, filtered5, 'g', 'LineWidth', 1.8);
hold off;
grid on;
title('Task 3: Noise Filtering with 5-Point Moving Average');
xlabel('Sample index n');
ylabel('Amplitude');
legend('Clean Signal', 'Noisy Signal', '5-Point Filtered', 'Location', 'northeast');

saveas(fig_filt5, 'noise_filtering.png');

%% --- Task 4: Compare Two Filter Lengths ---
h15 = ones(1, 15) / 15;
filtered15 = conv(measured, h15, 'same');

fig_comp = figure('Name', 'Filter Length Comparison', 'Color', 'w');
plot(n, clean, 'b', 'LineWidth', 1.5);
hold on;
plot(n, measured, 'Color', [0.75 0.75 0.75], 'LineWidth', 1.0);
plot(n, filtered5, 'g-', 'LineWidth', 1.6);
plot(n, filtered15, 'r--', 'LineWidth', 1.8);
hold off;
grid on;
title('Task 4: Moving-Average Filter Comparison (5-Point vs 15-Point)');
xlabel('Sample index n');
ylabel('Amplitude');
legend('Clean Signal', 'Noisy Signal', '5-Point Filter', '15-Point Filter', 'Location', 'northeast');

saveas(fig_comp, 'filter_comparison.png');

disp('Lecture 03 script completed and all figures saved.');