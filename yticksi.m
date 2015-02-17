 function s=yticksi(ah)
 %YTIXKSI labels the y-axis of a plot using SI multipliers S=(AH)
 %
 %  Inputs:  AH       axis handle [default: current axes]
 %
 % Outputs:  S        optional global SI multiplier (see usage below)
 %
 % Usage:   (1) plot(...);
 %              yticksi;
 %
 %          (2) plot(...);
 %              ylabel(['Frequency (' yticksi 'Hz)']);
 %
 % The first form will label the tick marks on the y-axis of the current plot
 % using SI multipliers where appropriate. This is particularly useful for log
 % plots which MATLAB does not label very well.
 % The second form will, if possible, use a single SI multiplier for all the tick
 % marks; this global multiplier can be incorporated into the axis label as shown.
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 if ~nargin
     ah=gca;
 end
 if nargout
 s=xyzticksi(2,ah);
 else
     xyzticksi(2,ah);
 end