clc;clear

for one = 1:5 % 1:PMM;2:SEP;3:TIO;4:NTA;5:NTAandTIOandPMMandSEPlg;6:NTAandTIOandPMMandSEPandWWBb
    two = 1;% minus 1:TPCtrl;
    three = 6;% Colorbar 1 to 6
    four = 1;% plot 1:tropical;2:global
    five = 1;% 1:no colorbar;2:colorbar
    first_name = {'PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb'};
    first_name2 = {'CESM-TP+NETP','CESM-TP+SETP','CESM-TP+TIO','CESM-TP+TA','CESM-TP+G','CESM-TP+G+WWBs'};
    first_name3 = {'a','b','c','d','e','f'};
    second_name = {'TPCtrl'};
    second_name2 = {'CESM-TP'};
    fourth_name = {'Tropical\',[]};
    fifth_name = {[],'Colorbar_'};
    
    path_spmm1 = [360-130,0];
    path_spmm2 = [360-80,-20];

    path1 = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\'];
    struct = dir([path1,'*.mat']);
    name1 = {struct.name}';
    
    len_m = (3:11)-2;% month
    % len_m = (11:13)-2;% month
    %%
    aimpath = ['F:\2023PMM_Work\Figures_for_Publish\Figure\Fig4_ComMap_SSTdiffCtrlWind_Average_Mon',num2str(len_m(1)+2),'to',num2str(len_m(end)+2),'\Color',num2str(three),'\'];
    if exist(aimpath,'dir')~=7
        mkdir(aimpath);
    end
    
    pathfig = [aimpath,fifth_name{five},'Fig4',first_name3{one},'_Com_SSTdiff',second_name{two},'_Month',num2str(len_m(1)+2),'to',num2str(len_m(end)+2),'_mEnA_Exp_',first_name{one},'_Color',num2str(three)];
    
    load([path1,'Compose_Preci_Global_Monthly_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end)]);% Preci
    data2 = load([path1,'Compose_SSTdiff',second_name{two},'_Global_Monthly_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-8),'.mat']);% SSTdiff
    data3 = load([path1,'Compose_SSTdiff',second_name{two},'_Global_Monthly_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-8),'_Avr',num2str(len_m(1)+2),'to',num2str(len_m(end)+2),'Mon.mat']);% SSTdiff
    data4 = load([path1,'Compose_Wind_diff',second_name{two},'_Global_Monthly_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-5),'_Avr',num2str(len_m(1)+2),'to',num2str(len_m(end)+2),'Mon.mat']);% WindDiff
    
    a1 = lon >= 360-170 & lon <= 360-120;% Nino34
    b1 = lat >= -5 & lat <= 5;% Nino34
    nino34_ndj = mean(mean(mean(data2.ssta_ensemble(a1,b1,9:11))));

    ssta = data3.ssta_ensemble;
    uvela = data4.uvela_ensemble;
    vvela = data4.vvela_ensemble;
    preci = preci_ensemble*24*3600*1000;% change to mm/day
    
    t_ssta = data3.t_ssta_ensemble;
    t_uvela = data4.t_uvela_ensemble;
    t_vvela = data4.t_vvela_ensemble;
    t_preci = t_preci_ensemble;
    
    bin_ssta = ssta;
    bin_uvela = uvela;
    bin_vvela = vvela;
    bin_preci = mean(preci(:,:,len_m),3);
    %%
    bin_ssta_t = t_ssta;
    bin_uvela_t = t_uvela;
    bin_vvela_t = t_vvela;

    bin_preci_t = sum(t_preci(:,:,len_m),3);
    bin_preci_t( bin_preci_t < length(len_m)/2 ) = 0;
    bin_preci_t( bin_preci_t > 0 ) = 1;

    bin_vela_t = bin_uvela_t + bin_vvela_t;
    bin_vela_t( bin_vela_t > 0 ) = 1;

    bin_ssta_t(bin_ssta_t == 0) = nan;
    bin_preci_t(bin_preci_t == 0) = nan;
    bin_vela_t(bin_vela_t == 0) = nan;
    %%
    lon_start = 0;
    lon_end = 360;
    if four == 1 % tropics
        lat_start = -35;
        lat_end = 35;
        PaperPosition = [-0.5 0 9 2];
        ly_color = -20;
        ly_text = 6;
        lq_position = [-3.07,0.34,0.43,0.25];
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
            text_lon{i} =[num2str(plot_lon(i)),'°'];
        elseif plot_lon(i) > 0 && plot_lon(i) < 180
            text_lon{i} =[num2str(plot_lon(i)),'°E'];
        elseif plot_lon(i) == 180
            text_lon{i} =[num2str(plot_lon(i)),'°'];
        elseif plot_lon(i) > 180 && plot_lon(i) < 360
            text_lon{i} =[num2str(360-plot_lon(i)),'°W'];
        elseif plot_lon(i) == 360
            text_lon{i} =[num2str(360-plot_lon(i)),'°'];
        end
    end

    for i = 1:length(plot_lat)
        if plot_lat(i)< 0
            text_lat{i} =[num2str(-plot_lat(i)),'°S'];
        elseif plot_lat(i) == 0
            text_lat{i} =[num2str(plot_lat(i)),'°'];
        elseif plot_lat(i) > 0
            text_lat{i} =[num2str(plot_lat(i)),'°N'];
        end
    end
    
    cbar = 3.5;
    ls_sst = 0.15;
    if three == 1
        cb_RedBlue = input_colorbar_rgb('F:\PMM_For_Paper/colorbar/cb_RedBlue_SST.rgb')/255;
    elseif three == 2
        cb_RedBlue = input_colorbar_rgb('F:\PMM_For_Paper/colorbar/cb_RedBlue_SST.rgb')/255;
        cb_RedBlue(13:14,:) = ones(2:3);
        cb_RedBlue = cb_RedBlue(4:end-3,:);
        for i2 = 3:-1:0
            cb_RedBlue(end-i2,:) = cb_RedBlue(end-i2-1,:)*0.8+cb_RedBlue(end-i2,:)*0.2;
        end
    elseif three == 3
        cb_RedBlue = input_colorbar_rgb('F:\PMM_For_Paper/colorbar/cb_RedBlue_SST52.rgb')/255;
        cb_RedBlue(26:27,:) = ones(2,3);
        ls_sst = 0.05;
    elseif three == 4
        cb_RedBlue = input_colorbar_rgb('F:\PMM_For_Paper/colorbar/cb_RedBlue_SST104.rgb')/255;
        cb_RedBlue(52:53,:) = ones(2,3);
        ls_sst = 0.05;
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
    
    color_plot = [151,137,246 ...% 蓝紫色1
        ;75,0,192 ...% 2蓝紫色
        ;255,0,255 ... % 3紫红色
        ;1,132,127 ...;% 4马尔斯绿
        ;255,119,15]/255; % 5爱马仕橙
    %%
    a = lon >= lon_start & lon <= lon_end;
    b = lat >= lat_start & lat <= lat_end;
    lon = lon(a);
    lat = lat(b);
    
    k_scale = 10;
    LW = 1;% lines
    LW2 = 3;% contour
    LW3 = 0.5;% quiver
    LW4 = 3;% contour
    
    bin_fig1 = bin_ssta(a,b,:).*bin_ssta_t(a,b,:);
    % bin_fig1 = bin_ssta(a,b);
    bin_fig2 = bin_preci(a,b,:).*bin_preci_t(a,b,:);
    bin_fig3 = bin_uvela(a,b).*bin_vela_t(a,b)*k_scale;
    bin_fig4 = bin_vvela(a,b).*bin_vela_t(a,b)*k_scale;
    
    bin_fig1_test = bin_ssta_t(a,b);
    %%
    % set(0,'DefaultFigureVisible', 'off');
    fig1 = bin_fig1';
    fig2 = bin_fig2';
    fig3 = bin_fig3';
    fig4 = bin_fig4';
    fig1_test = bin_fig1_test';
    
    close all;
    m_proj('miller','lon',[lon_start,lon_end],'lat',[lat_start,lat_end]);
    m_gshhs_l('patch',[0.7 0.7 0.7],'edgecolor','none');
    m_grid('linest','none','linewidth',LW,'tickdir','out','Xtick',[],'Ytick',[],'FontName',FontName,'FontSize',FontSize);
    
    hold on;
    
    if one >= 5
        for i2 = 1:length(plot_lon)
            if  plot_lon(i2) == 0 || plot_lon(i2) == 360
                m_text(plot_lon(i2)-3,lat_start-6,text_lon{i2},'FontName',FontName,'FontSize',FontSize);
            else
                m_text(plot_lon(i2)-8,lat_start-6,text_lon{i2},'FontName',FontName,'FontSize',FontSize);
            end
        end
    end

    for i2 = 1:length(plot_lat)
        a = -25;
        if plot_lat(i2) == 0
            a = a+5.5;
        end
        m_text(lon_start+a,plot_lat(i2),text_lat{i2},'FontName',FontName,'FontSize',FontSize);
    end

    hold on;
    
    [X,Y] = meshgrid(lon,lat);
    [cs,h] = m_contourf(lon,lat,fig1,'levelstep',ls_sst);
    
    % d_num = 2;
    % [x2,y2]=find(fig1_test'>=1);
    % m_plot(lon(x2(1:d_num:end)),lat(y2(1:d_num:end)),'g.','markersize',2,'color',[0.3,0.3,0.3]);% plot dots
    
    % [cs2,h2] = m_contour(lon,lat,fig2,[3,3],'color',[132,60,112]/255,'LineWidth',LW2);
    % [cs3,h3] = m_contour(lon,lat,fig2,[7,7],'color',[0,1,0],'LineWidth',LW2);

    set(h,'LineColor','none');

    if one == 1 || one >= 5 % NETP
        lon_point1 = [360-135,360-160];
        lat_point1 = [30,10];
        lon_point2 = [360-110,360-115];
        lat_point2 = [15,10];

        m_plot([lon_point2(1),lon_point1(1)],[lat_point1(1),lat_point1(1)],'color',color_plot(1,:),'LineWidth',LW4)
        m_plot([lon_point1(1),lon_point1(2)],[lat_point1(1),lat_point1(2)],'color',color_plot(1,:),'LineWidth',LW4)
        m_plot([lon_point1(2),lon_point2(2)],[10,10],'color',color_plot(1,:),'LineWidth',LW4)
        m_plot([lon_point2(2),lon_point2(1)],[lat_point2(2),lat_point2(1)],'color',color_plot(1,:),'LineWidth',LW4)
        m_plot([lon_point2(1),lon_point2(1)],[lat_point2(1),lat_point1(1)],'color',color_plot(1,:),'LineWidth',LW4)    
    end

    if one == 2 || one >= 5 % SETP
        lon_point = [360-120,360-70];
        lat_point = [-30,-10];% SEP

        m_plot([lon_point(2),lon_point(1)],[lat_point(2),lat_point(2)],'color',color_plot(2,:),'LineWidth',LW4)
        m_plot([lon_point(1),lon_point(1)],[lat_point(2),lat_point(1)],'color',color_plot(2,:),'LineWidth',LW4)
        m_plot([lon_point(1),lon_point(2)],[lat_point(1),lat_point(1)],'color',color_plot(2,:),'LineWidth',LW4)
        m_plot([lon_point(2),lon_point(2)],[lat_point(1),lat_point(2)],'color',color_plot(2,:),'LineWidth',LW4)
    end

    if one == 3 || one >= 5 % tio
        lon_point2 = [98,108];% 印度洋部分
        lat_point2 = [10,-8];
        a_ch2 = (lat_point2(1)-lat_point2(2))/(lon_point2(1)-lon_point2(2));
        b_ch2 = lat_point2(1)-a_ch2*lon_point2(1);

        m_plot([30,(30-b_ch2)/a_ch2],[30,30],'color',color_plot(3,:),'LineWidth',LW4)
        m_plot([30,30],[-30,30],'color',color_plot(3,:),'LineWidth',LW4)
        m_plot([30,(-30-b_ch2)/a_ch2],[-30,-30],'color',color_plot(3,:),'LineWidth',LW4)
        m_plot([(-30-b_ch2)/a_ch2,(30-b_ch2)/a_ch2],[-30,30],'color',color_plot(3,:),'LineWidth',LW4)
    end
    
    if one == 4 || one >= 5 % NTA
        lon_point1 = [360-91,360-80];% 墨西哥湾
        lat_point1 = [15,7.5];
        a_ch = (lat_point1(1)-lat_point1(2))/(lon_point1(1)-lon_point1(2));
        b_ch = lat_point1(1)-a_ch*lon_point1(1);

        lon_point2 = 360-50;% 南美沿岸
        lat_point2 = lon_point2*a_ch+b_ch;

        m_plot([(20-b_ch)/a_ch,360],[30,30],'color',color_plot(4,:),'LineWidth',LW4)
        m_plot([(20-b_ch)/a_ch,(20-b_ch)/a_ch],[20,30],'color',color_plot(4,:),'LineWidth',LW4)
        m_plot([(20-b_ch)/a_ch,lon_point2],[20,lat_point2],'color',color_plot(4,:),'LineWidth',LW4)
        m_plot([lon_point2,lon_point2],[-30,lat_point2],'color',color_plot(4,:),'LineWidth',LW4)
        m_plot([lon_point2,360],[-30,-30],'color',color_plot(4,:),'LineWidth',LW4)

        m_plot([0,20],[-30,-30],'color',color_plot(4,:),'LineWidth',LW4)
        m_plot([20,20],[-30,10],'color',color_plot(4,:),'LineWidth',LW4)
        m_plot([0,20],[10,10],'color',color_plot(4,:),'LineWidth',LW4)
    end
    
    d_num = 7;
    h5 = m_quiver(X(1:d_num:end,1:d_num:end),Y(1:d_num:end,1:d_num:end)...
        ,fig3(1:d_num:end,1:d_num:end),fig4(1:d_num:end,1:d_num:end),'color',[0,0,0]...
        ,'LineStyle','-','LineWidth',LW3,'ShowArrowHead','on','AutoScale','off');
    rectangle('Position',lq_position,'Curvature',[0,0],'FaceColor',[1,1,1]);
    h6 = m_quiver(lq_lon,lq_lat,1*k_scale,0,'color',[0,0,0]...
        ,'LineStyle','-','LineWidth',LW3,'ShowArrowHead','on','AutoScale','off');
    m_plot([lq_lon+1*k_scale+2,lq_lon+1*k_scale-1],[lq_lat,lq_lat-1],'Color',[0,0,0],'LineStyle','-','LineWidth',LW3)
    m_plot([lq_lon+1*k_scale+2,lq_lon+1*k_scale-1],[lq_lat,lq_lat+1],'Color',[0,0,0],'LineStyle','-','LineWidth',LW3)
    m_text(lq_lon-1,lq_lat-5,'1m s^{-1}','FontName',FontName,'FontSize',FontSize3);

%     m_plot([path_spmm1(1),path_spmm2(1)],[path_spmm1(2),path_spmm2(2)],'LineWidth',LW2,'color',[0,0,0],'LineStyle','-');
    for i2 = 1:length(plot_lon)
        m_plot([plot_lon(i2),plot_lon(i2)],[lat_start,lat_start+len_plot_lon],'color',[0,0,0],'LineWidth',LW);
        m_plot([plot_lon(i2),plot_lon(i2)],[lat_end-len_plot_lon,lat_end],'color',[0,0,0],'LineWidth',LW);
    end
    for i2 = 1:length(plot_lat)
        m_plot([lon_start,lon_start+len_plot_lon],[plot_lat(i2),plot_lat(i2)],'color',[0,0,0],'LineWidth',LW);
        m_plot([lon_end-len_plot_lon,lon_end],[plot_lat(i2),plot_lat(i2)],'color',[0,0,0],'LineWidth',LW);
    end
        
    ax = gca;
    colormap(ax,cb_RedBlue)
    caxis([-cbar,cbar]);
    
    if five == 1
        %     colorbar('FontName',FontName,'FontSize',FontSize)
        %     m_text(lon_end+45,ly_color,'SST[℃]','rotation',90,'FontName',FontName,'FontSize',FontSize);
    elseif five == 2
        colorbar('horiz','position',[0.13,0.13,0.78,0.04],'FontName',FontName,'FontSize',FontSize);
        %     m_text(lon_end+10,lat_start-3,'SST[℃]','FontName',FontName,'FontSize',FontSize);
        PaperPosition(4) = PaperPosition(4)+1;
    end
    
    %     m_text(120,-28,['lead(',num2str(i-n_fig),')'],'FontName',FontName,'FontSize',FontSize2);
    title([first_name2{one}],'FontName',FontName,'FontSize',FontSize2*four,'Interpreter','None');
    m_text(lon_start,lat_end+ly_text,['(',first_name3{one},')'],'FontName',FontName,'FontSize',FontSize2*four,'Interpreter','None');
    % m_text(lon_end-107,lat_end+ly_text,['NDJ NINO3.4 = ',num2str(nino34_ndj,'%2.2f'),'°C'],'FontName',FontName,'FontSize',FontSize2*four,'Interpreter','None');
    %%
    set(gcf,'PaperUnits','inches','PaperPosition',PaperPosition,'color',[1 1 1],'PaperOrientation','landscape');
    print('-dpdf','-r1000',[pathfig,'.pdf']);
    print('-djpeg','-r1000',[pathfig,'.jpg']);
end