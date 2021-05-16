load cadnn_result1.mat
load cadnn_result2.mat
load cadnn_result3.mat

yloc_7=[];
for i = 1:6:660
    yloc_7(end+1,:)=mean(yloc(i:i+5,:));
end
error_7_cadnn=sqrt((yloc_7(:,1)-testLoc(:,1)).^2+(yloc_7(:,2)-testLoc(:,2)).^2);
figure;
set(gca,'FontName','Times New Roman','fontsize',16);
hold on;
h=cdfplot(error_nc_cadnn);
set(h,'linewidth',1.5);
h=cdfplot(error_7_cadnn);
set(h,'linewidth',1.5);
h=cdfplot(error_36_cadnn);
set(h,'linewidth',1.5);
title('');
xlabel('Localization Error (m)');
ylabel('Probability');
legend('Scheme-1','Scheme-2','Scheme-3','location','southeast');
axis([0 5 0 1]);
% set(gca,'DataAspectRatio',[3 1 1]);
% saveas(gcf, 'cadnn.eps','psc2');

load knn_result.mat
figure;
set(gca,'FontName','Times New Roman','fontsize',16);
hold on;
h=cdfplot(error_nc_knn);
set(h,'linewidth',1.5);
h=cdfplot(error_7_knn);
set(h,'linewidth',1.5);
h=cdfplot(error_36_knn);
set(h,'linewidth',1.5);
title('');
xlabel('Localization Error (m)');
ylabel('Probability');
legend('Scheme-1','Scheme-2','Scheme-3','location','southeast');
axis([0 5 0 1]);
% set(gca,'DataAspectRatio',[3 1 1]);
% saveas(gcf, 'knn.eps','psc2');

load rf_result.mat
figure;
set(gca,'FontName','Times New Roman','fontsize',16);
hold on;
h=cdfplot(error_nc_rf);
set(h,'linewidth',1.5);
h=cdfplot(error_7_rf);
set(h,'linewidth',1.5);
h=cdfplot(error_36_rf);
set(h,'linewidth',1.5);
title('');
xlabel('Localization Error (m)');
ylabel('Probability');
legend('Scheme-1','Scheme-2','Scheme-3','location','southeast');
axis([0 5 0 1]);
% set(gca,'DataAspectRatio',[3 1 1]);
% saveas(gcf, 'rf.eps','psc2');

load svm_result.mat
figure;
set(gca,'FontName','Times New Roman','fontsize',16);
hold on;
h=cdfplot(error_nc_svm);
set(h,'linewidth',1.5);
h=cdfplot(error_7_svm);
set(h,'linewidth',1.5);
h=cdfplot(error_36_svm);
set(h,'linewidth',1.5);
title('');
xlabel('Localization Error (m)');
ylabel('Probability');
legend('Scheme-1','Scheme-2','Scheme-3','location','southeast');
axis([0 5 0 1]);
% set(gca,'DataAspectRatio',[3 1 1]);
% axis tight;
% saveas(gcf, 'svm.eps','psc2');