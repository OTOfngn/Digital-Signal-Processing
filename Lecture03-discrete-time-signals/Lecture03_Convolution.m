clear;
close all;
clc;

% Use the same random noise each time
rng(1);

%% Create a clean discrete-time signal

n = 0:100;
clean = sin(0.1*pi*n);

%% Add noise

noise = 0.4*randn(size(n));
measured = clean + noise;
scaled = 2*measured
%% Task 2
delay = 5;
delayed = [zeros(1,delay),measured];
n_measured = 0:length(measured)-1;
n_delayed = 0:length(delayed)-1;
%% Task 3
h5 = ones(1,5)/5;
filtered5 = conv(measured,h5,'same')
%% Task 4
h15 = ones(1,15)/15;
filtered15 = conv(measured,h15,'same')
%% Display the clean and noisy signals

gcf = figure;

plot(n,clean,'b','LineWidth',1.5);
hold on;
plot(n,measured,'Color',[0.6 0.6 0.6]);
%% Task 1
%plot(n,scaled)
%plot(n_delayed,delayed)
plot(n,filtered5)
plot(n,filtered15)

grid on;
xlabel('Sample index n');
ylabel('Amplitude');
title('Noisy and Filtered Signals');
legend('Clean Signal','Noisy Signal','five-point filtered signal', '15-point filtered signal');
%saveas(gcf,'signal_operations.png');
saveas(gcf,'filter_comparison.png');