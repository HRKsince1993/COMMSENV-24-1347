clc;clear

for one = 1:3 % 1:NTAandTIOandPMMandSEPandWWBbmay;2:NTAandTIOandPMMandSEPandWWBb;3:NTAandTIOandPMMandSEPandWWBb
    two = 1;% 1:NTAandTIOandPMMandSEPlg
    three = 1;% 1:Equator;2:Equator North;3:Equator South;4:North Equator
    four = 1;% 1:Pacific;2:Global
    five = 1;% 1:ERA5
    six = 6;% Colorbar 1 to 6

    first_name = {'NTAandTIOandPMMandSEPandWWBbmay','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBOctNov'};
    first_name2 = {'CESM-TP+G+WWB1','CESM-TP+G+WWBs','CESM-TP+G+WWB2'};
    first_name3 = {'a','c','b'};
    second_name = {'NTAandTIOandPMMandSEPlg'};
    second_name2 = {'CESM-TP+G'};
    
    third_name = {'Equ','Equ_N','Equ_S','Equ_N2'};
    fourth_name = {'Pac','Global'};
    fifth_name = {'_ERA5'};
    
    yu_wwb = 0.02;
    switch four
        case 1 % pacific
            lon_box = [120,360-80];
            PaperPosition = [0.1 0 5 8];
        case 2 % Global
            lon_box = [0,360];
            PaperPosition = [0.1 0 8 8];
    end
    switch three
        case 1
            lat_box = [-5,5];
        case 2
            lat_box = [5,10];
        case 3
            lat_box = [-10,-5];
        case 4
            lat_box = [15,30];
    end
    path1 = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\'];
    struct = dir([path1,'*.mat']);
    name1 = {struct.name}';
    
    aimpath = ['F:\2023PMM_Work\Figures_for_Publish\Figure\FigS17_SecEquator_Monthly\Color',num2str(six),'\'];
    if exist(aimpath,'dir')~=7
        mkdir(aimpath);
    end
    
    pathfig = [aimpath,'FigS17',first_name3{one},'_Exp_',first_name{one},'_SSTA_Sec',fourth_name{four},third_name{three},fifth_name{five},'_Color',num2str(six)];
    load([path1,'Compose_SSTdiff',second_name{two},'_Global_Daily_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-8),'.mat']);% SSH
    data1 = load([path1,'SST_Casely_Daily\SST_Global_Daily_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-8),'_01.mat']);
    data2 = load([path1,'Compose_Uvel50diff',second_name{two},'_Global_Monthly_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-8),'.mat']);% Uvel
    data3 = load('F:\2023PMM_Work\bin_data\Find_WWB_Method\TauxA_WWB_Input_Daily_ERA5.mat');
    
    time = data1.time;
    ssta = ssta_ensemble;
    t_ssta = t_ssta_ensemble;
    
    date2 = data2.date;
    time2 = data2.time;
    uvela = data2.uvela_ensemble*100;% cm/s
    t_uvela = data2.t_uvela_ensemble;
    
    date3 = data3.date;
    taux = data3.taux_wwb_day_sstgrid;
    
    a = find(date3(:,1) == 2023 & date3(:,2) == 11 & date3(:,3) == 30);
    date3(1:a,4) = date(9,5)-a+1:date(9,5);
    date3(a:end,4) = date(9,5):date(9,5)+size(date3,1)-a;
    time3 = date3(:,4);
    %%
    a = lon >= lon_box(1) & lon <= lon_box(2);
    b = lat >= lat_box(1) & lat <= lat_box(2);
    bin_ssha = squeeze(nanmean(ssta(a,b,:),2));
    bin_ssha_t = squeeze(nanmean(t_ssta(a,b,:),2));
    bin_ssha_t(bin_ssha_t < 0.5) = nan;
    bin_ssha_t(bin_ssha_t >= 0.5) = 1;
    
    bin_uvela = squeeze(nanmean(uvela(a,b,:),2));
    bin_uvela_t = squeeze(nanmean(t_uvela(a,b,:),2));
    bin_uvela_t(bin_uvela_t < 0.5) = nan;
    bin_uvela_t(bin_uvela_t >= 0.5) = 1;
    bin_uvela = bin_uvela.*bin_uvela_t;
    
    bin_taux = squeeze(nanmean(taux(a,b,:),2));
    clear bin3_lon;
    for i1 = 1:size(bin_taux,2)
        bin3_lon(:,i1) = lon(a);
    end
    bin3_lon( bin_taux < yu_wwb ) = nan;
    bin3_lon( isnan(bin_taux) ) = nan;
    
    fig1_lon = lon(a);
    fig1_test = bin_ssha_t;
    fig1 = bin_ssha.*bin_ssha_t;
    fig1_date = date;
    fig1_time = time;
    fig1_lon = cat(1,fig1_lon(1:31),fig1_lon(34:149),fig1_lon(152:end));
    fig1 = cat(1,fig1(1:31,:),fig1(34:149,:),fig1(152:end,:));
    fig1_test = cat(1,fig1_test(1:31,:),fig1_test(34:149,:),fig1_test(152:end,:));
    
    fig2_lon = lon(a);
    fig2 = bin_uvela;
    fig2_date = date2;
    fig2_time = time2;
    fig2a = fig2;
    fig2b = fig2;
    fig2a( fig2a < 0 ) = nan;
    fig2b( fig2b > 0 ) = nan;
    
    fig3_lon = lon(a);
    fig3 = bin3_lon;
    fig3_date = date3;
    fig3_time = time3;
    if one == 1
        a = fig3_date(:,2) == 5;
    elseif one == 2
        a = fig3_date(:,2) == 5 | fig3_date(:,2) == 10 | fig3_date(:,2) == 11;
    elseif one == 3
        a = fig3_date(:,2) == 10 | fig3_date(:,2) == 11;
    end
    fig3(:,~a) = nan;
    %%
    FontSize = 20;
    FontSize2 = 20;
    FontSize3 = 10;
    FontName = 'Arial';
    LW = 2;% lines
    LW2 = 1;% contour
    LW3 = 1;% plot
    
    clear text_lon text_lat
    for i = 1:length(lon_box)
        if lon_box(i)< 180
            text_lon{i} =[num2str(lon_box(i)),'буE'];
        elseif lon_box(i) == 180
            text_lon{i} =[num2str(lon_box(i)),'бу'];
        elseif lon_box(i) > 180 && lon_box(i) <= 360
            text_lon{i} =[num2str(360-lon_box(i)),'буW'];
        end
    end
    for i = 1:length(lat_box)
        if lat_box(i)< 0
            text_lat{i} =[num2str(-lat_box(i)),'буS'];
        elseif lat_box(i) == 0
            text_lat{i} =[num2str(lat_box(i)),'бу'];
        elseif lat_box(i) > 0
            text_lat{i} =[num2str(lat_box(i)),'буN'];
        end
    end
    
    text_letter = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n'};
    text_month = {'Jan/23','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','Jan/24','Feb'};
    
    cbar = 3.55;
    lv_ssta = 0.1;
    lv_uvel = 5;
    if six == 1
        cb_RedBlue = input_colorbar_rgb('F:\PMM_For_Paper\colorbar\cb_RedBlue_SST.rgb')/255;
    elseif six == 2
        cb_RedBlue = input_colorbar_rgb('F:\PMM_For_Paper\colorbar\cb_RedBlue_SST.rgb')/255;
        cb_RedBlue(13,:) = [1,1,1];
        cb_RedBlue(14,:) = [1,1,1];
        cb_RedBlue = cb_RedBlue(4:end-3,:);
        for i2 = 3:-1:0
            cb_RedBlue(end-i2,:) = cb_RedBlue(end-i2-1,:)*0.8+cb_RedBlue(end-i2,:)*0.2;
        end
    elseif six == 3
        cb_RedBlue = input_colorbar_rgb('F:\PMM_For_Paper\colorbar\cb_RedBlue_SST52.rgb')/255;
        cb_RedBlue(26:27,:) = ones(2,3);
    elseif six == 4
        cb_RedBlue = input_colorbar_rgb('F:\PMM_For_Paper\colorbar\cb_RedBlue_SST104.rgb')/255;
        cb_RedBlue(52:53,:) = ones(2,3);
    elseif six == 5
        cb_RedBlue = input_colorbar_rgb('F:\PMM_For_Paper\colorbar\cb_RedBlue_SST.rgb')/255;
        cb_RedBlue(13:14,:) = ones(2:3);
        % cb_RedBlue(24,:) = cb_RedBlue(23,:)*0.6+cb_RedBlue(24,:)*0.4;
        cb_RedBlue = cb_RedBlue(1+1:end-1,:);
        for i2 = 4:-1:0
            cb_RedBlue(end-i2,:) = cb_RedBlue(end-i2-1,:)*0.8+cb_RedBlue(end-i2,:)*0.2;
        end
    elseif six == 6
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
    close all
    [cs,h] = contourf(fig1_lon,fig1_time,fig1','levelstep',lv_ssta);
    hold on
    [cs2,h2] = contour(fig2_lon,fig1_date(:,4),fig2a','color',[132,60,112]/255,'LineWidth',LW2,'LineStyle','-','levelstep',lv_uvel);
    [cs3,h3] = contour(fig2_lon,fig1_date(:,4),fig2b','color',[0,0,1],'LineWidth',LW2,'LineStyle','--','levelstep',lv_uvel);
    
    % d_num = 3;
    % [x2,y2]=find(fig1_test>=1);
    % plot(fig1_lon(x2(1:d_num:end)),fig1_time(y2(1:d_num:end)),'g.','markersize',3,'color',[0.3,0.3,0.3]);
    
    rectangle('Position',[fig1_lon(1),fig1_date(1,4)-3,fig1_lon(end)-fig1_lon(1),3],'Curvature',[0,0],'FaceColor',[1,0,1],'EdgeColor','None');
    % xtickangle(0)
    
    for i1 = 1:size(fig3,2)
        plot(fig3(:,i1),zeros(size(fig3,1),1)+fig3_time(i1),'color',[0,0,0],'LineWidth',LW3,'LineStyle','-')
    end
    
    ax = gca;
    colormap(ax,cb_RedBlue)
    caxis([-cbar,cbar]);
    % colorbar
    
    set(h,'LineColor','none');
    set(h2,'ShowText','on','TextStep',get(h2,'LevelStep')*2);
    clabel(cs2,h2,'FontName',FontName,'fontsize',FontSize3);
    set(h3,'ShowText','on','TextStep',get(h3,'LevelStep')*2);
    clabel(cs3,h3,'FontName',FontName,'fontsize',FontSize3);
    
    xtick = get(gca,'xtick');
    % str = get(gca,'xticklabel');
    clear xticklabel
    for i2 = 1:length(xtick)
        if xtick(i2) < 180 && xtick(i2) > 0
            xticklabel{i2} = [num2str(xtick(i2)),'буE'];
        elseif xtick(i2) == 180 || xtick(i2) == 0
            xticklabel{i2} = [num2str(xtick(i2)),'бу'];
        else
            xticklabel{i2} = [num2str(360-xtick(i2)),'буW'];
        end
    end
    ytick = cat(1,fig1_time(1)-59,fig1_time(1)-28,fig1_date(:,4));
    if one == 1
        yticklabel = text_month;
    else
        yticklabel = [];
    end
    
    ylim([fig1_time(1)-59,fig1_date(12,5)])
    set(gca,'xtick',xtick(1:2:end),'xticklabel',xticklabel(1:2:end),'ytick',ytick,'yticklabel',yticklabel,'Layer','top','FontSize',FontSize,'FontName',FontName,'ydir','reverse');
   xtickangle(0)

    text(fig1_lon(1),ytick(1)-(ytick(end)-ytick(1))/30,['(',first_name3{one},')'],'FontName',FontName,'FontSize',FontSize2,'Interpreter','None');
   
    % text(183,ytick(1)-(12-ytick(1))/30,first_name2{one},'FontName',FontName,'FontSize',FontSize2,'Interpreter','None');
    % title(['(',first_name3{one},') ',first_name2{one},'-',second_name2{two}],'FontName',FontName,'FontSize',FontSize2,'Interpreter','None');
    title([first_name2{one}],'FontName',FontName,'FontSize',FontSize2,'Interpreter','None');
    % xlabel([first_name2{one}],'FontName',FontName,'FontSize',FontSize2,'Interpreter','None');
    %%
    set(gcf,'PaperUnits','inches','PaperPosition',PaperPosition,'color',[1 1 1]);
    print('-djpeg','-r1000',[pathfig,'.jpg']);
    print('-dpdf','-r1000',[pathfig,'.pdf']);
    %%
    if one == 1
        colorbar('FontSize',FontSize,'FontName',FontName)
        % title([fourth_name{four},third_name{three},'[',text_lon{1},'-',text_lon{2},', ',text_lat{1},'-',text_lat{2},'] SSTA and D20A'],'FontName',FontName,'FontSize',FontSize2,'Interpreter','None');
        yticklabel = text_month;
        set(gca,'xtick',xtick(1:2:end),'xticklabel',xticklabel(1:2:end),'ytick',ytick,'yticklabel',yticklabel,'Layer','top','FontSize',FontSize,'FontName',FontName,'ydir','reverse');

        pathfig2 = [aimpath,'Colorbar_FigS17',first_name3{one},'_Exp_',first_name{one},'_SSTA_Sec',fourth_name{four},third_name{three},fifth_name{five},'_Color',num2str(six)];
        % print('-dpdf','-r1000',[pathfig2,'.pdf']);
        print('-djpeg','-r1000',[pathfig2,'.jpg']);
        print('-dpdf','-r1000',[pathfig2,'.pdf']);
    end
end