clear;
clc;
%% data correction, remove No.125 of two M6, change No.126 to No.125
data=readtable('testdata_corrected_g2_mi1.csv');
data(find(table2array(data(:,4))==125),:)=[];
data(find(table2array(data(:,4))==126),4)=array2table(125);
writetable(data,'atestdata_corrected_g2_mi1.csv','WriteVariableNames',false);

data=readtable('testdata_corrected_g2_mi2.csv');
data(find(table2array(data(:,4))==125),:)=[];
data(find(table2array(data(:,4))==126),4)=array2table(125);
writetable(data,'atestdata_corrected_g2_mi2.csv','WriteVariableNames',false);

data=readtable('testdata_corrected_g2_sam.csv');
data(find(table2array(data(:,4))==126),4)=array2table(125);
writetable(data,'atestdata_corrected_g2_sam.csv','WriteVariableNames',false);

data=readtable('testdata_corrected_g2_ipad.csv');
data(find(table2array(data(:,4))==126),4)=array2table(125);
writetable(data,'atestdata_corrected_g2_ipad.csv','WriteVariableNames',false);
% ts=data(find(strcmp(data{:,3},'a483e7e37fc4')),:);%a483e7e37fc4%6036dda1a103
% ts=table2array(ts);
% ts(:,1)=array2table(round(table2array(ts(:,1))/1000));
% ts(:,5)=array2table(table2array(ts(:,5))+1);
% inc=0;
% for i=2:height(data)
%     x=table2array(data(i,1))-table2array(data(i-1,1));
%     if x>3
%         data(i,4)
%     end
% %     ts(i,4)=array2table(table2array(ts(i,4))+inc);
% end
% writetable(ts,'testdata_corrected_g1_mac.csv','WriteVariableNames',false);