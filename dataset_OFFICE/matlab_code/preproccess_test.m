% 读取并拼接原始数据,timestamp,apmac,devmac,gridid,apid,channel,rss
data_raw1 = readtable('test0410/第一组x21.5y17.3/240995b2909c_-1_21.5_17.3_raw.dat');
% data_raw2 = readtable('testdata/raw-9');
% data_raw3 = readtable('testdata/raw-10');
% data_raw4 = readtable('testdata/raw-11');
% data_raw1(:,4)=array2table(114);
% data_raw2(:,4)=array2table(93);
% data_raw3(:,4)=array2table(131);
% data_raw4(:,4)=array2table(162);

% data_raw=[data_raw1;data_raw2;data_raw3;data_raw4];
% outTable = readtable('out_fingerprintdata.dat');
% data_raw=[inTable;outTable];
% 根据mac地址过滤设备
% data_raw(find(~(strcmp(data_raw{:,3},'9c207b9d2614')|strcmp(data_raw{:,3},'9c207b9d2613'))),:)=[];
% apMacList = {'70476001a301' '70476001a302' '70476001a303' '70476002a301' '70476002a307' '70476002a308' '70476002a309' '70476002a310' '70476002a311' '70476002a312'};
% for i = 1:length(apMacList)
%     data_raw(find(strcmpi(data_raw{:,2},apMacList(i))),5)=array2table(i);
% end
% % 信道过滤5G或2.4G频段
% data_raw(find(data_raw{:,6}>14),:)=[];
% 去除无用属性,timestamp,gridid,apid,rss
data_raw1(:,2:4)=[];
data_raw=table2array(data_raw1);
%
% 时间处理为秒，校正时间顺序
data_raw(:,1) = round(data_raw(:,1)./1000);
data_raw=sortrows(data_raw,1);
data_raw(:,2)=data_raw(:,2)+1;
data_raw(find(data_raw(:,3)==2),3)=1;
data_raw(find(data_raw(:,3)==3),3)=1;
data_raw(find(data_raw(:,3)==9),3)=8;
data_raw(find(data_raw(:,3)==13),3)=11;
data_raw(find(data_raw(:,3)==58),3)=42;
data_raw(find(data_raw(:,3)==165),3)=155;

%% 开始构建测试数据
test_data=[];
aps=unique(data_raw(:,2))';
channels=unique(data_raw(:,3))';

t = data_raw(1,1)-10;
tidx=0;
while true
    t=t+10;
    tidx=tidx+1;
    if t > data_raw(end,1)
        break;
    end
    data_time=data_raw(find(data_raw(:,1)>=t&data_raw(:,1)<t+10),:);
    if isempty(data_time)
        continue;
    end
    for cidx = channels
        data_channel = data_time(find(data_time(:,3)==cidx),:);
        if isempty(data_channel)
            continue;
        end
        temp=[];
        for aidx = aps
            rssIdx=find(data_channel(:,2)==aidx);
            if isempty(rssIdx)
                temp(aidx)=-100;
            else
                temp(aidx)=mean(data_channel(rssIdx,4));
            end
        end
        test_data(end+1,:)=[temp,cidx,tidx];
    end
    data_raw(end,1)-t
end
%
writetable(array2table(test_data),'test_data.csv','WriteVariableNames',false);
% writetable(array2table(data_test(:,[1:10,21])),'test_data_mean.csv','WriteVariableNames',false);
