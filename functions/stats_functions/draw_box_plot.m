function draw_box_plot(percentiles,classes)


boxplot(percentiles,'Labels',classes);

% upper end
h = flipud(findobj(gca,'Tag','Upper Whisker'));
for j=1:length(h)
    ydata = get(h(j),'YData');
    ydata(2) = percentiles(end-1,j);
    set(h(j),'YData',ydata);
end

h = flipud(findobj(gca,'Tag','Upper Adjacent Value'));
for j=1:length(h)
    ydata = get(h(j),'YData');
    ydata(:) = percentiles(end-1,j);
    set(h(j),'YData',ydata);
end



% % lower end
% h = flipud(findobj(gca,'Tag','Lower Whisker'));
% for j=1:length(h)
%     ydata = get(h(j),'YData');
%     ydata(2) = percentiles(1,j);
%     set(h(j),'YData',ydata);
% end
% 
% h = flipud(findobj(gca,'Tag','Lower Adjacent Value'));
% for j=1:length(h)
%     ydata = get(h(j),'YData');
%     ydata(:) = percentiles(1,j);
%     set(h(j),'YData',ydata);
% end


%remove outliers
h = flipud(findobj(gca,'Tag','Outliers'));
for j=1:length(h)
    set(h,'Visible','off')
end

end

