clc;
clear all;
close all;


% img = imread('tictactoe.bmp');
img = imread('image_at_lab.bmp');
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
%Threshold might change according to lighting
BW = imbinarize(mask,0.68);
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
m2=round(stats.MajorAxisLength(1)/1.25);
n2=round(stats.MinorAxisLength(1)/1.25);
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
zoomed_img_sharp = imsharpen(zoomed_img,'Radius',0.5,'Amount',5);
figure()
imshow(zoomed_img_sharp)



% Next Image
img1 = imread('image_at_lab01.bmp');
img1 = imsharpen(img1);
img1 = rgb2gray(img1);

zoomed_img1 = zeros(m2,n2);
zoomed_img1 = img1(start_y:end_y,start_x:end_x);

zoomed_img1 = imsharpen(zoomed_img1,'Radius',0.5,'Amount',5);
figure()
imshow(zoomed_img1)

figure()
imshow(zoomed_img_sharp-zoomed_img1)

% Next Image
img2 = imread('image_at_lab02.bmp');
img2 = imsharpen(img2);
img2 = rgb2gray(img2);

zoomed_img2 = zeros(m2,n2);
zoomed_img2 = img2(start_y:end_y,start_x:end_x);

zoomed_img2 = imsharpen(zoomed_img2,'Radius',0.5,'Amount',5);
figure()
imshow(zoomed_img2)

figure()
imshow(zoomed_img1-zoomed_img2)

