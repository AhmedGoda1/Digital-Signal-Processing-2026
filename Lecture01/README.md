# Lecture 01: Signal Visualization with MATLAB

## Task 2: Frequency Comparison
1. **Which signal changes fastest?**
   - The 10 Hz signal changes the fastest because it completes 10 complete cycles per second.
2. **Which signal has the lowest frequency?**
   - The 2 Hz signal has the lowest frequency (2 cycles per second).
3. **How can you see the difference in the plots?**
   - Higher frequency signals have cycles/peaks packed closer together along the horizontal time axis within the same 1-second duration.

## Task 3: Amplitude Comparison
1. **Which signal has the largest amplitude?**
   - The signal with an amplitude of 2.0 has the largest peak deviation from zero.
2. **Does changing amplitude change frequency?**
   - No. Amplitude only scales the vertical height/depth of the waveform; the number of cycles per second remains unchanged.
3. **Give one real-world example where amplitude is important:**
   - Audio volume control: Increasing the amplitude of an audio wave makes the sound louder without changing its pitch (frequency).

## Task 4: Add Noise
1. **What changed after adding noise?**
   - The smooth sinusoidal curve became jagged and distorted due to random perturbations added to every sample.
2. **Can you still recognize the original signal?**
   - Yes, the underlying periodic 5 Hz oscillation is still clearly visible through the fluctuations.
3. **Give one real-world source of signal noise:**
   - Thermal noise in electronic sensors and resistors caused by the random thermal agitation of charge carriers.

## Task 6: AI Usage Note
- **AI Tool Used:** Gemini
- **Prompt:** "Provide the MATLAB script for Lecture 01 implementing Task 1 through Task 5 (generating sine waves, comparing frequencies/amplitudes, adding Gaussian noise, and saving the three required PNGs)."
- **What AI Suggested:** A complete modular MATLAB script using `sin()`, `subplot()`, `randn()`, and `saveas()` functions to generate and export all required figures.
- **Did the code work immediately?** Yes.
- **What did you modify?** Kept standard MATLAB plotting styles, verified matching file names, and adjusted subplot line widths for clarity.
- **How did you verify the result?** Ran the script in MATLAB Online, confirmed the generated figure windows displayed correct cycle counts and amplitude scales, and verified that the three `.png` files were properly exported.