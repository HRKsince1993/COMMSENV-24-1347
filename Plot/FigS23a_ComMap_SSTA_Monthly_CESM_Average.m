clc;clear

% first_name = {'TPCtrl','NTAandTIOandSEPlg','NTAandTIOandPMMandSEPlg','NTAandTIOandSEPandWWBbmay','NTAandTIOandSEPandWWBb'}';
% first_name2 = {'TPCtrl','NA+TIO+SETP','NA+TIO+NETP+SETP','NA+TIO+SETP+WWB1','NA+TIO+SETP+WWBs'}';
first_name = {'Ctrl','TPCtrl','NETPCli','PMM','NTAandTIOandPMMandSEPandWWBb'}';
first_name2 = {'G','TPCtrl','NETPCli','PMM','NTAandTIOandPMMandSEPandWWBb'}';
first_name3 = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q'};

three = 6;% Colorbar 1 to 6
four = 0;% 0:Nothing;1:plot box region;
%%
for one = 1:1
    path1 = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\'];
    struct = dir([path1,'*.mat']);
    name1 = {struct.name}';
    
    aimpath = ['F:\2023PMM_Work\Figures_for_Publish\Figure\FigS23_ComMap_SSTA_CESM_Average\'];
    if exist(aimpath,'dir')~=7
        mkdir(aimpath);
    end
    
    load([path1,'Compose_SSTA_Global_Monthly_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-8),'_Avr3to11Mon.mat']);% SSTA
    load([path1,'Compose_TauAx_Global_Monthly_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-8),'_Avr3to11Mon.mat']);% TauxA
    load([path1,'Compose_TauAy_Global_Monthly_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-8),'_Avr3to11Mon.mat']);% TauyA
    
    lon_start = 0;
    lon_end = 360;
    
    % globe
    lat_start = -60;
    lat_end = 60;
    ly_color = -25;
    ly_text = 9;
    lq_position = [-3.09,0.85,0.82,0.3];
    lq_lon = 5;
    lq_lat = 56;
    len_plot_lon = 3;

    % a = (lon_end-lon_start)/(lat_end-lat_start);
    % a = ceil(a*10)/10;
    % PaperPosition = [0 0 a 1]*4;
    PaperPosition = [-0.5 0 10 4];
    
    FontSize = 15;
    FontSize2 = 15;
    FontName = 'Arial';
    
    plot_lon = lon_start:60:lon_end;
    plot_lat = lat_start:30:lat_end;
    clear text_lon text_lat
    for i1 = 1:length(plot_lon)
        if plot_lon(i1) == 0
            text_lon{i1} =[num2str(plot_lon(i1)),'¡ã'];
        elseif plot_lon(i1) < 180 && plot_lon(i1) > 0
            text_lon{i1} =[num2str(plot_lon(i1)),'¡ãE'];
        elseif plot_lon(i1) == 180
            text_lon{i1} =[num2str(plot_lon(i1)),'¡ã'];
        elseif plot_lon(i1) > 180 && plot_lon(i1) < 360
            text_lon{i1} =[num2str(360-plot_lon(i1)),'¡ãW'];
        elseif plot_lon(i1) == 360
            text_lon{i1} =[num2str(360-plot_lon(i1)),'¡ã'];
        end
    end
    for i1 = 1:length(plot_lat)
        if plot_lat(i1)< 0
            text_lat{i1} =[num2str(-plot_lat(i1)),'¡ãS'];
        elseif plot_lat(i1) == 0
            text_lat{i1} =[num2str(plot_lat(i1)),'¡ã'];
        elseif plot_lat(i1) > 0
            text_lat{i1} =[num2str(plot_lat(i1)),'¡ãN'];
        end
    end
    
    k_scale = 300;
    LW = 1;% lines
    LW2 = 3;% contour
    LW3 = 0.5;% quiver
    LW4 = 2;% box
    
    a = lon >= lon_start & lon <= lon_end;
    b = lat >= lat_start & lat <= lat_end;
    bin_lon = lon(a);
    bin_lat = lat(b);
    bin_fig1 = ssta_ensemble(a,b);
    bin_fig3 = tauxa_ensemble(a,b)*k_scale;
    bin_fig4 = tauya_ensemble(a,b)*k_scale;

    bin_ssta_test = t_ssta_ensemble(a,b);
    bin_uvela_test = t_tauxa_ensemble(a,b);
    bin_vvela_test = t_tauya_ensemble(a,b);

    bin_ssta_test( bin_ssta_test > 0 ) = 1;
    bin_uvela_test( bin_uvela_test > 0 ) = 1;
    bin_vvela_test( bin_vvela_test > 0 ) = 1;
    bin_vela_test = bin_uvela_test + bin_vvela_test;
    bin_vela_test( bin_vela_test > 0 ) = 1;

    bin_ssta_test(bin_ssta_test == 0) = nan;
    bin_vela_test(bin_vela_test == 0) = nan;
    %%
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

    color_plot = [0,0,0 ...
        ;75,0,192 ...% 1À¶×ÏÉ«
        ;121,139,113 ...% 4ÄªÀ¼µÏÉ«
        ;1,132,127 ...% 5Âí¶ûË¹ÂÌ
        ;0,46,166 ...% 2¿ËÀ³ÒòÀ¶
        ;252,218,94 ...% 6ÄÃÆÂÀï»Æ
        ;1,62,119 ...% 7ÆÕÂ³Ê¿À¶
        ;183,127,112 ... % 8ÄªÀ¼µÏ×Ø
        ;212,183,173 ...% 9ÄªÀ¼µÏ³È
        ;255,0,255]/255;
    
    % set(0,'DefaultFigureVisible', 'off');
    % for i1 = 1:size(bin_fig1,3)
    fig1 = bin_fig1'.* bin_ssta_test';
    fig3 = bin_fig3'.* bin_vela_test';
    fig4 = bin_fig4'.* bin_vela_test';
    

    close all;
    m_proj('miller','lon',[lon_start,lon_end],'lat',[lat_start,lat_end]);
    m_gshhs_l('patch',[0.7 0.7 0.7],'edgecolor','none');
    m_grid('linest','none','linewidth',LW,'tickdir','out','Xtick',[],'Ytick',[],'FontName',FontName,'FontSize',FontSize);
        
    hold on;
    
    for i2 = 1:length(plot_lon)
        if plot_lon(i2) == 0 || plot_lon(i2) == 360
            m_text(plot_lon(i2)-3,lat_start-5,text_lon{i2},'FontName',FontName,'FontSize',FontSize);
        else
            m_text(plot_lon(i2)-8,lat_start-5,text_lon{i2},'FontName',FontName,'FontSize',FontSize);
        end
    end
    for i2 = 1:length(plot_lat)
        a = -25;
        if plot_lat(i2) == 0
            a = a+5;
        end
        m_text(lon_start+a,plot_lat(i2),text_lat{i2},'FontName',FontName,'FontSize',FontSize);
    end

    [X,Y] = meshgrid(bin_lon,bin_lat);
    [cs,h] = m_contourf(bin_lon,bin_lat,fig1,'levelstep',lv_sst);
    
    d_num = 7;
    h5 = m_quiver(X(1:d_num:end,1:d_num:end),Y(1:d_num:end,1:d_num:end)...
        ,fig3(1:d_num:end,1:d_num:end),fig4(1:d_num:end,1:d_num:end),'color',[0,0,0]...
        ,'LineStyle','-','LineWidth',LW3,'ShowArrowHead','on','AutoScale','off');

    rectangle('Position',lq_position,'Curvature',[0,0],'FaceColor',[1,1,1]);
    h6 = m_quiver(lq_lon,lq_lat,0.01*k_scale,0,'color',[0,0,0]...
        ,'LineStyle','-','LineWidth',LW3,'ShowArrowHead','on','AutoScale','off');
    m_plot([lq_lon+0.01*k_scale+3,lq_lon+0.01*k_scale],[lq_lat,lq_lat-0.5],'Color',[0,0,0],'LineStyle','-','LineWidth',LW3)
    m_plot([lq_lon+0.01*k_scale+3,lq_lon+0.01*k_scale],[lq_lat,lq_lat+0.5],'Color',[0,0,0],'LineStyle','-','LineWidth',LW3)
    m_text(lq_lon,lq_lat-5,'0.01N m^{-2}','FontName',FontName,'FontSize',FontSize2);
        
    set(h,'LineColor','none');
    if four == 1
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
        
        % TIO
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
    end

    for i2 = 1:length(plot_lon)
        m_plot([plot_lon(i2),plot_lon(i2)],[lat_start,lat_start+len_plot_lon],'color',[0,0,0],'LineWidth',LW);
        m_plot([plot_lon(i2),plot_lon(i2)],[lat_end-len_plot_lon,lat_end],'color',[0,0,0],'LineWidth',LW);
    end
    for i2 = 1:length(plot_lat)
        m_plot([lon_start,lon_start+len_plot_lon],[plot_lat(i2),plot_lat(i2)],'color',[0,0,0],'LineWidth',LW);
        m_plot([lon_end-len_plot_lon,lon_end],[plot_lat(i2),plot_lat(i2)],'color',[0,0,0],'LineWidth',LW);
    end

    ax = gca;
    caxis([-cbar,cbar]);
    colormap(ax,cb_RedBlue)

    %     m_text(lon_end+45,-25,'SST[¡æ]','rotation',90,'FontName',FontName,'FontSize',FontSize);
    %     m_text(120,-28,['lead(',num2str(i-n_fig),')'],'FontName',FontName,'FontSize',FontSize2);
    %     m_text(lon_start,lat_end+9,[num2str(date(i1,1),'%4i'),'.',num2str(date(i1,2),'%2i'),' ',name1{one}(1:end-8),' anomalous SST and wind stress'],'FontName',FontName,'FontSize',FontSize2*2,'Interpreter','None');
%     m_text(lon_start,lat_end+9,['Exp_',first_name2{one},' anomalous SST'],'FontName',FontName,'FontSize',FontSize2,'Interpreter','None');
    title(['CESM'],'FontName',FontName,'FontSize',FontSize,'Interpreter','None');   
    m_text(lon_start,lat_end+4,'(a)','FontName',FontName,'FontSize',FontSize,'Interpreter','None');
    %%
    pathfig = [aimpath,'FigS23a_Avr3to11_Com_SSTA_Monthly_Exp_',first_name{one},'_Color',num2str(three)];
    set(gcf,'PaperUnits','inches','PaperPosition',PaperPosition,'color',[1 1 1],'PaperOrientation','landscape');
    print('-djpeg','-r1000',[pathfig,'.jpg']);
    print('-dpdf','-r1000',[pathfig,'.pdf']);

    colorbar('YTick',-3:1:3,'YTickLabel',-3:1:3,'FontName',FontName,'FontSize',FontSize)
    pathfig = [aimpath,'Colorbar_FigS23a_Avr3to11_Com_SSTA_Monthly_Exp_',first_name{one},'_Color',num2str(three)];
    print('-djpeg','-r1000',[pathfig,'.jpg']);
    print('-dpdf','-r1000',[pathfig,'.pdf']);

    % end
end