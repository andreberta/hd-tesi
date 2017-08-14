function [ new_value ] = change_range( values)
%CHANGE_RANGE Set the range of values to be in [0.1]

old_max = max(values);
old_min = min(values);
new_max = 1;
new_min = 0;
new_value = ((bsxfun(@minus,values,old_min) .* (new_max - new_min))...
              ./ (old_max - old_min));

end

