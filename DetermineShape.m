function [ shape ] = DetermineShape( boardBW )
% Counts the number of connected components in BW image. X will have 1 CC
% and O will have two. 

shape_det = imcomplement(boardBW);
CC = bwconncomp(shape_det);

shape = CC.NumObjects;
end

