close all
clear 
clc

Dataset = loading();
X = [Dataset(:,1:6) Dataset(:,8:10)]';
y = Dataset(:,7)';

net = fitnet([10,5]);

% Set up Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
 
% Train the Network
[net,tr] = train(net,X,y);

outputs = net(X);
errors = gsubtract(outputs,y);
performance = perform(net,y,outputs);
 
% View the Network
% view(net)

conf=[y' outputs'];
rmse=sqrt(mse(conf(:,1),conf(:,2)));

figure, scatter(conf(:,1),conf(:,2));
hold on
a = [0 20000]; b = [0 20000]; 
plot(a,b)
title('NN Regression'), xlabel('true price'), ylabel('predicted price')
