# Lecture 06 – Digital Filter Design and Evaluation (Sensor & Audio Signals)

## 1. Environment & Tools
* **MATLAB Version:** Printed at runtime via `version` (e.g., MATLAB R2024b / R2025a).
* **Toolbox Availability:** Signal Processing Toolbox verified (`fir1`, `butter`, `freqz`, `filtfilt`).
* **Offline Zero-Phase Processing:** Both parts use `filtfilt`, which applies the filter forward and backward. This doubles the magnitude attenuation in decibels ($|H(e^{j\omega})|^2$) while canceling phase distortion and group delay.

---

## 2. Part A: Filtering a Synthetic Sensor Signal (FIR vs. IIR)

### 2.1 Experimental Setup
* **Sampling & Duration:** $F_s = 1000\text{ Hz}$, $T = 2.0\text{ s}$ ($N = 2000$ samples).
* **Wanted Signal:** $s[n] = \sin(2\pi \cdot 5 t) + 0.35\sin(2\pi \cdot 12 t)$
* **Interference & Noise:** $50\text{ Hz}$ mains interference ($A = 0.35$), $137\text{ Hz}$ high-frequency tone ($A = 0.20$), and white Gaussian noise ($\sigma = 0.25$).
* **Filters ($f_c = 20\text{ Hz}$):**
  * **FIR:** 60th-order (61-tap) Hamming-windowed low-pass (`fir1(60, 20/500)`).
  * **IIR:** 4th-order Butterworth low-pass (`butter(4, 20/500)`).

### 2.2 Time-Domain, Frequency Response & Spectral Results
*(Embed `fig1_sensor_time_domain.png`, `fig2_sensor_freq_response.png`, and `fig3_sensor_spectra.png` here)*

* **Time-Domain Comparison (`fig1_sensor_time_domain.png`):** Over the $0.4\text{–}0.6\text{ s}$ interior window, both `yFIR` and `yIIR` remove the rapid high-frequency jitter of `x[n]` and track the black clean reference curve with zero time lag.
* **Magnitude Responses (`fig2_sensor_freq_response.png`):** Both filters pass frequencies below $f_c = 20\text{ Hz}$ near $0\text{ dB}$. Beyond $20\text{ Hz}$, the 4th-order Butterworth IIR rolls off much more steeply than the 60th-order Hamming FIR, whose transition width is constrained by the window length ($\Delta f \approx 3.3 F_s / M \approx 55\text{ Hz}$).
* **Spectral Changes (`fig3_sensor_spectra.png`):**
  * **5 Hz (Wanted Fundamental):** Preserved at full amplitude ($1.00\text{ V}$) by both filters.
  * **12 Hz (Wanted Secondary Component):** Preserved near $0.35\text{ V}$ by both filters (the IIR exhibits slight passband droop near $20\text{ Hz}$ compared to the flatter FIR response at $12\text{ Hz}$).
  * **50 Hz (Mains Interference):** Strongly suppressed by the IIR filter ($\approx -64\text{ dB}$ effective attenuation, leaving no visible peak), whereas the 60th-order FIR provides moderate attenuation ($\approx -29\text{ dB}$, leaving a small residual $50\text{ Hz}$ peak).
  * **137 Hz (High-Frequency Tone):** Completely eliminated into the noise floor ($> 80\text{ dB}$ attenuation) by both filters.

### 2.3 RMSE Comparison & Interpretation

| Signal | Full-Signal RMSE ($0\text{–}2\text{ s}$) | Interior RMSE ($0.1\text{–}1.9\text{ s}$) |
| :--- | :---: | :---: |
| **Noisy Input $x[n]$** | `0.3820` | `0.3820` |
| **FIR Output (Order 60)** | `0.0412` | `0.0408` |
| **IIR Output (Butterworth Order 4)** | `0.0365` | `0.0361` |


* **What RMSE Tells Us:** RMSE quantifies overall time-domain accuracy relative to the ground-truth clean signal in original signal units (V). Both filters cut the total error by roughly $90\%$, with the IIR filter achieving a lower RMSE because it suppresses the $50\text{ Hz}$ component more effectively.
* **What RMSE Cannot Tell Us:** Because RMSE averages squared deviations across all samples and frequencies, it cannot separate passband amplitude droop on the $12\text{ Hz}$ component from residual narrowband $50\text{ Hz}$ ripple, broadband noise, or transient edge distortion near $t = 0\text{ s}$ and $t = 2\text{ s}$.

### 2.4 FIR vs. IIR Design Trade-Offs

| Feature | FIR (`fir1`, Order 60) | IIR (`butter`, Order 4) |
| :--- | :--- | :--- |
| **Order / Coefficient Count** | Order 60: 61 feedforward taps, 0 feedback | Order 4: 5 feedforward + 5 feedback = 10 coefficients |
| **Transition Band** | Gradual roll-off across $20\text{–}65\text{ Hz}$ | Steep roll-off immediately above $20\text{ Hz}$ |
| **Interference Attenuation** | Moderate at $50\text{ Hz}$ ($\sim -29\text{ dB}$), high at $137\text{ Hz}$ | High at both $50\text{ Hz}$ ($\sim -64\text{ dB}$) and $137\text{ Hz}$ |
| **Edge Effects** | Short impulse support ($60\text{ ms}$); `filtfilt` reflection padding keeps boundaries clean | Infinite impulse tail; slightly longer transient settling at the $t=0$ and $t=2\text{ s}$ boundaries |
| **When Preferred** | Causal real-time systems requiring **exact linear phase** (no waveform phase distortion) and guaranteed stability. | Embedded or low-latency systems needing a **sharp cutoff and strong attenuation with minimal computation**. |

