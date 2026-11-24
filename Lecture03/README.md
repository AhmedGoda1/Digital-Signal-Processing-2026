# Lecture 03 – Discrete-Time Signal Operations and Convolution

## Overview
This assignment explores basic discrete-time signal manipulations (amplitude scaling and time shifting) and demonstrates how linear convolution with moving-average impulse responses filters high-frequency random noise from a discrete sine wave.

---

## Analysis & Questions

1. **Which operation changed the signal amplitude?**
   - Amplitude scaling (`scaled = 2 * measured`) changed the signal amplitude. In `signal_operations.png`, the vertical range doubled—peaks that previously reached roughly $\pm 1.4$ extended to approximately $\pm 2.8$. The frequency, zero-crossing indices, and horizontal sample positions remained completely unchanged.

2. **How did the five-sample delay change the signal?**
   - Prepending five zeros (`[zeros(1, 5), measured]`) shifted the entire waveform 5 sample indices to the right along the horizontal axis, increasing the total vector length from 101 to 106 samples. The internal shape and amplitude of the signal were preserved without distortion. In real systems, delays arise from sensor propagation time, analog-to-digital conversion latency, or network transmission buffers.

3. **What does the impulse response $h[n]$ represent?**
   - The impulse response $h[n]$ defines the output of a linear time-invariant (LTI) system when excited by a single unit impulse $\delta[n]$. In a moving-average filter, $h[n]$ acts as a sliding window of weights (e.g., $1/5$ for five consecutive samples) that dictates how neighboring input samples are averaged together.

4. **How did convolution change the noisy signal?**
   - Applying `conv(measured, h5, 'same')` slid the 5-sample averaging kernel across the noisy input. Because random Gaussian noise fluctuates rapidly above and below zero from sample to sample, averaging five adjacent points caused positive and negative noise spikes to partially cancel out, producing a smoother curve that tracks the underlying `sin(0.1*pi*n)` wave.

5. **What differences did you observe between the 5-point and 15-point filters?**
   - In `filter_comparison.png`, the 5-point filter (`green`) removes sharp high-frequency jitter while still retaining minor ripples and closely matching the peak height of the blue clean sine wave. The 15-point filter (`red dashed`) produces a much smoother curve with almost no jaggedness, but visibly flattens the peaks of the sine wave.

6. **Which filter removed more noise?**
   - The 15-point moving-average filter removed significantly more noise. Averaging across 15 samples instead of 5 reduces noise variance by a larger factor ($\sigma^2 / N$), effectively eliminating rapid sample-to-sample fluctuations.

7. **Did the longer filter remove or distort useful signal information?**
   - Yes. Because the clean signal `sin(0.1*pi*n)` completes one full cycle every $2\pi / 0.1\pi = 20$ samples, a 15-sample window spans three-quarters (75%) of an entire wave cycle. Averaging across both rising and falling portions of the sine wave attenuates (shrinks) the true signal amplitude, reducing the peaks from $\pm 1.0$ down to roughly $\pm 0.65$, and introduces edge distortion at the boundaries (`n = 0` and `n = 100`).

8. **Which filter would you recommend for this signal? Explain your decision.**
   - The **5-point moving-average filter** is recommended for this specific signal. A 5-sample window covers only one-quarter (25%) of the 20-sample signal period, providing a strong balance between suppressing rapid noise spikes and preserving the true peak amplitude and phase of the sine wave.

9. **Give one real engineering application for moving-average filtering.**
   - Industrial temperature or pressure monitoring: Slowly varying physical sensor readings (such as boiler temperature or tank level) often suffer from high-frequency electrical interference from nearby motors. A moving-average filter smooths out electrical spikes so control systems do not trigger false alarms.

---

## AI Usage
- **Tool used:** Gemini
- **How I used it:** Used to review MATLAB syntax for zero-padding array concatenation (`[zeros(1, delay), measured]`), structure multi-plot comparisons, and verify the theoretical relationship between window length and signal period.
- **What I verified or changed:** Ran `Lecture03_convolution.m` in MATLAB, verified that all three required `.png` figures were saved without errors, confirmed that the 15-point filter attenuated peak amplitude by inspecting the plot axes, and wrote the final analysis based on visual inspection of the generated figures.