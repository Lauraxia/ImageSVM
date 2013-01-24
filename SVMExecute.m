function [output] = SVMExecute ( scanType )
% Trains and tests SVM for classifying points on 'image.bmp'
% 1 == Test scan, 0 == Full Image Scan
    fprintf('Reading logical categorization data:               ')
    load('Unique_Training_Data.mat');
    perm_data   = randperm(length(uniqueTraining));
    train_length  = length(uniqueTraining) - round(length(uniqueTraining) / 3);
    test_length = length(uniqueTraining);
    fprintf('[Y]\n')
    
    % For training the system, we will use only 2/3rds of the points
    % available from the data set. The other 1/3rd of the data will be used
    % during testing for classifying and comparing.

    % The following is to see the effect of overtraining the system
    %trainxy_d = uniqueTraining(:,1:2);
    %class_d = uniqueTraining(:,3);

    
    class_d = uniqueTraining(perm_data(1:train_length),3);
    
    fprintf ('Reading training target points:                    ')
    
    trainxy_d = uniqueTraining(perm_data(1:train_length),1:2);
    fprintf ('[Y]\n')
    
    fprintf('Loading Image Data:                                ')
    image_d = imread('image.bmp');
    fprintf ('[Y]\n')
    
    rowcount = length(trainxy_d(:,1));
    labtrain_d = zeros(rowcount,3);
    
    % To create the training and test data, we need to concatenate the
    % two matricies together to form the 5-Dimensional Input.
    % train_d[h,2], labtrain_d[h,3]
    fprintf('Converting Training Points to LAB format:          ')
    labtrain_d = xyToLab([trainxy_d(:,2),trainxy_d(:,1)], image_d);
    
    train_d = horzcat(trainxy_d, labtrain_d);
    fprintf('[Y]\n')
    
    fprintf('Creating Support Vector Structure:                 ')
    svmstr_d = svmtrain(train_d, class_d, 'method', 'LS', 'kernel_function','mlp');
    fprintf('[Y]\n')
    
    fprintf('Reading testing data:                              ')
    train_length = train_length + 1;
    %testxy_d = uniqueTraining(train_length:test_length,1:2);
    testxy_d = uniqueTraining(:,1:2);
    
    rowcount = length(testxy_d(:,1));
    testlab_d = zeros(rowcount,3);
    fprintf('[Y]\n')
    
    fprintf('Converting Test Points to LAB format:              ')
    testlab_d = xyToLab([testxy_d(:,2),testxy_d(:,1)], image_d);
    test_d = horzcat(testxy_d,testlab_d);
    fprintf('[Y]\n')
    
    if scanType == 1
        fprintf('Classifying Data using SVM:                        ')
        class_d = svmclassify(svmstr_d, test_d);
        fprintf('[Y]\n')
    
        image_sizes = size(image_d);
        class_img = zeros(image_sizes(1),image_sizes(2),image_sizes(3));
        fprintf('Classifying Points from SVM:                       ')
        for j = 1:round(length(class_d))
            targetxy = testxy_d(:,1);
            if class_d(j) == -1
                class_img(testxy_d(j,2),testxy_d(j,1),:) = [1,0,0];
            else
                class_img(testxy_d(j,2),testxy_d(j,1),:) = [0,0,1];
            end
        end
    fprintf('%d Points Done\n',length(class_d))
    else
        % Complete Image Search format.
        fprintf('Classifying Image using SVM:                     ')
        image_sizes = size(image_d);
        class_img = zeros(image_sizes(1),image_sizes(2),image_sizes(3));
        point_d = zeros(1,5);
        for i = 1:image_sizes(1)
            for j = 1:image_sizes(2)
                point_d(1:2) = [i,j];
                point_d(3:5) = xyToLab([i,j],image_d);
                if svmclassify(svmstr_d,point_d) == -1
                    class_img(testxy_d(j,2),testxy_d(j,1),:) = [1,0,1];
                else
                    class_img(testxy_d(j,2),testxy_d(j,1),:) = [0,0,1];                    
                end
            end
            fprintf('%f%% done\n',i * 100 / image_sizes(1) )
        end
    fprintf('%d Points Done\n',image_sizes(1) * image_sizes(2))
    end
    
    
    
    output = class_img;
    image(class_img);
end


