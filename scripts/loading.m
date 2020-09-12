function [final_dataset, table_stat] = loading()
tab = readtable('diamonds.csv');

%% Integer encoding
% Since it is possible to identify a clear order between categorical
% features integer encoding can describe the relations and it is not
% necessary the one-hot-encoding.

% I1: worst, IF: best
chiarezza = categorical({'I1','SI2', 'SI1', 'VS2', 'VS1', 'VVS2',...
    'VVS1','IF'});
l1 = length(chiarezza);
% Fair: worst, ideal: best
taglio = categorical({'Fair', 'Good', 'Very Good', 'Premium', 'Ideal'}); 
l2 = length(taglio);
% D: best, J: worst        unique sorts data automatically
colore = categorical(unique(tab.color)); l3 = length(colore);

%data = table2array(T(:,2:end));

%%

clarity = zeros(size(tab,1),1);
for i = 1:l2
    clarity(tab.clarity==chiarezza(i)) = i;
end

cut = zeros(size(tab,1),1);
for i = 1:l2
    cut(tab.cut==taglio(i)) = i;
end

color = zeros(size(tab,1),1);
for i = 1:l3
    color(tab.color==colore(i)) = i;
end

Dataset = [table2array(tab(:,2)), cut, color, clarity, ...
    table2array(tab(:,6:end))];

%% Statistics
media = mean(Dataset)';
massimo = max(Dataset)';
minimo = min(Dataset)';
st_dev = std(Dataset)';
Nan_num = sum(isnan(Dataset))';
LastName = {'mean';'max';'min';'standard deviation';'# of NaN'};
l1 = {'Carat','Cut','Color','Clarity','Depth','Table','Price','x','y','z'};
t1 = zeros(5,9);
for i = 1:10
    t1(:,i) = [media(i);massimo(i);minimo(i);st_dev(i);Nan_num(i)];
end

table_stat = table(t1(:,1), t1(:,2), t1(:,3), t1(:,4), t1(:,5),t1(:,6),...
    t1(:,7),t1(:,8),t1(:,9),t1(:,10),'RowNames',LastName);


% Some feature have x, y or z equal to 0, which is not possible since they
% are physical dimensions, therefore these elements will be discarded
% Also, a new feature is created: volume

volume = Dataset(:,8).*Dataset(:,9).*Dataset(:,10);
ind = find(volume == 0);

Dataset(ind,:) = [];
final_dataset = Dataset;
