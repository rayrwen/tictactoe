clear
clc

file = dir('player_x'); 
NF = length(file);

gau_noise = 0.035;
sp_noise = 0.15;

status1 = mkdir(sprintf('player_x_gau%04d',gau_noise*1000));
status2 = mkdir(sprintf('player_x_sp%04d',sp_noise*1000));

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
end