clc;clear
aimpath = 'F:\2023PMM_Work\Figures_for_Publish\Figure\Fig3_Map_SSTAandWindA_2023\';
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end

pathfig = [aimpath,'Fig3b_VarBar_SSTA_Monthly_ERA5_2023'];

data1= load('F:\2023PMM_Work\bin_data\SEP_SSTA_ERA5_1979to2023.mat');% SETP
data2 = load('F:\2023PMM_Work\bin_data\Mask_TIO_lg_SSTA_ERA5_1979to2023.mat');% TIO_lg
data3 = load('F:\2023PMM_Work\bin_data\Mask_NTA_lg_SSTA_ERA5_1979to2023.mat');% NTA_lg
data4 = load('F:\2023PMM_Work\bin_data\Mask_NETP_New_SSTA_ERA5_1979to2023.mat');% PMM

date = data1.date;
sep = data1.area_ssta;
tio = data2.area_ssta;
nta = data3.area_ssta;
pmm = data4.area_ssta;

a = date(:,1) >= 2023;
fig1 = [pmm(a),sep(a),tio(a),nta(a)];

% legend_name = {'NETP','SETP','TIO','TA'};
legend_name1 = {'Northeastern tropical Pacific','Southeastern tropical Pacific'};
legend_name2 = {'Tropical Indian Ocean','Tropical Atlantic'};
%%
FontSize = 15;
FontName = 'Arial';
LW = 5;% lines
BarWidth = 0.15;

text_month = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','Jan(1)','Feb(1)'};

color_plot = [151,137,246 ...% 蓝紫色1
             ;75,0,192 ...% 1蓝紫色
             ;255,0,255 ...
             ;1,132,127]/255;% 5马尔斯绿 
%%
close all;

hold on
for i1 = 1:size(fig1,2)
    h1 = bar([1:size(fig1,1)]+(i1-2.5)*BarWidth,fig1(:,i1),'BarWidth',BarWidth,'FaceColor',color_plot(i1,:));
end

box on
grid on;
% ylim([-0.3,1.3]);
ylim([-0.5,1.5]);
xlim([0.5,length(fig1)+0.5]);

l_start = 1;l_space = 5.5;l_line = 0.7;l_y = 0.43;
rectangle('Position',[l_start-0.15,1.4-l_y,11,0.43],'Curvature',[0,0],'FaceColor',[1,1,1]);
for i1 = 1:length(legend_name2)
    rectangle('Position',[l_start+l_space*(i1-1),1.5-l_y,l_line,0.05],'Curvature',[0,0],'FaceColor',color_plot(i1+2,:));
    text(l_line+l_start+l_space*(i1-1)+0.1,1.52-l_y,legend_name2{i1},'FontSize',FontSize,'FontName',FontName,'Interpreter','None');
end

l_y2 = l_y - 0.2;
for i1 = 1:length(legend_name1)
    rectangle('Position',[l_start+l_space*(i1-1),1.5-l_y2,l_line,0.05],'Curvature',[0,0],'FaceColor',color_plot(i1,:));
    text(l_line+l_start+l_space*(i1-1)+0.1,1.52-l_y2,legend_name1{i1},'FontSize',FontSize,'FontName',FontName,'Interpreter','None');
end

set(gca,'xtick',1:length(fig1),'xticklabel',text_month,'ytick',-0.3:0.3:1.5,'FontSize',FontSize,'FontName',FontName);
xtickangle(0)
% legend(legend_name,'Location','NorthWest');
xlabel('2023','FontSize',FontSize,'FontName',FontName);
ylabel('SST anomaly','FontSize',FontSize,'FontName',FontName);

text(0.5,1.62,['(b)'],'FontSize',FontSize,'FontName',FontName);
title('Monthly evolution','FontSize',FontSize,'FontName',FontName);

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 9 3],'color',[1 1 1],'PaperOrientation','landscape');
print('-dpdf','-r1000',[pathfig,'.pdf']);
print('-djpeg','-r1000',[pathfig,'.jpg']);