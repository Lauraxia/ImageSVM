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
    averages(i,:,:,:) = squeeze(images(i,1,:,:,:)) / (testCount - 1);
    for j = 2:testCount-1
        averages(i,:,:,:) = squeeze(averages(i,:,:,:)) + squeeze(images(i,j,:,:,:)) / (testCount -1);
    end
end

% Each column is a difference between two progressions
% Since the first parameter is the test size, we can average each level
% over the second parameter positions.


for i = 1:testSize-1
    diff(i,:,:,:) = squeeze(averages(i,:,:,:)) - squeeze(averages(i+1,:,:,:));
end


for i = 1:testSize-1
    imshow(squeeze(diff(i,:,:,:)));
    pause(1);
end