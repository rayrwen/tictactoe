clear
clc

file = dir('player_x'); 
NF = length(file);

gau_noise = 0.015;
sp_noise = 0.15;
motion = 30;
sheer = 0.05;

status1 = mkdir(sprintf('player_x_gau%04d',gau_noise*1000));
status2 = mkdir(sprintf('player_x_sp%04d',sp_noise*1000));
status3 = mkdir(sprintf('player_x_motion%04d',motion));
status4 = mkdir(sprintf('player_x_sheer%04d',sheer*1000));

for i = 3:NF
  I = imread(fullfile('player_x', file(i).name));
  J = imnoise(I, 'gaussian', 0, gau_noise);
%   figure; imshow(J)
  imwrite(J, fullfile(sprintf('player_x_gau%04d',gau_noise*1000), ...
    sprintf('image%d.bmp', i-3)));

  J = imnoise(I, 'salt & pepper', sp_noise);
%   figure; imshow(J)
  imwrite(J, fullfile(sprintf('player_x_sp%04d',sp_noise*1000), ...
    sprintf('image%d.bmp', i-3)));

   H = fspecial('motion',motion,45);
   J = imfilter(I,H,'replicate');
   imwrite(J, fullfile(sprintf('player_x_motion%04d',motion), ...
    sprintf('image%d.bmp', i-3)));


    T = maketform('affine', [1 0 0; sheer 1 0; 0 0 1] );
    R = makeresampler({'cubic','nearest'},'fill');
    J = imtransform(I,T,R);
    imwrite(J, fullfile(sprintf('player_x_sheer%04d',sheer*1000), ...
    sprintf('image%d.bmp', i-3)));

    
end