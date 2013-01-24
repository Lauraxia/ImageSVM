function output = SVMExecute ( uniqueData )
    fprintf('Reading logical categorization data (category.dat)\n')
    %class_d = csvread('category.dat');
    class_d = uniqueData(1:100,3);

    fprintf ('Reading training target points (train.dat)\n')
    %trainxy_d = csvread('train.dat');
    trainxy_d = uniqueData(1:100,1:2);
    
    fprintf('Loading Image Data\n')
    image_d = imread('image.bmp');
    %conv_str = makecform('srgb2lab');
    %labimg_d = applycform(image_d,conv_str);
    
    rowcount = length(trainxy_d(:,1));
    
    labtrain_d = zeros(rowcount,3);
    
    fprintf('Converting Training Points to LAB format\n')
    labtrain_d = xyToLab(trainxy_d, image_d);
    
    % To create the training and test data, we need to concatenate the
    % two matricies together to form the 5-Dimensional Input.
    % train_d[h,2], labtrain_d[h,3]
    train_d = horzcat(trainxy_d, labtrain_d);
    
    fprintf('Creating Support Vector Structure\n')
    svmstr_d = svmtrain(train_d, class_d, 'kernel_function','mlp');
    
    fprintf('Reading testing data (test.dat)\n')
    %testxy_d = csvread('test.dat');
    testxy_d = uniqueData(101:200,1:2);
    
    rowcount = length(testxy_d(:,1));
    testlab_d = zeros(rowcount,3);
    
    fprintf('Converting Test Points to LAB format\n')
    testlab_d = xyToLab(testxy_d, image_d);
    test_d = horzcat(testxy_d,testlab_d);
    
    fprintf('Classifying Data using SVM\n')
    class_d = svmclassify(svmstr_d, test_d);
    % output = classperf(class_d, test_d);
    
    output = class_d;
end


