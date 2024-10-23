clc;clear;

one = 2;% From 1:Han;2:Chen
first_name = {'SSTandWind','SST'};
first_name2 = {'Han','Chen'};

aimpath = ['F:\2023PMM_Work\Figures_for_Publish\Figure\FigS19_',first_name{one},'_Climate\'];
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end

switch one
    case 1
        load('F:\2023PMM_Work\Figures_for_Response\Han_List_CMIP_Name29.mat');
    case 2
        load('F:\2023PMM_Work\Figures_for_Response\Chen_List_CMIP_Name37.mat');
end

letter_month = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};
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
        text_lon{i} =[num2str(plot_lon(i)),'буE'];
    elseif plot_lon(i) == 180
        text_lon{i} =[num2str(plot_lon(i)),'бу'];
    elseif plot_lon(i) > 180
        text_lon{i} =[num2str(360-plot_lon(i)),'буW'];
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

cbar1 = 16;
cbar2 = 32;
cb_RedBlue = input_colorbar_rgb('F:\2023PMM_Work\bin_data\colorbar\cb_SST.rgb')/255;
cb_RedBlue = cb_RedBlue(65:end,:);
%%
set(0,'DefaultFigureVisible', 'off');
for i1 = 1:length(list_name)
    load(['G:\CMIP\Data_CMIP_',first_name2{one},'\SST_Climate\SST_Climate_',list_name{i1},'_1900to2014.mat']);
    fig_name = list_name{i1};
    if one == 1
        sst_cli = sst_climate;
    elseif one == 2
        sst_cli = sst_climate';
    end
    
    pathfig = [aimpath,'FigS19_',num2str(i1+2),'_',first_name{one},'_Cli_',fig_name,'_',num2str(date(1,1)),'to',num2str(date(end,1))];
    %%
    fig1 = sst_cli';
    
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
    
    if i1 > length(list_name)-4
        for i2 = 1:length(plot_lon)
            m_text(plot_lon(i2)-5,lat_start-5,text_lon{i2},'FontName',FontName,'FontSize',FontSize);
        end
    end
    
    if mod(i1,4) == 3
        for i2 = 1:length(plot_lat)
            a = -20;
            if plot_lat(i2) == 0
                a = a+4;
            end
            m_text(lon_start+a,plot_lat(i2),text_lat{i2},'FontName',FontName,'FontSize',FontSize);
        end
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

    % m_text(lon_end+42,-15,'SST[буC]','rotation',90,'FontName',FontName,'FontSize',FontSize);
    m_text(lon_start,lat_end+5,['(',num2str(i1+2),') ',fig_name],'FontName',FontName,'FontSize',FontSize);
    %%
    set(gcf,'PaperUnits','inches','PaperPosition',PaperPosition,'color',[1 1 1]);
    % print('-djpeg','-r1000',[pathfig,'.jpg']);
    print('-dpdf','-r1000',[pathfig,'.pdf']);
end