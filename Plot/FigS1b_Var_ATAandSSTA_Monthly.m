clc;clear
aimpath = 'F:\2023PMM_Work\Figures_for_Publish\Figure\FigS1_Var_ATAandSSTA_Monthly\';
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end
pathfig = [aimpath,'FigS1b_Var_ATAandSSTA_Monthly_2023'];

FontSize = 20;
FontName = 'Arial';
LW = 5;% lines

data1 = load('F:\2023PMM_Work\Figures_for_Response\bin_data\Area_TempA2m_Global_Monthly.mat');
data2 = load('G:\ENSO_Work\bin_data\Var_AreaSSTA_Nino34_Monthly_ERA5_1979to2023.mat');

date = data1.date;
fig1 = data1.area_ta2m;% Global
fig2 = data2.area_ssta;% ENSO
fig1 = fig1/std(fig1);
fig2 = fig2/std(fig2);

l_month = 7;
a = find( date(:,1) == 2022 & date(:,2) == l_month);
date = date(a:end,:);
fig1 = fig1(a:end);
fig2 = fig2(a:end);
%%
color_plot = [215,0,15 ...% 中国红
    ;0,46,166 ...% 克莱因蓝
    ;121,139,113 ...% 莫兰迪色
    ;1,132,127 ...% 马尔斯绿
    ;1,62,119 ...% 普鲁士蓝
    ;252,218,94 ...% 拿坡里黄
    ;255,119,15]/255;% 爱马仕橙

bin_text_month = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};
text_month = cat(2,bin_text_month(l_month:end),bin_text_month);
text_month{1} = [text_month{1},'/22'];
text_month{12-l_month+2} = 'Jan/23';
legend_name = {'GMST','NINO3.4'};
%%
close all;

h1 = plot(1:length(fig1),fig1,'LineWidth',LW,'color',color_plot(1,:),'LineStyle','-');
hold on
h2 = plot(1:length(fig1),fig2,'LineWidth',LW,'color',color_plot(2,:),'LineStyle','-');

grid on;

xtick = 1:3:length(fig1);
ytick = -4:2:4;

xlim([1,length(fig1)]);
ylim([ytick(1),ytick(end)]);

xticklabel = text_month(xtick);
yticklabel = [];
set(gca,'xtick',xtick,'xticklabel',xticklabel,'ytick',ytick,'yticklabel',yticklabel,'FontSize',FontSize,'FontName',FontName);
xtickangle(0)

legend(legend_name,'Location','SouthEast','FontSize',FontSize,'FontName',FontName);
text(1,4.45,'(b)','FontSize',FontSize,'FontName',FontName);
% text(5.5,4.45,'2023','FontSize',FontSize,'FontName',FontName);
text(length(fig1)-(length(fig1)-1)/36,ytick(1)-(ytick(end)-ytick(1))/13.5,'Dec','FontSize',FontSize,'FontName',FontName);
%%
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 6 4],'color',[1 1 1],'PaperOrientation','landscape');
print('-djpeg','-r1000',[pathfig,'.jpg']);
print('-dpdf','-r1000',[pathfig,'.pdf']);