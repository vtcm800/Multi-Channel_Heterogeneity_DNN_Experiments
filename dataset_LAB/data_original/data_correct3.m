clear;
clc;
%% data correction, including the grid number, AP number and time accuracy of the original data in "in_fingerprintdata1579238584915.dat"
data=readtable('in_fingerprintdata1579238584915.dat');
ts=data(find(strcmp(data{:,3},'f0d1a92cd8e0')),:);
% Xiaomi M6-1  4c49e3c1bc3d
% Xiaomi M6-2  4c49e3c7774f
% Samsung S9+  8c4500b6d814
% iPad Pro  f0d1a92cd8e0
% ts=table2array(ts);
ts(:,1)=array2table(round(table2array(ts(:,1))/1000));
ts(:,5)=array2table(table2array(ts(:,5))+1);
% inc=0;
% for i=2:height(ts)
%     if table2array(ts(i,1))-table2array(ts(i-1,1))>10
%         inc=inc+1;
%     end
%     ts(i,4)=array2table(table2array(ts(i,4))+inc);
% end
writetable(ts,'testdata_corrected_g2_ipad.csv','WriteVariableNames',false);