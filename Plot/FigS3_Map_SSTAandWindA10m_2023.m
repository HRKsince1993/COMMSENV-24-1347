clc;clear
two = 1;% 1:raw;2:detrend
three = 6;% Colorbar 1 to 6
four = 1;% plot 1:tropical;2:global
five = 1;% 1:no colorbar;2:colorbar
fifth_name = {[],'Colorbar_'};

load(['G:\ENSO_Work\Data_ENSO\SSTA_Global_Monthly_ERA5_1979to2023.mat']);
% load(['F:\ENSO_Work\Data_ENSO\TauAxy_Tropical_Monthly_ERA5_Averaged_1979to2023.mat']);
load(['G:\ENSO_Work\Data_ENSO\WindA10m_Global_Monthly_ERA5_Averaged_1979to2023.mat']);

aimpath = ['F:\2023PMM_Work\Figures_for_Publish\Figure\FigS3_Map_SSTAandWindA10m_2023\Color',num2str(three),'\'];
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end

switch two
    case 1
        a = date(:,1) >= 2023;
        date = date(a,:);
        ssta = ssta(:,:,a);
        u10a = u10a(:,:,a);
        v10a = v10a(:,:,a);
        second_name = [];
        second_name2 = [];
    case 2
        a = date(:,1) >= 2022;
        date = date(a,:);
        ssta = ssta_detrend(:,:,a);
        u10a = u10a_detrend(:,:,a);
        v10a = v10a_detrend(:,:,a);
        second_name = '_Detrend';
        second_name2 = ' after detrending';
end
%%
lon_start = 0;
lon_end = 360;
if four == 1 % tropics
    lat_start = -35;
    lat_end = 35;
    if five == 1
        PaperPosition = [-0.5 0 9 2];
    elseif five == 2
        PaperPosition = [-0.5 0 9 3];
    end
    ly_color = -20;
    ly_text = 7;
    lq_position = [-3.07,0.34,0.43,0.25];
    % lq_position = [-3.07,0.358,0.45,0.25];
    lq_lon = 5;
    lq_lat = 30;
    len_plot_lon = 3;
elseif four == 2 % globe
    lat_start = -60;
    lat_end = 60;
    PaperPosition = [0 0 10 4];
    ly_color = -25;
    ly_text = 9;
    lq_position = [2.58,-1.18,0.55,0.25];
    lq_lon = 360-30;
    lq_lat = -50;
end

% a = (lon_end-lon_start)/(lat_end-lat_start);
% a = ceil(a*10)/10;
% PaperPosition = [0 0 a 1]*4;

FontSize = 15;
FontSize2 = 15;
FontSize3 = 12;
FontName = 'Arial';

plot_lon = 0:60:360;
plot_lat = -30:15:30;
clear text_lon text_lat
for i = 1:length(plot_lon)
    if plot_lon(i) == 0
        text_lon{i} =[num2str(plot_lon(i)),'¡ã'];
    elseif plot_lon(i) < 180
        text_lon{i} =[num2str(plot_lon(i)),'¡ãE'];
    elseif plot_lon(i) == 180
        text_lon{i} =[num2str(plot_lon(i)),'¡ã'];
    elseif plot_lon(i) > 180 && plot_lon(i) < 360
        text_lon{i} =[num2str(360-plot_lon(i)),'¡ãW'];
    elseif plot_lon(i) == 360
        text_lon{i} =[num2str(360-plot_lon(i)),'¡ã'];
    elseif plot_lon(i) > 360 && plot_lon(i) < 360+180
        text_lon{i} =[num2str(plot_lon(i)-360),'¡ãE'];
    elseif plot_lon(i) == 360+180
        text_lon{i} =[num2str(plot_lon(i)-360),'¡ã'];
    end
end
for i = 1:length(plot_lat)
    if plot_lat(i)< 0
        text_lat{i} =[num2str(-plot_lat(i)),'¡ãS'];
    elseif plot_lat(i) == 0
        text_lat{i} =[num2str(plot_lat(i)),'¡ã'];
    elseif plot_lat(i) > 0
        text_lat{i} =[num2str(plot_lat(i)),'¡ãN'];
    end
end

k_scale = 3;
LW = 1;% lines
LW2 = 3;% contour
LW3 = 0.5;% quiver
LW4 = 3;% contour

text_letter = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n'};
text_month = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','Jan/24','Feb'};

cbar = 3.55;
lv_sst = 0.1;
if three == 1
    cb_RedBlue = input_colorbar_rgb('F:\PMM_For_Paper\colorbar\cb_RedBlue_SST.rgb')/255;
elseif three == 2
    cb_RedBlue = input_colorbar_rgb('F:\PMM_For_Paper\colorbar\cb_RedBlue_SST.rgb')/255;
    cb_RedBlue(13:14,:) = ones(2:3);
    cb_RedBlue = cb_RedBlue(4:end-3,:);
    for i2 = 3:-1:0
        cb_RedBlue(end-i2,:) = cb_RedBlue(end-i2-1,:)*0.8+cb_RedBlue(end-i2,:)*0.2;
    end
elseif three == 3
    cb_RedBlue = input_colorbar_rgb('F:\PMM_For_Paper\colorbar\cb_RedBlue_SST52.rgb')/255;
    cb_RedBlue(26:27,:) = ones(2,3);
elseif three == 4 
    cb_RedBlue = input_colorbar_rgb('F:\PMM_For_Paper\colorbar\cb_RedBlue_SST104.rgb')/255;
    cb_RedBlue(52:53,:) = ones(2,3);
elseif three == 5 
    cb_RedBlue = input_colorbar_rgb('F:\PMM_For_Paper\colorbar\cb_RedBlue_SST.rgb')/255;
    cb_RedBlue(13:14,:) = ones(2:3);
    % cb_RedBlue(24,:) = cb_RedBlue(23,:)*0.6+cb_RedBlue(24,:)*0.4;
    cb_RedBlue = cb_RedBlue(1+1:end-1,:);
    for i2 = 4:-1:0
        cb_RedBlue(end-i2,:) = cb_RedBlue(end-i2-1,:)*0.8+cb_RedBlue(end-i2,:)*0.2;
    end
elseif three == 6
    cbar = 3.55;
    lv_ssta = 0.2;
    cb_RedBlue = input_colorbar_rgb('F:\PMM_For_Paper\colorbar\cb_RedBlue_SST.rgb')/255;
    cb_RedBlue(13:14,:) = ones(2:3);
    % cb_RedBlue(24,:) = cb_RedBlue(23,:)*0.6+cb_RedBlue(24,:)*0.4;
    cb_RedBlue = cb_RedBlue(1+1:end-1,:);
    for i2 = 4:-1:0
        cb_RedBlue(end-i2,:) = cb_RedBlue(end-i2-1,:)*0.8+cb_RedBlue(end-i2,:)*0.2;
    end
end
% set(0,'DefaultFigureVisible', 'off');

color_plot = [151,137,246 ...% À¶×ÏÉ«1
    ;75,0,192 ...% 1À¶×ÏÉ«
    ;121,139,113 ...% 4ÄªÀ¼µÏÉ«
    ;1,132,127 ...% 5Âí¶ûË¹ÂÌ
    ;0,46,166 ...% 2¿ËÀ³ÒòÀ¶
    ;252,218,94 ...% 6ÄÃÆÂÀï»Æ
    ;1,62,119 ...% 7ÆÕÂ³Ê¿À¶
    ;183,127,112 ... % 8ÄªÀ¼µÏ×Ø
    ;212,183,173 ...% 9ÄªÀ¼µÏ³È
    ;255,0,255]/255;
%%
a = lon >= lon_start & lon <= lon_end;
b = lat >= lat_start & lat <= lat_end;
lon = lon(a);
lat = lat(b);

bin_fig1 = ssta(a,b,:);
bin_fig3 = u10a(a,b,:)*k_scale;
bin_fig4 = v10a(a,b,:)*k_scale;

if five == 1
    k_select = 1:2:12;
else
    k_select = 9;
end
for i1 = 1:length(k_select)
    fig1 = bin_fig1(:,:,k_select(i1))';
    fig3 = bin_fig3(:,:,k_select(i1))';
    fig4 = bin_fig4(:,:,k_select(i1))';
    
    close all;
    m_proj('miller','lon',[lon_start,lon_end],'lat',[lat_start,lat_end]);
    m_gshhs_l('patch',[0.7 0.7 0.7],'edgecolor','none');
    m_grid('linest','none','linewidth',LW,'tickdir','out','Xtick',[],'Ytick',[],'FontName',FontName,'FontSize',FontSize);
    
    hold on;
    
    [X,Y] = meshgrid(lon,lat);
    [cs,h] = m_contourf(lon,lat,fig1,'levelstep',lv_ssta);
    
    d_num = 7;
    h5 = m_quiver(X(1:d_num:end,1:d_num:end),Y(1:d_num:end,1:d_num:end)...
        ,fig3(1:d_num:end,1:d_num:end),fig4(1:d_num:end,1:d_num:end),'color',[0,0,0]...
        ,'LineStyle','-','LineWidth',LW3,'ShowArrowHead','on','AutoScale','off');
    
    % if i1 == length(k_select)
        rectangle('Position',lq_position,'Curvature',[0,0],'FaceColor',[1,1,1]);
        h6 = m_quiver(lq_lon,lq_lat,1*k_scale,0,'color',[0,0,0]...
            ,'LineStyle','-','LineWidth',LW3,'ShowArrowHead','on','AutoScale','off');
        m_plot([lq_lon+1*k_scale+1,lq_lon+1*k_scale-1],[lq_lat,lq_lat-1],'Color',[0,0,0],'LineStyle','-','LineWidth',LW3)
        m_plot([lq_lon+1*k_scale+1,lq_lon+1*k_scale-1],[lq_lat,lq_lat+1],'Color',[0,0,0],'LineStyle','-','LineWidth',LW3)
        m_text(lq_lon-1,lq_lat-4,'1m s^{-1}','FontName',FontName,'FontSize',FontSize3);
    % end
    
    set(h,'LineColor','none');
    

    for i2 = 1:length(plot_lon)
        m_plot([plot_lon(i2),plot_lon(i2)],[lat_start,lat_start+len_plot_lon],'color',[0,0,0],'LineWidth',LW);
        m_plot([plot_lon(i2),plot_lon(i2)],[lat_end-len_plot_lon,lat_end],'color',[0,0,0],'LineWidth',LW);
    end
    for i2 = 1:length(plot_lat)
        m_plot([lon_start,lon_start+len_plot_lon],[plot_lat(i2),plot_lat(i2)],'color',[0,0,0],'LineWidth',LW);
        m_plot([lon_end-len_plot_lon,lon_end],[plot_lat(i2),plot_lat(i2)],'color',[0,0,0],'LineWidth',LW);
    end
    
    if five == 1
        if i1 == 6
            for i2 = 1:length(plot_lon)
                if  plot_lon(i2) == 0 || plot_lon(i2) == 360
                    m_text(plot_lon(i2)-3,lat_start-8,text_lon{i2},'FontName',FontName,'FontSize',FontSize);
                else
                    m_text(plot_lon(i2)-8,lat_start-8,text_lon{i2},'FontName',FontName,'FontSize',FontSize);
                end
            end
        end
        
        
        for i2 = 1:length(plot_lat)
            a = -32;
            if plot_lat(i2) == 0
                a = a+7;
            end
            m_text(lon_start+a,plot_lat(i2),text_lat{i2},'FontName',FontName,'FontSize',FontSize);
        end
    end

    % NETP
    lon_point1 = [360-135,360-160];
    lat_point1 = [30,10];
    lon_point2 = [360-110,360-115];
    lat_point2 = [15,10];
    
    m_plot([lon_point2(1),lon_point1(1)],[lat_point1(1),lat_point1(1)],'color',color_plot(1,:),'LineWidth',LW4)
    m_plot([lon_point1(1),lon_point1(2)],[lat_point1(1),lat_point1(2)],'color',color_plot(1,:),'LineWidth',LW4)
    m_plot([lon_point1(2),lon_point2(2)],[10,10],'color',color_plot(1,:),'LineWidth',LW4)
    m_plot([lon_point2(2),lon_point2(1)],[lat_point2(2),lat_point2(1)],'color',color_plot(1,:),'LineWidth',LW4)
    m_plot([lon_point2(1),lon_point2(1)],[lat_point2(1),lat_point1(1)],'color',color_plot(1,:),'LineWidth',LW4)
    
    % SETP
    lon_point = [360-120,360-70];
    lat_point = [-30,-10];% SEP
    
    m_plot([lon_point(2),lon_point(1)],[lat_point(2),lat_point(2)],'color',color_plot(2,:),'LineWidth',LW4)
    m_plot([lon_point(1),lon_point(1)],[lat_point(2),lat_point(1)],'color',color_plot(2,:),'LineWidth',LW4)
    m_plot([lon_point(1),lon_point(2)],[lat_point(1),lat_point(1)],'color',color_plot(2,:),'LineWidth',LW4)
    m_plot([lon_point(2),lon_point(2)],[lat_point(1),lat_point(2)],'color',color_plot(2,:),'LineWidth',LW4)
    
    % tio
    lon_point2 = [98,108];% Ó¡¶ÈÑó²¿·Ö
    lat_point2 = [10,-8];
    a_ch2 = (lat_point2(1)-lat_point2(2))/(lon_point2(1)-lon_point2(2));
    b_ch2 = lat_point2(1)-a_ch2*lon_point2(1);
    
    m_plot([30,(30-b_ch2)/a_ch2],[30,30],'color',color_plot(10,:),'LineWidth',LW4)
    m_plot([30,30],[-30,30],'color',color_plot(10,:),'LineWidth',LW4)
    m_plot([30,(-30-b_ch2)/a_ch2],[-30,-30],'color',color_plot(10,:),'LineWidth',LW4)
    m_plot([(-30-b_ch2)/a_ch2,(30-b_ch2)/a_ch2],[-30,30],'color',color_plot(10,:),'LineWidth',LW4)
    
    % NTA
    lon_point1 = [360-91,360-80];% Ä«Î÷¸çÍå
    lat_point1 = [15,7.5];
    a_ch = (lat_point1(1)-lat_point1(2))/(lon_point1(1)-lon_point1(2));
    b_ch = lat_point1(1)-a_ch*lon_point1(1);
    
    lon_point2 = 360-50;% ÄÏÃÀÑØ°¶
    lat_point2 = lon_point2*a_ch+b_ch;
    
    m_plot([(20-b_ch)/a_ch,360],[30,30],'color',color_plot(4,:),'LineWidth',LW4)
    m_plot([(20-b_ch)/a_ch,(20-b_ch)/a_ch],[20,30],'color',color_plot(4,:),'LineWidth',LW4)
    m_plot([(20-b_ch)/a_ch,lon_point2],[20,lat_point2],'color',color_plot(4,:),'LineWidth',LW4)
    m_plot([lon_point2,lon_point2],[-30,lat_point2],'color',color_plot(4,:),'LineWidth',LW4)
    m_plot([lon_point2,360],[-30,-30],'color',color_plot(4,:),'LineWidth',LW4)
    
    m_plot([0,20],[-30,-30],'color',color_plot(4,:),'LineWidth',LW4)
    m_plot([20,20],[-30,10],'color',color_plot(4,:),'LineWidth',LW4)
    m_plot([0,20],[10,10],'color',color_plot(4,:),'LineWidth',LW4)

    %
    ax = gca;
    colormap(ax,cb_RedBlue)
    caxis([-cbar,cbar])
    
    if five == 1
        %     colorbar('FontName',FontName,'FontSize',FontSize)
        %     m_text(lon_end+45,ly_color,'SST[¡æ]','rotation',90,'FontName',FontName,'FontSize',FontSize);
    elseif five == 2
        colorbar('horiz','position',[0.13,0.13,0.78,0.04],'FontName',FontName,'FontSize',FontSize);
%         m_text(lon_end+10,lat_start-5,'SST[¡æ]','FontName',FontName,'FontSize',FontSize);
    end
    %     colormap(b2r(-bar,bar))
    
    %     m_text(120,-28,['lead(',num2str(i-n_fig),')'],'FontName',FontName,'FontSize',FontSize2);
    % m_text(lon_start,lat_end+ly_text,'(a) Anomalous SST&U10','FontName',FontName,'FontSize',FontSize2);
    title([text_month{k_select(i1)}],'FontName',FontName,'FontSize',FontSize2);
    m_text(lon_start,lat_end+ly_text,['(',text_letter{i1},')'],'FontName',FontName,'FontSize',FontSize2);
    %%
    pathfig = [aimpath,fifth_name{five},'FigS3',text_letter{i1},'_',text_month{k_select(i1)},'_Map_SSTAandWindA_2023_Color',num2str(three)];
    set(gcf,'PaperUnits','inches','PaperPosition',PaperPosition,'color',[1 1 1],'PaperOrientation','landscape');
    print('-dpdf','-r1000',[pathfig,'.pdf']);
    print('-djpeg','-r1000',[pathfig,'.jpg']);
end