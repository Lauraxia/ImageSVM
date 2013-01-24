function output = SVMExecute
    fprintf('Reading logical categorization data (category.dat)\n')
    class_d = csvread('category.dat');

    fprintf ('Reading training target points (train.dat)\n')
    trainxy_d = csvread('train.dat');
    
    fprintf('Loading Image Data\n')
    image_d = imread('alex.jpg');
    conv_str = makecform('srgb2lab');
    labimg_d = applycform(image_d,conv_str);
    
    rowcount = length(trainxy_d(:,1));
    
    
    
    labtrain_d = zeros(rowcount,3);
    
    labtrain_d = xyToLab(trainxy_d, image_d);
    
%     for i = 1:rowcount,
%         pos_x = trainxy_d(i,1) + 1;
%         pos_y = trainxy_d(i,2) + 1;
%         
%         for j = 1:3,
%             labtrain_d(i,j) = labimg_d(pos_y,pos_x,j);
%         end
%     end
    % To create the training and test data, we need to concatenate the
    % two matricies together to form the 5-Dimensional Input.
    % train_d[h,2], labtrain_d[h,3]
    
    train_d = horzcat(trainxy_d, labtrain_d);
    
    
    for j = 1:3,
        %imshow(labimg_d(:,:,j));
        %pause;
    end
    
    fprintf('Creating Support Vector Structure\n')
    svmstr_d = svmtrain(train_d, class_d, 'kernel_function','mlp');
    
    fprintf('Reading testing data (test.dat)\n')
    testxy_d = csvread('test.dat');
    
    rowcount = length(testxy_d(:,1));
    testlab_d = zeros(rowcount,3);
    
    for i = 1:rowcount,
        testlabxy_d = zeros(1,3);
        pos_x = testxy_d(i,1);
        pos_y = testxy_d(i,2);
        
        for j = 1:3
            testlabxy_d(1,j) = labimg_d(pos_y, pos_x,j);
        end
        testlab_d(i,:) = testlabxy_d;
    end
    
    test_d = horzcat(testxy_d,testlab_d);
    
    fprintf('Classifying Data using SVM\n')
    class_d = svmclassify(svmstr_d, test_d);
    % output = classperf(class_d, test_d);
    
    output = class_d;
end


