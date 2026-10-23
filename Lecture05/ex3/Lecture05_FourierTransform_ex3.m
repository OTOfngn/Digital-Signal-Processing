d = 1;   % Replace 4 with your own digit, from 0 to 9
f2 = 13.2 + 0.17*d;

t = 0:0.001:1;
x = 0.8*sin(2*pi*15*t) + 0.4*sin(2*pi*f2*t);
plot(t,x)
xlabel('Time (s)')
ylabel('Amplitude')
title('One-Second Sound Wave')
grid on
saveas(gcf,"one-second-soundwave.png")

t = 0:0.001:4;
x = 0.8*sin(2*pi*15*t) + 0.4*sin(2*pi*f2*t);
plot(t,x)
xlabel('Time (s)')
ylabel('Amplitude')
title('Four-Second Soundwave')
grid on
saveas(gcf,"four-second-soundwave.png")

t = 0:0.001:1;
x = 0.8*sin(2*pi*15*t) + 0.4*sin(2*pi*f2*t);
x = fft(x, 4*length(x));
f = 0:length(x)-1;
plot(f, abs(x))
xlabel('Time (s)')
ylabel('Amplitude')
title('Zero-Padded Spectra')
grid on
saveas(gcf,"zero-padded-spectra.png")