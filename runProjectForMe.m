% Executes the test bed as required.

testSize  = [100;250;500;1000;2000;3000;4000;5000;8000;12000];
testCount = 5;


x = rmdir('testing','s');
for testNumber = 1:length(testSize)
    for i = 1:testCount
        fprintf('Running test #%d for packet size %d\n', i, testSize(testNumber));
        currentTestLocation = sprintf('testing/size%d/test%d',testNumber,i);
        saveImageLocation   = sprintf('%s/image.png',currentTestLocation);
        saveDataLocation    = sprintf('%s/data.mat',currentTestLocation);
        
        mkdir(currentTestLocation);
        
        uniqueTraining = generateMaskPoints(0,testSize(testNumber));
        save('Unique_Training_Data', 'uniqueTraining');
        fprintf('Executing SVM Trainer and Classifier\n');
        SVMExecute;
        
        imwrite(img_plot,saveImageLocation,'PNG');
        save(saveDataLocation, 'img_plot', 'svmstr_d', 'uniqueTraining');
        close all;
        
        saveAccuracyLocation = sprintf('%s/%f',currentTestLocation,acc*100);
        save(saveAccuracyLocation, 'acc');
    end
    
end
