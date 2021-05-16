train_data=readtable('train_data_36.csv');
train_data=table2array(train_data);
y=train_data(:,37);
new_data=[];
for i = 1:length(train_data)
    temp=train_data(1,:);
    new_data(1,:,1,i)=temp(1:6);
    new_data(2,:,1,i)=temp(7:12);
    new_data(3,:,1,i)=temp(13:18);
    new_data(4,:,1,i)=temp(19:24);
    new_data(5,:,1,i)=temp(25:30);
    new_data(6,:,1,i)=temp(31:36);
end
TTrain=categorical(train_data(:,37));
XTrain=new_data;
% a=new_data(:,:,:,2);
% imagesc(a);
% load digitTrainSet;
layers = [imageInputLayer([6 6 1],'Normalization','none');
%     convolution2dLayer(3,32);
%     reluLayer();
    %           maxPooling2dLayer(2,'Stride',2);
%     convolution2dLayer(3,32);
%     reluLayer();
%     convolution2dLayer(2,32);
%     reluLayer();
    %           maxPooling2dLayer(2,'Stride',2);
    fullyConnectedLayer(10);
    fullyConnectedLayer(10);
    %               reluLayer();
    fullyConnectedLayer(122);
    softmaxLayer();
    classificationLayer()];
opts = trainingOptions('sgdm');
net = trainNetwork(XTrain,TTrain,layers,opts);
% load digitTestSet;
% YTest = classify(net,XTest);
% accuracy = sum(YTest == TTest)/numel(TTest)
test_data=readtable('test_data_36.csv');
test_data=table2array(test_data);
new_test_data=[];
for i = 1:length(test_data)
    temp=test_data(1,:);
    new_test_data(1,:,1,i)=temp(1:6);
    new_test_data(2,:,1,i)=temp(7:12);
    new_test_data(3,:,1,i)=temp(13:18);
    new_test_data(4,:,1,i)=temp(19:24);
    new_test_data(5,:,1,i)=temp(25:30);
    new_test_data(6,:,1,i)=temp(31:36);
end
XTest=new_test_data;
YTest = classify(net,XTest);
% 
% inputs = cancerInputs;
% targets = cancerTargets;
% 
% % Create a Pattern Recognition Network
% hiddenLayerSize = 10;
% net = patternnet(hiddenLayerSize);
% 
% 
% % Set up Division of Data for Training, Validation, Testing
% net.divideParam.trainRatio = 70/100;
% net.divideParam.valRatio = 15/100;
% net.divideParam.testRatio = 15/100;
% 
% 
% % Train the Network
% [net,tr] = train(net,inputs,targets);
% 
% % Test the Network
% outputs = net(inputs);
% errors = gsubtract(targets,outputs);
% performance = perform(net,targets,outputs)
% 
% % View the Network
% view(net)
% 
% % Plots
% % Uncomment these lines to enable various plots.
% % figure, plotperform(tr)
% % figure, plottrainstate(tr)
% % figure, plotconfusion(targets,outputs)
% % figure, ploterrhist(errors)

% [inputs,targets] = cancer_dataset;
% hiddenLayerSize = 10;
% net = patternnet(hiddenLayerSize);
% net.divideParam.trainRatio = 70/100;
% net.divideParam.valRatio   = 15/100;
% net.divideParam.testRatio  = 15/100;
% [net,tr] = train(net,inputs,targets);
% outputs = net(inputs);
% errors = gsubtract(targets,outputs);
% performance = perform(net,targets,outputs)
% tInd = tr.testInd;
% tstOutputs = net(inputs(:,tInd));
% tstPerform = perform(net,targets(:,tInd),tstOutputs)
% view(net)
% figure, plotperform(tr)
% figure, plotconfusion(targets,outputs)