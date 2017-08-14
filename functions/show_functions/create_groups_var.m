
function groups = create_groups_var(visits)

    groups = cell(1,length(visits));
    for ii=1:length(visits)
        groups{ii} = ['v_',num2str(visits(ii))];
    end

end
