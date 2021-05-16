% x=readtable('../results/result2.txt','Delimiter',' ');
% x=table2array(x);
load('../results/result.mat');
data=readtable('../datasets/train_data_36.csv','Delimiter',',');
y_all=unique(data(:,37));
y_all=table2array(y_all);
% y_pre=y_all(x+1,:);
y_pre=yloc';
realLoc=[21.5,17.3;
    23.4,14.3;
    30.0,17.8;
    37.0,18.8;
    34.0,7.8;
    18.5,13.3;
    16.5,18.3];
load('coordinates.mat');
yLoc=posGrid(y_pre,:);
test_data_nc=readtable('../datasets/test_data_36.csv','Delimiter',',');
test_data_nc=table2array(test_data_nc);
for td=unique(test_data_nc(:,38))'
    tdidx=find(test_data_nc(:,38)==td);
    testLoc(tdidx,1)=realLoc(td,1);
    testLoc(tdidx,2)=realLoc(td,2);
end
yLoc(:,3)=sqrt((yLoc(:,1)-testLoc(:,1)).^2+(yLoc(:,2)-testLoc(:,2)).^2);
% cdfplot(yLoc(:,3));
% axis([0 10 0 1]);
% title('定位误差CDF图');
% xlabel('定位误差（m）');
% ylabel('CDF');

mean(yLoc(:,3))
median(yLoc(:,3))