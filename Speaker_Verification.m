clear all;
clc;


%% Data Collection

disp('==========================================================');
disp('Welcome to data collection system for Speaker Verification');

S=input('How many speakers? :');
Time=input('Enter the time for which you want to record=');

Fs=44100;
Ch=1;
N=Time*Fs;

disp('==========================================================');

speaker=cell(1,S);
for i=1:S
    str=sprintf('Data for speaker-%d:',i)
    disp('Press any key when you are ready');
    pause;
    speaker{i}=wavrecord(N,Fs,Ch);
end


 sp=cell(1,S);
 SP=cell(1,S);
 cept_S=cell(1,S);
 
 % Silence Removal
for i=1:S 
    for j=1:N
        if(speaker{i}(j)>0.02)
           sp{i}=speaker{i}(j:N);
           break;
        end
    end

k=length(sp{i});

while(k>1)
         k=k-1;
      if (sp{i}(k)<0.02)
         continue;
      else 
           SP{i}=sp{i}(1:k);
           cept_S{i} = melcepst(SP{i},Fs);
           break;
      end
end
end

%% GMM

m=cell(1,S);
v=cell(1,S);
p=cell(1,S);
b=cell(1,S);
post=cell(1,S);
prob=cell(1,S);

for i=1:S
obj = gmdistribution.fit(cept_S{i},16,'CovType','diagonal');
m{i}=obj.mu;
v{i}=obj.Sigma;
p{i}=obj.PComponents;
post{i} = posterior(obj,cept_S{i});
end

%b{2} = mvnpdf(cept_S{2}(1:16,1:12),m{2},v{2});
%prob{2}=b{2}'.*p{2};

% D = mahal(obj,cept_S{1});
% scatter(cept_S{1}(:,1),cept_S{1}(:,2),10,D(:,1),'.')
% hb = colorbar;
% ylabel(hb,'Mahalanobis Distance to Component 1')

save('speaker_data.mat');   