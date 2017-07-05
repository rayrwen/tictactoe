clc;
clear all;
close all;

%X are 1 and O are 2
TicTacToe = zeros(3,3);

with_webcam = false;
%%% Change this for experimenting with different kinds of noise
% Suitable noise choices are gau, sp, sheer, motion or none.
% Before selecting a noise, run the add_noise.m function, to generate the
% noises on the input images and save them. 

noise = 'gau';
noise_level = '0015';
%%%%%%%%%%%%%%%%%%%%%%%

%Thresholds 
paper_thresh = 0.65;
black_thresh = 0.60;
rescale_coef = 1.5;
diff_thresh  = 50/255;
erode_size   = 2;
dilate_size  = 6;
time_per_move = 5;

if strcmp(noise,'motion')
    black_thresh = 0.67;
    diff_thresh  = 0.1;
end

% Initialize Boards
play_mat = zeros(3);
comp_mat = zeros(3);
img_count = 1;


% Initialize Camera
% TicTacToe Initialization Assumes Board is already drawn

if with_webcam
  cam = webcam(2);
  board_init = snapshot(cam);
  imwrite(board_init, ['image',num2str(img_count),'.bmp'])
  board_init = preprocess_img(board_init);
else
  board_init = imread(fullfile(sprintf('player_x_%s%s', noise, noise_level), ...
    sprintf('image%d.bmp', img_count)));
  board_init = preprocess_img(board_init, noise);
end

% Extract Paper Information
[m2,n2,start_x,start_y,end_x,end_y] = GetPaperDimensions( board_init, ...
    paper_thresh,rescale_coef );
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
[center y_threshold x_threshold] = GetBoardDimensions(boardBW);


status = 0;
while(status==0)    
    t = time_per_move;
    disp(['You have ',num2str(t),' seconds left'])
    while t~=0
        t=t-1;
        pause(1)
        disp(['You have ',num2str(t),' seconds left'])
    end
    disp('Reading Move')
    if with_webcam
      image_update = snapshot(cam);
      imwrite(image_update, ['image',num2str(img_count),'.bmp'])
      img_count = img_count + 1;
      % PreProcessing
      image_update = preprocess_img(image_update);
    else
      img_count = img_count + 1;
      image_update = imread(fullfile(sprintf('player_x_%s%s', noise, noise_level), ...
        sprintf('image%d.bmp',img_count)));
      % PreProcessing
      image_update = preprocess_img(image_update,noise);
    end
    
    
    
    
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
      fprintf('Status == %d\n', status);
      if status == 1
        disp('Player wins');
      else if status == 2
          disp('Computer wins');
        else if status == 3
            disp('Its a draw!');
          else
            disp('Not a valid move! Game over...');
          end
        end
      end
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


    