function show_ls_res(val,p2show,x_labels,y_label,title_)

figure;

x = 1:size(val,2);

for ii= 1:length(p2show)
    
    patient = p2show(ii);
    
    %plot
    subplot(4,1,ii)
    e = errorbar(x,val(patient,:,2),val(patient,:,1),val(patient,:,3),'LineWidth',1);
    e.Marker = 's';
    e.MarkerFaceColor = 'black';
    e.Color = 'black';

    grid on;

    
    %set y axis
    max_y = max(val(patient,:,2) + val(patient,:,3));
    min_y = min(val(patient,:,2) - val(patient,:,1));
    ylim([min_y-0.1,max_y+0.1]);

    %st x axis
    xlim([x(1)-0.2,x(end)+0.2])
    xticks(x(1):x(end))
    xticklabels(x_labels)

    
    
end

[~,~]=suplabel('Visit');
[~,~]=suplabel(y_label,'y');

if exist('title_','var')
    [~,~]=suplabel(title_,'t');
%     saveas(gcf,title_,'png')
end


end

