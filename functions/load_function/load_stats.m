function [ res ] = load_stats( path , number , hemi )
%LOAD_STATS Load data from a stat file

%TODO : che si possono leggere con la stessa struttura sono
%       -aparc.a2009s.stats
%       -aparc.DKTatlas40.stats
%       -BA.stats/BA.thrsh.stats
%       ci sarà da modificare qualche cosa nella funzione load_seg_stasts
stats = stats_value();
if number == 1 || number == 10
    path_complete_stats = [path,'stats/',stats{number}];
else
    path_complete_stats = [path,'stats/',hemi,'.',stats{number}];
end

[segname, segindex, segstats] = load_segstats(path_complete_stats,'');
res.segname = segname;
res.segindex = segindex;
res.segstats = segstats;

end

