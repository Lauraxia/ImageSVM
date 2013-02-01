function [ canny ] = xyToCanny(  xy, img )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

imgBW = rgb2gray(img);
filtImg = edge(imgBW,'canny');



canny = zeros(length(xy(:,1)), 1);
H = fspecial('disk', 4);%'gaussian', [15,15], 0.5);%('motion',20,45);%('gaussian', [255 255]);

%imgBW = rgb2gray(img);
filtImg = filtImg * 255;
filtC = imfilter(filtImg,H,'replicate');
%for testing only:
imshow(uint8(filtC));

for i=1:length(xy(:,1))
    canny(i, 1) = filtC(xy(i,1), xy(i,2));
end

end

