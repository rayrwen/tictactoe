function [ x,y,center] = GetObjectLocation( boardBW, center, x_threshold, y_threshold )
%Gets the X and Y position of a shape on the 3x3 tictactoe board.


% Finding Center of object. (Removing Nans from table by storting)
stats = regionprops('table',boardBW,'Centroid','MajorAxisLength','MinorAxisLength');
stats2 = table2array(stats);
[Y, I] = sort(stats2(:,1));
stats = stats2(I,:);

% Add Info to center array
center(size(center,1)+1,:) = round(stats(1,:));

% Location on Board
di_y = center(size(center,1),1)-center(1,1);
di_x = center(size(center,1),2)-center(1,2);

% Add 2 because center is initialized as 0,0 but should be 2,2
y=round(di_y/y_threshold)+2;
x=round(di_x/x_threshold)+2;


end

