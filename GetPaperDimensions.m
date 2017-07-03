function [ m2,n2,start_x,start_y,end_x,end_y ] = GetPaperDimensions( img,paper_thresh,rescale_coef )

% This function expected a grayscale image focused on a sheet of paper.
% Will return the dimensions of that paper to filter out background.
% Function assumes tictactoe board is somewhat centered and rescales the
% image.



% LowPass to remove any light noise outside paper
mask = double(imgaussfilt(img,10));
% figure()
% imshow(uint8(mask))
mask = mask./255;
%Threshold might change according to lighting
BW = imbinarize(mask,paper_thresh);
% figure()
% imshow(BW*255)

% for i = 1:m
%     for j = 1:n
%         if BW(i,j)==1
%             masked_image(i,j)=img(i,j);
%         end
%     end
% end

% figure()
% imshow(uint8(masked_image))

%Resizing size to try and capture the tic tac toe board. Arbitrarily chose
%1.5. camera view will affect this
stats = regionprops('table',BW,'Centroid','MajorAxisLength','MinorAxisLength')

% ZoomSize
m2=round(stats.MajorAxisLength(1)/rescale_coef);
n2=round(stats.MinorAxisLength(1)/rescale_coef);


center = stats.Centroid;
center = round(center(1,:));

start_x = center(1)-m2/2;
end_x = start_x+m2-1;
start_y = center(2)-n2/2;
end_y = start_y+n2-1;



end

