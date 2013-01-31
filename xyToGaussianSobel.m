function [ sobel ] = xyToGaussianSobel(  xy, img )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
H = fspecial('sobel');
V = H';

imgBW = rgb2gray(img);
filtH = imfilter(imgBW,H,'replicate');
filtV = imfilter(imgBW,V,'replicate');

H = fspecial('disk', 7);%'gaussian', [15,15], 0.5);%('motion',20,45);%('gaussian', [255 255]);

%imgBW = rgb2gray(img);
filtH = imfilter(filtH,H,'replicate');
filtV = imfilter(filtV,H,'replicate');

%for testing only:
%imshow(filtH);
%figure;
%imshow(filtV);

sobel = zeros(length(xy(:,1)), 2);

for i=1:length(xy(:,1))
    sobel(i, 1) = filtH(xy(i,1), xy(i,2));
    sobel(i, 2) = filtV(xy(i,1), xy(i,2));
end

end

