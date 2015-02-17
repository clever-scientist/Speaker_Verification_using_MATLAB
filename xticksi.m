 function s=xticksi(ah)
 %XTIXKSI labels the x-axis of a plot using SI multipliers S=(AH)
 %
 %  Inputs:  AH       axis handle [default: current axes]
 %
 % Outputs:  S        optional global SI multiplier (see usage below)
 %
 % Usage:   (1) plot(...);
 %              xticksi;
 %
 %          (2) plot(...);
 %              xlabel(['Frequency (' xticksi 'Hz)']);
 %
 % The first form will label the tick marks on the x-axis of the current plot
 % using SI multipliers where appropriate. This is particularly useful for log
 % plots which MATLAB does not label very well.
 % The second form will, if possible, use a single SI multiplier for all the tick
 % marks; this global multiplier can be incorporated into the axis label as shown.
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 if ~nargin
     ah=gca;
 end
 if nargout
 s=xyzticksi(1,ah);
 else
     xyzticksi(1,ah);
 end