function [ a ] = convertImageToLAB( a )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

overallWidth = length(a(1,:,1));
overallHeight = length(a(:,1,1));

a = double(a); %very important! LAB values have decimals and are often negative!

%convert to LAB
for j=1:overallHeight
    for k=1:overallWidth
        a(j,k,:) = findLAB(double([a(j,k,1); a(j,k,2); a(j,k,3)]));
    end
end

end

