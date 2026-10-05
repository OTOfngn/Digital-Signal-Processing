1. Identify the sample represented by each term in X(z).
    = 1+2*z^-1+z^-2
2. Write the Z-transform of the delayed signal.
    = z^-1+2*z^-2+z^-3
3. Explain why delaying the signal by one sample multiplies X(z) by z⁻¹.
    Because the signals in x[n] shift right by one.
4. Calculate y[0], y[1], y[2] and y[3] by hand. Compare them with MATLAB.
    [0.5,1.5,1.5,0.5]
5. Explain how b = [0.5 0.5] represents the two terms in H(z).
    =0.5+0.5*z^-1
6. Change the system to H(z) = 0.8 + 0.2z⁻¹. Update b, run the code again, and explain which input sample now has more influence on the output.
    The x[n] has a larger influence on the output.
