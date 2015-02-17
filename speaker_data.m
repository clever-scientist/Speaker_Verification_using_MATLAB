clc;
clear all;
close all;
%load('data_collection.mat');

%% Speaker Database

disp('==========================================================');
disp('Welcome to Speaker-data collection system');

Time=input('Enter the time for which you want to record=');

Fs=44100;
Ch=1;
N=Time*Fs;

S=input('Enter the number of speakers= ');
disp('==========================================================');

data=cell(1,S);

for i=1:S
    disp('press any key and say "LEFT"');
    pause;
    data{i}=wavrecord(N,Fs,Ch);
end

%% Silence removal
d=cell(1,S);
D=cell(1,S);
cept_D=cell(1,S);

for i=1:S 
    for j=1:N
        if(data{i}(j)>0.02)
           d{i}=data{i}(j:N);
           break;
        end
    end

k=length(d{i});

while(k>1)
         k=k-1;
      if (d{i}(k)<0.02)
         continue;
      else 
           D{i}=d{i}(1:k);
           cept_D{i} = melcepst(D{i},Fs);
           break;
      end
end
end

%% Kmeans clustering (12 clusters)

IDX=cell(1,S);
C=cell(1,S);

%sumd=cell(1,S);

for i=1:S
    [IDX{i},C{i}]=kmeans(cept_D{i},20);
end

save('speaker_data.mat');