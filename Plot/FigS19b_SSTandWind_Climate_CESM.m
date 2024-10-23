clc;clear;

one = 2;% 1:SST and Wind;2:Only SST
first_name = {'SSTandWind','SST'};

aimpath = ['F:\2023PMM_Work\Figures_for_Publish\Figure\FigS19_',first_name{one},'_Climate\'];
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end
load('F:\CESM_Work\Data_CESM\Control_Run\SST_Global_Monthly_Ctrl_1to100yr.mat');
data2 = load('F:\CESM_Work\Data_CESM\Control_Run_CAM\Wind_Global_Monthly_Ctrl_1to100yr_CAM.mat');

yr_box = [1,99];
fig_name = 'CESM';

a1 = date(:,1) >= yr_box(1) & date(:,1) <= yr_box(2);
date = date(a1,:);
sst = sst(:,:,a1);

a2 = data2.date(:,1) >= date(1,1) & data2.date(:,1) <= date(end,1);
u10m = data2.uvel(:,:,a2);
v10m = data2.vvel(:,:,a2);

sst_cli = mean(sst,3);
u10_cli = mean(u10m,3)';
v10_cli = mean(v10m,3)';
clear sst u10m v10m data2

pathfig = [aimpath,'FigS19_2_',first_name{one},'_Cli_',fig_name,'_',num2str(date(1,1)),'to',num2str(date(end,1))]
%%
lon_start = 120;
lon_end = 360-80;
lat_start = -30;
lat_end = 30;

% a = (lon_end-lon_start)/(lat_end-lat_start);
% a = ceil(a*10)/10;
% PaperPosition = [0 0 a 1]*4;
PaperPosition = [-0.25 0 9 4];

FontSize = 25;% Figure
FontSize2 = 10;% contour
FontName = 'Arial';
LW = 1;% figure
LW2 = 0.5;% Line
LW3 = 0.5;% quiver

plot_lon = lon_start:30:lon_end;
plot_lat = lat_start:15:lat_end;
clear text_lon text_lat
for i = 1:length(plot_lon)
    if plot_lon(i)< 180
        text_lon{i} =[num2str(plot_lon(i)),'��E'];
    elseif plot_lon(i) == 180
        text_lon{i} =[num2str(plot_lon(i)),'��'];
    elseif plot_lon(i) > 180
        text_lon{i} =[num2str(360-plot_lon(i)),'��W'];
    end
end
for i = 1:length(plot_lat)
    if plot_lat(i)< 0
        text_lat{i} =[num2str(-plot_lat(i)),'��S'];
    elseif plot_lat(i) == 0
        text_lat{i} =[num2str(plot_lat(i)),'��'];
    elseif plot_lat(i) > 0
        text_lat{i} =[num2str(plot_lat(i)),'��N'];
    end
end

cbar1 = 16;
cbar2 = 32;
cb_RedBlue = input_colorbar_rgb('F:\2023PMM_Work\bin_data\colorbar\cb_SST.rgb')/255;
cb_RedBlue = cb_RedBlue(65:end,:);
%%
% set(0,'DefaultFigureVisible', 'off');
fig1 = sst_cli';
fig3 = u10_cli';
fig4 = v10_cli';

close all;
m_proj('miller','lon',[lon_start,lon_end],'lat',[lat_start,lat_end]);
m_gshhs_l('patch',[0.7 0.7 0.7],'edgecolor','none');
m_grid('linest','none','linewidth',LW,'tickdir','out','Xtick',[],'Ytick',[],'FontName',FontName,'FontSize',FontSize);
hold on

[cs,h] = m_contourf(lon,lat,fig1,'levelstep',0.5);
[cs2,h2] = m_contour(lon,lat,fig1,'levelstep',2,'LineStyle','-','color',[0,0,0],'LineWidth',LW2);
% [cs3,h3] = m_contour(lon,lat,fig1,[28,28],'LineStyle','-','color',[0,0,0],'LineWidth',LW2*4);


m_proj('miller','lon',[lon_start,lon_end],'lat',[lat_start,lat_end]);
m_gshhs_l('patch',[0.7 0.7 0.7],'edgecolor','none');
m_grid('linest','none','linewidth',LW,'tickdir','out','Xtick',[],'Ytick',[],'FontName',FontName,'FontSize',FontSize);

for i2 = 1:length(plot_lon)
    m_plot([plot_lon(i2),plot_lon(i2)],[lat_start,lat_start+2],'color',[0,0,0],'LineWidth',LW);
    m_plot([plot_lon(i2),plot_lon(i2)],[lat_end-2,lat_end],'color',[0,0,0],'LineWidth',LW);
end
for i2 = 1:length(plot_lat)
    m_plot([lon_start,lon_start+2],[plot_lat(i2),plot_lat(i2)],'color',[0,0,0],'LineWidth',LW);
    m_plot([lon_end-2,lon_end],[plot_lat(i2),plot_lat(i2)],'color',[0,0,0],'LineWidth',LW);
end
% for i2 = 1:length(plot_lon)
%     m_text(plot_lon(i2)-5,lat_start-5,text_lon{i2},'FontName',FontName,'FontSize',FontSize);
% end
% for i2 = 1:length(plot_lat)
%     a = -15;
%     if plot_lat(i2) == 0
%         a = a+6;
%     end
%     m_text(lon_start+a,plot_lat(i2),text_lat{i2},'FontName',FontName,'FontSize',FontSize);
% end

if one == 1
    [X,Y] = meshgrid(lon,lat);
    d_num = 7;
    h5 = m_quiver(X(1:d_num:end,1:d_num:end),Y(1:d_num:end,1:d_num:end)...
        ,fig3(1:d_num:end,1:d_num:end),fig4(1:d_num:end,1:d_num:end),'color',[0,0,0]...
        ,'LineStyle','-','LineWidth',LW3,'ShowArrowHead','on','AutoScale','off');
    rectangle('Position',[-1.38,-0.53,0.25,0.15],'Curvature',[0,0],'FaceColor',[1,1,1]);
    h6 = m_quiver(lon_start+2,lat_start+7,5,0,'color',[0,0,0]...
        ,'LineStyle','-','LineWidth',LW3,'ShowArrowHead','on','AutoScale','off');
    m_text(lon_start+2,lat_start+4,'5m/s','FontName',FontName,'FontSize',FontSize);
end
set(h,'LineColor','none');
set(h2,'ShowText','on','TextStep',get(h2,'LevelStep')*2);
% set(h3,'ShowText','on','TextStep',get(h3,'LevelStep')*2);
clabel(cs2,h2,'FontName',FontName,'fontsize',FontSize2);
% clabel(cs3,h3,'FontName',FontName,'fontsize',FontSize2);

ax = gca;
colormap(ax,cb_RedBlue)
% colorbar('FontName',FontName,'FontSize',FontSize);
% colorbar('horiz','FontName',FontName,'FontSize',FontSize);
caxis([cbar1,cbar2]);

% m_text(lon_end+42,-15,'SST[��C]','rotation',90,'FontName',FontName,'FontSize',FontSize);
m_text(lon_start,lat_end+5,['(2) ',fig_name],'FontName',FontName,'FontSize',FontSize);
%%
set(gcf,'PaperUnits','inches','PaperPosition',PaperPosition,'color',[1 1 1]);
print('-djpeg','-r1000',[pathfig,'.jpg']);
print('-dpdf','-r1000',[pathfig,'.pdf']);
