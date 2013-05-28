uniqueTraining = generateMaskPoints(1, 2000);
save('Unique_Training_Data', 'uniqueTraining')
run('SVMExecute.m')