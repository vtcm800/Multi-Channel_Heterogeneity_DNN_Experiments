% 训练集准备
train_data_36 = readtable('train_data_36.csv');
train_data_36 = table2array(train_data_36);
xtr_36 = train_data_36(:,1:36);
ytr_36 = train_data_36(:,37);
train_data_nc = readtable('train_data_nc_6.csv');
train_data_nc = table2array(train_data_nc);
xtr_nc = train_data_nc(:,1:6);
ytr_nc = train_data_nc(:,7);
% 测试集准备
test_data_36 = readtable('test_data_36.csv');
test_data_36 = table2array(test_data_36);
xte_36 = test_data_36(:,1:36);
test_data_nc = readtable('test_data_nc_6.csv');
test_data_nc = table2array(test_data_nc);
xte_nc = test_data_nc(:,1:6);
% % yte = test_data(:,11);
realLoc=[21.5,17.3;
    23.4,14.3;
    30.0,17.8;
    37.0,18.8;
    34.0,7.8;
    18.5,13.3;
    16.5,18.3];
load('coordinates.mat');
% % 每个标签等量数据25条
% % ylist=[];
% % new_data=[];
% % for yidx = unique(train_data(:,21))'
% %     ylist(end+1)=length(find(train_data(:,21)==yidx));
% % end
% % ymin=min(ylist);
% % for yidx = unique(train_data(:,21))'
% %     data_temp=train_data(find(train_data(:,21)==yidx),:);
% %     new_data=[new_data;data_temp(1:ymin,:)];
% % end
% % writetable(array2table(new_data),'train_data_all_order_equivalent.csv','WriteVariableNames',false);
% % writetable(array2table(new_data(:,[1:10,21])),'train_data_mean_order_equivalent.csv','WriteVariableNames',false);
% 
% % 数据按标签排序
% % train_data = sortrows(train_data,21);
% % writetable(array2table(train_data),'train_data_all.csv','WriteVariableNames',false);
% % writetable(array2table(train_data(:,[1:10,21])),'train_data_mean.csv','WriteVariableNames',false);
% 
% % 决策树分类
% md = fitctree(xtr,ytr);
% y = predict(md,xte);
% yLoc=posGrid(y,:);
% location=[];
% for t=unique(test_data(:,8))'
%     tidx=find(test_data(:,8)==t);
%     location(end+1,:)=[mean(yLoc(tidx,1)),mean(yLoc(tidx,2))];
% end
% location(:,3)=sqrt((location(:,1)-realLoc(1)).^2+(location(:,2)-realLoc(2)).^2);
% % plot(location(:,1),location(:,2),'.r','markersize',20);
% % hold on;
% % plot(realLoc(1),realLoc(2),'.b','markersize',20);
% % figure;
% cdfplot(location(:,3));
% % length(find(y==ytr))/length(ytr)
% hold on;
% 1
% 
% % 判别分析
% md = fitcdiscr(xtr,ytr);
% y = predict(md,xte);
% yLoc=posGrid(y,:);
% location=[];
% for t=unique(test_data(:,8))'
%     tidx=find(test_data(:,8)==t);
%     location(end+1,:)=[mean(yLoc(tidx,1)),mean(yLoc(tidx,2))];
% end
% location(:,3)=sqrt((location(:,1)-realLoc(1)).^2+(location(:,2)-realLoc(2)).^2);
% cdfplot(location(:,3));
% 2
% 朴素贝叶斯
% md_36 = fitcnb(xtr_36,ytr_36);
% md_nc = fitcnb(xtr_nc,ytr_nc);
% y_36 = predict(md_36,xte_36);
% y_nc = predict(md_nc,xte_nc);
% yLoc_36=posGrid(y_36,:);
% yLoc_nc=posGrid(y_nc,:);
% location=[];
% for t=unique(test_data(:,8))'
%     tidx=find(test_data(:,8)==t);
%     location(end+1,:)=[mean(yLoc(tidx,1)),mean(yLoc(tidx,2))];
% end
% location(:,3)=sqrt((location(:,1)-realLoc(1)).^2+(location(:,2)-realLoc(2)).^2);
% cdfplot(location(:,3));
% 3
% knn最近邻
% md_36 = fitcknn(xtr_36,ytr_36);
% md_nc = fitcknn(xtr_nc,ytr_nc);
% y_36 = predict(md_36,xte_36);
% y_nc = predict(md_nc,xte_nc);
% yLoc_36=posGrid(y_36,:);
% yLoc_nc=posGrid(y_nc,:);
% testLoc=[];
% for td=unique(test_data_nc(:,8))'
%     tdidx=find(test_data_nc(:,8)==td);
%     testLoc(tdidx,1)=realLoc(td,1);
%     testLoc(tdidx,2)=realLoc(td,2);
% end
% yLoc_36(:,3)=sqrt((yLoc_36(:,1)-testLoc(:,1)).^2+(yLoc_36(:,2)-testLoc(:,2)).^2);
% yLoc_nc(:,3)=sqrt((yLoc_nc(:,1)-testLoc(:,1)).^2+(yLoc_nc(:,2)-testLoc(:,2)).^2);
% hold on;
% cdfplot(yLoc_36(:,3));
% cdfplot(yLoc_nc(:,3));
% 12
% 4
% % % SVM
% md_36 = fitcecoc(xtr_36,ytr_36);
% 3
% md_nc = fitcecoc(xtr_nc,ytr_nc);
% 4
% % y = predict(md,xte);
% % yLoc=posGrid(y,:);
% % location=[];
% % for t=unique(test_data(:,8))'
% %     tidx=find(test_data(:,8)==t);
% %     location(end+1,:)=[mean(yLoc(tidx,1)),mean(yLoc(tidx,2))];
% % end
% % location(:,3)=sqrt((location(:,1)-realLoc(1)).^2+(location(:,2)-realLoc(2)).^2);
% % cdfplot(location(:,3));
% % 5
% 集成学习
% md_36 = fitensemble(xtr_36,ytr_36,'Bag',10,'Tree','Type','Classification');
% md_nc = fitensemble(xtr_nc,ytr_nc,'Bag',10,'Tree','Type','Classification');
% y_36 = predict(md_36,xte_36);
% y_nc = predict(md_nc,xte_nc);
% yLoc_36=posGrid(y_36,:);
% yLoc_nc=posGrid(y_nc,:);
% testLoc=[];
% for td=unique(test_data_nc(:,8))'
%     tdidx=find(test_data_nc(:,8)==td);
%     testLoc(tdidx,1)=realLoc(td,1);
%     testLoc(tdidx,2)=realLoc(td,2);
% end
% yLoc_36(:,3)=sqrt((yLoc_36(:,1)-testLoc(:,1)).^2+(yLoc_36(:,2)-testLoc(:,2)).^2);
% yLoc_nc(:,3)=sqrt((yLoc_nc(:,1)-testLoc(:,1)).^2+(yLoc_nc(:,2)-testLoc(:,2)).^2);
% cdfplot(yLoc_36(:,3));
% cdfplot(yLoc_nc(:,3));

