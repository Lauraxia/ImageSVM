testSize = 10;
testCount = 5;

x = zeros(testSize*testCount,1);
y = zeros(testSize*testCount,1);



for i = 1:testSize
    for j = 1:testCount
        dataLocation = sprintf('testing/size%d/test%d/data.mat',i,j);
        fileLocation = sprintf('testing/size%d/test%d/accuracy.mat',i,j);
        load(dataLocation,'uniqueTraining');
        load(fileLocation,'acc2');
        
        x(j+i*testCount) = length(uniqueTraining(:,1));
        y(j+i*testCount) = acc2;
    end
end


x(1:5) = [];
y(1:5) = [];

scatter(x,y);

xlabel('Test Size (#)');
ylabel('Accuracy  (%)');
title('Relation between Test Size and Accuracy');
grid on;