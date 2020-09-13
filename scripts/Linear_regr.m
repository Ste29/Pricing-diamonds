close all
clear
clc

Dataset = loading();
X = [Dataset(:,1:6) Dataset(:,8:10)];
y = Dataset(:,7);

sz = 8;  % for scatter graph

% test set and training set
permutazione = randperm(size(Dataset,1))';
numTest = floor(size(Dataset,1)*.7);
Xtrain = X(permutazione(1:numTest),:);
Xvalid = X(permutazione(numTest+1:end),:);

ytrain = y(permutazione(1:numTest));
yvalid = y(permutazione(numTest+1:end));

%% Linear regression with raw data

Linea1 = Xtrain;
md1 = fitlm(Linea1, ytrain);
y_pred1 = predict(md1, Xvalid);
rms1 = sqrt(mse(y_pred1,yvalid));

figure, scatter(yvalid,y_pred1,sz),xlabel('true price'), ylabel('predicted price')
hold on
a = [0 20000]; b = [0 20000]; 
plot(a,b), title('Linear regression using raw data')

%%  LR with log10(price), log10(carat) and volume

% Diamonds are approximated with a pyramid, therefore starting from their
% physical features a new one is created: volume
X = [Dataset(:,1:6) Dataset(:,8).*Dataset(:,9).*Dataset(:,10)/3]; 

% In order to boost linear regression performances the relation needs to be
% as linear as possible, therefore log(carat) and log(price) are used

Xtrain = X(permutazione(1:numTest),:);
Xvalid = X(permutazione(numTest+1:end),:);

valid2 = [log10(Xvalid(:,1)) Xvalid(:,2:end)];
Linea2 = [log10(Xtrain(:,1)) Xtrain(:,2:end)];
md2 = fitlm(Linea2, log10(ytrain));
y_pred2 = predict(md2, valid2);
rms2 = sqrt(mse(10.^(y_pred2),yvalid));

figure, scatter(yvalid,10.^(y_pred2),sz),xlabel('true price'), ylabel('predicted price')
hold on
a = [0 20000]; b = [0 20000]; 
plot(a,b)
title('LR using log10(price), log10(carat) and volum')

%% LR with clustering

% In log(price) it is possible to notice 2 distincted gaussian
% distributions, therefore it was tried to cluster the diamonds based only
% on their features.
% To do this it was made a kmeans on features. Then 2 different 
% regressions were trained, one for the first Gaussian and one for the 
% second. To evaluate the test set each sample was assigned to its cluster 
% choosing according to which centroid was closest (L2 standard) and then 
% it was evaluated using the trained regression on that cluster


figure,subplot(121), histogram(log10(y)), title('Histogram log10(price)')

[idx1,C1] = kmeans(Xtrain,2);
subplot(122), histogram(log10(ytrain(idx1==1))), hold on, histogram(log10(ytrain(idx1==2)))
title('Histogram log10(price), cluster 1 and cluster 2')

LineaClust1 = [log10(Xtrain(idx1==1,1)) Xtrain(idx1==1,2:end)];
LineaClust2 = [log10(Xtrain(idx1==2,1)) Xtrain(idx1==2,2:end)];

for i = 1:size(Xvalid,1)
    distanza = (Xvalid(i,:)-C1).^2;
    distanza1 = sqrt(sum(distanza,2));
    [~,ind] = min(distanza1);
    
    if ind == 1
        idx2(i) = 1;
    else
        idx2(i) = 2;
    end
end
idx2 = idx2';
    

validClust1 = [log10(Xvalid(idx2==1,1)) Xvalid(idx2==1,2:end)];
validClust2 = [log10(Xvalid(idx2==2,1)) Xvalid(idx2==2,2:end)];

% Linear Regression
mdClust1 = fitlm(LineaClust1, log10(ytrain(idx1==1)));
mdClust2 = fitlm(LineaClust2, log10(ytrain(idx1==2)));

y_predClust1 = predict(mdClust1, validClust1);
y_predClust2 = predict(mdClust2, validClust2);
y_predtot(idx2==1) = y_predClust1;
y_predtot(idx2==2) = y_predClust2;
y_predtot = y_predtot';

rmsClust1 = sqrt(mse(10.^(y_predClust1),yvalid(idx2==1)));
rmsClust2 = sqrt(mse(10.^(y_predClust2),yvalid(idx2==2)));
rmstot = sqrt(mse(10.^(y_predtot),yvalid));

figure, subplot(131), scatter(yvalid(idx2==1),10.^(y_predClust1),sz)
xlabel('true price'), ylabel('predicted price'), hold on
a = [0 20000]; b = [0 20000]; 
plot(a,b)
title('First cluster')
subplot(132), scatter(yvalid(idx2==2),10.^(y_predClust2),sz)
xlabel('true price'), ylabel('predicted price'), hold on
a = [0 20000]; b = [0 20000]; 
plot(a,b)
title('Second cluster')

subplot(133), scatter(yvalid,10.^(y_predtot),sz)
xlabel('true price'), ylabel('predicted price'), hold on
a = [0 20000]; b = [0 20000]; 
plot(a,b)
title('Entire test set')
