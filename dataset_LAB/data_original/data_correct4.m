clear;
clc;
%% data verification, compare to Group 1, check whether the last two points reversed
data=readtable('testdata_corrected_g1_dell.csv');
uni_grid=table2array(unique(data(:,4)));
rss_mean_dell=[];
for i=125:126
    for j=1:4
        rss_mean_dell(i-124,j)=mean(table2array(data(find(table2array(data(:,4))==i&table2array(data(:,5))==j),7)));
    end
end
data=readtable('testdata_corrected_g1_mac.csv');
uni_grid=table2array(unique(data(:,4)));
rss_mean_mac=[];
for i=125:126
    for j=1:4
        rss_mean_mac(i-124,j)=mean(table2array(data(find(table2array(data(:,4))==i&table2array(data(:,5))==j),7)));
    end
end
%% Group 1 is right!
data=readtable('testdata_corrected_g2_mi1.csv');
uni_grid=table2array(unique(data(:,4)));
rss_mean_mi1=[];
for i=125:126
    for j=1:4
        rss_mean_mi1(i-124,j)=mean(table2array(data(find(table2array(data(:,4))==i&table2array(data(:,5))==j),7)));
    end
end
data=readtable('testdata_corrected_g2_mi2.csv');
uni_grid=table2array(unique(data(:,4)));
rss_mean_mi2=[];
for i=125:126
    for j=1:4
        rss_mean_mi2(i-124,j)=mean(table2array(data(find(table2array(data(:,4))==i&table2array(data(:,5))==j),7)));
    end
end
data=readtable('testdata_corrected_g2_sam.csv');
uni_grid=table2array(unique(data(:,4)));
rss_mean_sam=[];
for i=125:126
    for j=1:4
        rss_mean_sam(i-124,j)=mean(table2array(data(find(table2array(data(:,4))==i&table2array(data(:,5))==j),7)));
    end
end
data=readtable('testdata_corrected_g2_ipad.csv');
uni_grid=table2array(unique(data(:,4)));
rss_mean_ipad=[];
for i=125:126
    for j=1:4
        rss_mean_ipad(i-124,j)=mean(table2array(data(find(table2array(data(:,4))==i&table2array(data(:,5))==j),7)));
    end
end
% sam and iPad were not collected in the No.125 point, reverse No.125 and No.126 of two M6s
