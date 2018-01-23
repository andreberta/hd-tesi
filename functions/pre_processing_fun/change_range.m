function [ new_value ] = change_range(values)
%%
%CHANGE_RANGE Rescale values to be in the interval [0,1]

%% Computation
% get old min and max values
old_max = max(values);
old_min = min(values);
% set new min and max values
new_max = 1;
new_min = 0;
% actual computation of the result
new_value = ((bsxfun(@minus,values,old_min) .* (new_max - new_min))...
              ./ (old_max - old_min));

end

