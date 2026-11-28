%% Lecture 06: Digital Filter Design and Evaluation (Sensor & Audio Signals)
clear; clc; close all;

%% 0. MATLAB Version & Toolbox Verification
fprintf('=====================================================\n');
fprintf('MATLAB Version: %s\n', version);
hasSPT = license('test', 'Signal_Toolbox') && ~isempty(ver('signal'));
fprintf('Signal Processing Toolbox Available: %d\n', hasSPT);
fprintf('=====================================================\n\n');

%% ========================================================================
%  PART A: Filter a Synthetic Sensor Signal (FIR vs. IIR)
%  ========================================================================
Fs = 1000;
t = (0:1/Fs:2-1/Fs)';
rng(7);

clean = sin(2*pi*5*t) + 0.35*sin(2*pi*12*t);
noise = 0.35*sin(2*pi*50*t) + 0.20*sin(2*pi*137*t) + 0.25*randn(size(t));
x = clean + noise;

% Design 20 Hz Low-Pass Filters
fc = 20;
bFIR = fir1(60, fc/(Fs/2), 'low');          % Order 60 (61 taps)
[bIIR, aIIR] = butter(4, fc/(Fs/2), 'low'); % 4th-order Butterworth IIR

% Zero-phase offline filtering
yFIR = filtfilt(bFIR, 1, x);
yIIR = filtfilt(bIIR, aIIR, x);

% --- Figure 1: Sensor Time-Domain Comparison (0.2 s window) ---
idxWin = (t >= 0.4) & (t <= 0.6); % Interior 0.2 s window
fig1 = figure('Name', 'Sensor Time-Domain Comparison', 'Color', 'w', 'Position', [100 100 950 480]);
plot(t(idxWin), x(idxWin), 'Color', [0.75 0.75 0.75], 'LineWidth', 1.0); hold on;
plot(t(idxWin), clean(idxWin), 'k-', 'LineWidth', 2.0);
plot(t(idxWin), yFIR(idxWin), 'b--', 'LineWidth', 1.6);
plot(t(idxWin), yIIR(idxWin), 'r-.', 'LineWidth', 1.6);
hold off;
grid on;
xlabel('Time (s)');
ylabel('Amplitude (V)');
title('Part A: Sensor Signal Time-Domain Comparison (0.4 s to 0.6 s)');
legend('Noisy Input x[n]', 'Clean Reference', 'FIR Output (Order 60)', 'IIR Output (Butterworth Order 4)', 'Location', 'northeast');
saveas(fig1, 'fig1_sensor_time_domain.png');

% --- Figure 2: Sensor Filter Magnitude Responses (freqz) ---
[H_fir, f_resp] = freqz(bFIR, 1, 2048, Fs);
[H_iir, ~]      = freqz(bIIR, aIIR, 2048, Fs);

fig2 = figure('Name', 'Sensor Frequency Responses', 'Color', 'w', 'Position', [100 100 950 480]);
plot(f_resp, 20*log10(abs(H_fir) + eps), 'b-', 'LineWidth', 1.6); hold on;
plot(f_resp, 20*log10(abs(H_iir) + eps), 'r--', 'LineWidth', 1.6);
xline(fc, 'k:', 'LineWidth', 1.5, 'Label', 'Cutoff fc = 20 Hz', 'LabelVerticalAlignment', 'bottom');
yline(-3, 'g:', 'LineWidth', 1.2, 'Label', '-3 dB');
hold off;
grid on;
xlim([0 200]);
ylim([-100 5]);
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Part A: Filter Magnitude Responses (FIR Order 60 vs. Butterworth IIR Order 4)');
legend('FIR Low-Pass (Order 60, 61 taps)', 'Butterworth IIR (Order 4)', 'Location', 'northeast');
saveas(fig2, 'fig2_sensor_freq_response.png');

% --- Figure 3: Sensor Single-Sided Amplitude Spectra ---
N = length(x);
f_spec   = Fs * (0:(N/2)) / N;
P1_noisy = single_sided_spectrum(x);
P1_fir   = single_sided_spectrum(yFIR);
P1_iir   = single_sided_spectrum(yIIR);

fig3 = figure('Name', 'Sensor Amplitude Spectra', 'Color', 'w', 'Position', [100 100 950 650]);
subplot(3,1,1);
plot(f_spec, P1_noisy, 'Color', [0.4 0.4 0.4], 'LineWidth', 1.2);
xlim([0 160]); ylim([0 1.1]); grid on;
xlabel('Frequency (Hz)'); ylabel('Amplitude (V)');
title('Single-Sided Amplitude Spectrum: Noisy Input x[n]');

