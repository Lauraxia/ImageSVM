a = imread('Haykin_cover_sketch.bmp');
%coords = [1, 1; 3, 3; 2, 4];

b =a;
for i=1:length(a(:,1,1))
    for j=1:length(a(1,:,1))
        b(i,j,:) = findLAB([a(i,j,1); a(i,j,2); a(i,j,3)]);
    end
end
%lab = findLAB(reshape(a, 1, length(a(:,1,1)) * length(a(1,:,1))));

close all;
figure;
b = double(b);
imshow(uint8(b(:,:,1)./max(max(b(:,:,1))).*255));

figure;
imshow(uint8(b(:,:,2)./max(max(b(:,:,2))).*255));

figure;
imshow(uint8(b(:,:,3)./max(max(b(:,:,3))).*255));
%sobel = xyToSobel(coords, a);
%gaussianlab = xyToCanny(coords, a);