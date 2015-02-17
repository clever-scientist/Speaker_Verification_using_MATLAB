clc;
clear all;
close all;
load('speaker_data.mat');

%% Testing

%Test data

disp('==========================================================');
disp('To authenticate that YOU are YOU press any key and say "LEFT"');
pause;
test=wavrecord(N,Fs,Ch);
    for j=1:N
        if(test(j)>0.02)
           t=test(j:N);
           break;
        end
    end
    k=length(t);

while(k>1)
         k=k-1;
      if (t(k)<0.02)
         continue;
      else 
           T=t(1:k);
           cept_T= melcepst(T,Fs);
           break;
      end
end

[idx,c]=kmeans(cept_T,20);

%% Comparison of IDX and Centroids with speaker_data using Mahalanobis distance
dist_one=cell(1,S);
dist_two=cell(1,S);
d_o=zeros(1,S);
d_t=zeros(1,S);

for i=1:S
    dist_one{i}=mahal(idx,IDX{i});
         d_o(i)=mean(dist_one{i})
end
result_o=min(d_o)
for i=1:S
    if(result_o==d_o(i))
        str = fprintf('You are speaker number %d .\n', i);
        break;
    end
end

for i=1:S
    dist_two{i}=mahal(c,C{i});
         d_t(i)=mean(dist_two{i})
end
result_t=min(d_t)
for i=1:S
    if(result_t==d_t(i))
        str = fprintf('You are speaker number %d .\n', i);
        break;
    end
end

