load ../results/result.mat
yreal=readtable('../datasets/test_data_36.csv');
yreal=yreal(:,39:40);
yreal=table2array(yreal);
errors=sqrt((yloc(:,1)-yreal(:,1)).^2+(yloc(:,2)-yreal(:,2)).^2);
% cdfplot(errors);
% axis([0 5 0 1]);
mean(errors)
median(errors)

% train_data=readtable('../datasets/train_data_36.csv');
% train_data=table2array(train_data);
% x=train_data(:,1:36);
% y=train_data(:,37);
% x = x - median(x(:));
% x=mapminmax(x);
% new_data=[];
% for i = 1:length(x)
%     temp=x(i,:);
%     new_data(1,:,i)=temp(1:6);
%     new_data(2,:,i)=temp(7:12);
%     new_data(3,:,i)=temp(13:18);
%     new_data(4,:,i)=temp(19:24);
%     new_data(5,:,i)=temp(25:30);
%     new_data(6,:,i)=temp(31:36);
% end
% for i = 1:length(new_data(1,1,:))
%     vl_imarraysc(new_data(:,:,i));
%     saveas(gcf,[ '../results/signal_image/grid',num2str(y(i)),'_idx',num2str(i)], 'eps');
%     saveas(gcf,[ '../results/signal_image/grid',num2str(y(i)),'_idx',num2str(i)], 'png');
%     close;
% end