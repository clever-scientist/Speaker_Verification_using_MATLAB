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


%% GMM Modeling

gmm_object=cell(1,S);
components=30;
post=cell(1,S);
for i=1:S
    gmm_object{i}=gmdistribution.fit(cept_D{i},components,'Start','randSample','CovType','diagonal','SharedCov',true);
    post{i}=posterior(gmm_object{i},cept_D{i});
end

save('speaker_gmmdata.mat');
