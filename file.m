clear all;
clc;
%% Ask the file name
fid = fopen('in.m','r');
fid1 = fopen('sapisynth.m','a+');
while (~feof(fid))
f1 = fgets(fid);
f1 = f1(5:end);
fprintf(fid1,'%s',f1);
end