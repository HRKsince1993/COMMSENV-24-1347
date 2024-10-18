clc;clear

five = 1;% 202301 to 202302. 1:ERA5;2:GODAS;3:Song;4:no 202301 to 202302
for one = 1:3 % 1:TPCtrl;2:NTAandTIOandPMMandSEPlg;3:NTAandTIOandPMMandSEPandWWB;
    first_name = {'TPCtrl','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb'};
    first_name2 = {'CESM-TP','CESM-TP+G','CESM-TP+G+WWBs'};
    first_name3 = {'b','c','d','e','f'};
    
    three = 1;% 1:Equator;2:Equator North;3:Equator South;4:North Equator
    four = 1;% 1:Pacific;2:Global
    six = 6;% Colorbar 1 to 5

    second_name = {'Ctrl','TroPac','TPCtrl'};
    third_name = {'Equ','Equ_N','Equ_S','Equ_N2'};
    fourth_name = {'Pac','Global'};
    fifth_name = {'ERA5JF','GODASJF','SongJF','noJF'};

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
    path1 = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'/'];
    struct = dir([path1,'*.mat']);
    name1 = {struct.name}';
    
    aimpath = ['F:\2023PMM_Work\Figures_for_Publish\Figure\Fig1_SecEquator_Monthly\',fifth_name{five},'_Color',num2str(six),'\'];
    if exist(aimpath,'dir')~=7
        mkdir(aimpath);
    end
    
    savename = ['Fig1',first_name3{one},'_Exp_',first_name{one},'_SSTA_Sec',fourth_name{four},third_name{three},'_',fifth_name{five},'_Color',num2str(six)];
    pathfig = [aimpath,savename];

    load([path1,'Compose_SSTA_Global_Monthly_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-8),'.mat']);% SST
    data2 = load([path1,'Compose_SecIso20A_SecEqutor_Monthly_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-8),'.mat']);% D20
    %%
    switch five
        case 1 % ERA5
            data1 = load('G:\ENSO_Work/Data_ENSO/SSTA_Global_Monthly_ERA5_1979to2023.mat');
        case 2 % GODAS
            data1 = load('G:\ENSO_Work/Data_ENSO/SSTA_Global_Monthly_GODAS_1980to2023.mat');
        case 3 % Song
            data1 = load('F:\2023PMM_Work/bin_data/SSTA_Song_202301to202302.mat');
    end
    c = data1.date(:,1)== 2023 & data1.date(:,2)<= 2;
    ssta_obs2023 = data1.ssta(:,:,c);

    ssta = cat(3,ssta_obs2023,ssta_ensamble);
    t_ssta = cat(3,ones(size(ssta_obs2023)),t_ssta_ensamble);
    
    a = lon >= lon_box(1) & lon <= lon_box(2);
    b = lat >= lat_box(1) & lat <= lat_box(2);
    bin_ssta = squeeze(nanmean(ssta(a,b,:),2));
    bin_ssta_t = squeeze(nanmean(t_ssta(a,b,:),2));
    bin_ssta_t(bin_ssta_t < 0.5) = nan;
    bin_ssta_t(bin_ssta_t >= 0.5) = 1;
    bin_ssta = bin_ssta.*bin_ssta_t;
    
    fig1_lon = lon(a);
    fig1 = bin_ssta;
    fig1_date = date;
    
    fig1_lon = cat(1,fig1_lon(1:31),fig1_lon(34:149),fig1_lon(152:end));
    fig1 = cat(1,fig1(1:31,:),fig1(34:149,:),fig1(152:end,:));
    
    a = find(data2.sec_lon >= lon_box(1) & data2.sec_lon <= lon_box(2));
    t_iso20a = data2.t_iso20a_ensamble;
    iso20a = data2.iso20a_ensamble;
    t_iso20a(t_iso20a < 1) = nan;
    %%
    bin_iso20a = iso20a(a,:).*t_iso20a(a,:);
    fig2_lon = data2.sec_lon(a);
    
    data2b = load('F:\2023PMM_Work/bin_data/SecGloEquISO20_Monthly_2023.mat');
    data2c = load('F:\ENSO_Work/bin_data/SecGloEquISO20_MonthCli1980to2022.mat');
    a = find(data2b.sec_lon >= lon_box(1) & data2b.sec_lon <= lon_box(2));
    bin_iso20a_obs = data2b.iso_20(a,1:3) - data2c.iso_20_month_cli(a,1:3);
    bin_iso20a_lon = data2b.sec_lon(a);
    bin_iso20a_date = data2b.date;
    clear bin_iso20a_obs2
    for i1 = 1:size(bin_iso20a_obs,2)
        bin_iso20a_obs2(:,i1) = interp1(bin_iso20a_lon,bin_iso20a_obs(:,i1),fig2_lon,'linear');
    end
    fig2 = cat(2,bin_iso20a_obs2,bin_iso20a);
    fig2_date = cat(1,data2b.date(1:3,:),data2.date);
    %%
    fig2a = fig2;
    fig2b = fig2;
    fig2a( fig2a < 0 ) = nan;
    fig2b( fig2b > 0 ) = nan;
    %%
    FontSize = 20;
    FontSize2 = 20;
    FontSize3 = 10;
    FontName = 'Arial';
    LW = 2;% lines
    LW2 = 1;% contour
    LW3 = 3;% contour
    
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
    lv_d20 = 10;
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
    set(0,'DefaultFigureVisible', 'on');

    close all
    [cs1,h1] = contourf(fig1_lon,1:size(fig1,2),fig1','levelstep',lv_ssta);
    hold on
%     [cs1b,h1b] = contourf(fig1_lon,3:14,fig1(:,4:end)','levelstep',lv_ssta);
%     [cs2,h2] = contour(fig2_lon,1:3,fig2a(:,1:3)','color',[0,0,0],'LineWidth',LW2,'LineStyle','-','levelstep',lv_d20);
%     [cs2b,h2b] = contour(fig2_lon,3:14,fig2a(:,4:end)','color',[0,0,0],'LineWidth',LW2,'LineStyle','-','levelstep',lv_d20);
%     [cs3,h3] = contour(fig2_lon,1:3,fig2b(:,1:3)','color',[0,0,1],'LineWidth',LW2,'LineStyle','--','levelstep',lv_d20);
%     [cs3b,h3b] = contour(fig2_lon,3:14,fig2b(:,4:end)','color',[0,0,1],'LineWidth',LW2,'LineStyle','--','levelstep',lv_d20);
    
    rectangle('Position',[fig1_lon(1),2.9,fig1_lon(end)-fig1_lon(1),0.1],'Curvature',[0,0],'FaceColor',[1,0,1],'EdgeColor','None');
    
    % [X,Y] = meshgrid(fig_lon,1:size(fig1,2));
    % d_num = 1;
    % d_num2 = 5;
    % h5 = quiver(X(1:d_num:end,1:d_num2:end),Y(1:d_num:end,1:d_num2:end)...
    %     ,fig1(1:d_num2:end,1:d_num:end)',fig2(1:d_num2:end,1:d_num:end)','color',[0,0,0]...
    %     ,'LineStyle','-','LineWidth',LW3,'ShowArrowHead','on','AutoScale','off');
    
    ax = gca;
    colormap(ax,cb_RedBlue)
    caxis([-cbar,cbar]);
    % colorbar
    
    set(h1,'LineColor','none');
%     set(h1b,'LineColor','none');
%     set(h2,'ShowText','on','TextStep',get(h2,'LevelStep'));
%     clabel(cs2,h2,'FontName',FontName,'fontsize',FontSize3);
%     set(h2b,'ShowText','on','TextStep',get(h2b,'LevelStep'));
%     clabel(cs2b,h2b,'LabelSpacing',500,'FontName',FontName,'fontsize',FontSize3);
%     set(h3,'ShowText','on','TextStep',get(h3,'LevelStep'));
%     clabel(cs3,h3,'FontName',FontName,'fontsize',FontSize3);
%     set(h3b,'ShowText','on','TextStep',get(h3b,'LevelStep'));
%     clabel(cs3b,h3b,'FontName',FontName,'fontsize',FontSize3);
    %%
    xtick = get(gca,'xtick');
    % str = get(gca,'xticklabel');
    clear xticklabel

    if one <= 4
        for i2 = 1:length(xtick)
            if xtick(i2) < 180 && xtick(i2) > 0
                xticklabel{i2} = [num2str(xtick(i2)),'буE'];
            elseif xtick(i2) == 180 || xtick(i2) == 0
                xticklabel{i2} = [num2str(xtick(i2)),'бу'];
            else
                xticklabel{i2} = [num2str(360-xtick(i2)),'буW'];
            end
        end
    else
        xticklabel = [];
    end

    ytick = 1:14;
    if one == 0
        yticklabel = text_month(1:14);
    else
        yticklabel = [];
    end
    
    ylim([1,14])
    set(gca,'xtick',xtick(1:2:end),'xticklabel',xticklabel(1:2:end),'ytick',ytick,'yticklabel',yticklabel,'Layer','top','FontSize',FontSize,'FontName',FontName,'ydir','reverse');
    xtickangle(0)
    
    % text(fig_lon(end)+55,mean(time)+20,'SST[буC]','rotation',90,'FontName',FontName,'FontSize',FontSize,'Interpreter','None');
    % text(200-15,2.8,[num2str(360-200),'буW'],'FontName',FontName,'FontSize',FontSize,'Interpreter','None');
    % text(250-15,2.8,[num2str(360-250),'буW'],'FontName',FontName,'FontSize',FontSize,'Interpreter','None');
    if one == 0
        title(['(',first_name3{one},') ',first_name2{one},' and ',fifth_name{five}],'FontName',FontName,'FontSize',FontSize2,'Interpreter','None');
    else
        text(fig1_lon(1),ytick(1)-(ytick(end)-ytick(1))/30,['(',first_name3{one},')'],'FontName',FontName,'FontSize',FontSize2,'Interpreter','None');
        title([first_name2{one}],'FontName',FontName,'FontSize',FontSize2,'Interpreter','None');
    end
    % xlabel([first_name2{one}],'FontName',FontName,'FontSize',FontSize2,'Interpreter','None');
    %%
    set(gcf,'PaperUnits','inches','PaperPosition',PaperPosition,'color',[1 1 1]);
    print('-djpeg','-r1000',[pathfig,'.jpg']);
    print('-dpdf','-r1000',[pathfig,'.pdf']);
    %%
    if one == 1
        colorbar('FontSize',FontSize,'FontName',FontName)
        % ylabel(colorbar,'SST[буC]','FontSize',FontSize,'FontName',FontName)
        % title([fourth_name{four},third_name{three},'[',text_lon{1},'-',text_lon{2},', ',text_lat{1},'-',text_lat{2},'] SSTA and D20A'],'FontName',FontName,'FontSize',FontSize2,'Interpreter','None');
        yticklabel = text_month(1:12);
        set(gca,'xtick',xtick(1:2:end),'xticklabel',xticklabel(1:2:end),'ytick',ytick,'yticklabel',yticklabel,'Layer','top','FontSize',FontSize,'FontName',FontName,'ydir','reverse');

        pathfig2 = [aimpath,'Colorbar_',savename];
        set(gcf,'PaperUnits','inches','PaperPosition',PaperPosition,'color',[1 1 1]);
        print('-djpeg','-r1000',[pathfig2,'.jpg']);
        print('-dpdf','-r1000',[pathfig2,'.pdf']);
    end
end