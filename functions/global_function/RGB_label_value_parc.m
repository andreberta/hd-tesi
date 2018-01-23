function [ res ] = RGB_label_value_parc()
%RGB_LABEL_VALUE_PARC Return a vector containing the RGB code of the parc
%region
% See also doc of parc_region_value function


%NOTE : the last value (1639705) should be the value for unknown in this
%case but it is not actualy use, instead is use the first unknown 
%(#0 in LUT). I have addet it in case it appears.

%%
res = [0       , 2647065 , 10511485 , 6500    , 3294840 , 6558940  ,660700 ...
       9231540 ,7874740   ,9180300  ,9182740  ,3296035   ,9211105 ...
       4924360 , 3302560 , 3988500  , 3988540 , 9221340 , 3302420  ,1326300 ...
       3957880 , 1316060 ,14464220  ,14423100 ,11832480 ,9180240   ,8204875 ...
       10542100, 9221140 , 14474380 , 1351760 ,6553700  ,11146310  ,13145750 ...
       2146559 , 1639705 ,14433500]';
end

