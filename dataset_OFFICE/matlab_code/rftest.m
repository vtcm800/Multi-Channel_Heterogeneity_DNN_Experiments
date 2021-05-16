% ѵ����׼��
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
% ���Լ�׼��
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

mean7=[];
mean36=[];
meannc=[];
% knn�����
% for n=5:5:100
for n =40
    md_36 = fitensemble(xtr_36,ytr_36,'Bag',10,'Tree','Type','Classification');
    md_nc = fitensemble(xtr_nc,ytr_nc,'Bag',10,'Tree','Type','Classification');
    md_7 = fitensemble(xtr_7,ytr_7,'Bag',10,'Tree','Type','Classification');
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
    
    hold on;
    cdfplot(errornc);
    cdfplot(error7);
    cdfplot(error36);
    % title('����ָ�ƿ⹹������ҫ�ֻ�0410��һ��ʵ��������ݣ�10���������ŵ���λ�����ƽ�����λ����Ϊһ�ζ�λ������ʵ��λ�õĶ�λ���CDFͼ');
    title('');
    xlabel('��λ��m��');
    ylabel('CDF');
    % legend('������','�б����','���ر�Ҷ˹','kNN','֧��������','����ѧϰ�����ɭ�֣�');
    legend('S1','S2','S3');
    axis([0 10 0 1]);
    mean7(end+1)=mean(error7);
    mean36(end+1)=mean(error36);
    meannc(end+1)=mean(errornc);
end
error_7_rf=error7;
error_36_rf=error36;
error_nc_rf=errornc;
save('rf_result.mat','error_7_rf','error_36_rf','error_nc_rf');