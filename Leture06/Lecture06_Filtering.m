clear;


Fs = 1000;
t = (0:1/Fs:2-1/Fs)';
rng(7);
clean = sin(2*pi*5*t) + 0.35*sin(2*pi*12*t);
noise = 0.35*sin(2*pi*50*t) + 0.20*sin(2*pi*137*t) + 0.25*randn(size(t));
x = clean + noise;

fc = 20;
bFIR = fir1(60, fc/(Fs/2), 'low');
[bIIR,aIIR] = butter(4, fc/(Fs/2), 'low');
yFIR = filtfilt(bFIR, 1, x);
yIIR = filtfilt(bIIR, aIIR, x);

%Part A
figure;
plot(t, x, 'Color', [0.7 0.7 0.7]); hold on;
plot(t, clean, 'k', t, yFIR, 'b', t, yIIR, 'r');
legend('Noisy signal', 'Clean signal', 'FIR output', 'IIR output');
xlabel('Time (s)'); ylabel('Amplitude'); grid on;

% Part B: Magnitude responses
[HFIR, f] = freqz(bFIR, 1, 4096, Fs);
[HIIR, ~] = freqz(bIIR, aIIR, 4096, Fs);

figure;
plot(f, 20*log10(max(abs(HFIR), eps)), 'b', ...
     f, 20*log10(max(abs(HIIR), eps)), 'r', 'LineWidth', 1.2);
hold on;
xline(fc, 'k--', '20 Hz cutoff', 'LabelVerticalAlignment', 'bottom');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
legend('FIR filter', 'IIR filter', 'Location', 'southwest');
title('Filter Magnitude Responses');
grid on;

N = numel(x);
fSpec = (0:floor(N/2))' * Fs/N;

S = abs(fft([x, yFIR, yIIR], N))/N;
S = S(1:numel(fSpec), :);
S(2:end-~mod(N,2), :) = 2*S(2:end-~mod(N,2), :);

figure;
plot(fSpec, S, 'LineWidth', 1.2);
xlabel('Frequency (Hz)');
ylabel('Amplitude');
legend('Noisy signal', 'FIR output', 'IIR output', 'Location', 'northeast');
title('Single-Sided Amplitude Spectra');
grid on;
xlim([0 150]);
%The IIR output aligns with x in low frequency domain, but loses
%information in higher frequency domain.

%Part B

load handel
xClean = y(:);
assert(Fs > 102, 'Sampling rate must exceed 102 Hz.');

tAudio = (0:numel(xClean)-1)'/Fs;
xHum = xClean + 0.15*sin(2*pi*50*tAudio);

[bN,aN] = butter(2, [49 51]/(Fs/2), 'stop');
yAudio = filtfilt(bN, aN, xHum);

nShow = min(numel(xClean), round(0.5*Fs));
figure;
subplot(2,1,1);
plot(tAudio(1:nShow), xHum(1:nShow), 'r', ...
     tAudio(1:nShow), xClean(1:nShow), 'k');
grid on; legend('Hum-added','Clean');
xlabel('Time (s)'); ylabel('Amplitude');
title('Before filtering');

subplot(2,1,2);
plot(tAudio(1:nShow), yAudio(1:nShow), 'b', ...
     tAudio(1:nShow), xClean(1:nShow), 'k');
grid on; legend('Filtered','Clean');
xlabel('Time (s)'); ylabel('Amplitude');
title('After narrow 49--51 Hz notch filtering');

N = numel(xHum);
fAudio = (0:floor(N/2))'*Fs/N;
spec = abs(fft([xClean xHum yAudio], N))/N;
spec = spec(1:numel(fAudio), :);
spec(2:end-~mod(N,2), :) = 2*spec(2:end-~mod(N,2), :);

figure;
plot(fAudio, spec, 'LineWidth', 1.1);
xlim([0 200]); grid on;
xline(50, 'k--', '50 Hz');
xlabel('Frequency (Hz)'); ylabel('Amplitude');
legend('Clean','Hum-added','Filtered');
title('Audio spectra');

gain = max(abs([xHum; yAudio]));
sound(xHum/gain, Fs);
pause(numel(xHum)/Fs + 0.5);
sound(yAudio/gain, Fs);

A = [sin(2*pi*50*tAudio), cos(2*pi*50*tAudio), ones(size(tAudio))];
ampBefore = hypot(A(:,1)'*xHum, A(:,2)'*xHum) * 2 / numel(xHum);
ampAfter  = hypot(A(:,1)'*yAudio, A(:,2)'*yAudio) * 2 / numel(yAudio);
[H50,~] = freqz(bN, aN, 50, Fs);
fprintf('Estimated 50 Hz amplitude: %.6f before, %.6f after\n', ...
        ampBefore, ampAfter);
fprintf('Filter attenuation at 50 Hz: %.2f dB\n', 20*log10(abs(H50)));

[bW,aW] = butter(2, [45 55]/(Fs/2), 'stop');
yWide = filtfilt(bW, aW, xHum);
[HW50,~] = freqz(bW, aW, 50, Fs);

figure;
plot(tAudio(1:nShow), yAudio(1:nShow), ...
     tAudio(1:nShow), yWide(1:nShow));
grid on; xlabel('Time (s)'); ylabel('Amplitude');
legend('49--51 Hz notch','45--55 Hz notch');
title('Narrow and wide notch comparison');

fprintf('Wide-notch attenuation at 50 Hz: %.2f dB\n', 20*log10(abs(HW50)));
fprintf(['A wider stop band rejects more hum-frequency variation, but can also ', ...
         'remove useful low-frequency audio near 50 Hz.\n']);
figs = findall(0, 'Type', 'figure');
[~, order] = sort([figs.Number]);
figs = figs(order);

names = {'Sensor time-domain comparison', ...
         'Sensor frequency responses', ...
         'Sensor spectra', ...
         'Audio waveform comparison', ...
         'Audio spectrum', ...
         'Notch filter comparison'};

for k = 1:min(numel(figs), numel(names))
    savefig(figs(k), [names{k} '.fig']);
    exportgraphics(figs(k), [names{k} '.png'], 'Resolution', 300);
end

rmseFIR = sqrt(mean((yFIR - clean).^2));
rmseIIR = sqrt(mean((yIIR - clean).^2));

figRMSE = figure('Name', 'Sensor spectra and RMSE table');
uitable(figRMSE, 'Data', {'FIR', rmseFIR; 'IIR', rmseIIR}, ...
    'ColumnName', {'Filter', 'RMSE'}, ...
    'Position', [20 20 300 80]);
savefig(figRMSE, 'Sensor spectra and RMSE table.fig');
exportgraphics(figRMSE, 'Sensor spectra and RMSE table.png', 'Resolution', 300);