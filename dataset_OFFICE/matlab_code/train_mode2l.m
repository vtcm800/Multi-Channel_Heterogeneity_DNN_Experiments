% ѵ����׼��
train_data_36 = readtable('train_data_36.csv');
train_data_36 = table2array(train_data_36);
xtr_36 = train_data_36(:,1:36);
ytr_36 = train_data_36(:,37);
train_data_nc = readtable('train_data_nc_6.csv');
train_data_nc = table2array(train_data_nc);
xtr_nc = train_data_nc(:,1:6);
ytr_nc = train_data_nc(:,7);
% ���Լ�׼��
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
% % ÿ����ǩ��������25��
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
% % ���ݰ���ǩ����
% % train_data = sortrows(train_data,21);
% % writetable(array2table(train_data),'train_data_all.csv','WriteVariableNames',false);
% % writetable(array2table(train_data(:,[1:10,21])),'train_data_mean.csv','WriteVariableNames',false);
% 
% % ����������
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
% % �б����
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
% ���ر�Ҷ˹
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
% knn�����
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
% ����ѧϰ
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

% ������
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
% % title('����ָ�ƿ⹹������ҫ�ֻ�0410��һ��ʵ��������ݣ�10���������ŵ���λ�����ƽ�����λ����Ϊһ�ζ�λ������ʵ��λ�õĶ�λ���CDFͼ');
% title('��λ���CDFͼ');
% xlabel('��λ��m��');
% ylabel('CDF');
% % legend('������','�б����','���ر�Ҷ˹','kNN','֧��������','����ѧϰ�����ɭ�֣�');
% legend('kNN-36','kNN-6','֧��������-36','֧��������-6');
% axis([0 10 0 1]);
% 
% % ������
% % net = patternnet(30);
% % net.divideParam.trainRatio=0.7;
% % net.divideParam.valRatio = 0.15;
% % net.divideParam.testRatio = 0.15;
% % newff
% % [net,tr] = train(net,xtr',ytr');
% % performance = perform(net,xte',yte')