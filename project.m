clc;
clear all;
close all;


img = imread('tictactoe.bmp');
[m,n,o] = size(img);

figure()
imshow(img)


img = imsharpen(img);
img = rgb2gray(img);


img_neg = imcomplement(img);
% figure()
% imshow(img_neg)

mask = double(imgaussfilt(img,10));
figure()
imshow(uint8(mask))
mask = mask./255;
%Threshoold might change according to lighting
BW = imbinarize(mask,0.6);
figure()
imshow(BW*255)

masked_image = zeros(m,n);
for i = 1:m
    for j = 1:n
        if BW(i,j)==1
            masked_image(i,j)=img(i,j);
        end
    end
end

figure()
imshow(uint8(masked_image))

stats = regionprops('table',BW,'Centroid',...
    'MajorAxisLength','MinorAxisLength')
%Resizing size to try and capture the tic tac toe board. Arbitrarily chose
%1.5. camera view will affect this
m2=round(stats.MajorAxisLength(1)/1.5);
n2=round(stats.MinorAxisLength(1)/1.5);
zoomed_img = zeros(m2,n2);

center = stats.Centroid;
center = round(center(1,:));

start_x = center(1)-m2/2;
end_x = start_x+m2-1;
start_y = center(2)-n2/2;
end_y = start_y+n2-1;

zoomed_img = img(start_y:end_y,start_x:end_x);

figure()
imshow(zoomed_img)

