close all
clear
clc

[Dataset,stats] = loading();

X = [Dataset(:,1:6) Dataset(:,8:10)];
y = Dataset(:,7);

sz = 8; 

% Subplot
% Feature distribution, bar diagram
titolo = {'carat', 'cut', 'color', 'clarity', 'depth', 'table', 'price',...
    'length', 'width', 'height'};
figure
for i = 1:size(Dataset,2)
    subplot(2,5,i), histogram(Dataset(:,i)), xlabel(titolo(i)), title(titolo{i})
    ylabel('# of diamonds')
end

% price vs features, scatter plot
figure
for i = 1:size(Dataset,2)
%     if i ~= 7
        subplot(2,5,i), scatter(Dataset(:,i),Dataset(:,7),1),xlabel(titolo(i))
        tit = sprintf('%s vs price', titolo{i});
        ylabel('Price'),title(tit)
%     end
end

% Scatter matrix
figure, plotmatrix(Dataset),title('scatter matrix')

% Boxplot
figure, subplot(131),boxplot(y,X(:,2)),title('cut vs price')
xlabel('cut'), ylabel('price')
subplot(132),boxplot(y,X(:,3)),title('color vs price')
xlabel('color'), ylabel('price')
subplot(133),boxplot(y,X(:,4)),title('clarity vs price')
xlabel('clarity'), ylabel('price')

% price and log10(price) hist
figure, subplot(122),histogram(log10(y)), title('Histogram log10(price)')
subplot(121),histogram(y),title('Hisogram price')

% How categorical features influence price
c = [0 0 1; 0 1 1; 0 1 0; 1 0.5 0; 1 1 0; 1 0 0; 1 0 1; 0 0 0]; 
figure
subplot(131)
for i = 1:5
    ind = X(:,2) == i;
    scatter(log10((X(ind,1))),log10(y(ind)),sz,c(i,:),'filled'), hold on
end
taglio = {'Fair', 'Good', 'Very Good', 'Premium', 'Ideal'}; 
xlabel('log10 carat'),ylabel('log10 price'),title('Cut')
legend(taglio,'Location','best')

subplot(132)
for i = 1:7
    ind = X(:,3) == i;
    scatter(log10(X(ind,1)),log10(y(ind)),sz,c(i,:),'filled'), hold on
end
colore = {'D', 'E', 'F', 'G', 'H', 'I', 'J'};
xlabel('log10 carat'),ylabel('log10 price'),title('Color')
legend(colore,'Location','best')

subplot(133)
for i = 1:8
    ind = X(:,4) == i;
    scatter(log10(X(ind,1)),log10(y(ind)),sz,c(i,:),'filled'), hold on
end
chiarezza = {'I1','SI2', 'SI1','VS2','VS1','VVS2','VVS1','IF'};
xlabel('log10 carat'),ylabel('log10 price'),title('clarity')
legend(chiarezza,'Location','best')
