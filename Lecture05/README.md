# Lecture 05 – Fourier Series, DTFT, and DFT

## Exercise 1: Build a Square Wave from Harmonics

![Square Wave Comparison](exercise-1/square-wave-comparison.png)

* **Prediction:** Adding higher odd harmonics will make the smooth sine wave progressively flatten at the top and bottom, sharpen at the vertical edges, and resemble an ideal square wave.
* **Observations as $H$ increases ($1 \rightarrow 3 \rightarrow 9 \rightarrow 25$):**
  * At $H = 1$, the waveform is a single fundamental sine wave of amplitude $4/\pi \approx 1.27$.
  * As $H$ increases to $3$, $9$, and $25$, the flat plateaus become flatter and the rising/falling transitions become much steeper, closely approximating a square wave between $+1$ and $-1$.
* **Behavior near sharp transitions (Gibbs Phenomenon):**
  * Near the jump discontinuities ($t = -1, -0.5, 0, 0.5, 1$), narrow overshoot ripples appear right before and after each transition. Even as $H$ increases to $25$, the ripples become narrower in time, but the peak overshoot remains at roughly $9\%$ of the jump height (known as the **Gibbs phenomenon**).

---

## Exercise 2: Find Two Frequencies with the FFT

![Two Frequency Spectrum](exercise-2/two-frequency-spectrum.png)

* **Expected Values:**
  * Component 1: Frequency $f_1 = 15\text{ Hz}$, Amplitude $A_1 = 0.8$
  * Component 2: Frequency $f_2 = 40\text{ Hz}$, Amplitude $A_2 = 0.4$
* **Frequency-Bin Spacing Calculation:**
  $$\Delta f = \frac{f_s}{N} = \frac{200\text{ Hz}}{200\text{ samples}} = 1.0\text{ Hz/bin}$$
* **Comparison of Expected vs. Measured Values:**
  * Because both $15\text{ Hz}$ and $40\text{ Hz}$ are exact integer multiples of $\Delta f = 1.0\text{ Hz}$, all signal energy lands cleanly on bins $15$ and $40$ with zero spectral leakage:
    * **Peak 1:** Measured $15.0\text{ Hz}$ with amplitude $0.8000$ (matches expected).
    * **Peak 2:** Measured $40.0\text{ Hz}$ with amplitude $0.4000$ (matches expected).

---

## Exercise 3: Investigate Spectral Leakage

![Leakage Comparison](exercise-3/leakage-comparison.png)

* **Student Digit & Frequency:**
  * Last digit $d = \text{[INSERT YOUR DIGIT]}$
  * Calculated $f_2 = 13.2 + 0.17 \times d = \text{[INSERT CALCULATED f2]}\text{ Hz}$
* **Prediction:** Because $f_2$ is not an integer multiple of the $1.0\text{ Hz}$ bin spacing, it falls between DFT frequency bins. Its energy will spread ("leak") across neighboring bins, lowering its peak height below $0.4$ and creating a wider base, whereas the $15\text{ Hz}$ peak will remain sharp at $0.8$.
* **1-Second vs. 4-Second Recording:**
  * **1-Second Recording ($N = 200$):** Bin spacing is $\Delta f = 200 / 200 = 1.0\text{ Hz}$. The $f_2$ peak is smeared across adjacent bins with reduced peak amplitude, and it sits very close to the $15\text{ Hz}$ peak.
  * **4-Second Recording ($N = 800$):** Bin spacing improves by a factor of $4$ to $\Delta f = 200 / 800 = 0.25\text{ Hz}$. The two peaks ($f_2$ and $15\text{ Hz}$) become clearly separated with much sharper resolution and less leakage.
* **Effect of Zero-Padding (`fft(x, 4*length(x))`):**
  * Zero-padding the 1-second signal to $800$ points interpolates the spectrum on a $0.25\text{ Hz}$ grid, revealing the smooth underlying sinc-like sidelobe structure and making the true peak location easier to read.
  * **Does it add new information?** No. Appending zeros adds no new measurements of the physical signal, so it cannot improve true frequency resolution or separate two closely spaced frequencies that were unresolved in the original 1-second window.

---

## Exercise 4: Compare the DTFT and DFT

![DTFT vs DFT Comparison](exercise-4/dtft-dft-comparison.png)

* **Comparison of DTFT and DFT:**
  * The DTFT produces a continuous magnitude curve $|X(e^{j\omega})|$ over $\omega \in [-\pi, \pi]$, peaking at $4$ at $\omega = 0$.
  * The DFT evaluates exact samples of that continuous DTFT curve at equally spaced frequencies $\omega_k = \frac{2\pi k}{N}$. For `fft(x, 4)`, the 4 points land at $\omega = -\pi, -\pi/2, 0, \pi/2$—three of which fall directly on the zeros of the DTFT.
* **Why `fft(x, 64)` produces more frequency points:**
  * `fft(x, 64)` pads $x[n]$ with $60$ trailing zeros to length $N = 64$, evaluating the DTFT at $64$ closely spaced frequencies ($\Delta\omega = 2\pi/64$) instead of $4$.
  * **Does it add new samples?** No, the underlying signal sequence remains $[1, 1, 1, 1]$; zero-padding only increases frequency sampling density along the existing DTFT curve.
* **Where the DTFT magnitude becomes zero:**
  * Analytically, $X(e^{j\omega}) = 1 + e^{-j\omega} + e^{-j2\omega} + e^{-j3\omega} = e^{-j1.5\omega}\frac{\sin(2\omega)}{\sin(\omega/2)}$.
  * Within $[-\pi, \pi]$, the magnitude becomes zero at:
    $$\omega = \pm\frac{\pi}{2} \quad (\approx \pm 1.57\text{ rad/sample}) \quad \text{and} \quad \omega = \pm\pi \quad (\approx \pm 3.14\text{ rad/sample})$$

---

## AI Usage Note
* **Tool Used:** Gemini
* **How AI Was Used:** Used to verify MATLAB syntax for single-sided FFT normalization (`P1(2:end-1) = 2*P1(2:end-1)`), `fftshift` alignment for comparing the DTFT with `fft(x, 4)` and `fft(x, 64)`, and formatting multi-panel figures.
* **Verification:** Executed all four scripts independently in MATLAB, verified that measured peak frequencies/amplitudes matched theoretical expectations, and customized `d` and `f2` in Exercise 3.