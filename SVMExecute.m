%function output = SVMExecute 
    a = [ 1 1 1 1 0 0];
    % 1 = XY
    % 2 = Gaussian Lab
    % 3 = Lab
    % 4 = Sobel
    % 5 = Gaussian Sobel
    % 6 = Gaussian Canny
    
    
%% load stuff
    fprintf('Reading logical categorization data (category.dat)\n')
    %class_d = csvread('category.dat');

    fprintf ('Reading training target points (train.dat)\n')
    
    load('Unique_Training_Data.mat');
    %training_all
    %random_order = randperm(length(uniqueTraining(:,1)));
    
    midpoint = 0.66*length(uniqueTraining(:,1));
    
    trainxy_d = uniqueTraining(1:midpoint,:);
    trainxy_testd = uniqueTraining(midpoint:end,:);
    
    %load, transpose image:
    fprintf('Loading Image Data\n')
    image_d = imread('Haykin_cover_sketch.bmp');
    image_d2(:,:,1) = image_d(:,:,1)';
    image_d2(:,:,2) = image_d(:,:,2)';
    image_d2(:,:,3) = image_d(:,:,3)';
    image_d = image_d2;
    
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
    
    % To create the training and test data, we need to concatenate the
    % two matricies together to form the N-Dimensional Input.
    train_d = zeros(length(trainxy_d(:,1:1)), 1);
    if a(1)
        train_d = horzcat(train_d, trainxy_d(:,1:2));
    end
    if a(2)
        fprintf('Converting Training Points to LAB (Gaussian) format\n')
        gaussianlab_d = xyToGaussianLab(trainxy_d(:, 1:2), image_d);
        train_d = horzcat(train_d, gaussianlab_d);
    end
    if a(3)
        fprintf('Converting Training Points to LAB format\n')
        labtrain_d = zeros(rowcount,3);
        labtrain_d = xyToLab(trainxy_d(:, 1:2), image_d); 
        train_d = horzcat(train_d, labtrain_d);
    end
    if a(4)
        sobel_d = xyToSobel(trainxy_d(:, 1:2), image_d);
        train_d = horzcat(train_d, sobel_d);
    end
    if a(5)
        gaussiansobel_d = xyToGaussianSobel(trainxy_d(:, 1:2), image_d);
        train_d = horzcat(train_d, gaussiansobel_d);
    end
    if a(6)
        canny_d = xyToCanny(trainxy_d(:, 1:2), image_d);
        train_d = horzcat(train_d, canny_d);
    end
    train_d(:,1) = []; %yes, this is really awful...
    
    %% training
    
    fprintf('Creating Support Vector Structure\n')
    svmstr_d = svmtrain(train_d, trainxy_d(:,3), 'method', 'LS', 'kernel_function','rbf');
    
    fprintf('Reading testing data (test.dat)\n')
    %testxy_d = csvread('test.dat');
    
    rowcount = length(testxy_d(:,1));
    testlab_d = zeros(rowcount,3);
    

    test_d = zeros(rowcount, 1);
    if a(1)
        test_d = horzcat(test_d, testxy_d(:,1:2));
    end
    if a(2)
        fprintf('Converting Test Points to LAB (Gaussian) format\n')
        testgaussianlab_d = xyToGaussianLab(testxy_d, image_d);
        test_d = horzcat(test_d, testgaussianlab_d);
    end
    if a(3)
        fprintf('Converting Test Points to LAB format\n')
        testlab_d = zeros(rowcount,3);
        testlab_d = xyToLab(testxy_d, image_d); 
        test_d = horzcat(test_d, testlab_d);
    end
    if a(4)
        testsobel_d = xyToSobel(testxy_d, image_d);
        test_d = horzcat(test_d, testsobel_d);
    end
    if a(5)
        testgaussiansobel_d = xyToGaussianSobel(testxy_d, image_d);
        test_d = horzcat(test_d, testgaussiansobel_d);
    end
    if a(6)
        testcanny_d = xyToCanny(testxy_d, image_d);
        test_d = horzcat(test_d, testcanny_d);
    end
    test_d(:,1) = []; %awful
    
    fprintf('Classifying Data using SVM\n')
    
    blocksize = 2000;
    numblocks = (length(test_d(:,1)) / blocksize);

    for block = 1:numblocks
        fprintf('Classifying Block %d of %d\n', block, round(numblocks))
        class_d(blocksize*(block-1)+1:blocksize*block,:) = svmclassify(svmstr_d, test_d(blocksize*(block - 1)+1:blocksize*(block), :));
        
    end
    class_d(blocksize*block+1:rowcount,:) = svmclassify(svmstr_d, test_d(blocksize*block+1:rowcount, :));
    
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
    
    cmp2 = 0;
    for i=1:length(trainxy_testd(:,1,1))
       cmp2 = cmp2 + cmp(trainxy_testd(i,2),trainxy_testd(i,1));
    end
    
    acc2 = cmp2/length(trainxy_testd(:,1,1));
    disp([num2str(acc2*100) '% accuracy for test points only'])
    
%end
