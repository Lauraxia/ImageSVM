uniqueTraining = generateMaskPoints(1, 3000);
save('Unique_Training_Data', 'uniqueTraining')
run('SVMExecute.m')