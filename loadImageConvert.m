a = imread('alex.jpg');
coords = [1, 1; 3, 3; 2, 4];

%lab = xyToLab(coords, a);
%sobel = xyToSobel(coords, a);
gaussianlab = xyToGaussianLab(coords, a);