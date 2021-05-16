function createFingerprintDatabase()
%% Generate the fingerprint database, including the means and variance

inTable=readtable(strcat(begin_str,'../traindata_corrected.dat'),'Delimiter',',');%Importing the data

%% Get the grid number and coordinates
load(strcat(begin_str,'coordinates.mat'));

inTable(find(inTable{:,6}<15),:)=[];
inData=table2array(inTable(:,[4 5 7]));
%% parameter setting
IDX_GRID_ID=1;
IDX_AP_ID=2;
IDX_RSS=3;

[gridNum,~]=size(posGrid);
rssData=inData; 
apNum=max(rssData(:,IDX_AP_ID)); 
rssMean=zeros(gridNum,apNum);
rssStd=zeros(gridNum,apNum);
stat=zeros(gridNum,apNum);
for i=1:gridNum
    logical_grid_idx=(rssData(:,IDX_GRID_ID)==i);
    grid_idx=find(logical_grid_idx, 1);
    if isempty(grid_idx)
        continue;
    end
    for j=1:apNum
        idx= logical_grid_idx&(rssData(:,IDX_AP_ID)==j);
        temp=rssData(idx,IDX_RSS);
        if ~isempty(temp)
            rssMean(i,j)=mean(temp);
            rssStd(i,j)=std(temp);
            stat(i,j)=length(temp);
        end        
    end
end

rssMean3=rssMean;
rssStd3=rssStd;
inter_step=0.5;
ref_step=6;

for i=1:apNum
    idxTraining=find(rssMean(:,i)~=0&rssStd(:,i)~=0);
    idxInterpolation=find(rssMean(:,i)==0|rssStd(:,i)==0);
    [rssMean2,rssStd2]=interpolateFingerprintByGPRBatch(rssMean(:,i),rssStd(:,i),posGrid,idxInterpolation,idxTraining,inter_step,ref_step);
    rssMean3(:,i)=rssMean2;
    rssStd3(:,i)=rssStd2;
    
    %% anomaly detection
    [cidx,P]=trainLDPL(rssMean(:,i),rssStd(:,i),posGrid,idxInterpolation,idxTraining);
    
    for j=1:length(idxInterpolation),
        idx=idxInterpolation(j);
        if rssMean3(idx,i)==0 || rssMean3(idx,i)<-100
             rssMean3(idx,i)=-100;
             rssStd3(idx,i)=0.1;
             continue;
        end
        prediction2=polyval(P,10*log10(norm(posGrid(idx,:)-posGrid(cidx,:))));
        if prediction2<-100
            prediction2=-100;
        end
        if abs(rssMean3(idx,i)-prediction2)>15
            rssMean3(idx,i)=prediction2;
        end
        
    end
end

%Fingerprint_avg.data is the mean file, Fingerprint_std.data is the standard deviation file

favg=fopen('Fingerprint_avg_5.dat','w');
fstd=fopen('Fingerprint_std_5.dat','w');
for i=1:gridNum
    for j=1:apNum
        fprintf(favg,'%d',round(rssMean3(i,j)));
        fprintf(fstd,'%2.2f',rssStd3(i,j));
        if j~=apNum
            fprintf(favg,' ');
            fprintf(fstd,' ');
        end
    end
    fprintf(favg,'\r\n');
    fprintf(fstd,'\r\n');
end
fclose(favg);
fclose(fstd);
end

function [idx,p]=trainLDPL(rssMean,rssStd,posGrid,idxInterpolation,idxTraining)
[maxrss,i]=max(rssMean(idxTraining));
c=posGrid(idxTraining(i),:);
idx=idxTraining(i);
idxTraining(i)=[];
p=polyfit(10*log10(sqrt((posGrid(idxTraining,1)-c(1)).^2+(posGrid(idxTraining,2)-c(2)).^2)),rssMean(idxTraining),1);
end