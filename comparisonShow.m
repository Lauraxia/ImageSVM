testSize = 10;
testCount = 5;

for i = 1:testSize
    for j = 1:testCount
        fileLocation  = sprintf('testing/size%d/test%d/image.png',i,j);
        
        images_buffer = imread(fileLocation);
        images(i,j,:,:,:)   = images_buffer;
    end
end

for i = 1:testSize
    for j = 1:testCount-1
        diff(i,j,:,:,:) = squeeze(images(i,j,:,:,:) - images(i,j+1,:,:,:));
    end
end

% Each column is a difference between two progressions
% Since the first parameter is the test size, we can average each level
% over the second parameter positions.


for i = 1:testSize
    diff2(i,:,:,:) = squeeze(diff(i,1,:,:,:));
    for j = 2:testCount-1
        diff2(i,:,:,:) = squeeze(squeeze(diff2(i,:,:,:)) + squeeze(diff(i,j,:,:,:)));
    end
    diff2(i,:,:,:) = squeeze(floor(diff2(i,:,:,:) / (testCount - 1)));
end


for i = 1:testSize
    imshow(squeeze(diff2(i,:,:,:)));
    pause(1);
end