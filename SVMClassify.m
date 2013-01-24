function [ svmstr_d ] = SVMClassify ()
%SVMCLASSIFY Sets up a Support Vector Machine to classify the target image.
%   .
    
    load('Unique_Training_Data.mat');
    perm_data    = randperm(length(uniqueTraining));
    train_length = length(uniqueTraining) - round(length(uniqueTraining) / 3);
    test_length  = length(uniqueTraining);
    
    
    
    
    
end

