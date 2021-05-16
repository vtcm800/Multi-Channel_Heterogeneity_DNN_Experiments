%% Using GPR to predict the fingerprint of non-sampled grids
function [rssMean2,rssStd2]=interpolateFingerprintByGPRBatch(rssMean,rssStd,posGrid,idxInterpolation,idxTraining,inter_step,ref_step)
rssMean2=rssMean;
rssStd2=rssStd;
%% The number of grids
Grid_Num = size(rssMean,1);
%% The number of APs
AP_Num=size(rssMean,2);
neighborCount=8;

min_x=min(posGrid(idxInterpolation,1));
max_x=max(posGrid(idxInterpolation,1));
min_y=min(posGrid(idxInterpolation,2));
max_y=max(posGrid(idxInterpolation,2));


idxInterpolation_temp=idxInterpolation;
for x=min_x:inter_step:max_x,
    for y=min_y:inter_step:max_y,
        idx_temp=searchPosIdx(x,y,inter_step,posGrid,idxInterpolation_temp);
        if isempty(idx_temp)
            continue;
        end
        idx=idxInterpolation_temp(idx_temp);
        idxInterpolation_temp(idx_temp)=[];
        idx_temp=searchPosIdx(x-(ref_step-inter_step)/2,y-(ref_step-inter_step)/2,ref_step,posGrid,idxTraining);
        if length(idx_temp)<4
            continue;
        end
        
        idxNeighbor=idxTraining(idx_temp);
        
        Xstar=posGrid(idx,:);
        for i=1:AP_Num,
            y=rssMean(idxNeighbor,i);  % RSS
            U=posGrid(idxNeighbor,:); % Locations at which RSSIs are available
            %% Model Training
            [est,feval]=fmincon(@(x) MLE_GPR(x,U,y),[0,0,0,0,0,0,4,4],[],[],[],[],...
                [-100,-100,-100,-100,-100,-100,0,0],[100,100,100,100,100,100,10,5]);
            %% Predict the RSS mean
            [mf,~]=predict(est,y,U,Xstar);
            rssMean2(idx,i)=mf;
            rssStd2(idx,i)=stdInterpolate(rssStd(:,i),idxNeighbor);
        end
    end
end
end

function idx=searchPosIdx(x,y,step,posGrid,idxPos)
idx=[];
count=0;
for i=1:length(idxPos)
    if posGrid(idxPos(i),1)>=x && posGrid(idxPos(i),1)<x+step ...
            && posGrid(idxPos(i),2)>=y && posGrid(idxPos(i),2)<y+step
        count=count+1;
        idx(count)=i;
    end
end
end


function idxNeighbor=selectCloseNeighbor(idx,neibhorCount,posGrid,idxTraining)
pos=posGrid(idxTraining,:);
xydiff=zeros(length(idxTraining),2);
for j=1:length(idxTraining),
    xydiff(j,:)=pos(j,:)-posGrid(idx,:);
end
dist2=xydiff(:,1).^2+xydiff(:,2).^2;
[temp,tempIdx]=sort(dist2);
idx=tempIdx(1:min(neibhorCount,length(temp)));
idxNeighbor=idxTraining(idx);
end

function sf=stdInterpolate(rssStdi,idxNeighbor)
sf=mean(rssStdi(idxNeighbor));
end

%% Predict the fingerprint of the given positions
function [mf,vf]=predict(x,y,U,Xstar)
[len,dim]=size(Xstar);
mf=zeros(len,1);
vf=zeros(len,1);
for i=1:len,
    m=m_Vector(x,Xstar(i,:));
    m=m(1);
    mu=m_Vector(x,U);
    Km=K_Matrix(x,U);
    Kv=K_Vector(x,Xstar(i,:),U);
    k=K_Vector(x,Xstar(i,:),Xstar(i,:));
    k=k(1);
    
    mf(i,1)=m+Kv*inv(Km)*(y-mu);
    vf(i,1)=k-Kv*inv(Km)*Kv';
end
end

%% GPR modeling
%% x is the hyperparameter vector
function fun=MLE_GPR(x,U,y)
K=K_Matrix(x,U);
m=m_Vector(x,U);
fun=log(det(K))+(y-m)'*inv(K)*(y-m);
end
function K=K_Matrix(x,U)
K=K_Vector(x,U,U);
[dim1,dim2]=size(K);
K=K+eye(dim1);
end

function K=K_Vector(x,A,B)
[lenA,dim]=size(A);
[lenB,dim]=size(B);
K=zeros(lenA,lenB);
for i=1:lenA,
    for j=1:lenB,
        K(i,j)=x(7)^2*exp(-norm(A(i,:)-B(j,:))/x(8)^2/2);
    end
end
end

function m=m_Vector(x,U)
[len,dim]=size(U);
A=[x(1) x(3);x(3) x(2)];
b=[x(4);x(5)];
c=x(6);
m=zeros(len,1);
for i=1:len,
    m(i,1)=U(i,:)*A*U(i,:)'+U(i,:)*b+c;
end
end