clc;

clear all;
%load('speaker_gmmdata.mat');
spard=arduino('COM16');
spard.pinMode(7,'OUTPUT');
spard.pinMode(8,'OUTPUT');
spard.pinMode(9,'OUTPUT');
spard.pinMode(10,'OUTPUT');
spard.pinMode(11,'OUTPUT');
spard.pinMode(12,'OUTPUT');
spard.pinMode(13,'OUTPUT');

while(1)
    
load('data_collection.mat');

%% Testing

%Test data

disp('==========================================================');
disp('Press any key and say any of the four command');
pause;
%test_mu=[];
test=wavrecord(N,Fs,Ch);
test=ssubmmse(test,Fs);                                                    %MMSE noise removal

int speaker; 
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

test_mu=gmm_obj_new.mu;

%% Speaker Verification
% Based on Mahalanobis distance between mean of training data model and new speaker model

disp('Press ENTER to view the result');
pause;
int speaker;

mhl_distance_L=cell(S,D);
mhl_distance_R=cell(S,D);
mhl_distance_F=cell(S,D);
mhl_distance_B=cell(S,D);

mean_mahal_L=[];
mean_mahal_R=[];
mean_mahal_F=[];
mean_mahal_B=[];

min_dist=[];
%mean_mahal=cell(1,S);

for i=1:S
    for y=1:D
    mhl_distance_L{i,y}=mahal(gmm_obj_new.mu,m_L{i}{y});
    mhl_distance_R{i,y}=mahal(gmm_obj_new.mu,m_R{i}{y});
    mhl_distance_F{i,y}=mahal(gmm_obj_new.mu,m_F{i}{y});
    mhl_distance_B{i,y}=mahal(gmm_obj_new.mu,m_B{i}{y});
    
    mean_mahal_L(i,y)=mean(mhl_distance_L{i,y});                                     % Mean of mahalanobis distance
    mean_mahal_R(i,y)=mean(mhl_distance_R{i,y});
    mean_mahal_F(i,y)=mean(mhl_distance_F{i,y});
    mean_mahal_B(i,y)=mean(mhl_distance_B{i,y});
    end 
    
    min_L(i)=min(mean_mahal_L(i,:));
    min_R(i)=min(mean_mahal_R(i,:));
    min_F(i)=min(mean_mahal_F(i,:));
    min_B(i)=min(mean_mahal_B(i,:));
end

for i=1:S
    a(1)=min_L(i);
    a(2)=min_R(i);
    a(3)=min_F(i);
    a(4)=min_B(i);
    
    min_S(i)=min(a)
end 
 result=min(min_S);
 
 for i=1:S
       if (min_S(i)==result)
          
              str2 = fprintf('You are speaker number %d .\n', i);
              if(i==1)
                 spard.digitalWrite(11,1);
              elseif(i==2)
                 spard.digitalWrite(12,1);
              elseif(i==3)
                 spard.digitalWrite(13,1);
              end
                       
              speaker=i;
%               if (j==1)
%                      msgbox('You have spoken LEFT');
%              elseif (j==2)
%                      msgbox('You have spoken RIGHT');
%              elseif (j==3)
%                      msgbox('You have spoken FORWARD');
%               else   msgbox('You have spoken REVERSE');
%               end    
%                  
       else continue;
       end
 end

 
 % Speech Recognition
    d_L=cell(1,D);
    d_R=cell(1,D);
    d_F=cell(1,D);
    d_B=cell(1,D);
    m_l=[];
    m_r=[];
    m_f=[];
    m_b=[];
    a=[];
  
    
    for i=1:D
    d_L{i}=mahal(cept_T,cept_L{speaker}{i});
    d_R{i}=mahal(cept_T,cept_R{speaker}{i});
    d_F{i}=mahal(cept_T,cept_F{speaker}{i});
    d_B{i}=mahal(cept_T,cept_B{speaker}{i});
    
    figure(i);
    subplot(221);
    plot(d_L{i});
    title('left');
    subplot(222);
    plot(d_R{i});
    title('right');
    subplot(223);
    plot(d_F{i});
    title('forward');
    subplot(224);
    plot(d_B{i});
    title('reverse');

    m_l(i)=mean(d_L{i});
    m_r(i)=mean(d_R{i});
    m_f(i)=mean(d_F{i});
    m_b(i)=mean(d_B{i});
    
    
end
a=[];
disp('====================================================');
    
    m_l=min(m_l)
    m_r=min(m_r)
    m_f=min(m_f)
    m_b=min(m_b)
    
   
    a(1)=m_l;
    a(2)=m_r;
    a(3)=m_f;
    a(4)=m_b;
    
    result=min(a)
    
    if result==a(1)
        msgbox('You have spoken LEFT');
        spard.digitalWrite(7,1);
        spard.digitalWrite(8,0);
        spard.digitalWrite(9,1);
        spard.digitalWrite(10,1);
        for i=1:400000000
        end
        spard.digitalWrite(7,1);
        spard.digitalWrite(8,1);
        spard.digitalWrite(9,1);
        spard.digitalWrite(10,1);
     elseif result==a(2)
        msgbox('You have spoken RIGHT');
        spard.digitalWrite(7,1);
        spard.digitalWrite(8,1);
        spard.digitalWrite(9,1);
        spard.digitalWrite(10,0);
        for i=1:400000000
        end
        spard.digitalWrite(7,1);
        spard.digitalWrite(8,1);
        spard.digitalWrite(9,1);
        spard.digitalWrite(10,1);
    elseif result==a(3)
        msgbox('You have spoken FORWARD');
        spard.digitalWrite(7,1);
        spard.digitalWrite(8,0);
        spard.digitalWrite(9,1);
        spard.digitalWrite(10,0);
    for i=1:1000000000
    end
    
        spard.digitalWrite(7,1);
        spard.digitalWrite(8,1);
        spard.digitalWrite(9,1);
        spard.digitalWrite(10,1);
    else 
        msgbox('You have spoken REVERSE');
        spard.digitalWrite(7,0);
        spard.digitalWrite(8,1);
        spard.digitalWrite(9,0);
        spard.digitalWrite(10,1);
        for i=1:1000000000
        end
        spard.digitalWrite(7,1);
        spard.digitalWrite(8,1);
        spard.digitalWrite(9,1);
        spard.digitalWrite(10,1);
    end
disp('==========================================================');
disp('Press any key to speak again');  
pause;
clc;
close all;
spard.digitalWrite(11,0);
spard.digitalWrite(12,0);
spard.digitalWrite(13,0);
              
%clear all;
end





