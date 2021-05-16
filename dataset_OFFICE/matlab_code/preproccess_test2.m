% 读取并拼接原始数据,timestamp,apmac,devmac,gridid,apid,channel,rss
data_raw1 = readtable('../datasets/test0410/第一组x21.5y17.3/240995b2909c_-1_21.5_17.3_raw.dat');
data_raw1{:,end+1}=1;
data_raw2 = readtable('../datasets/test0410/第二组x23.5y14.3/240995b2909c_-1_23.5_14.3_raw.dat');
data_raw2{:,end+1}=2;
data_raw3 = readtable('../datasets/test0410/第三组x30y17.8/240995b2909c_-1_30.0_17.8_raw.dat');
data_raw3{:,end+1}=3;
data_raw4 = readtable('../datasets/test0410/第四组x37y18.8/240995b2909c_-1_37.0_18.8_raw.dat');
data_raw4{:,end+1}=4;
data_raw5 = readtable('../datasets/test0410/第五组x34y7.8/240995b2909c_-1_34.0_7.8_raw.dat');
data_raw5{:,end+1}=5;
data_raw6 = readtable('../datasets/test0410/第六组x18.5y13.3/240995b2909c_-1_18.5_13.3_raw.dat');
data_raw6{:,end+1}=6;
data_raw7 = readtable('../datasets/test0410/第七组x16.5y18.3/240995b2909c_-1_16.5_18.3_raw.dat');
data_raw7{:,end+1}=7;
data_raw=[data_raw1;data_raw2;data_raw3;data_raw4;data_raw5;data_raw6;data_raw7];
% 根据mac地址过滤设备
% data_raw(find(~(strcmp(data_raw{:,3},'9c207b9d2614')|strcmp(data_raw{:,3},'9c207b9d2613'))),:)=[];
% apMacList = {'70476001a301' '70476001a302' '70476001a303' '70476002a301' '70476002a307' '70476002a308' '70476002a309' '70476002a310' '70476002a311' '70476002a312'};
% for i = 1:length(apMacList)
%     data_raw(find(strcmpi(data_raw{:,2},apMacList(i))),5)=array2table(i);
% end
% % 信道过滤5G或2.4G频段
% data_raw(find(data_raw{:,6}>14),:)=[];
% 去除无用属性,timestamp,gridid,apid,rss,test_position_no
data_raw(:,2:4)=[];
data_raw=table2array(data_raw);
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
test_data_nc=[];
test_data_7=[];
aps=unique(data_raw(:,2))';
channels=unique(data_raw(:,3))';
tds=unique(data_raw(:,5))';
for tdidx=tds
    data_td=data_raw(find(data_raw(:,5)==tdidx),:);
    t = data_td(1,1)-10;
    tidx=0;
    while true
        t=t+10;
        tidx=tidx+1;
        if t-5 > data_td(end,1)
            break;
        end
        data_time=data_td(find(data_td(:,1)>=t&data_td(:,1)<t+10),:);
        if isempty(data_td)
            continue;
        end
        temp=[];
        
        temp_nc=[];
        for cidx = channels
            temp_7=[];
            data_channel = data_time(find(data_time(:,3)==cidx),:);
            for aidx = aps
                rssIdx=find(data_channel(:,2)==aidx);
                if isempty(rssIdx)
                    temp(end+1)=-100;
                    temp_7(end+1)=-100;
                else
                    temp(end+1)=mean(data_channel(rssIdx,4));
                    temp_7(end+1)=mean(data_channel(rssIdx,4));
                end
            end
            test_data_7(end+1,:)=[temp_7,cidx,tidx,tdidx];
        end
        for aidx = aps
            rssIdx=find(data_time(:,2)==aidx);
            if isempty(rssIdx)
                temp_nc(end+1)=-100;
            else
                temp_nc(end+1)=mean(data_time(rssIdx,4));
            end
        end
        test_data(end+1,:)=[temp,tidx,tdidx];
        test_data_nc(end+1,:)=[temp_nc,tidx,tdidx];
    end
    tdidx
end
realLoc=[21.5,17.3;
    23.4,14.3;
    30.0,17.8;
    37.0,18.8;
    34.0,7.8;
    18.5,13.3;
    16.5,18.3];
for td=unique(test_data_nc(:,8))'
    tdidx=find(test_data_nc(:,8)==td);
    test_data(tdidx,39)=realLoc(td,1);
    test_data(tdidx,40)=realLoc(td,2);
    test_data_nc(tdidx,9)=realLoc(td,1);
    test_data_nc(tdidx,10)=realLoc(td,2);
    tdidx=find(test_data_7(:,9)==td);
    test_data_7(tdidx,10)=realLoc(td,1);
    test_data_7(tdidx,11)=realLoc(td,2);
end

writetable(array2table(test_data),'../datasets/test_data_36.csv','WriteVariableNames',false);
writetable(array2table(test_data_nc),'../datasets/test_data_nc_6.csv','WriteVariableNames',false);
writetable(array2table(test_data_7),'../datasets/test_data_7.csv','WriteVariableNames',false);
