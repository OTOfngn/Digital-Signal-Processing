hold off;
clear;

t = linspace(-1, 1, 4000);
H = 1;
x = zeros(size(t));

for k = 1:2:H
    x = x + (4/pi) * sin(2*pi*k*t) / k;
end

plot(t, x)
grid on
xlabel('Time (s)')
ylabel('Amplitude')
title('Square wave approximation')

hold on

H = 3;
x = zeros(size(t));
for k = 1:2:H
    x = x + (4/pi) * sin(2*pi*k*t) / k;
end

plot(t, x)


H = 9;
x = zeros(size(t));
for k = 1:2:H
    x = x + (4/pi) * sin(2*pi*k*t) / k;
end

plot(t, x)


H = 25;
x = zeros(size(t));
for k = 1:2:H
    x = x + (4/pi) * sin(2*pi*k*t) / k;
end

plot(t, x)

saveas(gcf, "square-wave-comparison.png")
