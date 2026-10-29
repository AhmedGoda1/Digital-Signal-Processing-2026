%% Lecture 02: Sampling and Aliasing Investigation

%% --- Task 1: Create the Original Signal ---
f_sig = 10;                     % Signal frequency = 10 Hz
duration = 1.0;                 % Duration = 1 second

% High sampling frequency to emulate a continuous-time analog signal
fs_cont = 5000;                 
t_cont = 0:1/fs_cont:duration;  
x_cont = sin(2 * pi * f_sig * t_cont);

% Plot continuous-time signal
fig1 = figure('Name', 'Task 1: Original Signal', 'Color', 'w');
plot(t_cont, x_cont, 'b-', 'LineWidth', 1.5);
title('Original Continuous-Time Signal (10 Hz Sine Wave)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
legend('Continuous Signal (10 Hz)', 'Location', 'northeast');

% Save Task 1 figure
saveas(fig1, 'original_signal.png');

%% --- Task 2: Investigate Different Sampling Frequencies ---
fs_list = [15, 20, 25, 50, 100];

for k = 1:length(fs_list)
    fs = fs_list(k);
    t_samp = 0:1/fs:duration;
    x_samp = sin(2 * pi * f_sig * t_samp);

    % Create individual figures matching assignment requirements
    fig = figure('Name', sprintf('Sampling at %d Hz', fs), 'Color', 'w');

    % Plot reference continuous signal
    plot(t_cont, x_cont, 'b-', 'LineWidth', 1.2, 'DisplayName', 'Original 10 Hz Signal');
    hold on;

    % Overlay discrete sampled points with stem markers
    stem(t_samp, x_samp, 'r', 'filled', 'LineWidth', 1.2, ...
        'MarkerSize', 5, 'DisplayName', sprintf('Sampled Points (%d Hz)', fs));

    % Visual reconstruction helper (connecting discrete samples)
    plot(t_samp, x_samp, 'r--', 'LineWidth', 1.0, 'DisplayName', 'Reconstructed Form');

    hold off;
    title(sprintf('Signal Sampled at f_s = %d Hz (Signal f = 10 Hz)', fs));
    xlabel('Time (s)');
    ylabel('Amplitude');
    ylim([-1.3 1.3]);
    grid on;
    legend('Location', 'northeast');

    % Save each figure with the exact required filename
    filename = sprintf('sampling_%dHz.png', fs);
    saveas(fig, filename);
end

disp('All tasks executed and figures saved successfully.');