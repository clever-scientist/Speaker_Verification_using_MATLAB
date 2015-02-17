clc;
clear all;
load('speaker_gmmdata.mat');

%% Testing

%Test data

disp('==========================================================');
disp('To authenticate that YOU are YOU press any key and say "LEFT"');
pause;
test=wavrecord(N,Fs,Ch);

%Silence Removal

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

gmm_obj_new=gmdistribution.fit(cept_T,components,'Start','randSample','CovType','diagonal','SharedCov',true);

%% Clustering

idx=cell(1,S);
clstr=cell(S,components);
temp=[];

for j=1:components
    for i=1:S
        idx{i}=cluster(gmm_object{i},cept_T);
              
    end
    
end


for i=1:S
    for j=1:components
        clstr{i,j}=cept_T(idx{i}==j,:);
    end
end


% % %% Decision Making Based on Clustering Data and Mean data from the Model
% % 
% % % Based on clustering
% % count=0;                                                                   % Count of number of non-empty sub-cluster
% % speaker=[];                                                                % The > the count the > the prob of the speaker is a certain one.
% %                                                                            
% % for i=1:S
% %     for j=1:components
% %         TF=isempty(clstr{i,j});
% %         if TF==0
% %             count=count+1;
% %         else
% %             continue;
% %         end
% %     end
% %     speaker(i)=count;
% %     count=0;
% % end
% % 
% % max_clstr=max(speaker);
% % 
% % msgbox('Press ENTER twice to view the result by 1st method');
% % pause;
% % 
% % for i=1:S
% %     if max_clstr==speaker(i);
% %         str1 = fprintf('You are speaker number %d .\n', i);
% %     else continue;
% %     end
% % end

%% Based on Mahalanobis distance between mean of training data model and new
% speaker model

msgbox('Press ENTER twice to view the result by 2nd method');
pause;

mean_mahal=[];

for i=1:S
    mhl_distance=mahal(gmm_obj_new.mu,gmm_object{i}.mu);
    mean_mahal(i)=mean(mhl_distance);                                      % Mean of mahalanobis distance
end

result_mean=min(mean_mahal);

for i=1:S
    if result_mean==mean_mahal(i)
       str2 = fprintf('You are speaker number %d .\n', i); 
    else continue;
    end
end

 %%%%%%%%%Use "AIC" to compare model quality

%% Posterior Probability based decision making

post_t = cell(1,1);

    post_t=posterior(gmm_obj_new,cept_T);