% 神经网络
net_36 = patternnet([10]);
net_36.trainFcn = 'trainscg';
% net_36.performFcn='rmse';
ttr_36= posGrid(ytr_36,:);
ttr_36 = zeros(length(ytr_36),max(ytr_36));
for i = 1:length(ytr_36)
    ttr_36(i,ytr_36(i))=1;
end
net_36 = train( net_36, xtr_36' , ttr_36' ) ;
y_36 = vec2ind(net_36(xte_36'));
% yLoc_36 = net_36(xte_36');
% y_36 = predict(md_36,xte_36);
% y_nc = predict(md_nc,xte_nc);
% yLoc_36=posGrid(y_36,:);
% yLoc_nc=posGrid(y_nc,:);
% testLoc=[];
% for td=unique(test_data_nc(:,8))'
%     tdidx=find(test_data_nc(:,8)==td);
%     testLoc(tdidx,1)=realLoc(td,1);
%     testLoc(tdidx,2)=realLoc(td,2);
% end
% yLoc_36 = yLoc_36';
% yLoc_36(:,3)=sqrt((yLoc_36(:,1)-testLoc(:,1)).^2+(yLoc_36(:,2)-testLoc(:,2)).^2);
% yLoc_nc(:,3)=sqrt((yLoc_nc(:,1)-testLoc(:,1)).^2+(yLoc_nc(:,2)-testLoc(:,2)).^2);
% cdfplot(yLoc_36(:,3));
% axis([0 10 0 1]);
% cdfplot(yLoc_nc(:,3));


% 
% % title('参与指纹库构建的荣耀手机0410第一组实验测试数据，10秒中所有信道定位结果求平均后的位置作为一次定位，其与实际位置的定位误差CDF图');
% title('定位误差CDF图');
% xlabel('定位误差（m）');
% ylabel('CDF');
% % legend('决策树','判别分析','朴素贝叶斯','kNN','支持向量机','集成学习（随机森林）');
% legend('kNN-36','kNN-6','支持向量机-36','支持向量机-6');
% axis([0 10 0 1]);
% 
% % 神经网络
% % net = patternnet(30);
% % net.divideParam.trainRatio=0.7;
% % net.divideParam.valRatio = 0.15;
% % net.divideParam.testRatio = 0.15;
% % newff
% % [net,tr] = train(net,xtr',ytr');
% % performance = perform(net,xte',yte')