clear;
clc;

load results.mat;
data=readtable('train_data_36.csv','Delimiter',',');
y_all=unique(data(:,37));
y_all=table2array(y_all);
y_pre(:,1)=y_all(pre_dex(:,1)+1,:);
y_pre(:,2)=y_all(pre_dex(:,2)+1,:);
y_pre(:,3)=y_all(pre_dex(:,3)+1,:);
realLoc=[21.5,17.3;
    23.4,14.3;
    30.0,17.8;
    37.0,18.8;
    34.0,7.8;
    18.5,13.3;
    16.5,18.3];
load('coordinates.mat');
wn=[];
for i=1:length(w)
    wn(i,:)=w(i,:)./sum(w(i,:));
end

yLoc(:,1)=posGrid(y_pre(:,1),1).*w(:,1)+posGrid(y_pre(:,2),1).*w(:,2)+posGrid(y_pre(:,3),1).*w(:,3);
yLoc(:,2)=posGrid(y_pre(:,1),2).*w(:,1)+posGrid(y_pre(:,2),2).*w(:,2)+posGrid(y_pre(:,3),2).*w(:,3);
test_data_nc=readtable('test_data_36.csv','Delimiter',',');
test_data_nc=table2array(test_data_nc);
for td=unique(test_data_nc(:,38))'
    tdidx=find(test_data_nc(:,38)==td);
    testLoc(tdidx,1)=realLoc(td,1);
    testLoc(tdidx,2)=realLoc(td,2);
end
% testLoc=testLoc(1:109,:);
yLoc(:,3)=sqrt((yLoc(:,1)-testLoc(:,1)).^2+(yLoc(:,2)-testLoc(:,2)).^2);
cdfplot(yLoc(:,3));
axis([0 5 0 1]);
title('定位误差CDF图');
xlabel('定位误差（m）');
ylabel('CDF');
mean(yLoc(:,3))