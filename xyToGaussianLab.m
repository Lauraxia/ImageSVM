function [ labGaussian ] = xyToGaussianLab(  xy, img )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
H = fspecial('disk', 5);%'gaussian', [15,15], 0.5);%('motion',20,45);%('gaussian', [255 255]);

%imgBW = rgb2gray(img);
filtImg = imfilter(img,H,'replicate');

%for testing only:
imshow(img);
figure;
imshow(filtImg);

labGaussian = xyToLab(xy, filtImg);

end

