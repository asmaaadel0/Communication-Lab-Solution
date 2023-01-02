filename = 'sample3.wav';
[sig,fs] = audioread(filename);
samples = [1,20*fs];
clear sig fs
[sig,fs] = audioread(filename,samples);
sig = sig(:,1) + sig(:,2);
N = size(sig,1);
%sound(sig,fs);
%===========================================================================%
%time domain
time = (0:length(sig) - 1)*20/length(sig); 
figure(1);
subplot(3,1,1);
plot(time,sig);
title(" modulating(original) signal in time domain");
xlabel('Time');
ylabel('Amplitude');

%===========================================================================%
%  Frequency domain
freq_y= fft(sig);
dfs=fs/length(sig);
fre_range=-fs/2:dfs:fs/2-dfs;
magnitude_1=abs(fftshift(freq_y));
phase_1=unwrap(angle(freq_y));
subplot(3,1,2);
plot(fre_range,magnitude_1);
title(" magnitude");
ylabel('magnitude');
subplot(3,1,3);
plot(fre_range,phase_1);
title(" phase");
ylabel('phase');

%===========================================================================%
%carrier and modulation
bw=bandwidth(sig)./(2.*pi);
fc=(fs/2)-bw;
wc=fc*2*pi;
%A ==> minimum value
Ac = abs(min(sig));
carrier= cos(wc*time).';
%===========================================================================%
%time
modulated_signal = (sig+Ac).*carrier;
figure(2);
subplot(3,1,1);
plot(time,modulated_signal);
title(" modulated signal in time domain");
ylabel('Amplitude');

%===========================================================================%
%  Frequency domain
freq_y_2=fft(modulated_signal);


magnitude_2=abs(fftshift(freq_y_2));
phase_2=unwrap(angle(freq_y_2));
subplot(3,1,2);

% plot(f1,magnitude1(1:N/2),magnitude1(N/2+1:N));
plot(fre_range,magnitude_2);

title(" magnitude");
ylabel('magnitude ');
subplot(3,1,3);
plot(fre_range,phase_2);
title(" phase");
ylabel('phase');
%===========================================================================%
%demodulation
demodulated_signal =  modulated_signal.*carrier;

LPF = lowpass(demodulated_signal,10000,fs);
LPF=LPF*2;
LPF = LPF -Ac;
%===========================================================================%
%time
figure(3);
subplot(3,1,1);
plot(time,LPF);
title(" demodulated signal in time domain");
ylabel('Amplitude');
%===========================================================================%
%  Frequency domain
freq_y_3=fft(LPF);
magnitude_3=abs(fftshift(freq_y_3));
phase_3=unwrap(angle(freq_y_3));
subplot(3,1,2);
plot(fre_range,magnitude_3);
title(" magnitude");
ylabel('magnitude ');
subplot(3,1,3);
plot(fre_range,phase_3);
title(" phase");

ylabel('phase');

sound(LPF,fs);