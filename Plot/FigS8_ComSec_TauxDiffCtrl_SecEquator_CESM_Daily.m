clc;clear

for one = 1:5 % 1:PMM;2:SEP;3:TIO;4:NTA;5:NTAandTIOandPMMandSEPlg;6:NTAandTIOandPMMandSEPandWWBb;7:NTAandTIOandPMMandSEPandWWBbmay;8:NTAandTIOandPMMandSEPandWWBb
    two = 1;% 1:TPCtrl; 2:NTAandTIOandPMMandSEPlg
    three = 6;% Colorbar 1 to 6
    five = 1;% 1:no colorbar;2:colorbar

    first_name = {'PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay','NTAandTIOandPMMandSEPandWWBb'};
    first_name2 = {'CESM-TP+NETP','CESM-TP+SETP','CESM-TP+TIO','CESM-TP+TA','CESM-TP+G','CESM-TP+G+WWBs','CESM-TP+G+WWB1','CESM-TP+G+WWBs'};
    first_name3 = {'a','b','c','d','e','f','g','h','i','j','k'};
    second_name = {'TPCtrl','NTAandTIOandPMMandSEPlg'};
    second_name2 = {'CESM-TP','CESM-TP+G'};
    fifth_name = {[],'Colorbar_'};

    % Pacific
    lon_box = [140,360-80];
    lat_box = [-5,5];
    PaperPosition = [0.1 0 5 8];

    yu1_taux = 0.02;% wind burst threshold value

    path1 = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\'];
    struct = dir([path1,'*.mat']);
    name1 = {struct.name}';

    aimpath = ['F:\2023PMM_Work\Figures_for_Publish\Figure\FigS8_SecEquator_Daily\Color',num2str(three),'\'];
    if exist(aimpath,'dir')~=7
        mkdir(aimpath);
    end

    pathfig = [aimpath,fifth_name{five},'FigS8',first_name3{one},'_UvelDiffCtrl_SecEquator_Monthly_Exp_',first_name{one},'_Color',num2str(three)];
    data1 = load([path1,'Compose_SecSSTdiff',second_name{two},'_SecEquator_Daily_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-8),'.mat']);% SST daily
    data2 = load([path1,'Compose_SecOcnUvelDiff',second_name{two},'_SecEquator_Monthly_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-8),'.mat']);% Uvel
    data3 = load([path1,'Compose_SecTauxDiff',second_name{two},'_SecEquator_Monthly_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-8),'.mat']);% Taux
    data4 = load([path1,'Compose_SecTauyDiff',second_name{two},'_SecEquator_Monthly_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-8),'.mat']);% Tauy

    lon = data1.lon;
    lat = data1.lat;
    depth = data2.depth;
    date1 = data1.date;

    a1 = lon >= lon_box(1) & lon <= lon_box(2);
    c1 = depth <= 55;

    bin1_lon = lon(a1);

    ssta = data1.ssta_ensemble(a1,:);
    t_ssta = data1.t_ssta_ensemble(a1,:);

    uvela = data2.uvela_ensemble(a1,c1,:);
    t_uvela = data2.t_uvela_ensemble(a1,c1,:);

    tauxa = data3.tauxa_ensemble(a1,:);
    t_tauxa = data3.t_tauxa_ensemble(a1,:);
    tauya = data4.tauya_ensemble(a1,:);
    t_tauya = data4.t_tauya_ensemble(a1,:);
    %%
    bin_ssta = ssta;
    bin_uvela = squeeze(nanmean(uvela,2));
    bin_tauxa = tauxa;
    bin_tauya = tauya;

    bin_ssta_t = t_ssta;
    bin_uvela_t = squeeze(mean(t_uvela,2));
    bin_tauxa_t = t_tauxa;
    bin_tauya_t = t_tauya;

    bin_ssta_t(bin_ssta_t > 0) = 1;
    bin_ssta_t(bin_ssta_t < 1) = nan;
    bin_uvela_t(bin_uvela_t > 0 ) = 1;
    bin_uvela_t(bin_uvela_t < 1 ) = nan;
    % bin_tau_t = bin_tauxa_t + bin_tauya_t;
    bin_tau_t = bin_tauxa_t;
    bin_tau_t(bin_tau_t == 0) = nan;
    bin_tau_t(bin_tau_t > 0) = 1;
    %%
    FontSize = 20;
    FontSize2 = 20;
    FontSize3 = 10;
    FontName = 'Arial';
    LW = 2;% lines
    LW2 = 1;% contour
    LW3 = 1;% quiver

    text_letter = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n'};
    text_month = {'Jan/23','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','Jan/24','Feb'};

    cbar = 3.55;
    ls_sst = 0.1;
    ls_uvel = 0.02;
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
    %%
    bin1 = bin_ssta(:,1);
    a1 = find(~isnan(bin1));

    fig1_lon = bin1_lon(a1);

    fig1 = bin_ssta(a1,:).*bin_ssta_t(a1,:);
    % fig1 = bin_tempa(a1,:);

    fig1_time = date1(1,4):date1(end,5);
    fig2_time = date1(:,4);

    % fig2 = bin_uvela.*bin_uvela_t;
    fig2 = bin_uvela(a1,:);
    fig2a = fig2;
    fig2b = fig2;
    fig2a( fig2a < 0 ) = nan;
    fig2b( fig2b > 0 ) = nan;

    k_scale = 1000;
    b1 = (fig1_lon(end)-fig1_lon(1)+1)/(fig1_time(end)-fig1_time(1)+60)/(PaperPosition(3)/PaperPosition(4));% 解决quiver失真问题，横纵轴比例/图片比例
    fig3 = bin_tauxa(a1,:).*bin_tau_t(a1,:)*k_scale;
    % fig4 = bin_tauya(a1,:).*bin_tau_t(a1,:)*k_scale/b1;
    fig4 = zeros(size(bin_tauya(a1,:)));

    fig1_test = bin_ssta_t(a1,:);
    fig2_test = bin_uvela_t(a1,:);
    %%
    close all

    [cs,h] = contourf(fig1_lon,fig1_time,fig1','levelstep',ls_sst);
    hold on
    % [cs2,h2] = contour(fig1_lon,fig1_time,fig2a','levelstep',ls_uvel,'Color',[132,60,112]/255,'LineWidth',LW2,'LineStyle','-');
    % [cs3,h3] = contour(fig1_lon,fig1_time,fig2b','levelstep',ls_uvel,'Color',[0,0,1],'LineWidth',LW2,'LineStyle','--');
    % [cs4,h4] = contour(fig1_lon,fig1_time,fig2',[0,0],'Color',[132,60,112]/255,'LineWidth',LW2,'LineStyle','-');

    rectangle('Position',[fig1_lon(1),fig2_time(1)-2,fig1_lon(end)-fig1_lon(1),2],'Curvature',[0,0],'FaceColor',[1,0,1],'EdgeColor','None');
    % xtickangle(0)

    % d_num = 2;
    % fig3_time = 3:size(fig1,2)+2;
    % [x2,y2]=find(fig1_test>=1);
    % plot(fig1_lon(x2(1:d_num:end)),fig3_time(y2(1:d_num:end)),'g.','markersize',5,'color',[0.3,0.3,0.3]);

    bpq = [2,2];% box_plot_quiver
    box_xdum = [25,10];% intervel of quiver
    for i2 = 1:size(fig3,2)
        pro = fig3(:,i2);
        a1 = find(~isnan(pro));

        if length(a1) <= 1
            continue
        end

        a2 = find(diff(a1) ~= 1);
        if length(a2) < 1 % only 1 data
            l_len = a1;
            fig3_lon = fig1_lon(l_len);
            fig3_pro = pro(l_len);

            if length(fig3_lon) <= 2
                continue
            end

            if length(fig3_lon) >= 10 || mean(fig3_pro) >= yu1_taux
                d_num = box_xdum(1);
            else
                d_num = box_xdum(2);
            end

            for i4 = 3:d_num:length(fig3_lon)
                plot([fig3_lon(i4),fig3_lon(i4)+fig3_pro(i4)],[fig2_time(i2),fig2_time(i2)],'color',[0,0,0],'LineWidth',LW3,'LineStyle','-')
                if fig3_pro(i4) > 0
                    plot([fig3_lon(i4)+fig3_pro(i4),fig3_lon(i4)+fig3_pro(i4)-bpq(1)],[fig2_time(i2)+0.01,fig2_time(i2)-bpq(2)],'color',[0,0,0],'LineWidth',LW3,'LineStyle','-')
                    plot([fig3_lon(i4)+fig3_pro(i4),fig3_lon(i4)+fig3_pro(i4)-bpq(1)],[fig2_time(i2)-0.01,fig2_time(i2)+bpq(2)],'color',[0,0,0],'LineWidth',LW3,'LineStyle','-')
                else
                    plot([fig3_lon(i4)+fig3_pro(i4),fig3_lon(i4)+fig3_pro(i4)+bpq(1)],[fig2_time(i2)+0.01,fig2_time(i2)-bpq(2)],'color',[0,0,0],'LineWidth',LW3,'LineStyle','-')
                    plot([fig3_lon(i4)+fig3_pro(i4),fig3_lon(i4)+fig3_pro(i4)+bpq(1)],[fig2_time(i2)-0.01,fig2_time(i2)+bpq(2)],'color',[0,0,0],'LineWidth',LW3,'LineStyle','-')
                end
            end
        else % more than 1 data
            for i3 = 1:length(a2)+1
                if i3 == 1
                    l_len = a1(1):a1(a2(1));
                elseif i3 == length(a2)+1
                    l_len = a1(a2(i3-1)+1):a1(end);
                else
                    l_len = a1(a2(i3-1)+1):a1(a2(i3));
                end
                fig3_lon = fig1_lon(l_len);
                fig3_pro = pro(l_len);

                if length(fig3_lon) <= 2
                    continue
                end

                if length(fig3_lon) >= 10 || mean(fig3_pro) >= yu1_taux
                    d_num = box_xdum(1);
                else
                    d_num = box_xdum(2);
                end

                for i4 = 3:d_num:length(fig3_lon)
                    plot([fig3_lon(i4),fig3_lon(i4)+fig3_pro(i4)],[fig2_time(i2),fig2_time(i2)],'color',[0,0,0],'LineWidth',LW3,'LineStyle','-')
                    if fig3_pro(i4) > 0
                        plot([fig3_lon(i4)+fig3_pro(i4),fig3_lon(i4)+fig3_pro(i4)-bpq(1)],[fig2_time(i2)+0.01,fig2_time(i2)-bpq(2)],'color',[0,0,0],'LineWidth',LW3,'LineStyle','-')
                        plot([fig3_lon(i4)+fig3_pro(i4),fig3_lon(i4)+fig3_pro(i4)-bpq(1)],[fig2_time(i2)-0.01,fig2_time(i2)+bpq(2)],'color',[0,0,0],'LineWidth',LW3,'LineStyle','-')
                    else
                        plot([fig3_lon(i4)+fig3_pro(i4),fig3_lon(i4)+fig3_pro(i4)+bpq(1)],[fig2_time(i2)+0.01,fig2_time(i2)-bpq(2)],'color',[0,0,0],'LineWidth',LW3,'LineStyle','-')
                        plot([fig3_lon(i4)+fig3_pro(i4),fig3_lon(i4)+fig3_pro(i4)+bpq(1)],[fig2_time(i2)-0.01,fig2_time(i2)+bpq(2)],'color',[0,0,0],'LineWidth',LW3,'LineStyle','-')
                    end
                end
            end
        end

    end
    
    rectangle('Position',[220,fig2_time(1)-45,53,30],'Curvature',[0,0],'FaceColor',[1,1,1]);
    quiver(220+3,fig2_time(1)-40,0.01*k_scale,0,'color',[0,0,0],'LineStyle','-','LineWidth',LW3,'MaxHeadSize',1,'ShowArrowHead','on','AutoScale','off');
    text(220+3,fig2_time(1)-31,'0.01N m^{-2}','FontName',FontName,'FontSize',FontSize2);

    ax = gca;
    colormap(ax,cb_RedBlue)
    caxis([-cbar,cbar]);

    set(h,'LineColor','none');
    % set(h2,'ShowText','on','TextStep',get(h2,'LevelStep')*2);
    % clabel(cs2,h2,'FontName',FontName,'fontsize',FontSize3);
    % set(h3,'ShowText','on','TextStep',get(h3,'LevelStep')*2);
    % clabel(cs3,h3,'FontName',FontName,'fontsize',FontSize3);
    % set(h4,'ShowText','on','TextStep',get(h4,'LevelStep')*2);
    % clabel(cs4,h4,'FontName',FontName,'fontsize',FontSize3);

    xtick = lon_box(1):20:lon_box(2);
    clear xticklabel
    for i2 = 1:length(xtick)
        if xtick(i2) < 180 && xtick(i2) > 0
            xticklabel{i2} = [num2str(xtick(i2)),'°E'];
        elseif xtick(i2) == 180 || xtick(i2) == 0
            xticklabel{i2} = [num2str(xtick(i2)),'°'];
        else
            xticklabel{i2} = [num2str(360-xtick(i2)),'°W'];
        end
    end

    if one <= 2
        xticklabel = [];
    end

    ytick = cat(1,fig2_time(1)-28-31,fig2_time(1)-28,fig2_time);
    if one == 1 || one == 4
        yticklabel = text_month;
    else
        yticklabel = [];
    end

    if five == 2
        colorbar('FontSize',FontSize,'FontName',FontName)
    end

    xlim([lon_box(1),lon_box(2)]);
    ylim([ytick(1),ytick(end)+31])
    set(gca,'xtick',xtick(1:2:end),'xticklabel',xticklabel(1:2:end),'ytick',ytick,'yticklabel',yticklabel,'Layer','top','FontSize',FontSize,'FontName',FontName,'ydir','reverse');
    xtickangle(0)
    
    text(fig1_lon(1),ytick(1)-(ytick(end)-ytick(1))/35,['(',first_name3{one},')'],'FontName',FontName,'FontSize',FontSize2,'Interpreter','None');
    title([first_name2{one}],'FontName',FontName,'FontSize',FontSize2,'Interpreter','None');
    %%
    set(gcf,'PaperUnits','inches','PaperPosition',PaperPosition,'color',[1 1 1]);
    print('-djpeg','-r1000',[pathfig,'.jpg']);
    print('-dpdf','-r1000',[pathfig,'.pdf']);

    if one == 1
        colorbar('FontSize',FontSize,'FontName',FontName)
        pathfig2 = [aimpath,fifth_name{2},'FigS8',first_name3{one},'_UvelDiffCtrl_SecEquator_Monthly_Exp_',first_name{one},'_Color',num2str(three)];
        print('-djpeg','-r1000',[pathfig2,'.jpg']);
        print('-dpdf','-r1000',[pathfig2,'.pdf']);
    end
end