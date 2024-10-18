clc;clear;
aimpath = 'F:\2023PMM_Work\Figures_for_Publish\Figure\FigS5_Mask_Region\';
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end

one = 1;% 1:global
first_name = {'Global'};
first_name2 = {'f'};

load(['F:\2023PMM_Work/bin_data/Mask_Tropics_Turn.mat']);
data2 = load(['F:\2023PMM_Work/bin_data/Mask_NTAlg2.mat']);
data3 = load(['F:\2023PMM_Work/bin_data/Mask_NTAlg3.mat']);
data4 = load(['F:\2023PMM_Work/bin_data/Mask_NTAlg4.mat']);
data5 = load(['F:\2023PMM_Work/bin_data/Mask_SEP.mat']);
data6 = load(['F:\2023PMM_Work/bin_data/Mask_TIOlg2.mat']);
data7 = load(['F:\2023PMM_Work/bin_data/Mask_NETP_New.mat']);
mask_region2 = data2.mask_region + data3.mask_region + data4.mask_region + data5.mask_region + data6.mask_region + data7.mask_region;
pathfig = [aimpath,'FigS5',first_name2{one},'_Mask_TroAnd',first_name{one}];

mask_region = -mask_region;
mask_region2(mask_region2 < 1 & mask_region2 > 0) = 0.5;
a = mask_region2 > 0;
mask_region(a) = mask_region2(a);
mask_region(mask_region == 0) = nan;

a = lat >= 45;
mask_region(:,a) = -1;
% mask_region(abs(mask_region)<1) = 0.5;

fig_lon = cat(1,lon,lon+360);
fig1_mask_region = cat(1,mask_region,mask_region);
%%
% lon_start = 0;
% lon_end = 360;
lon_start = 30;
lon_end = 360+30;
lat_start = -35;
lat_end = 35;

% a = (lon_end-lon_start)/(lat_end-lat_start);
% a = ceil(a*10)/10;
% PaperPosition = [0 0 a 1]*4;
PaperPosition = [-0.4 0 9 2];

FontSize = 15;
FontName = 'Arial';
LW = 1;% lines

plot_lon = lon_start:60:lon_end;
plot_lat = -30:15:30;
clear text_lon text_lat
for i = 1:length(plot_lon)
    if plot_lon(i) == 0
        text_lon{i} =[num2str(plot_lon(i)),'бу'];
    elseif plot_lon(i) < 180
        text_lon{i} =[num2str(plot_lon(i)),'буE'];
    elseif plot_lon(i) == 180
        text_lon{i} =[num2str(plot_lon(i)),'бу'];
    elseif plot_lon(i) > 180 && plot_lon(i) < 360
        text_lon{i} =[num2str(360-plot_lon(i)),'буW'];
    elseif plot_lon(i) == 360
        text_lon{i} =[num2str(360-plot_lon(i)),'бу'];
    elseif plot_lon(i) > 360 && plot_lon(i) < 360+180
        text_lon{i} =[num2str(plot_lon(i)-360),'буE'];
    elseif plot_lon(i) == 360+180
        text_lon{i} =[num2str(plot_lon(i)-360),'бу'];
    end
end
for i = 1:length(plot_lat)
    if plot_lat(i)< 0
        text_lat{i} =[num2str(-plot_lat(i)),'буS'];
    elseif plot_lat(i) == 0
        text_lat{i} =[num2str(plot_lat(i)),'бу'];
    elseif plot_lat(i) > 0
        text_lat{i} =[num2str(plot_lat(i)),'буN'];
    end
end
%%
close all;

[cs,h] = m_contourf(fig_lon,lat,fig1_mask_region','levelstep',0.25);

m_proj('miller','lon',[lon_start,lon_end],'lat',[lat_start,lat_end]);
m_gshhs_l('patch',[0.7 0.7 0.7],'edgecolor','none');
m_grid('linest','none','linewidth',LW,'tickdir','out','Xtick',[],'Ytick',[],'FontName',FontName,'FontSize',FontSize);
hold on

for i2 = 1:length(plot_lon)
    m_text(plot_lon(i2)-10,lat_start-6,text_lon{i2},'FontName',FontName,'FontSize',FontSize);
end
for i2 = 1:length(plot_lat)
    a = -32;
    if plot_lat(i2) == 0
        a = a+7;
    end
    m_text(lon_start+a,plot_lat(i2),text_lat{i2},'FontName',FontName,'FontSize',FontSize);
end

for i2 = 1:length(plot_lon)
    m_plot([plot_lon(i2),plot_lon(i2)],[lat_start,lat_start+3],'color',[0,0,0],'LineWidth',LW);
    m_plot([plot_lon(i2),plot_lon(i2)],[lat_end-3,lat_end],'color',[0,0,0],'LineWidth',LW);
end
for i2 = 1:length(plot_lat)
    m_plot([lon_start,lon_start+3],[plot_lat(i2),plot_lat(i2)],'color',[0,0,0],'LineWidth',LW);
    m_plot([lon_end-3,lon_end],[plot_lat(i2),plot_lat(i2)],'color',[0,0,0],'LineWidth',LW);
end

set(h,'LineColor','none');
colormap(b2r(-1,1))
caxis([-1,1]);

% m_text(lon_start,lat_end+5,['(',first_name2{one},') Exp_',first_name{one},' mask'],'FontName',FontName,'FontSize',FontSize,'Interpreter','None');
title(['CESM-TP+G'],'FontName',FontName,'FontSize',FontSize,'Interpreter','None');
m_text(lon_start,lat_end+7.5,['(',first_name2{one},')'],'FontName',FontName,'FontSize',FontSize);
%%
set(gcf,'PaperUnits','inches','PaperPosition',PaperPosition,'color',[1 1 1],'PaperOrientation','landscape');
print('-dpdf','-r1000',[pathfig,'.pdf']);
print('-djpeg','-r1000',[pathfig,'.jpg']);

