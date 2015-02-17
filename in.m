0001 function [x,fs,txt] = sapisynth(t,m)
0002 %SAPISYNTH  text-to-speech synthesize of text string or matrix [X,FS,TXT]=(T,M)
0003 %
0004 %  Usage:         sapisynth('Hello world');          % Speak text
0005 %                 sapisynth([1 2+3i; -1i 4],'j');    % speak a matrix using 'j' for sqrt(-1)
0006 %          [x,fs]=sapisynth('Hello world','k11');    % save waveform at 11kHz
0007 %                 sapisynth('Hello world','fc');     % use a female child voice if available
0008 %
0009 %  Inputs: t  is either a text string or a matrix
0010 %          m  is a mode string containing one or more of the
0011 %             following options (# denotes an integer):
0012 %
0013 %             'l'   x=a cell array containing a list of talkers
0014 %             'l#'  specify talker # (in the range 1:nvoices)
0015 %             'r#'  speaking rate -10(slow) to +10(fast) [0]
0016 %             'k#'  target sample rate in kHz [22]
0017 %             'o'   audio output [default if no output arguments]
0018 %             'j'   use 'j' rather than 'i' for complex numbers
0019 %             'm','f' 'c','t','a','s' = Male Female Child, Teen, Adult, Senior
0020 %                       specify any combination in order of priority
0021 %             'v'   autoscale volumne to a peak value of +-1
0022 %             'v#'  set volume (0 to 100) [100]
0023 %             'p#'  set pitch -10 to +10 [0]
0024 %             'n#'  number of digits precision for numeric values [3]
0025 %
0026 % Outputs: x    is the output waveform unless the 'l' option is chosen in
0027 %               which case x is a cell array with one row per available
0028 %               voice containing {'Name' 'Gender' 'Age'} where
0029 %               Gender={Male,Female} and Age={Unknown,Child,Teen,Adult,Senior}
0030 %          fs   is the actual sample frequency
0031 %         txt   gives the actual text sring sent to the synthesiser
0032 %
0033 % The input text string can contain embedded command which are described
0034 % in full at http://msdn.microsoft.com/en-us/library/ms717077(v=vs.85).aspx
0035 % and summarised here:
0036 %
0037 % '... <bookmark mark="xyz"/> ...'               insert a bookmark
0038 % '... <context id="date_mdy"> 03/04/01 </context> ...' specify order of dates
0039 % '... <emph> ... </emph> ...'                   emphasise
0040 % '... <volume level="50"> ... </volume> ...'    change volume level to 50% of full
0041 % '... <partofsp part="noun"> XXX </partofsp> ...'      specify part of speech of XXX: unkown, noun, verb modifier, function, interjection
0042 % '... <pitch absmiddle="-5"> ... </pitch> ...'  change pitch to -5 [0 is default pitch]
0043 % '... <pitch middle="5"> ... </pitch> ...'      add 5 onto the pitch
0044 % '... <pron sym="h eh 1 l ow "/> ...'           insert phoneme string
0045 % '... <rate absspeed="-5"> ... </rate> ...'     change rate to -5 [0 is default rate]
0046 % '... <rate speed="5"> ... </rate> ...'         add 5 onto the rate
0047 % '... <silence msec="500"/> ...'                insert 500 ms of silence
0048 % '... <spell> ... </spell> ...'                 spell out the words
0049 % '... <voice required="Gender=Female;Age!=Child"> ...' specify target voice attributes to be Female non-child
0050 %                                                         Age={Child, Teen, Adult, Senior}, Gender={Male, Female}
0051 %
0052 % Acknowledgement: This function was originally based on tts.m written by Siyi Deng
0053 
0054 % Bugs/Suggestions:
0055 %  (1) Allow the speaking of structures and cells
0056 %  (2) Allow a blocking call to sound output and/or a callback procedure and/or a status call
0057 %  (3) Have pitch and/or volume change to emphasise the first entry in a matrix row.
0058 %  (4) extract true frequency from output stream
0059 
0060 %      Copyright (C) Mike Brookes 2011
0061 %      Version: $Id: sapisynth.m 2721 2013-02-23 19:15:10Z dmb $
0062 %
0063 %   VOICEBOX is a MATLAB toolbox for speech processing.
0064 %   Home page: http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
0065 %
0066 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0067 %   This program is free software; you can redistribute it and/or modify
0068 %   it under the terms of the GNU General Public License as published by
0069 %   the Free Software Foundation; either version 2 of the License, or
0070 %   (at your option) any later version.
0071 %
0072 %   This program is distributed in the hope that it will be useful,
0073 %   but WITHOUT ANY WARRANTY; without even the implied warranty of
0074 %   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
0075 %   GNU General Public License for more details.
0076 %
0077 %   You can obtain a copy of the GNU General Public License from
0078 %   http://www.gnu.org/copyleft/gpl.html or by writing to
0079 %   Free Software Foundation, Inc.,675 Mass Ave, Cambridge, MA 02139, USA.
0080 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0081 persistent vv vvi vvj
0082 
0083 % Check that we are on a PC
0084 
0085 if ~ispc, error('only works on a PC'); end
0086 
0087 % decode the options
0088 
0089 if nargin<2
0090     m='';
0091 end
0092 opts=zeros(52,3); % [exists+number specified, value]
0093 lmode=length(m);
0094 i=1;
0095 while i<=lmode
0096     if i<lmode  % read a following integer if it exists
0097         [v,nv,e,ni]=sscanf(m(i+1:end),'%d',1);
0098     else
0099         nv=0;
0100         ni=1;
0101     end
0102     k=1+double(lower(m(i)))-'a'+26*(m(i)<'a');
0103     if k>=1 && k<=52
0104         opts(k,1)=1+nv;
0105         if nv
0106             opts(k,2)=v;
0107         end
0108         opts(k,3)=i;  % save position in mode string
0109     end
0110     i=i+ni;
0111 end
0112 
0113 S=actxserver('SAPI.SpVoice');
0114 V=invoke(S,'GetVoices');  % get a list of voices from the registry
0115 nv=V.Count;
0116 if isempty(vv) || size(vvi,1)~=nv
0117     vv=cell(nv,3);
0118     vvi=zeros(nv,6);
0119     ages={'Senior' 'Adult' 'Teen' 'Child'};
0120     for i=1:nv
0121         VI=V.Item(i-1);
0122         vv{i,1}=VI.GetDescription;
0123         vv{i,2}=VI.GetAttribute('Gender');
0124         vvi(i,1)=MatchesAttributes(VI,'Gender=Male');
0125         vvi(i,2)=MatchesAttributes(VI,'Gender=Female');
0126         vv{i,3}='Unknown';
0127         for j=1:length(ages)
0128             if MatchesAttributes(VI,['Age=' ages{j}])
0129                 vv{i,3}=ages{j};
0130                 vvi(i,2+j)=1;
0131                 break
0132             end
0133         end
0134     end
0135     vvj=vvi;
0136     % in the matrix below, the rows and columns are in the order Senior,Adult,Teen,Child.
0137     % Thus the first row gives the cost of selecting a voice with the wrong age when 'Senior'
0138     % was requested by the user. A voice of unkown age always scores 0 so entries with negative
0139     % values are preferred over 'unknown' while those with positive values are not.
0140     % Diagonal elements of the matrix are ignored (hence set to 0) since correct matches are
0141     % handled earlier with higher priority.
0142     vvj(:,3:6)=vvj(:,3:6)*[0 0 1 2; 1 0 2 3; 1 0 0 -1; 1 0 -1 0]'; % fuzzy voice attribute matching
0143 end
0144 
0145 % deal with the voice selection options
0146 
0147 optv=opts([13 6 19 1 20 3],[3 1 2]);
0148 if opts(12)   % if 'l' option specified - we need to get the voices
0149     if opts(12)>1
0150         S.Voice = V.Item(mod(opts(12,2)-1,nv));
0151     else
0152         x=vv;
0153         return
0154     end
0155 elseif any(optv(:,2))
0156     optv(:,3)=(1:6)';
0157     optv=sortrows(optv(optv(:,2)>0,:));  % sort in order of occurrence in mode string
0158     no=size(optv,1);
0159     optp=zeros(nv,2*no+1);
0160     optp(:,end)=(1:nv)'; % lowest priority condition is original rank
0161     optp(:,1:no)=-vvi(:,optv(:,3));
0162     optp(:,no+1:2*no)=vvj(:,optv(:,3));
0163     optp=sortrows(optp);
0164     S.Voice = V.Item(optp(1,end)-1);
0165 end
0166 
0167 % deal with the 'r' option
0168 
0169 if opts(18)>1  % 'r' option is specified with a number
0170     S.Rate=min(max(opts(18,2),-10),10);
0171 end
0172 
0173 % deal with the 'v' option
0174 
0175 if opts(22)>1  % 'r' option is specified with a number
0176     S.Volume=min(max(opts(22,2),0),100);
0177 end
0178 
0179 % deal with the 'k' option
0180 
0181 ff=[11025 12000 16000 22050 24000 32000 44100 48000]; % valid frequencies
0182 if opts(11)>1  % 'k' option is specified with a number
0183     [v,jf]=min(abs(ff/1000-opts(11,2)));
0184 else
0185     jf=4;  % default is 16kHz
0186 end
0187 fs=ff(jf);
0188 
0189 % deal with the 'n' option
0190 
0191 if opts(14)>1  % 'r' option is specified with a number
0192     prec=opts(14,2);
0193 else
0194     prec=3;
0195 end
0196 
0197 M=actxserver('SAPI.SpMemoryStream');
0198 M.Format.Type = sprintf('SAFT%dkHz16BitMono',fix(fs/1000));
0199 S.AudioOutputStream = M;
0200 if ischar(t)
0201     txt=t;
0202 else
0203     txt='';
0204     if numel(t)
0205         sgns={' minus ', '', ' plus '};
0206         sz=size(t);
0207         w=permute(t,[2 1 3:numel(sz)]);
0208         sz(1:2)=sz(1)+sz(2)-sz(1:2); % Permute the first two dimensions for reading
0209         szp=cumprod(sz);
0210         imch='i'+(opts(10)>0);
0211         vsep='';
0212         for i=1:numel(w)
0213             wr=real(w(i));
0214             wi=imag(w(i));
0215             switch((wr~=0)+2*(wi~=0))+4*(abs(wi)==1)
0216                 case {0,1}
0217                     txt=[txt sprintf('%s%.*g',vsep,prec,wr)];
0218                 case 2
0219                     txt=[txt sprintf('%s%.*g%c,',vsep,prec,wi,imch)];
0220                 case 3
0221                     txt=[txt sprintf('%s%.*g%s%.*g%c,',vsep,prec,wr,sgns{2+sign(wi)},prec,abs(wi),imch)];
0222                 case 6
0223                     if wi>0
0224                         txt=[txt vsep imch ','];
0225                     else
0226                         txt=[txt vsep 'minus ' imch ','];
0227                     end
0228                 case 7
0229                     txt=[txt sprintf('%s%.*g%s%c,',vsep,prec,wr,sgns{2+sign(wi)},imch)];
0230             end
0231             % could use a <silence msec="???"/> command here
0232             vsep=[repmat('; ',1,find([0 mod(i,szp)]==0,1,'last')-1) ' '];
0233         end
0234     end
0235 end
0236 
0237 % deal with the 'p' option
0238 
0239 if opts(16)>1  % 'r' option is specified with a number
0240     txt=[sprintf('<pitch absmiddle="%d"> ',min(max(opts(16,2),-10),10)) txt];
0241 end
0242 
0243 invoke(S,'Speak',txt);
0244 x = mod(32768+reshape(double(invoke(M,'GetData')),2,[])'*[1; 256],65536)/32768-1;
0245 delete(M);      % delete output stream
0246 delete(S);      % delete all interfaces
0247 
0248 if opts(22)==1 % 'v' option with no argument
0249     x=x*(1/max(abs(x))); % autoscale
0250 end
0251 if opts(15)>0 || ~nargout % 'o' option for audio output
0252     sound(x,fs);
0253 end