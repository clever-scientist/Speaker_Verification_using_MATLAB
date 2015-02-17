clc;
clear all;

load('data_collection.mat');
load('nntrial.mat');

%% Unknown Data

disp('==========================================================');
disp('Welcome to speech recognition system');
disp('Press any key and speak within 2 seconds');
pause;
check=wavrecord(N,Fs,Ch);

% Silence Removal
   for i=1:N
        if(check(i)>0.02)
           chk=check(i:N);
           break;
        end
   end
   k=length(chk);
   while(k>1)
         k=k-1;
      if (chk(k)<0.02)
         continue;
      else 
           CHK=chk(1:k);
           cept_CHK = melcepst(CHK,Fs);
           break;
      end
   end

    cept_CHK=cept_CHK';
    len_CHK=length(cept_CHK);

%% Testing the network

op=cell(1,4);
errors=cell(1,4);
performance=[];

if (len_CHK>len_L)
    op{1,1}=Lnet(cept_CHK(:,1:len_L));
    performance(1) = perform(Lnet,T_L,op{1,1})
else
    op{1,1}=Lnet(cept_CHK(:,1:len_CHK));
    performance(1) = perform(Lnet,T_L(1:len_CHK),op{1,1})
end

if (len_CHK>len_R)
    op{1,2}=Rnet(cept_CHK(:,1:len_R));
    performance(2) = perform(Rnet,T_R,op{1,2})
else
    op{1,2}=Rnet(cept_CHK(:,1:len_CHK));
    performance(2) = perform(Rnet,T_R(1:len_CHK),op{1,2})
end

if (len_CHK>len_F)
    op{1,3}=Fnet(cept_CHK(:,1:len_F));
    performance(3) = perform(Fnet,T_F,op{1,3})
else
    op{1,3}=Fnet(cept_CHK(:,1:len_CHK));
    performance(3) = perform(Fnet,T_F(1:len_CHK),op{1,3})
end

if (len_CHK>len_B)
    op{1,4}=Bnet(cept_CHK(:,1:len_B));
    performance(4) = perform(Bnet,T_B,op{1,4})
else
    op{1,4}=Bnet(cept_CHK(:,1:len_CHK));
    performance(4) = perform(Bnet,T_B(1:len_CHK),op{1,4})
end
    

% op{1,2}=Rnet(cept_CHK(:,1:len_R));
% op{1,3}=Fnet(cept_CHK(:,1:min(len_F);
% op{1,4}=Bnet(cept_CHK(:,1:len_B));
% 
% errors{1,1} = gsubtract(op{1,1},T_L);
% errors{1,2} = gsubtract(op{1,2},T_R);
% errors{1,3} = gsubtract(op{1,3},T_F);
% errors{1,4} = gsubtract(op{1,4},T_B);
% 
% performance(2) = perform(Rnet,T_R,op{1,2})
% performance(3) = perform(Fnet,T_F,op{1,3})
% performance(4) = perform(Bnet,T_B,op{1,4})
% 
