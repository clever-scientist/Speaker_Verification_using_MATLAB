 function [mel,mr] = frq2mel(frq)
 %FRQ2ERB  Convert Hertz to Mel frequency scale MEL=(FRQ)
 %    [mel,mr] = frq2mel(frq) converts a vector of frequencies (in Hz)
 %    to the corresponding values on the Mel scale which corresponds
 %    to the perceived pitch of a tone.
 %   mr gives the corresponding gradients in Hz/mel.
 
 %    The relationship between mel and frq is given by [1]:
 %
 %    m = ln(1 + f/700) * 1000 / ln(1+1000/700)
 %
 %      This means that m(1000) = 1000
 %
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 persistent k
 if isempty(k)
     k=1000/log(1+1000/700); %  1127.01048
 end
 af=abs(frq);
 mel = sign(frq).*log(1+af/700)*k;
 mr=(700+af)/k;
 if ~nargout
     plot(frq,mel,'-x');
     xlabel(['Frequency (' xticksi 'Hz)']);
     ylabel(['Frequency (' yticksi 'Mel)']);
 end