subplot(3,1,2);
plot(f_spec, P1_fir, 'b', 'LineWidth', 1.3);
xlim([0 160]); ylim([0 1.1]); grid on;
xlabel('Frequency (Hz)'); ylabel('Amplitude (V)');
title('Single-Sided Amplitude Spectrum: FIR Output (Order 60)');

subplot(3,1,3);
plot(f_spec, P1_iir, 'r', 'LineWidth', 1.3);
xlim([0 160]); ylim([0 1.1]); grid on;
xlabel('Frequency (Hz)'); ylabel('Amplitude (V)');
title('Single-Sided Amplitude Spectrum: IIR Output (Butterworth Order 4)');
saveas(fig3, 'fig3_sensor_spectra.png');

% --- RMSE Calculations (Full Signal vs. Interior Excluding 0.1 s Edges) ---
rmse_noisy = sqrt(mean((x - clean).^2));
rmse_fir   = sqrt(mean((yFIR - clean).^2));
rmse_iir   = sqrt(mean((yIIR - clean).^2));

mid = (t >= 0.1) & (t <= 1.9);
rmse_fir_mid = sqrt(mean((yFIR(mid) - clean(mid)).^2));
rmse_iir_mid = sqrt(mean((yIIR(mid) - clean(mid)).^2));

fprintf('--- PART A: RMSE EVALUATION (vs. Known Clean Reference) ---\n');
fprintf('%-28s | %-12s | %-15s\n', 'Signal', 'Full RMSE', 'Interior RMSE');
fprintf('---------------------------------------------------------------\n');
fprintf('%-28s | %-12.5f | %-15.5f\n', 'Noisy Input x[n]', rmse_noisy, rmse_noisy);
fprintf('%-28s | %-12.5f | %-15.5f\n', 'FIR Output (Order 60)', rmse_fir, rmse_fir_mid);
fprintf('%-28s | %-12.5f | %-15.5f\n\n', 'IIR Output (Butterworth 4)', rmse_iir, rmse_iir_mid);

%% ========================================================================
%  PART B: Reduce a 50 Hz Hum in Audio (Handel Recording)
%  ========================================================================
load handel; % provides y and Fs
FsAudio = Fs;
xClean = y(:);
assert(FsAudio > 102, 'Sample rate must exceed 102 Hz to represent 50 Hz.');

tAudio = (0:numel(xClean)-1)' / FsAudio;
xHum = xClean + 0.15*sin(2*pi*50*tAudio);

% Narrow 2nd-order Butterworth band-stop filter (49-51 Hz)
[bN, aN] = butter(2, [49 51]/(FsAudio/2), 'stop');
yAudioNarrow = filtfilt(bN, aN, xHum);

% Wider 2nd-order Butterworth band-stop filter (45-55 Hz)
[bW, aW] = butter(2, [45 55]/(FsAudio/2), 'stop');
yAudioWide = filtfilt(bW, aW, xHum);

% --- Figure 4: Audio Waveform Comparison (0.1 s section) ---
idxAud = (tAudio >= 1.0) & (tAudio <= 1.1);
fig4 = figure('Name', 'Audio Waveform Comparison', 'Color', 'w', 'Position', [100 100 950 650]);
subplot(3,1,1);
plot(tAudio(idxAud), xClean(idxAud), 'k', 'LineWidth', 1.1);
ylim([-0.8 0.8]); grid on;
xlabel('Time (s)'); ylabel('Amplitude');
title('Part B: Clean Audio Waveform (1.0 s to 1.1 s)');

subplot(3,1,2);
plot(tAudio(idxAud), xHum(idxAud), 'Color', [0.85 0.33 0.1], 'LineWidth', 1.1);
ylim([-0.8 0.8]); grid on;
xlabel('Time (s)'); ylabel('Amplitude');
title('Audio with Added 50 Hz Hum (Amplitude 0.15)');

subplot(3,1,3);
plot(tAudio(idxAud), yAudioNarrow(idxAud), 'b', 'LineWidth', 1.1);
ylim([-0.8 0.8]); grid on;
xlabel('Time (s)'); ylabel('Amplitude');
title('Filtered Audio (Narrow Band-Stop: 49–51 Hz)');
saveas(fig4, 'fig4_audio_waveform.png');

% --- Figure 5: Audio Low-Frequency Spectra (0 to 250 Hz) ---
Na = length(xClean);
f_aud = FsAudio * (0:floor(Na/2)) / Na;
P1_aud_clean  = single_sided_spectrum(xClean);
P1_aud_hum    = single_sided_spectrum(xHum);
P1_aud_narrow = single_sided_spectrum(yAudioNarrow);
P1_aud_wide   = single_sided_spectrum(yAudioWide);

