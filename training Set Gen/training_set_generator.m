clc; clear all; close all;

I = imread('Haykin_cover_sketch.bmp');
Imask = imread('Haykin_cover_sketch-mask.bmp');

%Imask = im2bw(Imask, 1);

[H,W,D] = size(I);

T = 5000;

f = figure;
set(f,'name',num2str(T),'numbertitle','off');

%I(im2bw(rgb2gray(Imask),0.0001)) = 0;

Itest = rgb2gray(Imask);

imshow(I);

training = zeros(T, 3);

k = 1;
while true
    [x,y] = ginput(1);

    if x > W || x < 0 || y > H || y < 0
        continue;
    else
        if Itest(y,x) ~= 0
            I(y,x,:) = [255 0 0];
            training(k,:) = [x y -1];
            set(f,'name',num2str(T-k),'numbertitle','off');
        else
            I(y,x,:) = [0 255 0];
            training(k,:) = [x y 1];
            set(f,'name',num2str(T-k),'numbertitle','off');
        end
    
        imshow(I);
        k = k + 1;
        if k > T
            break;
        end
    end
end

save('Training_Data', 'training')
close all;