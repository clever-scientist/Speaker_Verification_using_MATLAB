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
    
    if(max(frame) > 0.01)
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