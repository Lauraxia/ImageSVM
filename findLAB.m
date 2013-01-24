function [ lab ] = findLAB( sRGB )
%UNTITLED2 Summary of this function goes here
%   must be column vector
sRGB = double(sRGB);
sRGB = sRGB / 255.0;
a = 0.055;

%find cLinear values:
for j=1:3
    if (sRGB(j) > 0.04045)
        sRGB(j) = ((sRGB(j) + a)/(1+a))^2.4;
    else
        sRGB(j) = sRGB(j)/12.92;
    end
end
sRGB =  sRGB*100;
tristimulusTransform = [0.4124 0.3576 0.1805; 
    0.2126 0.7152 0.0722; 
    0.0193 0.1192 0.9505];

tristimulusValues = tristimulusTransform*sRGB;

%sRGB white point values:
Xn = 0.3127;
Yn = 0.3290;
Zn = 0.3583;
%Calculated from CIE 1 nm data using 1931 Standard Observer, D65
Xn= 95.04705587;
Yn = 100;
Zn = 108.8828736;

 %0.9505, 1.0000, 1.0890

%and convert to L*a*b*:
norm = tristimulusValues./[Xn; Yn; Zn];

if (norm(1) <0.01 || norm(2) < 0.01 || norm(3) <0.01)

    for j = 1:3
        if (norm(j) <= 0.008856)
            fnorm(j) = 7.787*norm(j) + 16/116;
        else
            fnorm(j) = norm(j)^(1/3);
        end
    end
    
    L = 116*(fnorm(2) - 16/116);
    a = 500*(fnorm(1) - fnorm(2));
    b = 200*(fnorm(2) - fnorm(3));
    
else
    L = 116*norm(2)^(1/3) - 16;
    a = 500*(norm(1)^(1/3) - norm(2)^(1/3));
    b = 200*(norm(2)^(1/3) - norm(3)^(1/3));
end

lab = [L a b];

end

