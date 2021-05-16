% 训练集准备
train_data_36 = readtable('../datasets/train_data_36.csv');
train_data_36 = table2array(train_data_36);
xtr_36 = train_data_36(:,1:36);
ytr_36 = train_data_36(:,37);
train_data_7 = readtable('../datasets/train_data_7.csv');
train_data_7 = table2array(train_data_7);
xtr_7 = train_data_7(:,1:7);
ytr_7 = train_data_7(:,8);
train_data_nc = readtable('../datasets/train_data_nc_6.csv');
train_data_nc = table2array(train_data_nc);
xtr_nc = train_data_nc(:,1:6);
ytr_nc = train_data_nc(:,7);
% 测试集准备
test_data_36 = readtable('../datasets/test_data_36.csv');
test_data_36 = table2array(test_data_36);
xte_36 = test_data_36(:,1:36);
test_data_7 = readtable('../datasets/test_data_7.csv');
test_data_7 = table2array(test_data_7);
xte_7 = test_data_7(:,1:7);
test_data_nc = readtable('../datasets/test_data_nc_6.csv');
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

% mean7=[];
% mean36=[];
meannc=[];
% knn最近邻
% for tt={'gaussian','linear','polynomial'}
for tt={'linear'}
    t=templateSVM('KernelFunction',char(tt));
    md_36 = fitcecoc(xtr_36,ytr_36,'Learners',t);
    1
    md_nc = fitcecoc(xtr_nc,ytr_nc,'Learners',t);
    2
    md_7 = fitcecoc(xtr_7,ytr_7,'Learners',t);
%     char(tt)
    y_36 = predict(md_36,xte_36);
    y_nc = predict(md_nc,xte_nc);
    y_7 = predict(md_7,xte_7);
    yLoc_36=posGrid(y_36,:);
    yLoc_nc=posGrid(y_nc,:);
    yLoc_7=posGrid(y_7,:);
    testLoc=[];
    for td=unique(test_data_nc(:,8))'
        tdidx=find(test_data_nc(:,8)==td);
        testLoc(tdidx,1)=realLoc(td,1);
        testLoc(tdidx,2)=realLoc(td,2);
    end
    error36=sqrt((yLoc_36(:,1)-testLoc(:,1)).^2+(yLoc_36(:,2)-testLoc(:,2)).^2);
    errornc=sqrt((yLoc_nc(:,1)-testLoc(:,1)).^2+(yLoc_nc(:,2)-testLoc(:,2)).^2);
    yLoc_7_new=[];
    for i = 1:6:660
        yLoc_7_new(end+1,:)=mean(yLoc_7(i:i+5,:));
    end
    error7=sqrt((yLoc_7_new(:,1)-testLoc(:,1)).^2+(yLoc_7_new(:,2)-testLoc(:,2)).^2);
%     
    hold on;
    cdfplot(errornc);
    cdfplot(error7);
    cdfplot(error36);
    % title('参与指纹库构建的荣耀手机0410第一组实验测试数据，10秒中所有信道定位结果求平均后的位置作为一次定位，其与实际位置的定位误差CDF图');
    title('');
    xlabel('定位误差（m）');
    ylabel('CDF');
    % legend('决策树','判别分析','朴素贝叶斯','kNN','支持向量机','集成学习（随机森林）');
    legend('S1','S2','S3');
    axis([0 10 0 1]);
    mean7(end+1)=mean(error7);
    mean36(end+1)=mean(error36);
    meannc(end+1)=mean(errornc);
end
% legend('g','l','p');
error_7_svm=error7;
error_36_svm=error36;
error_nc_svm=errornc;
save('svm_result.mat','error_7_svm','error_36_svm','error_nc_svm');