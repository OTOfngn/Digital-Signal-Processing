clear; clc; close all;

x = [1 2 1];
n = 0:length(x)-1;

% Delay the signal by one sample
xDelayed = [0 x];
nDelayed = 0:length(xDelayed)-1;

fig = figure;
subplot(2,1,1);
stem(n, x, 'filled');
title('Original Signal x[n]');
xlabel('Sample n'); ylabel('Amplitude');
grid on;

subplot(2,1,2);
stem(nDelayed, xDelayed, 'filled');
title('One-Sample Delay x[n-1]');
xlabel('Sample n'); ylabel('Amplitude');
grid on;
saveas(fig, 'Part1', 'png')

% Coefficients of H(z) = 0.5 + 0.5*z^(-1)
b = [0.8 0.2];
a = 1;

% Add one zero to show the final output sample
xInput = [x 0];
y = filter(b, a, xInput);
nOutput = 0:length( y )-1;

fig = figure;
subplot(2,1,1);
stem(nOutput, xInput, 'filled');
title('Input x[n]');
xlabel('Sample n'); ylabel('Amplitude');
grid on;

subplot(2,1,2);
stem(nOutput, y, 'filled');
title('Output y[n]');
xlabel('Sample n'); ylabel('Amplitude');
grid on;

disp('Output samples:');
disp( y ) ;

saveas(fig, 'Part2', 'png')