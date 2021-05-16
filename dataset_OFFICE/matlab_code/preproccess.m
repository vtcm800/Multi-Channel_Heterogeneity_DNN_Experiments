% 读取并拼接原始数据,timestamp,apmac,devmac,gridid,apid,channel,rss
inTable = readtable('fingerprint/in_fingerprintdata.dat','Delimiter',',');
outTable = readtable('fingerprint/out_fingerprintdata.dat','Delimiter',',');
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
    for aidx=1:length(aps)
        data_ap=data_grid(find(data_grid(:,2)==aps(aidx)),:);
        for cidx=1:length(channels)
            data_channel=data_ap(find(data_ap(:,3)==channels(cidx)),:);
            if isempty(data_channel)
                fp_mean(gidx,aidx,cidx)=-100;
                fp_std(gidx,aidx,cidx)=0;
            else
                fp_mean(gidx,aidx,cidx)=mean(data_channel(:,4));
                fp_std(gidx,aidx,cidx)=std(data_channel(:,4));
            end
            fp_mean(gidx,7,cidx)=channels(cidx);
            fp_mean(gidx,8,cidx)=grids(gidx);
        end
    end
end

train_data=[];
for gidx=1:length(grids)
    for cidx=1:length(channels)
        data_temp=[];
        for aidx=1:length(aps)
            data_temp=[data_temp,normrnd(fp_mean(gidx,aidx,cidx),fp_std(gidx,aidx,cidx),[100 1])];
        end
        data_temp(:,7)=fp_mean(gidx,7,cidx);
        data_temp(:,8)=fp_mean(gidx,8,cidx);
        train_data=[train_data;data_temp];
    end
end
writetable(array2table(train_data),'train_data.csv','WriteVariableNames',false);