fig5 = figure('Name', 'Audio Spectrum Comparison', 'Color', 'w', 'Position', [100 100 950 700]);
subplot(4,1,1);
plot(f_aud, P1_aud_clean, 'k', 'LineWidth', 1.1);
xlim([0 250]); ylim([0 0.18]); grid on;
xlabel('Frequency (Hz)'); ylabel('Amplitude');
title('Clean Audio Spectrum (0–250 Hz)');

subplot(4,1,2);
plot(f_aud, P1_aud_hum, 'Color', [0.85 0.33 0.1], 'LineWidth', 1.1);
xlim([0 250]); ylim([0 0.18]); grid on;
xlabel('Frequency (Hz)'); ylabel('Amplitude');
title('Hum-Added Audio Spectrum (Strong 50 Hz Spike)');

subplot(4,1,3);
plot(f_aud, P1_aud_narrow, 'b', 'LineWidth', 1.1);
xlim([0 250]); ylim([0 0.18]); grid on;
xlabel('Frequency (Hz)'); ylabel('Amplitude');
title('Filtered Output: Narrow Band-Stop (49–51 Hz)');

subplot(4,1,4);
plot(f_aud, P1_aud_wide, 'm', 'LineWidth', 1.1);
xlim([0 250]); ylim([0 0.18]); grid on;
xlabel('Frequency (Hz)'); ylabel('Amplitude');
title('Filtered Output: Wide Band-Stop (45–55 Hz)');
saveas(fig5, 'fig5_audio_spectrum.png');

% --- Figure 6: Notch Filter Frequency Response (49-51 Hz vs. 45-55 Hz) ---
[H_narrow, f_nresp] = freqz(bN, aN, 16384, FsAudio);
[H_wide, ~]         = freqz(bW, aW, 16384, FsAudio);

fig6 = figure('Name', 'Notch Filter Frequency Response', 'Color', 'w', 'Position', [100 100 950 460]);
plot(f_nresp, 20*log10(abs(H_narrow) + eps), 'b-', 'LineWidth', 1.6); hold on;
plot(f_nresp, 20*log10(abs(H_wide) + eps), 'm--', 'LineWidth', 1.6);
xline(50, 'k:', 'LineWidth', 1.4, 'Label', '50 Hz Hum');
hold off;
xlim([20 80]); ylim([-80 5]); grid on;
xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
title('Part B: Band-Stop Filter Magnitude Responses (49–51 Hz vs. 45–55 Hz)');
legend('Narrow Notch (49–51 Hz)', 'Wide Notch (45–55 Hz)', 'Location', 'southeast');
saveas(fig6, 'fig6_notch_response.png');

% --- Measure 50 Hz Amplitude & Filter Attenuation ---
[~, idx50] = min(abs(f_aud - 50));
amp50_clean  = P1_aud_clean(idx50);
amp50_hum    = P1_aud_hum(idx50);
amp50_narrow = P1_aud_narrow(idx50);
amp50_wide   = P1_aud_wide(idx50);

% Effective two-pass filtfilt attenuation at 50 Hz
H50_narrow_dB = 2 * 20*log10(abs(freqz(bN, aN, [50 100], FsAudio)));
H50_wide_dB   = 2 * 20*log10(abs(freqz(bW, aW, [50 100], FsAudio)));

fprintf('--- PART B: 50 Hz HUM MEASUREMENT ---\n');
fprintf('Audio Sample Rate (Fs): %d Hz | Total Samples: %d\n', FsAudio, Na);
fprintf('50 Hz FFT Peak Amplitude (Clean):           %.5f\n', amp50_clean);
fprintf('50 Hz FFT Peak Amplitude (Hum-Added):       %.5f\n', amp50_hum);
fprintf('50 Hz FFT Peak Amplitude (Narrow 49-51 Hz): %.5f\n', amp50_narrow);
fprintf('50 Hz FFT Peak Amplitude (Wide 45-55 Hz):   %.5f\n', amp50_wide);
fprintf('Effective filtfilt Attenuation at 50 Hz (Narrow): %.2f dB\n', H50_narrow_dB(1));
fprintf('Effective filtfilt Attenuation at 50 Hz (Wide):   %.2f dB\n', H50_wide_dB(1));

% Optional interactive listening at identical playback gain:
% sound(xHum, FsAudio); pause(length(xHum)/FsAudio + 0.5);
% sound(yAudioNarrow, FsAudio);

%% Helper Function: Single-Sided Amplitude Spectrum
function P1 = single_sided_spectrum(sig)
    N = length(sig);
    Y = fft(sig);
    P2 = abs(Y / N);
    P1 = P2(1:floor(N/2)+1);
    P1(2:end-1) = 2 * P1(2:end-1);
end