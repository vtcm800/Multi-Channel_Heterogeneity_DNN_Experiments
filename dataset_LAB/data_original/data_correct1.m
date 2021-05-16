clear;
clc;
%% data correction, including the grid number, AP number and time accuracy of the original data in "in_fingerprintdata1579235292738.dat"
data=readtable('in_fingerprintdata1579235292738.dat');
ts=data(find(strcmp(data{:,3},'a483e7e37fc4')),:);%a483e7e37fc4%6036dda1a103
% ts=table2array(ts);
ts(:,1)=array2table(round(table2array(ts(:,1))/1000));
ts(:,5)=array2table(table2array(ts(:,5))+1);
inc=0;
for i=2:height(ts)
    if table2array(ts(i,1))-table2array(ts(i-1,1))>10
        inc=inc+1;
    end
    ts(i,4)=array2table(table2array(ts(i,4))+inc);
end
writetable(ts,'testdata_corrected_g1_mac.csv','WriteVariableNames',false);