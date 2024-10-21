clc;clear
aimpath = 'F:\2023PMM_Work\Figures_for_Publish\Figure\FigS1_Var_ATAandSSTA_Monthly\';
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end
pathfig = [aimpath,'FigS1a_Var_ATAandSSTA_Monthly'];

FontSize = 20;
FontName = 'Arial';
LW = 2;% lines

data1 = load('F:\2023PMM_Work\Figures_for_Response\bin_data\Area_TempA2m_Global_Monthly.mat');
data2 = load('G:\ENSO_Work\bin_data\Var_AreaSSTA_Nino34_Monthly_ERA5_1979to2023.mat');
% data2 = load('G:\ENSO_Work\bin_data\Var_AreaSSTA_Nino34_Monthly_Hadley_1979to2023.mat');

date = data1.date;
fig1 = data1.area_ta2m;% Global
fig2 = data2.area_ssta;% ENSO
%%
fig1 = fig1/std(fig1);
fig2 = fig2/std(fig2);
cor1 = corrcoef(fig1,fig2);
%%
cbar = 4;

color_plot = [215,0,15 ...% 中国红
    ;0,46,166 ...% 克莱因蓝
    ;121,139,113 ...% 莫兰迪色
    ;1,132,127 ...% 马尔斯绿
    ;1,62,119 ...% 普鲁士蓝
    ;252,218,94 ...% 拿坡里黄
    ;255,119,15]/255;% 爱马仕橙

legend_name = {'GMST','NINO3.4'};
%%
close all;

h1 = plot(fig1,'LineWidth',LW,'color',color_plot(1,:),'LineStyle','-');
hold on
h2 = plot(fig2,'LineWidth',LW,'color',color_plot(2,:),'LineStyle','-');

a1 = find(date(:,1) == 2023 & date(:,2) == 1);
h3 = plot([a1,a1],[-cbar,cbar],'LineWidth',LW,'color',[0.7,0.7,0.7],'LineStyle','--');
h4 = plot(fig1,'LineWidth',LW,'color',color_plot(1,:),'LineStyle','-');
h5 = plot(fig2,'LineWidth',LW,'color',color_plot(2,:),'LineStyle','-');

grid on;
ylim([-cbar,cbar]);
xlim([0,size(date,1)]);

xtick = 13:12*5:size(date,1);
xtick = [xtick,xtick(end)+3*12];
xticklabel = {date(13:12*5:end,1);'     2023'};
set(gca,'xtick',xtick,'xticklabel',xticklabel,'ytick',-cbar:2:cbar,'FontSize',FontSize,'FontName',FontName);
xtickangle(0)

text_x1 = (2000-1979)*12+1;text_x2 = (2010-1979)*12+1;
rectangle('Position',[text_x1,-3.5,12*20,1],'Curvature',[0,0],'FaceColor',[1,1,1]);
plot([text_x1+5,text_x1+35],[-3,-3],'LineWidth',LW,'color',color_plot(1,:))
text(text_x1+37,-3,legend_name{1},'FontSize',FontSize,'FontName',FontName);
plot([text_x2,text_x2+30],[-3,-3],'LineWidth',LW,'color',color_plot(2,:))
text(text_x2+32,-3,legend_name{2},'FontSize',FontSize,'FontName',FontName);
% legend(legend_name,'Location','SouthWest','FontSize',FontSize,'FontName',FontName);
ylabel('Anomaly','FontSize',FontSize,'FontName',FontName);

text(1,4.45,'(a)','FontSize',FontSize,'FontName',FontName);
% text(10,-1.3,['Cor = ',num2str(cor1(2),'%2.2f')],'FontSize',FontSize,'FontName',FontName);
%%
set(gcf,'PaperUnits','inches','PaperPosition',[-0.5 0 9 4],'color',[1 1 1],'PaperOrientation','landscape');
print('-djpeg','-r1000',[pathfig,'.jpg']);
print('-dpdf','-r1000',[pathfig,'.pdf']);