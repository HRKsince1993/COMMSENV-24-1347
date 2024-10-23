clc;clear
aimpath = ['F:\2023PMM_Work\Figures_for_Publish\Figure\FigS22_ENSO_package_feedback\'];
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end

figpath = [aimpath,'Chen_FigS22b_ENSO_package_feedback_distribution'];

data = load('F:\2023PMM_Work\Figures_for_Response\bin_data_CMIP_Chen\Chen_ENSO_package_SSTandTaux_Feedback.mat');
bin_enso_feedback = [data.reg1_obs_a,data.reg2_cesm_a,data.reg3_cmip_a];
xtick_name = ['OBS';'CESM';data.list_name];
%%
FontSize = 18; 
FontSize2 = 25; 
FontName = 'Arial';
LW = 5;% lines

bar_width = 0.8;
%%
k_scale = 100;

close all
fig1 = bin_enso_feedback*k_scale;

h1 = bar(1,fig1(1),bar_width,'facecolor',[0,0,0]);
hold on
h2 = bar(2,fig1(2),bar_width,'facecolor',[1,0,0]);
h3 = bar(3:length(fig1),fig1(3:end),bar_width,'facecolor',[0.8,0.8,0.8]);
plot(xlim,[fig1(1),fig1(1)],'color',[0.7,0.7,0.7],'LineStyle','--')

box on
grid on;
ylim([0,1.5]);
xlim([0,length(fig1)+1]);
set(gca,'xtick',1:length(fig1),'xticklabel',xtick_name,'ytick',-1+0.5:0.5:2+0.5,'FontSize',FontSize,'FontName',FontName);
xtickangle(45)
% xlabel('2023','FontSize',FontSize,'FontName',FontName);
% ylabel(['Slope[10^{-',num2str(log10(k_scale)),'}N m^{-2} °„C^{-1}]'],'FontSize',FontSize2,'FontName',FontName);
ylabel('Slope','FontSize',FontSize2,'FontName',FontName);
title('SST-Zonal wind feedback','FontSize',FontSize2,'FontName',FontName);
text(0,1.6,'(b)','FontSize',FontSize2,'FontName',FontName);
%%
set(gcf,'PaperUnits','inches','PaperPosition',[-1 0 15.5 6],'color',[1 1 1],'PaperOrientation','landscape');
print('-djpeg','-r1000',[figpath,'.jpg']);
print('-dpdf','-r1000',[figpath,'_left.pdf']);

set(gcf,'PaperUnits','inches','PaperPosition',[-3 0 15.5 6],'color',[1 1 1],'PaperOrientation','landscape');
print('-dpdf','-r1000',[figpath,'_right.pdf']);

