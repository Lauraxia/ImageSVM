%function output = SVMExecute

%% load stuff
    fprintf('Reading logical categorization data (category.dat)\n')
    %class_d = csvread('category.dat');

    fprintf ('Reading training target points (train.dat)\n')
    
    load('Unique_Training_Data.mat');
    %training_all
    random_order = randperm(length(uniqueTraining(:,1)));
    
    midpoint = 0.66*length(uniqueTraining(:,1));
    
    trainxy_d = zeros(midpoint, 3);
    testxy_d = zeros(length(uniqueTraining(:,1)) - midpoint, 3);
    
    trainxy_d(:,1) = uniqueTraining(random_order(1:midpoint), 1);
    trainxy_d(:,2) = uniqueTraining(random_order(1:midpoint), 2);
    trainxy_d(:,3) = uniqueTraining(random_order(1:midpoint), 3);
    testxy_d(:,1) = uniqueTraining(random_order(midpoint+1:end), 1);
    testxy_d(:,2) = uniqueTraining(random_order(midpoint+1:end), 2);
    testxy_d(:,3) = uniqueTraining(random_order(midpoint+1:end), 3);
    

        
    
    %load, transpose image:
    fprintf('Loading Image Data\n')
    image_d = imread('Haykin_cover_sketch.bmp');
    image_d2(:,:,1) = image_d(:,:,1)';
    image_d2(:,:,2) = image_d(:,:,2)';
    image_d2(:,:,3) = image_d(:,:,3)';
    image_d = image_d2;
    %conv_str = makecform('srgb2lab');
    %labimg_d = applycform(image_d,conv_str);
    
    rowcount = length(trainxy_d(:,1));
    
    count = 1;
        testxy_d = zeros(length(image_d(:,1,1))*length(image_d(1,:,1)), 2);
    for i=1:length(image_d(:,1,1))
        for j=1:length(image_d(1,:,1))
            testxy_d(count, 1) = i;
            testxy_d(count, 2) = j;
            count = count +1;
        end
    end
    
    labtrain_d = zeros(rowcount,3);
    
    fprintf('Converting Training Points to LAB format\n')
    labtrain_d = xyToLab(trainxy_d(:, 1:2), image_d);
    sobel_d = xyToSobel(trainxy_d(:, 1:2), image_d);
    gaussiansobel_d = xyToGaussianSobel(trainxy_d(:, 1:2), image_d);
    gaussianlab_d = xyToGaussianLab(trainxy_d(:, 1:2), image_d);
    % To create the training and test data, we need to concatenate the
    % two matricies together to form the 5-Dimensional Input.
    % train_d[h,2], labtrain_d[h,3]
    train_d = horzcat(horzcat(trainxy_d(:,1:2),gaussianlab_d), horzcat(horzcat(labtrain_d, sobel_d), gaussiansobel_d));
    %train_d = labtrain_d;%
    %train_d = trainxy_d(:,1:2);
    %% training
    
    fprintf('Creating Support Vector Structure\n')
    svmstr_d = svmtrain(train_d, trainxy_d(:,3), 'method', 'LS', 'kernel_function','rbf');
    
    fprintf('Reading testing data (test.dat)\n')
    %testxy_d = csvread('test.dat');
    
    rowcount = length(testxy_d(:,1));
    testlab_d = zeros(rowcount,3);
    
    fprintf('Converting Test Points to LAB format\n')
    testlab_d = xyToLab(testxy_d, image_d);
    testsobel_d = xyToSobel(testxy_d, image_d);
    testgaussianlab_d = xyToGaussianLab(testxy_d, image_d);
    testgaussiansobel_d = xyToGaussianSobel(testxy_d, image_d);
    test_d = horzcat(horzcat(testxy_d(:,1:2), testgaussianlab_d), horzcat(horzcat(testlab_d, testsobel_d), testgaussiansobel_d));
    %test_d = testlab_d;%testxy_d(:,1:2);
    %test_d = testxy_d(:,1:2);
    fprintf('Classifying Data using SVM\n')
    
    
    blocksize = 2000;
    numblocks = (length(test_d(:,1)) / blocksize);

    for block = 1:numblocks
        fprintf('Classifying Block %d of %d\n', block, numblocks)
        class_d(blocksize*(block-1)+1:blocksize*block,:) = svmclassify(svmstr_d, test_d(blocksize*(block - 1)+1:blocksize*(block), :));
        
    end
    class_d(blocksize*block+1:rowcount,:) = svmclassify(svmstr_d, test_d(blocksize*block+1:rowcount, :));

    %{
    mid = length(test_d(:,1))/4;
    testend = length(test_d(:,1))/2;
    class_d1 = svmclassify(svmstr_d, test_d(1:mid, :));
    
    class_d2 = svmclassify(svmstr_d, test_d(mid+1:testend, :));
    % output = classperf(class_d, test_d);
    
    %output = vertcat(class_d1, class_d2);
    %}
    
    %% Classify, Plot
    
    img_plot = zeros(length(image_d(1,:,1)), length(image_d(:,1,1)), 3);
    
    class_d2 = zeros(length(class_d), 3);
    class_d2(class_d == -1, 1) = 1;
    class_d2(class_d == 1, 2) = 1;
    
    channel1 = class_d2(:,1);
    channel1b = reshape(channel1, length(image_d(1,:,1)), length(image_d(:,1,1)));
    channel2 = class_d2(:,2);
    channel2b = reshape(channel2, length(image_d(1,:,1)), length(image_d(:,1,1)));
    channel3 = class_d2(:,3);
    channel3b = reshape(channel3, length(image_d(1,:,1)), length(image_d(:,1,1)));
    
    img_plot(:,:,1) = channel1b;
    img_plot(:,:,2) = channel2b;
    img_plot(:,:,3) = channel3b;
    
    
    imshow(img_plot);
    
    % Accuracy
    imageCmp = imread('Haykin_cover_sketch-mask.bmp');
    
    cmp = (img_plot(:,:,1) > 0 & imageCmp(:,:,1) > 0) | ((img_plot(:,:,2) >0) & (imageCmp(:,:,1) == 0));
    [M,N] = size(cmp);
    
    acc = (sum(sum(cmp)))/(M*N);
    disp([num2str(acc*100) '% accuracy'])
%end
