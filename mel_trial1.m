clc;
clear all;

%% data collection
data=audiorecorder(22000,16,1);
Time=input('Enter the time for which u want to rcord(Seconds) T = '); % Seconds;
disp('Press any key to start recording');
pause;
recordblocking(data,Time);
b=getaudiodata(data);
figure(1);
plot(b);
title('Recorded Sound');
xlabel('Samples');ylabel('Amplitude');
display('============================================================');

%% Silecnce Removal
len=length(b);
time = 0.04;
frameSample = time*22000;
numFrame = floor(len/frameSample);
new_data = zeros(1,1);
count = 0;
for k=1:numFrame
    frame = b((k-1)*frameSample + 1 : k*frameSample);
    
    if(max(frame) > 0.005)
        count = count + 1;
        new_data((count-1)*frameSample + 1 : count*frameSample) = frame;
    end
end


% j=1;
%  for i=1:44000
%      if(abs(b(i))>0.0050)
%            new_data(j)=b(i);
%               j=j+1;
%    else
%        continue;
%      end
%  end

n=length(new_data);                                                         %length of voiced part 
m=(round(n/220)-1);                                                             %Number of windows required(1 window=220 samples) 
figure(2);
plot(new_data);
title('Silence removed');
xlabel('Samples');ylabel('Amplitude');
figure(3);
spectrogram(new_data);
disp('press any key when you are ready');
pause;

%% Windowing of audio data (by windows of 10ms)
final_data=cell(1,m);

for i=1:m
    temp=zeros(1,220);
    for j=((220*(i-1))+1):(i*220)
        temp(j-((i-1)*220))=new_data(j);
    end
    final_data{i}=temp;
end

%% FFT of individual windows
fft_spect=cell(1,m);
for i=1:m
    fft_spect{i}=fft(final_data{i});
end

%% Mel filtering
MelFrequencyVector=cell(1,m);
for i=1:m
    [Filter,MelFrequencyVector{i}] = melfilter(m,fft_spect{i},@triang);
end


%% Cepstral Analysis

%Internal Cepstral analysis function deals with real numbers only, whereas
%what we have are imaginary numbers. So, we need to convert them to real
%numbers. As a trial here I have taken magnitude of the complex numbers as
%the input to cepstral function.

y=cell(1,m);
for i=1:m
    y{i}=abs(MelFrequencyVector{i});
end

% xhat=cell(1,m);
% yhat=cell(1,m);

zhat=cell(1,m);
%zhat1=cell(1,m);

for i=1:m
%    [xhat{i},yhat{i}]=rceps(y{i});
[zhat{i},nd]=cceps(y{i});
end




