clc;clear

for one = 1:5 % 1:PMM;2:SEP;3:TIO;4:NTA;5:NTAandTIOandPMMandSEPlg;6:NTAandTIOandPMMandSEPandWWBb
    two = 1;% minus 1:TPCtrl;
    three = 1;% 1:color1;
    five = 1;% 1:no colorbar;2:colorbar
    six = 1;% plot wind 0:No;1:Yes
    
    first_name = {'PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb'};
    first_name2 = {'CESM-TP+NETP','CESM-TP+SETP','CESM-TP+TIO','CESM-TP+TA','CESM-TP+G','CESM-TP+G+WWBs'};
    first_name3 = {'a','b','c','d','e','f'};
    second_name = {'TPCtrl'};
    second_name2 = {'CESM-TP'};
    fourth_name = {'Tropical\',[]};
    fifth_name = {[],'Colorbar_'};

    path1 = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\'];
    struct = dir([path1,'*.mat']);
    name1 = {struct.name}';
    
    aimpath = ['F:\2023PMM_Work\Figures_for_Publish\Figure\FigS9_ComMap_WindDiffCtrl_Average\'];
    if exist(aimpath,'dir')~=7
        mkdir(aimpath);
    end

    lon_start = 0;% lon start of the figure
    lon_end = 360;% lon end of the figure
    lat_start = -35;% lat start of the figure
    lat_end = 35;% lat end of the figure
    plot_lon = lon_start:60:lon_end;% the lon that text
    plot_lat = -30:15:30;% the lat that text
    lat_text_x = -25;% text lat distance from lon_start
    lon_text_x = -8;% text lon distance from lon lines
    lon_text_y = -6;% text lon distance from lat_start
    if five == 2
        PaperPosition = [-0.5 0 9 3];% print size
    else
        PaperPosition = [-0.5 0 9 2];% print size
    end
    ly_color = -25;
    ly_text = 6;% text fig num
    lq_position = [-3.07,0.34,0.43,0.25];
    lq_lon = lon_start+5;% plot
    lq_lat = lat_end-5;
    len_plot_lon = 3;

    len_m = (3:11)-2;% month
    pathfig = [aimpath,fifth_name{five},'FigS9',first_name3{one},'_Com_WindDiff',second_name{two}...
        ,'_Month',num2str(len_m(1)+2),'to',num2str(len_m(end)+2),'_Exp_',first_name{one},'_Color',num2str(three)];
    
    data1 = load([path1,'Compose_SSTdiff',second_name{two},'_Global_Monthly_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-8)...
        ,'_Avr',num2str(len_m(1)+2),'to',num2str(len_m(end)+2),'Mon.mat']);% SSTdiff
    data2 = load([path1,'Compose_Wind_diff',second_name{two},'_Global_Monthly_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-5)...
        ,'_Avr',num2str(len_m(1)+2),'to',num2str(len_m(end)+2),'Mon.mat']);% WindDiff
    data3 = load([path1,'Compose_Precidiff',second_name{two},'_Global_Monthly_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-5)...
        ,'_Avr',num2str(len_m(1)+2),'to',num2str(len_m(end)+2),'Mon.mat']);% PreciDiff
    data4 = load([path1,'Compose_SLPdiff',second_name{two},'_Global_Monthly_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-5)...
        ,'_Avr',num2str(len_m(1)+2),'to',num2str(len_m(end)+2),'Mon.mat']);% SLPdiff

    lon = data1.lon;
    lat = data1.lat;
    precia = data3.precia_ensamble;
    uvela = data2.uvela_ensamble;
    vvela = data2.vvela_ensamble;
    slpa = data4.slpa_ensamble;

    precia2 = precia*24*3600*1000;% change to mm/day
    
    t_precia = data3.t_precia_ensamble;
    t_uvela = data2.t_uvela_ensamble;
    t_vvela = data2.t_vvela_ensamble;
    t_slpa = data4.t_slpa_ensamble;

    bin_precia = precia2;
    bin_uvela = uvela;
    bin_vvela = vvela;
    bin_slpa = slpa;
    %%
    bin_precia_t = t_precia;
    bin_precia_t( bin_precia_t>0 ) = 1;
    bin_slpa_t = t_slpa;
    bin_slpa_t( bin_slpa_t>0 ) = 1;

    bin_uvela_t = t_uvela;
    bin_vvela_t = t_vvela;
    bin_vela_t = bin_uvela_t + bin_vvela_t;
    bin_vela_t( bin_vela_t > 0 ) = 1;
    
    bin_precia_t(bin_precia_t == 0) = nan;
    bin_vela_t(bin_vela_t == 0) = nan;
    bin_slpa_t(bin_slpa_t == 0) = nan;
    %%
    % a = (lon_end-lon_start)/(lat_end-lat_start);
    % a = ceil(a*10)/10;
    % PaperPosition = [0 0 a 1]*4;
    
    FontSize = 15;% xtick
    FontSize2 = 15;% title
    FontSize3 = 10;% cable
    FontSize4 = 12;% legend
    FontName = 'Arial';
    
    clear text_lon text_lat
    for i1 = 1:length(plot_lon)
        if plot_lon(i1) == 0
            text_lon{i1} =[num2str(plot_lon(i1)),'°'];
        elseif plot_lon(i1) < 180 && plot_lon(i1) > 0
            text_lon{i1} =[num2str(plot_lon(i1)),'°E'];
        elseif plot_lon(i1) == 180
            text_lon{i1} =[num2str(plot_lon(i1)),'°'];
        elseif plot_lon(i1) > 180 && plot_lon(i1) < 360
            text_lon{i1} =[num2str(360-plot_lon(i1)),'°W'];
        elseif plot_lon(i1) == 360
            text_lon{i1} =[num2str(360-plot_lon(i1)),'°'];
        elseif plot_lon(i1) > 360 && plot_lon(i1) < 360+180 
            text_lon{i1} =[num2str(plot_lon(i1)-360),'°E'];
        end
    end
    for i1 = 1:length(plot_lat)
        if plot_lat(i1)< 0
            text_lat{i1} =[num2str(-plot_lat(i1)),'°S'];
        elseif plot_lat(i1) == 0
            text_lat{i1} =[num2str(plot_lat(i1)),'°'];
        elseif plot_lat(i1) > 0
            text_lat{i1} =[num2str(plot_lat(i1)),'°N'];
        end
    end
    
    if three == 1
        cb_RedBlue = input_colorbar_rgb('F:\2023PMM_Work\bin_data\colorbar\precip_diff_50lev.rgb')/255;
        cb_RedBlue(size(cb_RedBlue,1)/2:size(cb_RedBlue,1)/2+1,:) = ones(2,3);
    end
    
%     color_plot = [151,137,246 ...% 蓝紫色1
%         ;75,0,192 ...% 2蓝紫色
%         ;255,0,255 ... % 3紫红色
%         ;1,132,127 ...;% 4马尔斯绿
%         ;255,119,15]/255; % 5爱马仕橙
    color_plot = zeros(5,3);
    %%
    a = lon >= lon_start & lon <= lon_end;
    b = lat >= lat_start & lat <= lat_end;
    fig_lon = lon(a);
    fig_lat = lat(b);
    
    cbar = 3;
    ls_preci = 0.1;
    ls_pres = 0.4;
    k_scale = 10;
    LW = 1;% lines
    LW2 = 2;% contour
    LW3 = 0.5;% quiver
    LW4 = 2;% box
    
    bin_fig1 = bin_precia(a,b,:).*bin_precia_t(a,b,:);
    bin_fig2 = bin_slpa(a,b,:).*bin_slpa_t(a,b,:);
    bin_fig3 = bin_uvela(a,b,:).*bin_vela_t(a,b,:)*k_scale;
    bin_fig4 = bin_vvela(a,b,:).*bin_vela_t(a,b,:)*k_scale;
    
    % [lon_grid,lat_grid] = meshgrid(fig_lon,fig_lat);
    % [bin_slpb,~,~] = psi_streamfunction(lon_grid,lat_grid,bin_uvela(a,b,:)',bin_vvela(a,b,:)');
    % bin_fig2 = bin_slpb'.*bin_slpa_t(a,b,:)/1e6;% 
        
    bin_fig1_test = bin_precia_t(a,b,:);
    %%
    % set(0,'DefaultFigureVisible', 'off');
    fig1 = bin_fig1';
    fig2 = bin_fig2';
    fig3 = bin_fig3';
    fig4 = bin_fig4';
    
    fig5 = fig2;
    fig6 = fig2;
    fig5(fig5 < 0) = NaN;
    fig6(fig6 > 0) = NaN;
    
    fig1_test = bin_fig1_test';
    
    close all;

    hold on;

    [X,Y] = meshgrid(fig_lon,fig_lat);
    [cs,h] = m_contourf(fig_lon,fig_lat,fig1,'levelstep',ls_preci);
   
    m_proj('miller','lon',[lon_start,lon_end],'lat',[lat_start,lat_end]);
    m_gshhs_l('patch',[0.7 0.7 0.7],'edgecolor','none');
    m_grid('linest','none','linewidth',LW,'tickdir','out','Xtick',[],'Ytick',[],'FontName',FontName,'FontSize',FontSize);

    if one == 1 || one >= 5 % NETP
        lon_point1 = [360-135,360-160];
        lat_point1 = [30,10];
        lon_point2 = [360-110,360-115];
        lat_point2 = [15,10];

        m_plot([lon_point2(1),lon_point1(1)],[lat_point1(1),lat_point1(1)],'color',color_plot(1,:),'LineWidth',LW4,'LineStyle','--')
        m_plot([lon_point1(1),lon_point1(2)],[lat_point1(1),lat_point1(2)],'color',color_plot(1,:),'LineWidth',LW4,'LineStyle','--')
        m_plot([lon_point1(2),lon_point2(2)],[10,10],'color',color_plot(1,:),'LineWidth',LW4,'LineStyle','--')
        m_plot([lon_point2(2),lon_point2(1)],[lat_point2(2),lat_point2(1)],'color',color_plot(1,:),'LineWidth',LW4,'LineStyle','--')
        m_plot([lon_point2(1),lon_point2(1)],[lat_point2(1),lat_point1(1)],'color',color_plot(1,:),'LineWidth',LW4,'LineStyle','--')    
    end

    if one == 2 || one >= 5 % SETP
        lon_point = [360-120,360-70];
        lat_point = [-30,-10];% SEP

        m_plot([lon_point(2),lon_point(1)],[lat_point(2),lat_point(2)],'color',color_plot(2,:),'LineWidth',LW4,'LineStyle','--')
        m_plot([lon_point(1),lon_point(1)],[lat_point(2),lat_point(1)],'color',color_plot(2,:),'LineWidth',LW4,'LineStyle','--')
        m_plot([lon_point(1),lon_point(2)],[lat_point(1),lat_point(1)],'color',color_plot(2,:),'LineWidth',LW4,'LineStyle','--')
        m_plot([lon_point(2),lon_point(2)],[lat_point(1),lat_point(2)],'color',color_plot(2,:),'LineWidth',LW4,'LineStyle','--')
    end

    if one == 3 || one >= 5 % tio
        lon_point2 = [98,108];% 印度洋部分
        lat_point2 = [10,-8];
        a_ch2 = (lat_point2(1)-lat_point2(2))/(lon_point2(1)-lon_point2(2));
        b_ch2 = lat_point2(1)-a_ch2*lon_point2(1);

        m_plot([30,(30-b_ch2)/a_ch2],[30,30],'color',color_plot(3,:),'LineWidth',LW4,'LineStyle','--')
        m_plot([30,30],[-30,30],'color',color_plot(3,:),'LineWidth',LW4,'LineStyle','--')
        m_plot([30,(-30-b_ch2)/a_ch2],[-30,-30],'color',color_plot(3,:),'LineWidth',LW4,'LineStyle','--')
        m_plot([(-30-b_ch2)/a_ch2,(30-b_ch2)/a_ch2],[-30,30],'color',color_plot(3,:),'LineWidth',LW4,'LineStyle','--')
    end
    
    if one == 4 || one >= 5 % NTA
        lon_point1 = [360-91,360-80];% 墨西哥湾
        lat_point1 = [15,7.5];
        a_ch = (lat_point1(1)-lat_point1(2))/(lon_point1(1)-lon_point1(2));
        b_ch = lat_point1(1)-a_ch*lon_point1(1);

        lon_point2 = 360-50;% 南美沿岸
        lat_point2 = lon_point2*a_ch+b_ch;

        m_plot([(20-b_ch)/a_ch,360],[30,30],'color',color_plot(4,:),'LineWidth',LW4,'LineStyle','--')
        m_plot([(20-b_ch)/a_ch,(20-b_ch)/a_ch],[20,30],'color',color_plot(4,:),'LineWidth',LW4,'LineStyle','--')
        m_plot([(20-b_ch)/a_ch,lon_point2],[20,lat_point2],'color',color_plot(4,:),'LineWidth',LW4,'LineStyle','--')
        m_plot([lon_point2,lon_point2],[-30,lat_point2],'color',color_plot(4,:),'LineWidth',LW4,'LineStyle','--')
        m_plot([lon_point2,lon_end],[-30,-30],'color',color_plot(4,:),'LineWidth',LW4,'LineStyle','--')

        m_plot([0,20],[-30,-30],'color',color_plot(4,:),'LineWidth',LW4,'LineStyle','--')
        m_plot([20,20],[-30,10],'color',color_plot(4,:),'LineWidth',LW4,'LineStyle','--')
        m_plot([0,20],[10,10],'color',color_plot(4,:),'LineWidth',LW4,'LineStyle','--')
    end
    
    % [cs2,h2] = m_contour(fig_lon,fig_lat,fig5,'LineStyle','-','levelstep',ls_pres,'Color',[215,0,15]/255,'LineWidth',LW2);% positive SLP
    % [cs3,h3] = m_contour(fig_lon,fig_lat,fig6,'LineStyle','-','levelstep',ls_pres,'Color',[0,46,166]/255,'LineWidth',LW2);% negative SLP
    
    % d_num = 2;
    % [x2,y2]=find(fig1_test'>=1);
    % m_plot(lon(x2(1:d_num:end)),lat(y2(1:d_num:end)),'g.','markersize',2,'color',[0.3,0.3,0.3]);
    
    % [cs2,h2] = m_contour(lon,lat,fig2,[3,3],'color',[132,60,112]/255,'LineWidth',LW2);
    % [cs3,h3] = m_contour(lon,lat,fig2,[7,7],'color',[0,1,0],'LineWidth',LW2);
    
    for i2 = 1:length(plot_lon)
        m_plot([plot_lon(i2),plot_lon(i2)],[lat_start,lat_start+len_plot_lon],'color',[0,0,0],'LineWidth',LW);
        m_plot([plot_lon(i2),plot_lon(i2)],[lat_end-len_plot_lon,lat_end],'color',[0,0,0],'LineWidth',LW);
    end
    for i2 = 1:length(plot_lat)
        m_plot([lon_start,lon_start+len_plot_lon],[plot_lat(i2),plot_lat(i2)],'color',[0,0,0],'LineWidth',LW);
        m_plot([lon_end-len_plot_lon,lon_end],[plot_lat(i2),plot_lat(i2)],'color',[0,0,0],'LineWidth',LW);
    end

    if six == 1
        d_num = 7;
        h5 = m_quiver(X(1:d_num:end,1:d_num:end),Y(1:d_num:end,1:d_num:end)...
            ,fig3(1:d_num:end,1:d_num:end),fig4(1:d_num:end,1:d_num:end),'color',[0,0,0]...
            ,'LineStyle','-','LineWidth',LW3,'ShowArrowHead','on','AutoScale','off');
        rectangle('Position',lq_position,'Curvature',[0,0],'FaceColor',[1,1,1]);
        h6 = m_quiver(lq_lon,lq_lat,1*k_scale,0,'color',[0,0,0]...
            ,'LineStyle','-','LineWidth',LW3,'ShowArrowHead','on','AutoScale','off');
        m_plot([lq_lon+1*k_scale+2,lq_lon+1*k_scale-1],[lq_lat,lq_lat-1],'Color',[0,0,0],'LineStyle','-','LineWidth',LW3)
        m_plot([lq_lon+1*k_scale+2,lq_lon+1*k_scale-1],[lq_lat,lq_lat+1],'Color',[0,0,0],'LineStyle','-','LineWidth',LW3)
        m_text(lq_lon-1,lq_lat-4,'1m s^{-1}','FontName',FontName,'FontSize',FontSize4);
    end

    if one == 5
        for i2 = 1:length(plot_lon)
            if plot_lon(i2) == 0 || plot_lon(i2) == 360
                m_text(plot_lon(i2)+lon_text_x+5,lat_start+lon_text_y,text_lon{i2},'FontName',FontName,'FontSize',FontSize);
            else
                m_text(plot_lon(i2)+lon_text_x,lat_start+lon_text_y,text_lon{i2},'FontName',FontName,'FontSize',FontSize);
            end
        end
    end

    if five == 1
        for i2 = 1:length(plot_lat)
            a = lat_text_x;
            if plot_lat(i2) == 0
                a = a+5.5;
            end
            m_text(lon_start+a,plot_lat(i2),text_lat{i2},'FontName',FontName,'FontSize',FontSize);
        end
    end

    set(h,'LineColor','none');
    % set(h2,'ShowText','on','TextStep',get(h2,'LevelStep'));
    % clabel(cs2,h2,'FontName',FontName,'fontsize',FontSize3);
    % set(h3,'ShowText','on','TextStep',get(h3,'LevelStep'));
    % clabel(cs3,h3,'FontName',FontName,'fontsize',FontSize3);
    
    ax = gca;
    colormap(ax,cb_RedBlue)
    caxis([-cbar,cbar]);
    
    if five == 1
        % colorbar('FontName',FontName,'FontSize',FontSize)
        %     m_text(lon_end+45,ly_color,'SST[℃]','rotation',90,'FontName',FontName,'FontSize',FontSize);
    elseif five == 2
        colorbar('horiz','position',[0.13,0.13,0.78,0.04],'FontName',FontName,'FontSize',FontSize);
        %     m_text(lon_end+10,lat_start-3,'SST[℃]','FontName',FontName,'FontSize',FontSize);
    end
    
    %     m_text(120,-28,['lead(',num2str(i-n_fig),')'],'FontName',FontName,'FontSize',FontSize2);
    title([first_name2{one}],'FontName',FontName,'FontSize',FontSize2,'Interpreter','None');
    m_text(lon_start,lat_end+ly_text,['(',first_name3{one},')'],'FontName',FontName,'FontSize',FontSize2,'Interpreter','None');
    
    set(gcf,'PaperUnits','inches','PaperPosition',PaperPosition,'color',[1 1 1],'PaperOrientation','landscape');
    print('-dpdf','-r1000',[pathfig,'.pdf']);
    print('-djpeg','-r1000',[pathfig,'.jpg']);
    one
end