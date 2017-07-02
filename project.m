clc;
clear all;
close all;


TicTacToe = zeros(3,3);
%X are 1 and O are 2

%% First Image and Initialization
img = imread('image_at_lab01.bmp');
[m,n,o] = size(img);

% figure()
% imshow(img)
img = rgb2gray(img);
img = imsharpen(img);

% Mask off the paper
mask = double(imgaussfilt(img,10));
% figure()
% imshow(uint8(mask))
mask = mask./255;
%Threshold might change according to lighting
BW = imbinarize(mask,0.65);
% figure()
% imshow(BW*255)

masked_image = zeros(m,n);
for i = 1:m
    for j = 1:n
        if BW(i,j)==1
            masked_image(i,j)=img(i,j);
        end
    end
end

% figure()
% imshow(uint8(masked_image))

%Resizing size to try and capture the tic tac toe board. Arbitrarily chose
%1.5. camera view will affect this
stats = regionprops('table',BW,'Centroid','MajorAxisLength','MinorAxisLength')
m2=round(stats.MajorAxisLength(1)/1.25);
n2=round(stats.MinorAxisLength(1)/1.25);

zoomed_img = zeros(m2,n2);
center = stats.Centroid;
center = round(center(1,:));
start_x = center(1)-m2/2;
end_x = start_x+m2-1;
start_y = center(2)-n2/2;
end_y = start_y+n2-1;
zoomed_img = uint8(masked_image(start_y:end_y,start_x:end_x));

%Final Sharpening
% figure()
% imshow(zoomed_img)
zoomed_img_sharp = imsharpen(zoomed_img,'Radius',0.5,'Amount',2);

% zoomed_img = double(imgaussfilt(zoomed_img,3));

% figure(1)
% imshow(uint8(zoomed_img))
% title('Zoomed In')

board = double(zoomed_img)./255;
boardBW = imbinarize(board,160/255);
boardBW = uint8(boardBW*255);

% figure(2)
% imshow(boardBW)
% title('Binarized')
boardBW = imcomplement(boardBW);


% figure(3)
% imshow(boardBW)
% title('Complement')

se = strel('square',6);
BW2 = imdilate(boardBW,se);
figure()
imshowpair(img, BW2, 'montage')
title('TicTacToe Board')


%Finding Center. (Removing Nans from table by storting)
stats = regionprops('table',BW2,'Centroid','MajorAxisLength','MinorAxisLength');
stats2 = table2array(stats);
[Y, I] = sort(stats2(:,1));
stats = stats2(I,:);
center = round(stats(1,:));
y_threshold = center(1,3)/3;
x_threshold = center(1,4)/3;


%% Second Image
img1 = imread('image_at_lab02.bmp');
img1 = rgb2gray(img1);
img1 = imsharpen(img1);

%Masking and Extract board
masked_image = zeros(m,n);
for i = 1:m
    for j = 1:n
        if BW(i,j)==1
            masked_image(i,j)=img1(i,j);
        end
    end
end

zoomed_img1 = zeros(m2,n2);
zoomed_img1 = uint8(masked_image(start_y:end_y,start_x:end_x));

% zoomed_img1 = imsharpen(zoomed_img1,'Radius',0.5,'Amount',5);
% figure()
% imshow(zoomed_img1)

% figure(5)
% imshow(zoomed_img-zoomed_img1)
% title('difference')

board = double(zoomed_img-zoomed_img1)./255;
boardBW = imbinarize(board,50/255);
boardBW = uint8(boardBW*255);

% figure(6)
% imshow(boardBW)
% title('binarized')
% boardBW = imcomplement(boardBW);

se = strel('square',2);
BW2 = imerode(boardBW,se);

se = strel('square',6);
BW2 = imdilate(BW2,se);
figure()
imshowpair(img1, BW2, 'montage')
title('First Move')


% X or O
shape_det = imcomplement(BW2);
CC = bwconncomp(shape_det);

%Finding Center. (Removing Nans from table by storting)
stats = regionprops('table',BW2,'Centroid','MajorAxisLength','MinorAxisLength');
stats2 = table2array(stats);
[Y, I] = sort(stats2(:,1));
stats = stats2(I,:);
center(size(center,1)+1,:) = round(stats(1,:));

% Location on Board
di_y = center(size(center,1),1)-center(1,1);
di_x = center(size(center,1),2)-center(1,2);
y=round(di_y/y_threshold);
x=round(di_x/x_threshold);

TicTacToe(y+2,x+2) = CC.NumObjects

%% Third Image
img2 = imread('image_at_lab03.bmp');
img2 = rgb2gray(img2);
img2 = imsharpen(img2);

%Masking and Extract board
masked_image = zeros(m,n);
for i = 1:m
    for j = 1:n
        if BW(i,j)==1
            masked_image(i,j)=img2(i,j);
        end
    end
end

zoomed_img2 = zeros(m2,n2);
zoomed_img2 = uint8(masked_image(start_y:end_y,start_x:end_x));


% figure(5)
% imshow(zoomed_img1-zoomed_img2)
% title('difference')

board = double(zoomed_img1-zoomed_img2)./255;
boardBW = imbinarize(board,50/255);
boardBW = uint8(boardBW*255);

% figure(6)
% imshow(boardBW)
% title('binarized')
% boardBW = imcomplement(boardBW);

se = strel('square',2);
BW2 = imerode(boardBW,se);

se = strel('square',6);
BW2 = imdilate(BW2,se);

figure()
imshowpair(img2, BW2, 'montage')
title('Second Move')

% X or O
shape_det = imcomplement(BW2);
CC = bwconncomp(shape_det);



%Finding Center. (Removing Nans from table by storting)
stats = regionprops('table',BW2,'Centroid','MajorAxisLength','MinorAxisLength');
stats2 = table2array(stats);
[Y, I] = sort(stats2(:,1));
stats = stats2(I,:);
center(size(center,1)+1,:) = round(stats(1,:));

% Location on Board
di_y = center(size(center,1),1)-center(1,1);
di_x = center(size(center,1),2)-center(1,2);
y=round(di_y/y_threshold);
x=round(di_x/x_threshold);

TicTacToe(y+2,x+2) = CC.NumObjects
