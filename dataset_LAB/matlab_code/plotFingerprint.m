function plotFingerprint()
close all;

meanTable=readtable('Fingerprint_avg_test.dat');
stdTable=readtable('Fingerprint_std_test.dat');

rssMean=table2array(meanTable(:,:));
rssStd=table2array(stdTable(:,:));
[gridNum,apNum]=size(rssMean);

%% The definitions of grid number and coordinates
load('coordinates.mat');

for AP_ID=1:apNum,
    figure;
    stem3(posGrid(:,1),-posGrid(:,2),-rssMean(:,AP_ID));
    title(strcat('Average RSS of AP ',num2str(AP_ID)));
    xlabel('X');
    ylabel('Y');

end
end