clc;clear
aimpath = ['F:\2023PMM_Work\Figures_for_Publish\Figure\FigS22_ENSO_package_feedback\'];
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end

figpath = [aimpath,'Chen_FigS22c_ENSO_package_feedback_metric'];

data = load('F:\2023PMM_Work\Figures_for_Response\bin_data_CMIP_Chen\Chen_ENSO_package_SSTandTaux_Feedback.mat');
bin_enso_feedback = [data.reg1_obs_a,data.reg2_cesm_a,data.reg3_cmip_a];
data_name = ['Obs.';'CESM';data.list_name];
%%
clear metric_enso_amp
for i1 = 1:length(bin_enso_feedback)-1
    metric_enso_amp(i1,1) = abs((bin_enso_feedback(i1+1) - bin_enso_feedback(1))/bin_enso_feedback(1));
end

FontSize = 25; 
FontSize2 = 25;
FontName = 'Arial';
LW = 5;% lines

close all

fig1 = metric_enso_amp;
h = boxchart(fig1);
hold on
% box on
scatter(1.1,fig1(1),72,[0,0,0],'<','filled');

ytick = 0:0.1:0.6;
clear ytick_name
ytick_name{1} = 'ref';
for i1 = 2:length(ytick)
    ytick_name{i1} = num2str(ytick(i1));
end
ylim([ytick(1),ytick(end)])

set(gca,'xtick',[],'ytick',ytick,'yticklabel',ytick_name,'FontSize',FontSize,'FontName',FontName);
title('Metric','FontSize',FontSize,'FontName',FontName);
text(1.25,fig1(1),'CESM','FontSize',FontSize2,'FontName',FontName);
text(0,0.635,'(c)','FontSize',FontSize2,'FontName',FontName);
% xlabel('Feedback','FontSize',FontSize,'FontName',FontName)
%%
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 3.5 5],'color',[1 1 1],'PaperOrientation','landscape');
print('-djpeg','-r1000',[figpath,'.jpg']);
print('-dpdf','-r1000',[figpath,'.pdf']);

