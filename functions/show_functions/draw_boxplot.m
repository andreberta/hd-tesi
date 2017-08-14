function draw_boxplot(data,groups,width,title_,save)
%DRAW_BOXPLOT : draw a boxplot given the values of the percentile

%INPUT VALUES
%data is a matrix 5xn, where n is the number of group, while the rows are:
%-1: lower wiskers  
%-2: lower box side (Usually 25 percentile)
%-3: median         (Usually 50 percentile)
%-4: upper box side (Usually 75 percentile)
%-5: uper wisker

%groups is a cell array containing the label to display


%width is the width used for the box, the wiskers will have a third of that

%title_ a strig which will be shown as title in the plot

%save is an optional parameter, is a string containing the name of the destination
% file. If this parameter is defined the plot will be saved as an image, otherwise not


%%check variable
group_number = length(groups);

if ~(group_number == size(data,2))
    error('Data should have a number of cols equal to the number of groups');
end


x = 10:10:10*group_number;
for ii=1:group_number
    %y val
    low_w = data(1,ii);
    low_b = data(2,ii);
    median = data(3,ii);
    up_b = data(4,ii);
    up_w = data(5,ii);
    
    %x val
    left_w = x(ii) - width/6;
    right_w = x(ii) + width/6;
    
    left_b = x(ii) - width/2;
    right_b = x(ii) + width/2;

    
    %plot the box
    plot([left_b right_b],[low_b low_b],'b'),hold on
    plot([right_b right_b],[low_b up_b],'b'),hold on
    plot([right_b left_b],[up_b up_b],'b'),hold on
    plot([left_b left_b],[up_b low_b],'b'),hold on
    
    %plot the whiskers
    plot([left_w right_w],[low_w low_w],'b'),hold on
    plot([left_w right_w],[up_w up_w],'b'),hold on
    
    %plot the median
    plot([left_b right_b],[median median],'r'),hold on
    
    %plot vertical lines
    plot([x(ii) x(ii)],[up_b up_w],'b'),hold on
    plot([x(ii) x(ii)],[low_b low_w],'b'),hold on

end

hold off;

%edit plot
%label
set(gca, 'xtick', x); 
set(gca, 'xticklabel', groups); 
get(gca, 'xticklabelmode'); 

%title
title(title_);

% if nargin == 5
%   print (h, save);
% end








end