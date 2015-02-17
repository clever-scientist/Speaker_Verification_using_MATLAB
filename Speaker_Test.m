clc;
clear all;

load('speaker_data.mat');

%% Testing Phase
disp('Data of test speaker');
disp('Press any key when you are ready');
pause;
test=wavrecord(N,Fs,Ch);

for j=1:N
    if(test(j)>0.02)
       sp=test(j:N);
       break;
    end
end

k=length(sp);

while(k>1)
         k=k-1;
      if (sp(k)<0.02)
         continue;
      else 
           SP=sp(1:k);
           cept_test = melcepst(SP,Fs);
           break;
      end
end

m_t=cell(1,1);

obj_t = gmdistribution.fit(cept_test,16,'CovType','diagonal')
m_t=obj_t.mu;
v_t=obj_t.Sigma;
p_t=obj_t.PComponents;
post_t = posterior(obj,cept_test);


%% Decision Making

for i=1:S
%     d{i}=mahal(m_t,m{i});
%     f{i}=mean(d{i});
    d{i}=mahal(post_t,post{i});
    f{i}=mean(d{i});

end

a=[];
disp('====================================================');

 for i=1:S 
    a(i)=f{i};   
 end
    a
    result=max(a)
    
    if result==a(1)
        msgbox('You are Speaker-1');
    elseif result==a(2)
        msgbox('You are Speaker-2');
    elseif result==a(3)
        msgbox('You are Speaker-3');
    elseif result==a(4)
        msgbox('You are Speaker-4');
    end
