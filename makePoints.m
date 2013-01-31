uniqueTraining = generateMaskPoints(1, 5000);
save('Unique_Training_Data', 'uniqueTraining')
run('SVMExecute.m')