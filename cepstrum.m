clc;
clear all;
close all;

load('data_collection.mat');
%% New Data
disp('==========================================================');
disp('Press any key when you are ready and speak any of the four command');
pause;
sig=wavrecord(N,Fs,Ch);
D=5;
tic;
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


%% Mahalanobis Distance

d_L=cell(1,D);
d_R=cell(1,D);
d_F=cell(1,D);
d_B=cell(1,D);
m_L=[];
m_R=[];
m_F=[];
m_B=[];


for i=1:D
    d_L{i}=mahal(cept_sig,cept_L{i});
    d_R{i}=mahal(cept_sig,cept_R{i});
    d_F{i}=mahal(cept_sig,cept_F{i});
    d_B{i}=mahal(cept_sig,cept_B{i});
    
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
    title('backward');

    m_l(i)=mean(d_L{i})
    m_r(i)=mean(d_R{i})
    m_f(i)=mean(d_F{i})
    m_b(i)=mean(d_B{i})
    
    
end
a=[];
disp('====================================================');
    
    m_L=min(m_l)
    m_R=min(m_r)
    m_F=min(m_f)
    m_B=min(m_b)
    
   
    a(1)=m_L;
    a(2)=m_R;
    a(3)=m_F;
    a(4)=m_B;
    
    result=min(a)
    
    if result==a(1)
        msgbox('You have spoken LEFT');
    elseif result==a(2)
        msgbox('You have spoken RIGHT');
    elseif result==a(3)
        msgbox('You have spoken FORWARD');
    elseif result==a(4)
        msgbox('You have spoken REVERSE');
    else
        msgbox('Invalid word');
    end
    disp('processing time is:');
    time=toc