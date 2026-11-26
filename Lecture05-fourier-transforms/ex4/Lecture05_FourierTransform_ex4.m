x = [1 1 1 1];
n = 0:length(x)-1;

w = linspace(-pi, pi, 1000);
X = x * exp(-1j * (n.' * w));

X4 = fftshift(fft(x, 4));
X64 = fftshift(fft(x, 64));

w4 = (-2:1) * pi / 2;
w64 = (-32:31) * 2 * pi / 64;

figure
plot(w, abs(X), 'b', 'LineWidth', 1.5)
hold on
stem(w4, abs(X4), 'ro', 'filled', 'LineWidth', 1.2)
stem(w64, abs(X64), 'k.', 'LineWidth', 1.2)
xline(-pi/2, '--m')
xline(pi/2, '--m')
grid on
xlim([-pi pi])
xlabel('Angular frequency (rad/sample)')
ylabel('Magnitude')
title('DTFT and DFT Magnitudes')
legend('DTFT', 'DFT, N = 4', 'DFT, N = 64', 'Location', 'best')

text(-pi/2, 0.25, 'Zero at -\pi/2', ...
    'HorizontalAlignment', 'center', 'Color', 'm')
text(pi/2, 0.25, 'Zero at \pi/2', ...
    'HorizontalAlignment', 'center', 'Color', 'm')

saveas(gcf,"dtft-dft-comparison.png")
