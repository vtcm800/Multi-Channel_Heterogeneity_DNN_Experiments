% 读取并拼接原始数据,timestamp,apmac,devmac,gridid,apid,channel,rss
inTable = readtable('../datasets/fingerprint/in_fingerprintdata.dat','Delimiter',',');
outTable = readtable('../datasets/fingerprint/out_fingerprintdata.dat','Delimiter',',');
data_raw=[inTable;outTable];
% 根据mac地址过滤设备
% data_raw(find(~strcmp(data_raw{:,3},'A8:0C:63:50:92:A7')),:)=[];
% 信道过滤5G或2.4G频段
% data_raw(find(data_raw{:,6}>14),:)=[];
% 去除无用属性,gridid,apid,channel,rss
data_raw(:,1:3)=[];
data_raw=table2array(data_raw);
% 时间处理为秒，校正时间顺序
% data_raw(:,1) = round(data_raw(:,1)./1000);
% data_raw=sortrows(data_raw,1);
%

% %% 开始构建训练数据
% gridIDs=unique(data_raw(:,2))';
% apIDs=unique(data_raw(:,3))';
%
% t = data_raw(1,1)-1;
% while true
%     t=t+1;
%     if t > data_raw(end,1)
%         break;
%     end
%     data_time=data_raw(find(data_raw(:,1)==t),:);
%     if isempty(data_time)
%         continue;
%     end
%     for grid_num = gridIDs
%         data_grid = data_time(find(data_time(:,2)==grid_num),:);
%         if isempty(data_grid)
%             continue;
%         end
%         tmpRSSs = [zeros(1,length(apIDs)*2),grid_num];
%         datanum = 0;
%         for ap_num = apIDs
%             rssIdx=find(data_grid(:,3)==ap_num);
%             if isempty(rssIdx)
%                 tmpRSSs(ap_num)=-100;
%             else
%                 if length(rssIdx)<10
%                     datanum=datanum+1;
%                 end
%                 tmpRSSs(ap_num)=mean(data_grid(rssIdx,4));
%                 tmpRSSs(ap_num+length(apIDs))=std(data_grid(rssIdx,4));
%             end
%         end
% %         if length(find(tmpRSSs==-100))+datanum<8 && length(find(tmpRSSs==-100))<5
%             data_train(end+1,:)=tmpRSSs;
% %         end
%     end
%     data_raw(end,1)-t
% end
%
% writetable(array2table(data_train),'train_data_all.csv','WriteVariableNames',false);
% writetable(array2table(data_train(:,[1:5,11])),'train_data_mean.csv','WriteVariableNames',false);
data_raw(find(data_raw(:,3)==2),3)=1;
data_raw(find(data_raw(:,3)==3),3)=1;
data_raw(find(data_raw(:,3)==9),3)=8;
data_raw(find(data_raw(:,3)==13),3)=11;
data_raw(find(data_raw(:,3)==58),3)=42;
data_raw(find(data_raw(:,3)==165),3)=155;
fp_mean=[];
fp_std=[];
grids=unique(data_raw(:,1))';
aps=unique(data_raw(:,2))';
channels=unique(data_raw(:,3))';
for gidx=1:length(grids)
    data_grid=data_raw(find(data_raw(:,1)==grids(gidx)),:);
    colIdx=0;
    for cidx=1:length(channels)
        data_channel=data_grid(find(data_grid(:,3)==channels(cidx)),:);
        for aidx=1:length(aps)
            data_ap=data_channel(find(data_channel(:,2)==aps(aidx)),:);
            colIdx=colIdx+1;
            if isempty(data_ap)
                fp_mean(gidx,colIdx)=-100;
                fp_std(gidx,colIdx)=0;
            else
                fp_mean(gidx,colIdx)=mean(data_ap(:,4));
                fp_std(gidx,colIdx)=std(data_ap(:,4));
            end
        end
        %         colIdx=colIdx+1;
        %         fp_mean(gidx,colIdx)=channels(cidx);
    end
    colIdx=colIdx+1;
    fp_mean(gidx,colIdx)=grids(gidx);
end
fp_mean_nc=[];
fp_std_nc=[];
for gidx=1:length(grids)
    data_grid=data_raw(find(data_raw(:,1)==grids(gidx)),:);
    for aidx=1:length(aps)
        data_ap=data_grid(find(data_grid(:,2)==aps(aidx)),:);
        if isempty(data_ap)
            fp_mean_nc(gidx,aidx)=-100;
            fp_std_nc(gidx,aidx)=0;
        else
            fp_mean_nc(gidx,aidx)=mean(data_ap(:,4));
            fp_std_nc(gidx,aidx)=std(data_ap(:,4));
        end
    end
    fp_mean_nc(gidx,7)=grids(gidx);
end

train_data=[];
for gidx=1:length(grids)
    data_temp=[];
    for cidx=1:36
        %         for aidx=1:length(aps)
        data_temp=[data_temp,normrnd(fp_mean(gidx,cidx),fp_std(gidx,cidx),[100 1])];
        %         end
        %         data_temp(:,8)=fp_mean(gidx,8,cidx);
    end
    data_temp(:,end+1)=fp_mean(gidx,37);
    train_data=[train_data;data_temp];
end
load coordinates.mat
train_data(:,38:39)=posGrid(train_data(:,37),:);
tempidx=randperm(size(train_data, 1));
train_data=train_data(tempidx,:);
writetable(array2table(train_data),'../datasets/train_data_36.csv','WriteVariableNames',false);

train_data_nc=[];
for gidx=1:length(grids)
    data_temp=[];
    for cidx=1:6
        %         for aidx=1:length(aps)
        data_temp=[data_temp,normrnd(fp_mean_nc(gidx,cidx),fp_std_nc(gidx,cidx),[100 1])];
        %         end
        %         data_temp(:,8)=fp_mean(gidx,8,cidx);
    end
    data_temp(:,end+1)=fp_mean_nc(gidx,7);
    train_data_nc=[train_data_nc;data_temp];
end
train_data_nc(:,8:9)=posGrid(train_data_nc(:,7),:);
train_data_nc=train_data_nc(tempidx,:);
writetable(array2table(train_data_nc),'../datasets/train_data_nc_6.csv','WriteVariableNames',false);

train_data_7=[];
for gidx=1:length(grids)
    for cidx=0:5
        data_temp_7=[];
        for aidx=1:6
            data_temp_7=[data_temp_7,normrnd(fp_mean(gidx,cidx*6+aidx),fp_std(gidx,cidx*6+aidx),[20 1])];
        end
        data_temp_7(:,end+1)=channels(cidx+1);
        data_temp_7(:,end+1)=fp_mean(gidx,37);
        train_data_7=[train_data_7;data_temp_7];
    end
end
train_data_7(:,9:10)=posGrid(train_data_7(:,8),:);
tempidx=randperm(size(train_data_7, 1));
train_data_7=train_data_7(tempidx,:);
writetable(array2table(train_data_7),'../datasets/train_data_7.csv','WriteVariableNames',false);
