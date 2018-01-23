function [ pos ] = parc2pos_multiple( parc )
%PARC2POS_MULTIPLE Given a cell array containing regions name return a
%vector containg their positions

%%
pos = zeros(length(parc),1);

for ii=1:length(parc)
    pos(ii) = parc2pos(parc{ii});
end


end

