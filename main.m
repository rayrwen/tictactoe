clc;
clear all;
close all;

%X are 1 and O are 2
TicTacToe = zeros(3,3);

%Thresholds 
paper_thresh = 0.65;
black_thresh = 0.60;
rescale_coef = 1.5;
diff_thresh  = 50/255;
erode_size   = 2;
dilate_size  = 6;
t = 20;

%Initialize Boards
play_mat = zeros(3);
comp_mat = zeros(3);

%Initialize Camera
cam=webcam(2);

count = 0;
%TicTacToe Initialization Assumes Board is already drawn
board_init = snapshot(cam);
imwrite(board_init, ['image',num2str(count),'.bmp'])

board_init = preprocess_img(board_init);

% Extract Paper Information
[m2,n2,start_x,start_y,end_x,end_y] = GetPaperDimensions( board_init, ...
    paper_thresh,rescale_coef );
zoomed_past = zeros(m2,n2);
zoomed_past = uint8(board_init(start_y:end_y,start_x:end_x));


% GrayScale to BW
board = double(zoomed_past)./255;
boardBW = im2bw(board,black_thresh);
boardBW = uint8(boardBW*255);
boardBW = imcomplement(boardBW);

% Morphological Filtering (Dilate board for better structure)
se = strel('square',dilate_size);
boardBW = imdilate(boardBW,se);


figure()
imshowpair(board_init, boardBW, 'montage')
title('TicTacToe Board')

% Get Board Information
center = GetBoardDimensions(boardBW)
y_threshold = center(1,3)/3;
x_threshold = center(1,4)/3;


status = 0;
while(status==0)    
    t = 20;
    disp(['You have ',num2str(t),' seconds left'])
    while t~=0
        t=t-1;
        pause(1)
        disp(['You have ',num2str(t),' seconds left'])
    end
    disp('Reading Move')
    image_update = snapshot(cam);
    count = count + 1;
    imwrite(image_update, ['image',num2str(count),'.bmp'])
    
    % PreProcessing
    image_update = preprocess_img(image_update);
    
    % Extract Paper Information
    zoomed_current = zeros(m2,n2);
    zoomed_current = uint8(image_update(start_y:end_y,start_x:end_x));

    % BW Difference between current and previous image
    board = double(zoomed_past-zoomed_current)./255;
    boardBW = im2bw(board,diff_thresh);
    boardBW = uint8(boardBW*255);

    % Morphological Filtering (erode to remove any noise + dilate for
    % structures)
    se = strel('square',erode_size);
    boardBW = imerode(boardBW,se);
    se = strel('square',dilate_size);
    boardBW = imdilate(boardBW,se);


    figure()
    imshowpair(image_update, boardBW, 'montage')
    title('Current Move')

    % X or O (1 for X, 2 for O)
    shape_det = DetermineShape(boardBW);
    

    % GetObjectLocation
    [x,y,center] = GetObjectLocation(boardBW,center,x_threshold,y_threshold);

    % Update Boards
    play_mat(x,y) = 1;
    status = see_who_wins(play_mat, comp_mat);
    if status ~= 0
      fprintf('Status == %d\n Game over\n', status);
      break;
    end
    [play_mat, comp_mat, status] = next_step(play_mat, comp_mat);
    
    if shape_det == 1
        play_shape = 'X'; comp_shape = 'O';
    else
        play_shape = 'O'; comp_shape = 'X';
    end
    
    make_fig(play_mat, comp_mat, play_shape, comp_shape);
    zoomed_past = zoomed_current;
end

make_fig(play_mat, comp_mat, play_shape, comp_shape);


    