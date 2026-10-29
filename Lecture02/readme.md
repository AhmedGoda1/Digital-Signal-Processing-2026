# Lecture 02 – Sampling and Aliasing

## Objective
The purpose of this investigation is to explore the transition from continuous-time analog signals to digital discrete samples in industrial condition monitoring. We analyze the impact of sampling frequency ($f_s$) on signal representation, observe aliasing behavior, verify the Nyquist Sampling Theorem, and propose a robust sampling configuration for machine vibration analysis.

## Nyquist Analysis
According to the Nyquist Sampling Theorem, to perfectly reconstruct a bandlimited signal without information loss or aliasing distortion, the sampling frequency must be strictly greater than twice the highest frequency component present in the signal:

$$f_s > 2 \cdot f_{max}$$

Given:
$$f_{max} = 10\text{ Hz}$$

The minimum theoretical Nyquist rate is:
$$f_{Nyquist} = 2 \times 10\text{ Hz} = 20\text{ Hz}$$

### Questions:
1. **Which sampling frequencies satisfy the Nyquist criterion?**
   - $25\text{ Hz}$, $50\text{ Hz}$, and $100\text{ Hz}$ strictly satisfy the condition ($f_s > 20\text{ Hz}$).
   - $15\text{ Hz}$ fails ($15 < 20$).
   - $20\text{ Hz}$ is equal to the boundary ($f_s = 2 f_{max}$), but does not strictly satisfy the practical inequality required for arbitrary phase.

2. **Is sampling exactly at the Nyquist rate recommended in practice? Explain your answer.**
   - No, it is strongly discouraged in practical engineering. Sampling exactly at $f_s = 2 f_{max}$ yields only two samples per cycle. If samples coincide with the zero-crossings (a phase shift of $\phi = 0$ for a sine wave: $\sin(0) = \sin(\pi) = 0$), all collected samples will be identically zero, completely annihilating the signal. Furthermore, ideal reconstruction at the exact Nyquist boundary requires an infinitely sharp brick-wall analog reconstruction filter, which is physically impossible to construct.

## Results
- **15 Hz ($f_s < 2 f_{max}$):** Severe aliasing occurs. With only 15 samples per second across a 10 Hz wave, the reconstructed waveform appears as an erroneous low-frequency sine wave of $|15 - 10| = 5\text{ Hz}$.
- **20 Hz ($f_s = 2 f_{max}$):** The sample points fall precisely at the zero-crossings ($t = 0, 0.05, 0.10, \dots\text{ s}$), causing the sampled points to read zero amplitude and vanishing the wave entirely.
- **25 Hz ($f_s > 2 f_{max}$):** Aliasing is prevented mathematically, but the visual reconstruction using linear interpolation looks irregular and distorted because 2.5 samples per cycle is very coarse.
- **50 Hz ($f_s = 5 f_{max}$):** The sinusoidal structure is well-preserved with 5 samples per cycle; peaks and zero-crossings are easily discernible.
- **100 Hz ($f_s = 10 f_{max}$):** Excellent visual fidelity and temporal resolution with 10 samples per cycle, closely mimicking the original continuous analog vibration curve.

## Aliasing Discussion
Aliasing occurs at $15\text{ Hz}$ (producing a false $5\text{ Hz}$ phantom signal) and effectively destroys signal recovery at $20\text{ Hz}$. Aliasing happens because the sampling interval ($T_s$) is too wide to capture the oscillations; different continuous sinusoids pass through the exact same set of discrete points, confusing high frequencies with lower ones. 

For an industrial condition monitoring vibration sensor, sampling at $15\text{ Hz}$ or $20\text{ Hz}$ is dangerous because high-speed shaft faults or bearing degradation would either be undetected or misidentified as low-frequency vibrations.

## Engineering Recommendation
For a real condition monitoring system measuring a $10\text{ Hz}$ fundamental vibration component, **$100\text{ Hz}$ ($f_s = 10 \cdot f_{max}$)** is recommended. 

**Engineering Justification:**
- **Accuracy:** Ten samples per cycle provides reliable peak-amplitude detection, harmonic analysis, and accurate phase measurements without requiring heavy computational reconstruction filters.
- **Robustness:** An oversampling factor of 5× to 10× creates a wide transition band for cost-effective analog anti-aliasing filters (low-pass filters) preceding the ADC.
- **Processing Requirements:** A 100 Hz sampling rate requires only 100 values per second per channel, which places a negligible load on modern microcontrollers and embedded DSP processors while providing clean data for downstream machine learning or FFT algorithms.

## AI Usage
- **AI Tool Used:** Gemini
- **Prompt(s):** "Write a clean MATLAB script for Lecture 02 covering Task 1 (10 Hz signal) and Task 2 (15, 20, 25, 50, 100 Hz sampling using stem overlay and saving original_signal.png and all individual sampling PNGs). Provide the corresponding engineering discussion and Nyquist analysis for the README."
- **Summary of AI Response:** Provided a parameterized MATLAB loop utilizing `stem()` and `saveas()`, alongside a calculation of the Nyquist boundary and engineering justification for industrial vibration monitoring.
- **What I Modified:** Standardized the figure line styles (`stem` marker size, line width) to clearly highlight the sampled points against the analog line, and matched filenames to the exact assignment specification.
- **How I Verified the Results:** Ran `Lecture02_sampling_aliasing.m` in MATLAB. Verified that:
  1. The 6 generated `.png` files were properly exported to the directory.
  2. The 15 Hz plot clearly demonstrated the 5 Hz alias envelope.
  3. The 20 Hz plot landed precisely on zero points, proving the phase-dependent loss of information.