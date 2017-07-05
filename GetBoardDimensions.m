function [ center, y_threshold, x_threshold] = GetObjectDimensions( boardBW , noise )

% This function expects a BW image of an object and returns the dimensions


if nargin == 1
  noise = 'none';
end



%Finding Center. (Removing Nans from table by storting)
stats = regionprops('table',boardBW,'Centroid','MajorAxisLength','MinorAxisLength');
stats2 = table2array(stats);
[Y, I] = sort(stats2(:,1));
stats = stats2(I,:);
center = round(stats(1,:));
y_threshold = center(1,3)/3;
x_threshold = center(1,4)/3;

if strcmp(noise,'motion')
%Adjusting with SURF
    points  = detectSURFFeatures(boardBW);
    points6 = points.selectStrongest(6);
    points6 = points6.Location;
    [idx,points4]=kmeans(points6,4);
    
    center = [mean(points4(:,1)) mean(points4(:,2)) 0 0];
    y_threshold = points4(2,2)-points4(1,2);
    x_threshold = points4(3,1)-points4(1,1);
end


end

