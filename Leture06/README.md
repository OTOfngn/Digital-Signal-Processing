1.     Why is a 20 Hz low-pass reasonable for Part A, and what assumption does it make about the wanted sensor signal?
The filter is reasonable for Part A because the wanted signals are below 20Hz, while noises are way above 20Hz. It assumes that all signals above 20Hz are noises.

2.     Which filter gives the better result for the requirements you chose? Support the answer with at least two kinds of evidence.
IIR filter does. In time domain, its output is closer to the original signal. and in frequency spectra it overlaps with the original signal much better compared with FIR filter output.

3.     How would your implementation change if the sensor had to be filtered live with low latency?
IIR filter.

4.     Why is a narrow band-stop appropriate for a steady 50 Hz hum? What would you do if the interference frequency drifted?
A narrow band-stop works perfectly when the noise is steady in frequency because it can minimize its intervetion with wanted signals while filtering the noise. If the noise frequency drifted, I would change the band-stop frequency as well.

5.     Describe one limitation of your experiments and one improvement you would make in a real measurement system.
Limitation: The signal is too simple, and no live signal is given.
Improvement: Maybe using DL algorithms to detect noise and automatically change the filter frequency could be a good idea.
