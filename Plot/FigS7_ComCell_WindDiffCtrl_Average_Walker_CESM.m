clc;clear

for one = 1:5 % 1:PMM;2:SEP;3:TIO;4:NTA;5:NTAandTIOandPMMandSEPlg;6:NTAandTIOandPMMandSEPandWWBb
    two = 1;% minus 1:TPCtrl;
    three = 1;% 1:color1;
    five = 1;% 1:no colorbar;2:colorbar;3:legend
    six = 1;% plot wind 0:No;1:Yes
    seven = 1;% streamfunction method, 1:Sun 2:Yu
    fourth = 1;% section lat 1:5S to 5N;2:10S to 10N

    first_name = {'PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb'};
    first_name2 = {'CESM-TP+NETP','CESM-TP+SETP','CESM-TP+TIO','CESM-TP+TA','CESM-TP+G','CESM-TP+G+WWBs'};
    first_name3 = {'a','b','c','d','e','f'};
    second_name = {'TPCtrl'};
    second_name2 = {'CESM-TP'};
    fourth_num = [5,10];
    fifth_name = {[],'Colorbar_','Legend_'};

    path1 = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\'];
    struct = dir([path1,'*.mat']);
    name1 = {struct.name}';
    
    aimpath = ['F:\2023PMM_Work\Figures_for_Publish\Figure\FigS7_ComCell_WindDiffCtrl_Walker_Average\'];
    if exist(aimpath,'dir')~=7
        mkdir(aimpath);
    end
    
    len_m = (3:11)-2;% month
    pathfig = [aimpath,fifth_name{five},'FigS7',first_name3{one},'_ComCell_WindDiff',second_name{two},'_Walker_Mon'...
        ,num2str(len_m(1)+2),'to',num2str(len_m(end)+2),'_Lat',num2str(fourth_num(fourth)),'Sto',num2str(fourth_num(fourth)),'N_Exp_',first_name{one},'_Color',num2str(three)];
    
    data1 = load([path1,'Compose_WindU3diff',second_name{two},'_Walker_Global_Monthly_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-5)...
        ,'_Avr',num2str(len_m(1)+2),'to',num2str(len_m(end)+2),'Mon_Lat',num2str(fourth_num(fourth)),'Sto',num2str(fourth_num(fourth)),'N.mat']);% WindDiff
    data2 = load([path1,'Compose_WindW3diff',second_name{two},'_Equator_Global_Monthly_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-5)...
        ,'_Avr',num2str(len_m(1)+2),'to',num2str(len_m(end)+2),'Mon_Lat',num2str(fourth_num(fourth)),'Sto',num2str(fourth_num(fourth)),'N.mat']);% WindDiff
    
    lon = data1.lon(1:end-1);
    lev = data1.lev;
    uvela = data1.uvela_ensemble(1:end-1,:);
    wvela = data2.wvela_ensemble(1:end-1,:)*100;
    t_uvela = data1.t_uvela_ensemble(1:end-1,:);
    t_wvela = data2.t_wvela_ensemble(1:end-1,:);
    %%
    bin_uvela = uvela;
    bin_wvela = wvela;
    bin_uvela_t = t_uvela;
    bin_uvela_t( bin_uvela_t>0 ) = 1;
    bin_wvela_t = t_wvela;
    bin_wvela_t( bin_wvela_t>0 ) = 1;
    bin_vela_t = bin_uvela_t + bin_wvela_t;
    bin_vela_t( bin_vela_t>0 ) = 1;
    bin_vela_t(bin_vela_t == 0) = nan;

    fig2_lon = lon;

    ref_box_lev = [0,5]; 
    lev_cha1 = (ref_box_lev(end)-ref_box_lev(1))/(lev(end)-lev(1));
    lev_chb1 = ref_box_lev(1) - lev_cha1*lev(1);

    fig2_lev = lev*lev_cha1 + lev_chb1;
    fig2b_lon = cat(1,fig2_lon,fig2_lon + fig2_lon(end) + fig2_lon(1),fig2_lon + fig2_lon(end)*2 + fig2_lon(1));
    bin2_uvela = cat(1,bin_uvela,bin_uvela,bin_uvela);
    bin2_wvela = cat(1,bin_wvela,bin_wvela,bin_wvela);
    [lon_grid,lev_grid] = meshgrid(fig2b_lon,fig2_lev);

    [bin_psi,~,~] = psi_streamfunction_walker(lon_grid,lev_grid,bin2_uvela',bin2_wvela');
    bin2_psi = bin_psi(:,360:end-359);
    % bin_fig2 = bin_psi'.*bin_vela_t/1e6;%
    bin_fig2 = bin2_psi'/1e6;%
%%
    path_topo = 'G:\Ocean_Data\topo\ETOPO1_Ice_g_gmt4.grd';
    lat_topo = ncread(path_topo,'y');
    lon_topo = ncread(path_topo,'x');
    topo = ncread(path_topo,'z');
    a = lon_topo < 0;
    lon_topo(a) = lon_topo(a) + 360;
    [lon_topo,b] = sort(lon_topo);
    topo = topo(b,:);
    a = topo <= 0;
    topo(a) = 0;
    lat_topo_l = lat_topo >= -5 & lat_topo <= 5;
    fig_topo = 1000-mean(topo(:,lat_topo_l),2)/12;
    %%
    lon_start = 0;
    lon_end = 360;
    lev_start = 1000;
    lev_end = 200;

    % a = (lon_end-lon_start)/(lat_end-lat_start);
    % a = ceil(a*10)/10;
    % PaperPosition = [0 0 a 1]*4;
    PaperPosition = [0,0,9.08,2.5];

    FontSize = 20;% xtick
    FontSize2 = 20;% title
    FontSize3 = 10;% cable
    FontName = 'Arial';

    plot_lon = lon_start:60:lon_end;
    clear text_lon text_lat
    for i = 1:length(plot_lon)
        if plot_lon(i) == 0
            text_lon{i} =[num2str(plot_lon(i)),'°'];
        elseif plot_lon(i) >0 && plot_lon(i) < 180
            text_lon{i} =[num2str(plot_lon(i)),'°E'];
        elseif plot_lon(i) == 180
            text_lon{i} =[num2str(plot_lon(i)),'°'];
        elseif plot_lon(i) > 180 && plot_lon(i) < 360
            text_lon{i} =[num2str(360-plot_lon(i)),'°W'];
        elseif plot_lon(i) == 360
            text_lon{i} =[num2str(360-plot_lon(i)),'°'];
        end
    end
    %%
    k_scale = 5;
    LW = 1;% lines
    LW2 = 2;% contour
    LW3 = 1;% quiver
    LW4 = 2;% box
    ls_pres = 0.5;
    cbar = 6;
    
    a = (lon_end-lon_start)/(lev_start-lev_end)/(PaperPosition(3)/PaperPosition(4));% 解决quiver失真问题，横纵轴比例/图片比例

    bin_fig3 = bin_uvela.*bin_vela_t*k_scale;
    bin_fig4 = bin_wvela.*bin_vela_t*k_scale/a;
    bin2_fig3 = bin_uvela *k_scale;
    bin2_fig4 = bin_wvela *k_scale;

    if three == 1
        cb_RedBlue = input_colorbar_rgb('F:\PMM_For_Paper\colorbar\cb_RedBlue_SST.rgb')/255;
        cb_RedBlue = cb_RedBlue(2:end-1,:);
    end
    %%
    % set(0,'DefaultFigureVisible', 'off');
    fig2 = bin_fig2';
    fig3 = bin_fig3';
    fig4 = bin_fig4';

    fig5 = fig2;
    fig6 = fig2;
    fig5(fig5 < 0) = NaN;
    fig6(fig6 > 0) = NaN;

    fig3b = bin2_fig3';
    fig4b = bin2_fig4';

    close all

    hold on;

    [cs1,h1] = contourf(fig2_lon,lev,fig2,'levelstep',ls_pres);% positive SLP
%     [cs2,h2] = contour(fig2_lon,lev,fig5,'levelstep',ls_pres,'LineStyle','-','Color',[215,0,15]/255,'LineWidth',LW2);% positive SLP
%     [cs3,h3] = contour(fig2_lon,lev,fig6,'levelstep',ls_pres,'LineStyle','-','Color',[0,46,166]/255,'LineWidth',LW2);% negative SLP
    
    [X,Y] = meshgrid(fig2_lon,lev);
    % dx_num = 30;
    % dy_num = 4;
    % h4 = streamline(X,Y,fig3,fig4,X(1:dy_num:end,1:dx_num:end),Y(1:dy_num:end,1:dx_num:end));% stream lines
    % set(h4,'Color',[0,1,0],'LineWidth',LW2); 

    plot(lon_topo,fig_topo,'LineWidth',LW,'color',[0.7,0.7,0.7],'LineStyle','-');
    min_value = min(fig_topo); % 曲线的最低点
    max_value = max(fig_topo); % 曲线的最高点
    fill([lon_topo, fliplr(lon_topo)], [max_value*ones(size(fig_topo)), fliplr(fig_topo)],[0.7, 0.7, 0.7], 'EdgeColor', 'none');

    dx_num = 15;
    dy_num = 2;
    h5 = quiver(X(1:dy_num:end,1:dx_num:end),Y(1:dy_num:end,1:dx_num:end)...
        ,fig3(1:dy_num:end,1:dx_num:end),fig4(1:dy_num:end,1:dx_num:end),'color',[0,0,0]...
        ,'LineStyle','-','LineWidth',LW3,'MaxHeadSize',0.05,'ShowArrowHead','on','AutoScale','off');
    

    xtick = plot_lon;
    ytick = lev_end:200:lev_start;
    if one >= 5 % SETP
        xticklabel = text_lon;
    else
        xticklabel = [];
    end
    
%     if mod(one,2) == 1
        ylabel_name = 'Pressure[hPa]';
        yticklabel = ytick;
%     else
%         ylabel_name = ' ';
%         yticklabel = [];
%     end
    
    if five == 3
        kk2 = 300;
        rectangle('Position',[255,745-kk2,100,335],'Curvature',[0,0],'FaceColor',[1,1,1]);
        h6 = quiver(260,777-kk2,2*k_scale,0,'color',[0,0,0]...
            ,'LineStyle','-','LineWidth',LW3,'MaxHeadSize',10,'ShowArrowHead','on','AutoScale','off');
        plot([260+2*k_scale,260+k_scale],[777-kk2,777-kk2-15],'Color',[0,0,0],'LineStyle','-','LineWidth',LW3)
        plot([260+2*k_scale,260+k_scale],[777-kk2,777-kk2+15],'Color',[0,0,0],'LineStyle','-','LineWidth',LW3)

        text(260,850-kk2,'u:2m s^{-1}','FontName',FontName,'FontSize',FontSize2);
        text(260,970-kk2,'omega:2Pa s^{-1}','FontName',FontName,'FontSize',FontSize2);
        cb_RedBlue = ones(size(cb_RedBlue));
    end

    box on
    set(h1,'LineColor','none');
    set(gca,'xtick',xtick,'xticklabel',xticklabel,'ytick',ytick,'yticklabel',yticklabel,'xlim',[lon_start,lon_end],'ylim',[ytick(1),1000],'Layer','top','Ydir','reverse','FontSize',FontSize,'FontName',FontName);
    xtickangle(0)

    ax = gca;
    colormap(ax,cb_RedBlue)
    caxis([-cbar,cbar]);

    if five == 2
        % colorbar('FontName',FontName,'FontSize',FontSize)
        colorbar('horiz','FontName',FontName,'FontSize',FontSize);
    end
    
    ylabel(ylabel_name,'FontName',FontName,'FontSize',FontSize2,'Interpreter','None');
    title([first_name2{one}],'FontName',FontName,'FontSize',FontSize2,'Interpreter','None');
    text(0,125,['(',first_name3{one},')'],'FontName',FontName,'FontSize',FontSize2,'Interpreter','None');
    
    set(gcf,'PaperUnits','inches','PaperPosition',PaperPosition,'color',[1,1,1],'PaperOrientation','landscape');
    print('-djpeg','-r1000',[pathfig,'.jpg']);
    print('-dpdf','-r1000',[pathfig,'.pdf']);
    one
end
