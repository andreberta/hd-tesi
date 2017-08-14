function [ regions ] = regions_rosas( hemi )
%REGIONS_ROSAS given the hemisphere return return the most affected region
%of that hemisphere according to Rosas et. al. 2011

if strcmp(hemi,'lh')
    regions = {'precentral', 'postcentral'    , 'inferiorparietal',...
        'precuneus'  , 'superiorfrontal', 'caudalmiddlefrontal',...
        'rostralmiddlefrontal','superiortemporal','lingual'};
else if strcmp(hemi,'rh')
        regions = {'precentral','postcentral'    , 'inferiorparietal' ,...
            'precuneus'  , 'superiorfrontal', 'caudalmiddlefrontal',...
            'rostralmiddlefrontal' , 'superiorparietal','lingual',...
            'inferiortemporal' , 'middletemporal' , 'parsopercularis'...
            'parstriangularis' , 'parsorbitalis','superiortemporal'};
    else
        erro('Hemi %s does not exists',hemi);
    end
end

end

