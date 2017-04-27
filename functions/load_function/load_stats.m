function [ res ] = load_stats( path , number , hemi )
%LOAD_STATS Load data from a stat file


segstats_wmparc = number == 1 || number == 10;
aparc = number == 7;

%% Compute path
stats_values = stats_value();
if segstats_wmparc
    path_complete_stats = [path,'stats/',stats_values{number}];
else if aparc
        path_complete_stats = [path,'stats/',hemi,'.',stats_values{number}];
        
    else
        error('Stats file "%s" is not handled.', stats_values{number});
    end
end

%% open the file and check for error
fid = fopen(path_complete_stats);
if(fid == -1)
    fprintf('ERROR: opening %s\n',segstatsfile);
    return;
end

tline = fgetl(fid);
if(tline == -1)
    fprintf('ERROR: %s is not correctly formatted, no first line\n', ...
        segstatsfile);
    fclose(fid);
    return;
end

%% Loop through all the lines
nthrow = 1;
res = [];
while(1)
    
    % scroll through any blank lines or comments (#)
    while(1)
        tline = fgetl(fid);
        if(~isempty(tline) & tline(1) ~= '#')
            break;
        end
    end
    if(tline(1) == -1)
        break;
    end
    
    %read line
    if segstats_wmparc
        [stats] = readline_segstats_wmparc(tline);
        %return only the volume
        res(nthrow) = stats{6};
    else if aparc
            [stats] = readline_aparc(tline);
            res.names{nthrow} = stats{1};
            res.vals(nthrow,:) =[stats{3},stats{4}...
                                ,stats{5},stats{6},stats{7}];
        end
    end
 
    nthrow = nthrow + 1;
end

fclose(fid);


end

