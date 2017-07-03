function [ img ] = preprocess_img( img )
%pre-process image depending on noise

img = rgb2gray(img);
img = imsharpen(img);

end

