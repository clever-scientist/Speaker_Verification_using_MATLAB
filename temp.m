clc;
clear all;

%load('data_collection.mat');
%% New Data
Fs=44100;
N=88200;
Ch=1;
disp('==========================================================');
disp('Press any key when you are ready');
pause;
sig=wavrecord(N,Fs,Ch);

%% Silence removal
 q=[];
for i=1:N
    if(sig(i)>0.02)
      q=sig(i:N);
    break;
    end
end

i=length(q);
while(i>1)
         i=i-1;
      if (q(i)<0.02)
         continue;
      else 
           sig=q(1:i);
           break;
      end
end


%% Cepstrum of a signals

cept_sig = melcepst(sig,Fs);
csig=[];
cfin=[];
for i=1:132
    csig=[csig cept_sig(i,:)];
end
    csig=csig';

%%LLOyds
q=[2 7 3 0.747 10 21 1 8.3 13 19 20 23 9];
[partition,codebook]=lloyds(csig,q);
partition
codebook