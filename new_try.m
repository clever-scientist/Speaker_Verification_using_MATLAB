len = length(sig_A);
time = 0.04;
frameSample = time*Fs;
numFrame = floor(len/frameSample);
new_sig_U = zeros(1,len);
count = 0;
for k=1:numFrame
    frame = sig_U((k-1)*frameSample + 1 : k*frameSample);
    
    if(max(frame) > 0.005)
        count = count + 1;
        new_sig_U((count-1)*frameSample + 1 : count*frameSample) = frame;
    end
end