train_data = readtable('../datasets/train_data.csv');
train_data = table2array(train_data);
xtr = train_data(:,1:7);
ytr = train_data(:,8);
test_data = readtable('../datasets/test_data.csv');
test_data = table2array(test_data);
xte = test_data(:,1:7);
% yte = test_data(:,11);
realLoc=[21.5,17.3];
load('coordinates.mat');
% ÿ����ǩ��������25��
% ylist=[];
% new_data=[];
% for yidx = unique(train_data(:,21))'
%     ylist(end+1)=length(find(train_data(:,21)==yidx));
% end
% ymin=min(ylist);
% for yidx = unique(train_data(:,21))'
%     data_temp=train_data(find(train_data(:,21)==yidx),:);
%     new_data=[new_data;data_temp(1:ymin,:)];
% end
% writetable(array2table(new_data),'train_data_all_order_equivalent.csv','WriteVariableNames',false);
% writetable(array2table(new_data(:,[1:10,21])),'train_data_mean_order_equivalent.csv','WriteVariableNames',false);

% ���ݰ���ǩ����
% train_data = sortrows(train_data,21);
% writetable(array2table(train_data),'train_data_all.csv','WriteVariableNames',false);
% writetable(array2table(train_data(:,[1:10,21])),'train_data_mean.csv','WriteVariableNames',false);

% ����������
md = fitctree(xtr,ytr);
y = predict(md,xte);
yLoc=posGrid(y,:);
location=[];
for t=unique(test_data(:,8))'
    tidx=find(test_data(:,8)==t);
    location(end+1,:)=[mean(yLoc(tidx,1)),mean(yLoc(tidx,2))];
end
location(:,3)=sqrt((location(:,1)-realLoc(1)).^2+(location(:,2)-realLoc(2)).^2);
% plot(location(:,1),location(:,2),'.r','markersize',20);
% hold on;
% plot(realLoc(1),realLoc(2),'.b','markersize',20);
% figure;
cdfplot(location(:,3));
% length(find(y==ytr))/length(ytr)
hold on;
1

% �б����
md = fitcdiscr(xtr,ytr);
y = predict(md,xte);
yLoc=posGrid(y,:);
location=[];
for t=unique(test_data(:,8))'
    tidx=find(test_data(:,8)==t);
    location(end+1,:)=[mean(yLoc(tidx,1)),mean(yLoc(tidx,2))];
end
location(:,3)=sqrt((location(:,1)-realLoc(1)).^2+(location(:,2)-realLoc(2)).^2);
cdfplot(location(:,3));
2
% ���ر�Ҷ˹
md = fitcnb(xtr,ytr);
y = predict(md,xte);
yLoc=posGrid(y,:);
location=[];
for t=unique(test_data(:,8))'
    tidx=find(test_data(:,8)==t);
    location(end+1,:)=[mean(yLoc(tidx,1)),mean(yLoc(tidx,2))];
end
location(:,3)=sqrt((location(:,1)-realLoc(1)).^2+(location(:,2)-realLoc(2)).^2);
cdfplot(location(:,3));
3
% knn�����
md = fitcknn(xtr,ytr);
y = predict(md,xte);
yLoc=posGrid(y,:);
location=[];
for t=unique(test_data(:,8))'
    tidx=find(test_data(:,8)==t);
    location(end+1,:)=[mean(yLoc(tidx,1)),mean(yLoc(tidx,2))];
end
location(:,3)=sqrt((location(:,1)-realLoc(1)).^2+(location(:,2)-realLoc(2)).^2);
cdfplot(location(:,3));
4
% % SVM
% md = fitcecoc(xtr,ytr);
% y = predict(md,xte);
% yLoc=posGrid(y,:);
% location=[];
% for t=unique(test_data(:,8))'
%     tidx=find(test_data(:,8)==t);
%     location(end+1,:)=[mean(yLoc(tidx,1)),mean(yLoc(tidx,2))];
% end
% location(:,3)=sqrt((location(:,1)-realLoc(1)).^2+(location(:,2)-realLoc(2)).^2);
% cdfplot(location(:,3));
% 5
% ����ѧϰ
md = fitensemble(xtr,ytr,'Bag',10,'Tree','Type','Classification');
y = predict(md,xte);
yLoc=posGrid(y,:);
location=[];
for t=unique(test_data(:,8))'
    tidx=find(test_data(:,8)==t);
    location(end+1,:)=[mean(yLoc(tidx,1)),mean(yLoc(tidx,2))];
end
location(:,3)=sqrt((location(:,1)-realLoc(1)).^2+(location(:,2)-realLoc(2)).^2);
cdfplot(location(:,3));

% title('����ָ�ƿ⹹������ҫ�ֻ�0410��һ��ʵ��������ݣ�10���������ŵ���λ�����ƽ�����λ����Ϊһ�ζ�λ������ʵ��λ�õĶ�λ���CDFͼ');
title('��λ���CDFͼ');
xlabel('��λ��m��');
ylabel('CDF');
% legend('������','�б����','���ر�Ҷ˹','kNN','֧��������','����ѧϰ�����ɭ�֣�');
legend('������','�б����','���ر�Ҷ˹','kNN','����ѧϰ�����ɭ�֣�');

% ������
% net = patternnet(30);
% net.divideParam.trainRatio=0.7;
% net.divideParam.valRatio = 0.15;
% net.divideParam.testRatio = 0.15;
% 
% [net,tr] = train(net,xtr',ytr');
% performance = perform(net,xte',yte')