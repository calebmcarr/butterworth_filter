%Get Centered DFT of the corrupted signal
[y,Fs] = audioread('noisysig.wav');
N = length(y);
X1 = fftshift(fft(y));
X1mag = abs(X1);
XmagdB = 20*log10(X1mag);
figure(1);
w = -pi:2*pi/N:pi-2*pi/N;       % dig rad freq vector
f = w * Fs /(2*pi); 
plot(f,XmagdB);
% plot phase
xlim([-20000,20000]);
title('Magnitude of Centered DFT of noisysig.wav');
xlabel('analog frequency Hz');

%Get Centered DFT of the noise sample
[y1,Fs] = audioread('noisesamp.wav');
N1 = length(y1);
Z1 = fftshift(fft(y1));
Z1mag = abs(Z1);
ZmagdB = 20*log10(Z1mag);
figure(2);
w = -pi:2*pi/N1:pi-2*pi/N1;       % dig rad freq vector
f = w * Fs /(2*pi); 
plot(f,ZmagdB);
% plot phase
xlim([-20000,20000]);
title('Magnitude of Centered DFT of noisesamp.wav');
xlabel('analog frequency Hz');

%Create filter
Wp = .05;                  % normalized passband edge freq
Ws = .1;            % normalized stopband edge freq
Rp = 1;                         % max passband ripple
Rs = 60;                        % min stopband attenuation
[Nf, Wn] = buttord(Wp,Ws,Rp,Rs);  % design filter order
[num,den] = butter(Nf,Wn);      % design the filter
h=fvtool(num,den);              % show frequency response
figure(2);
freqz(num,den,1024);            % plot frequency response
title('Lowpass Frequency Response');
y1 = filter(num,den,y);        % apply the filter
y1 = y1 / max(abs(y1));         % normalize filtered signal
%sound(y1,Fs,16);                % play it through sound card
pause(5); 

%Save the file
audiowrite('filteredsig.wav',y1,Fs);

