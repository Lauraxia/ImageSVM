function [ lab ] = xyToLab( xy, img )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
rgb = zeros(length(xy(:,1)), 3);
lab = rgb;

for i=1:length(xy(:,1))
rgb(i,:) = img(xy(i,1), xy(i,2), :);
lab(i,:) = findLAB(rgb(i,:)');
end


end

