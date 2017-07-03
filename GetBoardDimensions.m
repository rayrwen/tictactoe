function [ center ] = GetObjectDimensions( boardBW )

% This function expects a BW image of an object and returns the dimensions

%Finding Center. (Removing Nans from table by storting)
stats = regionprops('table',boardBW,'Centroid','MajorAxisLength','MinorAxisLength');
stats2 = table2array(stats);
[Y, I] = sort(stats2(:,1));
stats = stats2(I,:);
center = round(stats(1,:));

end

