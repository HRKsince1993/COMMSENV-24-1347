clc;clear

one = 2;% From 1:Han;2:Chen
first_name = {'Han','Chen'};
first_name2 = {'41','39'};

aimpath = ['F:\2023PMM_Work\Figures_for_Publish\Figure\FigS21_ENSO_package_Amplitude\'];
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end

aimpath2 = ['F:\2023PMM_Work\Figures_for_Publish\bin_data_CMIP_',first_name{one},'\'];
if exist(aimpath2,'dir')~=7
    mkdir(aimpath2);
end

figpath = [aimpath,first_name{one},'_FigS21b_ENSO_package_amp_metric_total',first_name2{one}];

data = load(['F:\2023PMM_Work\Figures_for_Response\bin_data_CMIP_',first_name{one},'\',first_name{one},'_ENSO_package_amplitude_total',first_name2{one},'.mat']);
bin_std_nino34_ndj = data.bin_std_nino34_ndj;
data_name = data.xtick_name;

clear metric_enso_amp
for i1 = 1:length(bin_std_nino34_ndj)-1
    metric_enso_amp(i1,1) = abs((bin_std_nino34_ndj(i1+1) - bin_std_nino34_ndj(1))/bin_std_nino34_ndj(1));
end

save([aimpath2,first_name{one},'_ENSO_package_amplitude_metric_total',first_name2{one},'.mat'],'metric_enso_amp');

FontSize = 18; 
FontSize2 = 15;
FontName = 'Arial';
LW = 5;% lines

close all

fig1 = metric_enso_amp;
h = boxchart(fig1);
hold on
scatter(1.1,fig1(1),72,[0,0,0],'<','filled');

if one == 1
    ytick = 0:0.1:0.5;
elseif one == 2
    ytick = 0:0.1:0.6;
end

clear ytick_name
ytick_name{1} = 'ref';
for i1 = 2:length(ytick)
    ytick_name{i1} = num2str(ytick(i1));
end
ylim([ytick(1),ytick(end)])

set(gca,'xtick',[],'ytick',ytick,'yticklabel',ytick_name,'FontSize',FontSize,'FontName',FontName);
title('(b) Metric','FontSize',FontSize,'FontName',FontName);
text(1.25,fig1(1),'CESM','FontSize',FontSize2,'FontName',FontName);
% xlabel('Amplitude','FontSize',FontSize,'FontName',FontName)
%%
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 2 5],'color',[1 1 1],'PaperOrientation','landscape');
print('-djpeg','-r1000',[figpath,'.jpg']);
print('-dpdf','-r1000',[figpath,'.pdf']);
