function [ img ] = preprocess_img( img, noise )
% pre-process image depending on noise
% noise can be 'none', 'sp' or 'gau'

if nargin == 1
  noise = 'none';
end

img = rgb2gray(img);
img = imsharpen(img);

if strcmp(noise,'gau')
  % Average filter
  H = fspecial('average');
  img = imfilter(img,H);
  % Gaussian filter
  img = imgaussfilt(img,1);
  img = imsharpen(img);
end

if strcmp(noise,'sp')
  % Median filter
  img = medfilt2(img);
   % Gaussian filter
  img = imgaussfilt(img,1);
end

end

