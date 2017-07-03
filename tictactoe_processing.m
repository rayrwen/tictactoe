clc;
clear all;
close all;

%X are 1 and O are 2
TicTacToe = zeros(3,3);

%Thresholds 
paper_thresh = 0.65;
black_thresh = 0.6275;
rescale_coef = 1.25;
diff_thresh  = 50/255;
erode_size   = 2;
dilate_size  = 6;

%% First Image and Initialization
img = imread('image_at_lab01.bmp');
[m,n,o] = size(img);

% PreProcessing
img = preprocess_img(img);

% Extract Paper Information
[ m2,n2,start_x,start_y,end_x,end_y ] = GetPaperDimensions( img,paper_thresh,rescale_coef );
zoomed_img = zeros(m2,n2);
zoomed_img = uint8(img(start_y:end_y,start_x:end_x));


% GrayScale to BW
board = double(zoomed_img)./255;
boardBW = imbinarize(board,black_thresh);
boardBW = uint8(boardBW*255);
boardBW = imcomplement(boardBW);

% Morphological Filtering (Dilate board for better structure)
se = strel('square',dilate_size);
boardBW = imdilate(boardBW,se);


figure()
imshowpair(img, boardBW, 'montage')
title('TicTacToe Board')

% Get Board Information
center = GetBoardDimensions(boardBW)
y_threshold = center(1,3)/3;
x_threshold = center(1,4)/3;


%% Second Image
img1 = imread('image_at_lab02.bmp');

% PreProcessing
img1 = preprocess_img(img1);

% Extract Paper Information
zoomed_img1 = zeros(m2,n2);
zoomed_img1 = uint8(img1(start_y:end_y,start_x:end_x));

% BW Difference between current and previous image
board = double(zoomed_img-zoomed_img1)./255;
boardBW = imbinarize(board,diff_thresh);
boardBW = uint8(boardBW*255);

% Morphological Filtering (erode to remove any noise + dilate for
% structures)
se = strel('square',erode_size);
boardBW = imerode(boardBW,se);
se = strel('square',dilate_size);
boardBW = imdilate(boardBW,se);


figure()
imshowpair(img1, boardBW, 'montage')
title('First Move')


% X or O
shape_det = DetermineShape(boardBW);

% GetObjectLocation
[x,y,center] = GetObjectLocation(boardBW,center,x_threshold,y_threshold);

% Update Board
TicTacToe(x,y) = shape_det

%% Second Image
img2 = imread('image_at_lab03.bmp');

% PreProcessing
img2 = preprocess_img(img2);


% Extract Paper Information
zoomed_img2 = zeros(m2,n2);
zoomed_img2 = uint8(img2(start_y:end_y,start_x:end_x));

% BW Difference between current and previous image
board = double(zoomed_img1-zoomed_img2)./255;
boardBW = imbinarize(board,diff_thresh);
boardBW = uint8(boardBW*255);

% Morphological Filtering (erode to remove any noise + dilate for
% structures)
se = strel('square',erode_size);
boardBW = imerode(boardBW,se);
se = strel('square',dilate_size);
boardBW = imdilate(boardBW,se);


figure()
imshowpair(img2, boardBW, 'montage')
title('First Move')


% X or O
shape_det = DetermineShape(boardBW);

% GetObjectLocation
[x,y,center] = GetObjectLocation(boardBW,center,x_threshold,y_threshold);

% Update Board
TicTacToe(x,y) = shape_det