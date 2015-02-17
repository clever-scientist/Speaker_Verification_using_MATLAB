clc;
clear all;

load('data_collection.mat');


%% Transposing data-matrices
% In NNs tha data features are in rows instead of columns

for i=1:5
    cept_L{1,i}=cept_L{1,i}';
    cept_R{1,i}=cept_R{1,i}';
    cept_F{1,i}=cept_F{1,i}';
    cept_B{1,i}=cept_B{1,i}';
end    

%% data conditioning : used for setting matrix sizes

len_L=[];
len_R=[];
len_F=[];
len_B=[];

for i=1:5
    len_L(i)=length(cept_L{1,i});
    len_R(i)=length(cept_R{1,i});
    len_F(i)=length(cept_F{1,i});
    len_B(i)=length(cept_B{1,i});
end

len_L=min(len_L);
len_R=min(len_R);
len_F=min(len_F);
len_B=min(len_B);
  

%% Creating Target matrices by averaging data in rows of one of the five matrices

T_L=zeros(1,len_L);
T_R=zeros(1,len_R);
T_F=zeros(1,len_F);
T_B=zeros(1,len_B);


    % summation
    for i=1:5
        for j=1:12
           T_L(1,:)=T_L(1,:)+(cept_L{1,i}(j,1:len_L));
           T_R(1,:)=T_R(1,:)+(cept_R{1,i}(j,1:len_R));
           T_F(1,:)=T_F(1,:)+(cept_F{1,i}(j,1:len_F));
           T_B(1,:)=T_B(1,:)+(cept_B{1,i}(j,1:len_B));
        end
    end
        
    %division by 12
       T_L=T_L/12;
       T_R=T_R/12;
       T_F=T_F/12;
       T_B=T_B/12;
       
%% Create a fitting network for each of four commands

hiddenLayerSize=15;

Lnet=fitnet(hiddenLayerSize);
Rnet=fitnet(hiddenLayerSize);
Fnet=fitnet(hiddenLayerSize);
Bnet=fitnet(hiddenLayerSize);

% Set up Division of Data for Training, Validation, Testing
Lnet.divideParam.trainRatio = 70/100;
Lnet.divideParam.valRatio = 15/100;
Lnet.divideParam.testRatio = 15/100;

% Set up Division of Data for Training, Validation, Testing
Rnet.divideParam.trainRatio = 70/100;
Rnet.divideParam.valRatio = 15/100;
Rnet.divideParam.testRatio = 15/100;

% Set up Division of Data for Training, Validation, Testing
Fnet.divideParam.trainRatio = 70/100;
Fnet.divideParam.valRatio = 15/100;
Fnet.divideParam.testRatio = 15/100;

% Set up Division of Data for Training, Validation, Testing
Bnet.divideParam.trainRatio = 70/100;
Bnet.divideParam.valRatio = 15/100;
Bnet.divideParam.testRatio = 15/100;

%% Training the network
for i=1:5
[Lnet,Ltr]=train(Lnet,cept_L{1,i}(:,1:len_L),T_L);
[Rnet,Rtr]=train(Rnet,cept_R{1,i}(:,1:len_R),T_R);
[Fnet,Ftr]=train(Fnet,cept_F{1,i}(:,1:len_F),T_F);
[Bnet,Btr]=train(Bnet,cept_B{1,i}(:,1:len_B),T_B);
end


save('nntrial.mat');