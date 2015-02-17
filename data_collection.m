clear all;
clc;

disp('==========================================================');
disp('Welcome to data collection system');

Time=input('Enter the time for which you want to record=');
D=input('Enter the size of training set= ');

Fs=44100;
Ch=1;
N=Time*Fs;

disp('==========================================================');
disp('Data for Left');
left=cell(1,D);
for i=1:D
    disp('Press any key when you are ready');
    pause;
    left{i}=wavrecord(N,Fs,Ch);
end

disp('==========================================================');
disp('Data for Right');
right=cell(1,D);
for i=1:D
    disp('Press any key when you are ready');
    pause;
    right{i}=wavrecord(N,Fs,Ch);
end

disp('==========================================================');
disp('Data for Forward');
forward=cell(1,D);
for i=1:D
    disp('Press any key when you are ready');
    pause;
    forward{i}=wavrecord(N,Fs,Ch);
end

%% Backward
disp('==========================================================');
disp('Data for Backward');
backward=cell(1,D);
for i=1:D
    disp('Press any key when you are ready');
    pause;
    backward{i}=wavrecord(N,Fs,Ch);
end


% Silence removal

 l=cell(1,D);
 r=cell(1,D);
 f=cell(1,D);
 b=cell(1,D);

 L=cell(1,D);
 R=cell(1,D);
 F=cell(1,D);
 B=cell(1,D);
 
 cept_L=cell(1,D);
 cept_R=cell(1,D);
 cept_F=cell(1,D);
 cept_B=cell(1,D);
 
for i=1:D
    for j=1:N
        if(left{i}(j)>0.02)
           l{i}=left{i}(j:N);
           break;
        end
    end

k=length(l{i});

while(k>1)
         k=k-1;
      if (l{i}(k)<0.02)
         continue;
      else 
           L{i}=l{i}(1:k);
           cept_L{i} = melcepst(L{i},Fs);
           break;
      end
end
end


for i=1:D
    for j=1:N
        if(right{i}(j)>0.02)
           r{i}=right{i}(j:N);
           break;
        end
    end

k=length(r{i});

while(k>1)
         k=k-1;
      if (r{i}(k)<0.02)
         continue;
      else 
           R{i}=r{i}(1:k);
           cept_R{i} = melcepst(R{i},Fs);
           break;
      end
end
end


for i=1:D
    for j=1:N
        if(forward{i}(j)>0.02)
           f{i}=forward{i}(j:N);
           break;
        end
    end

k=length(f{i});

while(k>1)
         k=k-1;
      if (f{i}(k)<0.02)
         continue;
      else 
           F{i}=f{i}(1:k);
           cept_F{i} = melcepst(F{i},Fs);
           break;
      end
end
end


for i=1:D
    for j=1:N
        if(backward{i}(j)>0.02)
           b{i}=backward{i}(j:N);
           break;
        end
    end

k=length(b{i});

while(k>1)
         k=k-1;
      if (b{i}(k)<0.02)
         continue;
      else 
           B{i}=b{i}(1:k);
           cept_B{i} = melcepst(B{i},Fs);
           break;
      end
end
end

save('data_collection.mat');

% z=audioplayer(e,22050);
% play(z);


