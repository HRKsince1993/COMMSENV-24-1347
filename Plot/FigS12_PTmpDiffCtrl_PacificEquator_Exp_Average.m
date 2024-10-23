clc;clear
%%
for one = 1:1 % 1:PMM;2:SEP;3:TIO;4:NTA;5:NTAandTIOandPMMandSEPlg;6:NTAandTIOandPMMandSEPandWWBb
    two = 1;% minus 1:TPCtrl;
    three = 1;% color 1;
    four = 1;% plot 1:tropical;2:global
    five = 2;% 1:no colorbar;2:colorbar
    first_name = {'PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb'};
    first_name2 = {'CESM-TP+NETP','CESM-TP+SETP','CESM-TP+TIO','CESM-TP+TA','CESM-TP+G','CESM-TP+G+WWBs'};
    first_name3 = {'a','b','c','d','e','f'};
    second_name = {'TPCtrl'};
    second_name2 = {'CESM-TP'};
    fourth_name = {'Tropical\',[]};
    fifth_name = {[],'Colorbar_'};
    
    lon_box = [140,360-85];
    cbar = 1;
    
    path1 = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\'];
    struct = dir([path1,'*.mat']);
    name1 = {struct.name}';
    
    aimpath = ['F:\2023PMM_Work\Figures_for_Publish\Figure\FigS12_SecPTmpDiffCtrl_PacEquator_Monthly\'];
    if exist(aimpath,'dir')~=7
        mkdir(aimpath);
    end
    
    len_m = (3:11)-2;% month
    pathfig = [aimpath,fifth_name{five},'FigS12',first_name3{one},'_Com_SecTempDiff',second_name{two},'_Month',num2str(len_m(1)+2),'to',num2str(len_m(end)+2),'_Exp_',first_name{one},'_Color',num2str(three)]
    
    data1 = load([path1,'Compose_SecTempDiff',second_name{two},'_SecEqutor_Monthly_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-8),'_Avr',num2str(len_m(1)+2),'to',num2str(len_m(end)+2),'Mon.mat']);% SSTdiff
    data5 = load([path1,'Compose_SecIso20_SecEqutor_Monthly_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-8),'.mat']);% Iso20
  %%
    sec_lon = data1.lon;
    sec_depth = data1.depth;
    tempa = data1.temp_ensemble;
    iso20 = data5.iso20_ensemble;
    t_tempa = data1.t_temp_ensemble;
    
    bin_iso20 = mean(iso20(:,len_m),2);
    bin_tempa = tempa;
    bin_tempa_t = t_tempa;
    bin_tempa_t( bin_tempa_t>0 ) = 1;
    bin_tempa_t(bin_tempa_t == 0) = nan;
    %%
    a = sec_lon >= lon_box(1) & sec_lon <= lon_box(2);
    bin_lon = sec_lon(a);
   
    bin2_iso20 = bin_iso20(a);
    bin_tempa2 = bin_tempa(a,:);
    bin_tempa2_t = bin_tempa_t(a,:);
    fig1_test = bin_tempa2_t';
    %%
    % set(0,'DefaultFigureVisible', 'off');
    a1 = bin_tempa2(:,1);
    a2 = ~isnan(a1);
    fig_lon = bin_lon(a2);
    fig_depth = sec_depth;
    bin_fig1 = bin_tempa2(a2,:);
    bin_fig2 = bin2_iso20(a2);
    bin_fig1_t = bin_tempa2_t(a2,:);
    %%
    % a = (lon_end-lon_start)/(lat_end-lat_start);
    % a = ceil(a*10)/10;
    % PaperPosition = [0 0 a 1]*5;
    PaperPosition = [0 0 8 4];
    
    FontSize = 20;%
    FontSize2 = 20;% title
    FontSize3 = 10;% legend
    FontName = 'Arial';
    LW = 1;
    LW2 = 2;% plot
    LW3 = 1;% quiver
    
    load('F:\PMM_For_Paper\colorbar\cb_subtemp.mat');cb_RedBlue = cb_RedBlue/255;
    %% 
    % fig1 = bin_fig1'.*bin_fig1_t';
    fig1 = bin_fig1';
    fig2 = bin_fig2;
    
    fig1_test = bin_fig1_t;

    % set(0,'DefaultFigureVisible', 'off');
    close all
   
    [cs,h] = contourf(fig_lon,fig_depth,fig1,'levelstep',0.01);
    hold on
    plot(fig_lon,fig2,'color',[0,0,0],'LineWidth',LW2);
    
    d_num = 2;
    [x2,y2]=find(fig1_test >= 1);
    plot(fig_lon(x2(1:d_num:end)),fig_depth(y2(1:d_num:end)),'g.','markersize',7,'color',[0.3,0.3,0.3]);% plot dots

    hold off

    set(h,'LineColor','none');
    ax = gca;
    colormap(ax,cb_RedBlue)
    caxis([-cbar,cbar]);
    
    if five == 1
%         colorbar('FontName',FontName,'FontSize',FontSize);
    elseif five == 2
        c1 = colorbar('horiz','FontName',FontName,'FontSize',FontSize);
        % colorbar('horiz','position',[0.13,0.127,0.78,0.02],'FontName',FontName,'FontSize',FontSize);
        PaperPosition = [0 0 8 5];
    end
    
    clear xticklabel
    xtick = 140:40:360-100;
    for i2 = 1:length(xtick)
        if xtick(i2) < 180
            xticklabel{i2} = [num2str(xtick(i2)),'буE'];
        elseif xtick(i2) == 180
            xticklabel{i2} = [num2str(xtick(i2)),'бу'];
        else
            xticklabel{i2} = [num2str(360-xtick(i2)),'буW'];
        end
    end

    ytick = 0:50:300;
    yticklabel = ytick;
    ylabel_name = 'Depth[m]';
    
    if one < 4
        xticklabel = [];
    end

    if mod(one,2) == 0
        yticklabel = [];
        ylabel_name = [];
    end
    
    set(gca,'xtick',xtick,'xticklabel',xticklabel,'ytick',ytick,'yticklabel',yticklabel,'xlim',[lon_box(1),lon_box(2)],'Ylim',[ytick(1),ytick(end)],'Ydir','reverse','FontName',FontName,'FontSize',FontSize);
    ylabel(ylabel_name,'FontName',FontName,'FontSize',FontSize);
    text(fig_lon(1),-(fig_depth(end)-fig_depth(1))/36,['(',first_name3{one},') ',first_name2{one}],'FontName',FontName,'FontSize',FontSize2)
    %%
    pathfig = [aimpath,fifth_name{five},'FigS12',first_name3{one},'_ComSec_PtmpDiffCtrl_',first_name{one}];
    set(gcf,'PaperUnits','inches','PaperPosition',PaperPosition,'color',[1 1 1],'PaperOrientation','landscape');
    print('-djpeg','-r1000',[pathfig,'.jpg'])
    print('-dpdf','-r1000',[pathfig,'.pdf']);
end