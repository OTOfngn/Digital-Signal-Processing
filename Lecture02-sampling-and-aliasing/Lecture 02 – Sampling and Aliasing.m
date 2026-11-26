function sampling_analysis()
% sampling_analysis  Perform signal sampling study for a 10 Hz sine wave.
% Generates plots and saves required PNG files.

fs_cont = 10000;           % continuous-time approx sampling (Hz)
T = 1;                     % duration (s)
t_cont = 0:1/fs_cont:T;    % time vector (include endpoint)
f0 = 10;                   % signal frequency (Hz)
x_cont = sin(2*pi*f0*t_cont);

% Task 1: original signal plot
fig1 = figure('Visible','off');
plot(t_cont, x_cont, 'b','LineWidth',1.2)
title('Original 10 Hz Sine Wave')
xlabel('Time (s)')
ylabel('Amplitude')
grid on
legend('x(t) = sin(2\pi10t)')
xlim([0 1])
saveas(fig1, 'original_signal.png');
close(fig1)

% Task 2: sampling frequencies to investigate
Fs_list = [15 20 25 50 100];
nFs = numel(Fs_list);

fig2 = figure('Visible','off');
for k = 1:nFs
    Fs = Fs_list(k);
    ts = 0:1/Fs:T;
    xs = sin(2*pi*f0*ts);
    subplot(nFs,1,k)
    plot(t_cont, x_cont, 'b'), hold on
    stem(ts, xs, 'r', 'filled')
    hold off
    title(sprintf('Sampling at %d Hz', Fs))
    xlabel('Time (s)')
    ylabel('Amplitude')
    grid on
    legend('Original','Samples')
    xlim([0 1])
end
% Save combined figure
saveas(fig2, 'sampling_all.png');

% Also save separate figures as requested
for k = 1:nFs
    Fs = Fs_list(k);
    ts = 0:1/Fs:T;
    xs = sin(2*pi*f0*ts);
    fh = figure('Visible','off');
    plot(t_cont, x_cont, 'b','LineWidth',1.2), hold on
    stem(ts, xs, 'r', 'filled')
    hold off
    title(sprintf('Sampling at %d Hz', Fs))
    xlabel('Time (s)')
    ylabel('Amplitude')
    grid on
    legend('Original','Samples')
    xlim([0 1])
    filename = sprintf('sampling_%dHz.png', Fs);
    saveas(fh, filename);
    close(fh)
end

% Task 3: Nyquist analysis output to text file
fmax = f0;
fs_nyquist = 2*fmax;
fid = fopen('nyquist_analysis.txt','w');
fprintf(fid, 'Given fmax = %.2f Hz\n', fmax);
fprintf(fid, 'Minimum sampling frequency by Nyquist: fs_min = 2*fmax = %.2f Hz\n\n', fs_nyquist);
fprintf(fid, 'Sampling frequencies tested: %s\n', mat2str(Fs_list));
fprintf(fid, 'Which satisfy Nyquist (fs >= %.2f Hz):\n', fs_nyquist);
for k = 1:nFs
    Fs = Fs_list(k);
    fprintf(fid, '  %d Hz: %s\n', Fs, ternary(Fs>=fs_nyquist,'Yes','No'));
end
fprintf(fid, '\nIs sampling exactly at Nyquist recommended? No. In practice higher rate is used to allow anti-aliasing filter roll-off and timing/quantization margins.\n');
fclose(fid);

% Task 4: Aliasing detection and brief summary to text file
fid = fopen('aliasing_discussion.txt','w');
fprintf(fid, 'Aliasing occurrences for tested sampling rates:\n');
for k = 1:nFs
    Fs = Fs_list(k);
    % Determine aliased frequency via discrete-time folding to [-Fs/2, Fs/2]
    % continuous freq f0 aliased to f_alias = abs(mod(f0+Fs/2, Fs)-Fs/2)
    f_alias = abs(mod(f0+Fs/2, Fs)-Fs/2);
    aliasing = (Fs < 2*f0);
    fprintf(fid, '%d Hz -> aliased frequency = %.2f Hz; Aliasing: %s\n', Fs, f_alias, ternary(aliasing,'Yes','No'));
end
fprintf(fid, '\nRecommendation: use Fs >= 5*fmax (e.g., 50 or 100 Hz) for engineering robustness (anti-alias filtering, accuracy, processing margins).\n');
fclose(fid);

end

function out = ternary(cond, a, b)
if cond, out = a; else out = b; end
end