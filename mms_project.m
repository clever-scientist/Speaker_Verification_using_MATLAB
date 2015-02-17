%% Clearing the previous data
clear all;
close all;
clc;

%% Initilizing
Fs=44100; % Sampling Frequency
Ch=1; %Channel is mono
display('Wel come to Speech Recognition System');
Time=input('Enter the time for which u want to rcord(Seconds) T = '); % Seconds;
N=Time*Fs;
%N = 25000;
display('============================================================');
display('Press any key to start Recording');
pause
display('Speak in Microphone');

%% Recording Signal
sig=wavrecord(N,Fs,Ch);
display('Stop Recording');
display('============================================================');
%% Plotting the data
figure(1);
plot(sig);
title('Recorded Sound');
xlabel('Samples');ylabel('Amplitude');
display('============================================================');
ip=input('Press Any key to Listen Your Audio');

%% Playing Signal
sound(sig,Fs);

%% Removing silence
len = length(sig);
time = 0.04;
frameSample = time*Fs;
numFrame = floor(len/frameSample);
new_sig = zeros(1,1);
count = 0;
for k=1:numFrame
    frame = sig((k-1)*frameSample + 1 : k*frameSample);
    
    if(max(frame) > 0.005)
        count = count + 1;
        new_sig((count-1)*frameSample + 1 : count*frameSample) = frame;
    end
end
figure(2);
plot(new_sig);
title('Silence removed');
xlabel('Samples');ylabel('Amplitude');

%% Overwriting the signal with newsignal
sig = new_sig;

%% Predefined samples of LEFT, RIGHT, FORWARD and BACKWARD
disp('are you ready?');
pause;

disp('say left');
sig_L=wavrecord(N,Fs,Ch);
% sig_L=abs(fft(sig_L));

pause;
disp('say right');
sig_R=wavrecord(N,Fs,Ch);
% sig_R=abs(fft(sig_R));
pause;
disp('say forward');
sig_F=wavrecord(N,Fs,Ch);
% sig_F=abs(fft(sig_F));
pause;
disp('say backward');
sig_B=wavrecord(N,Fs,Ch);
% sig_B=abs(fft(sig_B));

% % sig_L = wavread('sound_A.wav');
% % sig_R = wavread('sound_E.wav');
% % sig_F = wavread('sound_O.wav');
% % sig_B = wavread('sound_U.wav');

%% Plotting the pre-defined signals
figure(3);
subplot(221);
plot(sig_L(1:length(sig_L)));
title('Signal L');
subplot(222);
plot(sig_R(1:length(sig_R)));
title('Signal R');
subplot(223);
plot(sig_F(1:length(sig_F)));
title('Signal F');
subplot(224);
plot(sig_B(1:length(sig_B)));
title('Signal B');

%% Cepstrum of a signals

cept_sig = melcepst(sig,Fs);
cept_L = melcepst(sig_L,Fs);
cept_R = melcepst(sig_R,Fs);
cept_F = melcepst(sig_F,Fs);
cept_B = melcepst(sig_B,Fs);

% L=10;
% 
% sig_A_interp = interp(sig_A,L);
% sig_E_interp = interp(sig_E,L);
% sig_O_interp = interp(sig_O,L);
% sig_U_interp = interp(sig_U,L);
% 
% sig_interp = interp(sig,L);
% 
% sig_A = sig_A_interp;
% sig_E = sig_E_interp;
% sig_O = sig_O_interp;
% sig_U = sig_U_interp;
% 
% sig = sig_interp;

%% Finding cross correlation
[corr_L lag_L] = xcorr(sig,sig_L);
[corr_R lag_R] = xcorr(sig,sig_R);
[corr_F lag_F] = xcorr(sig,sig_F);
[corr_B lag_B] = xcorr(sig,sig_B);

%% Frequencty domain
fft_L = fft(sig_L);
fft_R = fft(sig_R);
fft_F = fft(sig_F);
fft_B = fft(sig_B);
fft_sig = fft(sig);

%% Plotting the correlation function
figure(4);
subplot(221);
plot(lag_L,corr_L);
title('Cross Corr with A');
subplot(222);
plot(lag_R,corr_R);
title('Cross Corr with E');
subplot(223);
plot(lag_F,corr_F);
title('Cross Corr with O');
subplot(224);
plot(lag_B,corr_B);
title('Cross Corr with U');

% %% Plotting the FFT function
% figure(5);
% subplot(221);
% plot(fftshift(abs(fft_L)));
% title('Cross Corr with A');
% subplot(222);
% plot(fftshift(abs(fft_R)));
% title('Cross Corr with E');
% subplot(223);
% plot(fftshift(abs(fft_F)));
% title('Cross Corr with O');
% subplot(224);
% plot(fftshift(abs(fft_B)));
% title('Cross Corr with U');
% 
% %% Finding the x-corr sum
% sum_A = sum(abs(corr_L).^2);
% sum_E = sum(abs(corr_R).^2);
% sum_O = sum(abs(corr_F).^2);
% sum_U = sum(abs(corr_B).^2);

%% Finding the euclidian distance
% d_Au = disteusq(cept_A,cept_sig);
% d_Eu = disteusq(cept_E,cept_sig);
% d_Ou = disteusq(cept_O,cept_sig);
% d_Uu = disteusq(cept_U,cept_sig);

%% Finding the Itukora Distance
d_L = distitar(cept_L,cept_sig,'d');
d_R = distitar(cept_R,cept_sig,'d');
d_F = distitar(cept_F,cept_sig,'d');
d_B = distitar(cept_B,cept_sig,'d');


%% plotting the Itukora distances
figure(6);
subplot(221);
plot(abs(d_L));
title('Plotting with Left');
subplot(222);
plot(abs(d_R));
title('Plotting with Right');
subplot(223);
plot(abs(d_F));
title('Plotting with Forward');
subplot(224);
plot(abs(d_B));
title('Plotting with Backward');

%% Predicting for the distance
[max_L I_L] = max(d_L);
[max_R I_R] = max(d_R);
[max_F I_F] = max(d_F);
[max_B I_B] = max(d_B);

display('============================');
display('Itukora Distance');
display('============================');
pre_d_L = sum(abs(d_L))
pre_d_R = sum(abs(d_R))
pre_d_F = sum(abs(d_F))
pre_d_B = sum(abs(d_B))

pre = [pre_d_L pre_d_R pre_d_F pre_d_B];
[pre_min Ind] = max(pre);
if(Ind == 1)
    out = 'Left';
elseif (Ind == 2)
    out = 'Right';
% elseif (Ind == 3)
%     if(abs(pre(Ind)-pre_d_B)>=2)
%         out = 'Forward';
%     else
%         out = 'Backward';
%     end;
elseif (Ind == 3)
    out = 'Forward';
elseif (Ind == 4)
    out = 'Backward';
else
    disp('Error');
end;
display('============================');
display('Recognized speech is : ');
disp(out);
display('============================');