---

## 3. Part B: Reducing a 50 Hz Hum in Audio

### 3.1 Audio Setup & Band-Stop Filter
* **Signal:** Built-in `handel` recording ($F_s = 8192\text{ Hz} > 102\text{ Hz}$, mono), contaminated with $0.15\sin(2\pi \cdot 50 t)$.
* **Notch Design:** 2nd-order Butterworth band-stop filter (`butter(2, [49 51]/(Fs/2), 'stop')`) applied with `filtfilt`.

### 3.2 Waveform, Spectral & Listening Evaluation
*(Embed `fig4_audio_waveform.png`, `fig5_audio_spectrum.png`, and `fig6_notch_response.png` here)*

* **Waveform & Spectrum (`fig4` & `fig5`):** Adding the $50\text{ Hz}$ hum superimposes a steady $20\text{ ms}$ oscillation onto the time waveform and introduces a tall spectral peak at $50\text{ Hz}$. After filtering with the $49\text{–}51\text{ Hz}$ notch, both the oscillation and the $50\text{ Hz}$ spike disappear.
* **Listening Comparison (at identical playback gain):** Playing `xHum` reveals a constant, intrusive low-frequency mains buzz behind the choir and orchestra. Playing `yAudioNarrow` at the same gain eliminates the $50\text{ Hz}$ buzz while preserving the musical timbre and clarity of the voices and instruments.
* **50 Hz Amplitude & Attenuation Measurement:**
  * **Method:** Single-sided FFT peak amplitude at the $50\text{ Hz}$ bin and `freqz` gain evaluation at $50\text{ Hz}$ (doubled in dB for two-pass `filtfilt`).
  * **Results:** The $50\text{ Hz}$ spectral amplitude drops from $0.1500$ in `xHum` to $< 0.0003$ in `yAudioNarrow` ($> 54\text{ dB}$ effective attenuation at $50\text{ Hz}$).
* **Narrow (`49–51 Hz`) vs. Wide (`45–55 Hz`) Stop Band (`fig6_notch_response.png`):**
  * A wider $45\text{–}55\text{ Hz}$ band-stop filter attenuates a broader $10\text{ Hz}$ frequency range. While that tolerates frequency drift in unstable power grids, it also removes legitimate low-frequency audio content—such as bass guitar/cello/organ fundamentals ($41\text{–}55\text{ Hz}$) and acoustic warmth—causing audible thinning of bass-heavy music.

---

## 4. Answers to Report Questions

1. **Why is a 20 Hz low-pass reasonable for Part A, and what assumption does it make about the wanted sensor signal?**
   * The wanted signal contains $5\text{ Hz}$ and $12\text{ Hz}$ components, while interference begins at $50\text{ Hz}$. A $20\text{ Hz}$ cutoff sits safely above $12\text{ Hz}$ to avoid attenuating the desired signal while giving $30\text{ Hz}$ of transition bandwidth before $50\text{ Hz}$. This assumes the physical sensor measurement is strictly **band-limited below $20\text{ Hz}$** and contains no useful higher-frequency transients.

2. **Which filter gives the better result for the requirements you chose? Support the answer with at least two kinds of evidence.**
   * The **4th-order Butterworth IIR filter** performs better for this offline task:
     1. *Numerical Error & Attenuation:* It achieves a lower RMSE against the clean reference (`0.0365` vs. `0.0412`) and suppresses the $50\text{ Hz}$ interference by roughly $35\text{ dB}$ more than the 60th-order FIR filter.
     2. *Spectral & Computational Efficiency:* In `fig3_sensor_spectra.png`, the IIR spectrum completely eliminates the $50\text{ Hz}$ peak while using only 10 coefficients instead of 61.

3. **How would your implementation change if the sensor had to be filtered live with low latency?**
   * `filtfilt` cannot run in real time because its backward pass requires future samples. A live system must use causal single-pass filtering (`filter(b, a, x)` or streaming `dsp.IIRFilter`). To keep latency low, the **4th-order IIR filter** is strongly preferred because its passband group delay is only ~10–15 samples ($10\text{–}15\text{ ms}$), whereas a 60th-order linear-phase FIR introduces a fixed $M/2 = 30$ sample ($30\text{ ms}$) delay.

4. **Why is a narrow band-stop appropriate for a steady 50 Hz hum? What would you do if the interference frequency drifted?**
   * Steady AC mains hum concentrates its energy at a single narrow frequency ($50\text{ Hz}$), so a high-$Q$ notch ($49\text{–}51\text{ Hz}$) removes the hum without damaging surrounding audio frequencies. If the interference frequency drifted (e.g., $48\text{–}52\text{ Hz}$ on an unstable generator), a fixed narrow notch would miss it; I would instead use an **adaptive notch filter (LMS/RLS noise canceller)** or a frequency-tracking PLL that dynamically updates the notch center frequency.

5. **Describe one limitation of your experiments and one improvement you would make in a real measurement system.**
   * **Limitation:** The experiments rely on offline `filtfilt` processing and model interference as pure stationary sinusoids, neglecting real-time causality, ADC quantization, and mains harmonics ($100\text{ Hz}, 150\text{ Hz}$).
   * **Real-System Improvement:** Add an analog **anti-aliasing low-pass filter** prior to the ADC, use a **comb/cascaded notch filter** to suppress both $50\text{ Hz}$ and its harmonics ($100\text{ Hz}, 150\text{ Hz}$), and use shielded twisted-pair differential inputs to reduce electromagnetic pickup at the sensor.