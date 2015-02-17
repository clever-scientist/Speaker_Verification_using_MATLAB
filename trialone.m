clear all;
clc;
%%

%%data collection

disp('are you ready?');
pause;

disp('say left');
left=wavrecord(1.5*22050,22050,1);
left_a=abs(fft(left));
% figure(1);
% spectrum(left);

%% Low-pass filtering

d=fdesign.lowpass('Fp,Fst,Ap,Ast',0.20,0.22,1,60);
designmethods(d);
Hd = design(d,'equiripple');
fvtool(Hd);
y = filter(Hd,left);

%%%%Silence removal
 q=[];
for i=1:33075
if(y(i)>0.02)
q=y(i:33075);
break;
end
end

i=length(q);
while(i~=1)
         i=i-1;
      if (q(i)<0.02)
         continue;
      else 
           e=q(1:i);
           break;
      end
end

z=audioplayer(e,22050);
play(z);
%%%%%%%%%%


% % pause;
% % disp('say right');
% % right=wavrecord(1.5*22050,22050,1);
% % right_a=abs(fft(right));
% % % figure(2);
% % % spectrum(right);
% % 
% % pause;
% % disp('say forward');
% % forward=wavrecord(1.5*22050,22050,1);
% % forward_a=abs(fft(forward));
% % % figure(3);
% % % spectrum(forward);
% % 
% % pause;
% % disp('say backward');
% % backward=wavrecord(1.5*22050,22050,1);
% % backward_a=abs(fft(backward));
% % % figure(4);
% % % spectrum(backward);
% % 
% % %%
% % 
% % %%Check
% % 
% % disp('Now we will check');
% % pause;
% % disp('say any one of the four command');
% % anything=wavrecord(1.5*22050,22050,1);
% % anything_a=abs(fft(anything));
% % pause;
% % %compare and decide
% % %cmpr=[];
% % [i,l1]= xcorr(anything,left,'coeff');
% % [j,l2]= xcorr(anything,right,'coeff');
% % [k,l3]= xcorr(anything,forward,'coeff');
% % [l,l4]= xcorr(anything,backward,'coeff');
% % 
% % % figure(5);
% % % plot(l1,i);
% % % figure(6);
% % % plot(l2,j);
% % % figure(7);
% % % plot(l3,k);
% % % figure(8);
% % % plot(l4,l);
% % 
% % % 
% % % z=max(cmpr);
% % % 
% % % if z==cmpr(1)
% % %     disp('you have said left');
% % % elseif z==cmpr(2)
% % %     disp('you have said right'); 
% % % elseif z==cmpr(3)
% % %     disp('you have said forward');
% % % else
% % %     disp('you have said backward');
% % % end
% % 
