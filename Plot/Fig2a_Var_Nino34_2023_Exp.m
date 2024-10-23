clc;clear
aimpath = ['F:\2023PMM_Work\Figures_for_Publish\Figure\Fig2_Var_Nino34_Exp\'];
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end

for one = 1:3 % 1:TPCtrl;2:NTAandTIOandPMMandSEPlg;3:NTAandTIOandPMMandSEPandWWBb
    two = 1;% 1:Spread;2:Every lines
    three = 1;% 1:ERA5;2:GODAS
    first_name = {'TPCtrl','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb'};
    first_name2 = {'CESM-TP','CESM-TP+G','CESM-TP+G+WWBs'};
    first_name3 = {'a','b','c'};
    second_name = {'Spread','Lines'};
    third_name = {'ERA5','GODAS'};
    legend_name = {'OBS',first_name2{one}};
    pathfig = [aimpath,'Fig2',first_name3{one},'_Var_Nino34_',first_name{one},'_',second_name{two},'_',third_name{three}];

    switch three
        case 1
            data_obs = load('F:\2023PMM_Work\bin_data\Nino34_SSTA_ERA5_197901to202402.mat');
            a = data_obs.date(:,1) >= 2023;
            nino34_obs = data_obs.area_ssta(a);
        case 2
            data_obs = load('F:\2023PMM_Work\bin_data\Nino34_SSTA_GODAS_1980to2023.mat');
            data2_obs = load('F:\2023PMM_Work\bin_data\Nino34_SSTA_GODAS_202401.mat');
            a = data_obs.date(:,1) == 2023;
            nino34_obs = cat(1,data_obs.area_ssta(a),data2_obs.area_ssta);
    end
    fig1 = nino34_obs;
    fig1b = smooth(nino34_obs,3);
    fig1b(2) = fig1(2);

    path1 = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\SSTA_Casely\'];
    struct = dir([path1,'*.mat']);
    name1 = {struct.name}';
    clear bin_fig2
    for i1 = 2:length(name1)
        data = load([path1,name1{i1}]);
        bin_fig2(:,i1-1) = data.nino34;
    end

    for i2 = 1:size(bin_fig2,2)
        bin_fig2(:,i2) = smooth(bin_fig2(:,i2),3);
    end
    fig2 = mean(bin_fig2,2);

    avr_nino34_djf = mean(fig2(10:12));

    std_fig = std(bin_fig2,0,2);
    up_fig = fig2 + std_fig;
    down_fig = fig2 - std_fig;
    fig2_up = up_fig';
    fig2_down = down_fig';
    %%
    FontSize = 14;
    FontName = 'Arial';
    LW = 3;% lines
    LW3 = 1;% lines

    text_letter = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n'};
    % text_month = {'Jan/23','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','Jan/24','Feb'};
    text_month = {'DJF','Feb','FMA','MAM','AMJ','MJJ','JJA','JAS','ASO','SON','OND','NDJ','DJF/24','JF'};

    color_plot = [0,0,0 ...% 1 ºÚÉ«£¬OBS
        ;215,0,15 ...% 2 ÖÐ¹úºì, TP
%         ;151,137,246 ...% 3 À¶×ÏÉ«1, NETP
%         ;75,0,192 ...% 4 À¶×ÏÉ«, SETP
%         ;255,0,255 ... % 5 ×ÏºìÉ«, TIO
%         ;1,132,127 ...;% 6 Âí¶ûË¹ÂÌ, NTA
        ;255,119,15 ...% 7 °®ÂíÊË³È, All
%         ;129,56,188 ...% 8 ²¥¿Í×Ï NTA_S
%         ;131,55,255 ...% 9 ×ÏÉ« NTA_N
%         ;234,92,129 ...% 10 bilibiliºì, WWB
        ;76,168,248 ...% 11 À¶É«,WWBs
       %  ;227,173,82 ...% ±¸Ñ¡É« Î¢²©»Æ
        ]/255; %

    color_plot2 = [100,100,100 ... % 1 »ÒÉ«£¬OBS
        ;255,225,216 ...% 2Ãµ¹åºì, TP
%         ;224,220,252 ...% 3 µ­À¶×ÏÉ«1, NETP
%         ;208,179,255 ...% 4 µ­À¶×ÏÉ«, SETP
%         ;255,200,255 ... % 5 µ­×ÏºìÉ«, TIO
%         ;180,255,255 ...;% 6 µ­Âí¶ûË¹ÂÌ, NTA
        ;255,226,205 ...% 7 µ­°®ÂíÊË³È, All
%         ;199,164,228 ...% 8 µ­²¥¿Í×Ï NTA_S
%         ;227,209,255 ...% 9 µ­À¶×ÏÉ« NTA_N
%         ;247,197,210 ...% 10 µ­bilibiliºì,WWB
        ;182,219,252 ...%  11 µ­À¶É«,WWBs
%          ;249,234,185 ...% ±¸Ñ¡É« µ­Î¢²©»Æ
        ]/255;

    % data_cp = load('F:\2023PMM_Work/bin_data/ColorPlot.mat');
    % color_plot2 = data_cp.color_plot;

    text_name = {'Weak','Moderate','Strong','Extreme',''};
    %%
    close all;
    % rectangle('Position',[10,-1,10,10],'Curvature',[0,0],'FaceColor',[0.9,0.9,0.9],'EdgeColor','none');
    hold on
    h1 = plot(1:2,fig1(1:2),'LineWidth',LW,'color',color_plot(1,:),'LineStyle','-');% obs
    h2 = plot(4:14,fig2(2:end),'LineWidth',LW,'color',color_plot(one+1,:),'LineStyle','-');% exp

    for i2 = 1:4
        h5 = plot(xlim,[0.5,0.5]*i2,'LineWidth',LW3,'color',[0.5,0.5,0.5],'LineStyle','--');
        text(1.5,0.5*i2+0.2,text_name{i2},'FontSize',FontSize,'FontName',FontName,'Interpreter','None');
    end
    h6 = plot(xlim,[0,0],'LineWidth',LW3,'color',[0.5,0.5,0.5],'LineStyle','-');

    switch two
        case 1
            fill([4:14,14:-1:4],[fig2_down(2:end),flip(fig2_up(2:end),2)],color_plot2(one+1,:),'EdgeColor','None','FaceAlpha',0.8);
        case 2
            for i1 = 1:size(bin_fig2,2)
                fig4 = bin_fig2(:,i1);
                h3 = plot(3:14,fig4,'LineWidth',LW,'color',color_plot2(7,:),'LineStyle','-');% 7
                %     h3 = plot(3:14,fig4,'LineWidth',LW,'color',[0,0,0],'LineStyle','-');
            end
    end

    h1 = plot(1:2,fig1(1:2),'LineWidth',LW,'color',color_plot(1,:),'LineStyle','-');% obs
    h1b = plot(2:length(fig1b),fig1b(2:end),'LineWidth',LW,'color',[0,0,0],'LineStyle','-');% obs,Feb
    h2 = plot(4:14,fig2(2:end),'LineWidth',LW,'color',color_plot(one+1,:),'LineStyle','-');% exp
    h4 = plot([2,4],[fig1(2),fig2(2)],'LineWidth',LW,'color',[0.7,0.7,0.7],'LineStyle','--');
    % rectangle('Position',[2.4,fig1(2)-0.05,0.1,0.1],'Curvature',[0,0],'FaceColor',[1,1,1],'EdgeColor','none');
    % rectangle('Position',[2.9,fig2(1)-0.05,0.1,0.1],'Curvature',[0,0],'FaceColor',[1,1,1],'EdgeColor','none');

    box on
    grid on;
    ylim([-1.2,3.2]);
    xlim([1,13]);

    xtick = 1:1:14;
    xticklabel = [];
    if one == 3
        xticklabel = text_month(xtick);
    end

    if one == 1
        title('Evolution of NINO3.4 index','FontSize',FontSize,'FontName',FontName,'Interpreter','None')
    else
        title(' ','FontSize',FontSize,'FontName',FontName,'Interpreter','None')
    end

    set(gca,'xtick',xtick,'xticklabel',xticklabel,'ytick',-3:1:3,'Layer','top','FontSize',FontSize,'FontName',FontName);
    xtickangle(0)
    legend(legend_name,'Location','SouthEast','Interpreter','None');
    % xlabel('2023','FontSize',FontSize,'FontName',FontName);
    ylabel('NINO3.4','FontSize',FontSize,'FontName',FontName);
    % text(1,3.2,['Obs. and Exp_',first_name2{one},' Nino3.4 index. ',second_name{two}],'FontSize',FontSize,'FontName',FontName,'Interpreter','None');
    % text(0.6,-1.7,'2023','FontSize',FontSize,'FontName',FontName,'Interpreter','None');
    % text(12.6,-1.7,'2024','FontSize',FontSize,'FontName',FontName,'Interpreter','None');

    text(1,3.45,['(',first_name3{one},')'],'FontSize',FontSize,'FontName',FontName,'Interpreter','None')
    % text(8.5,2.7,['Mean Nino3.4(DJF)=',num2str(avr_nino34_djf,'%2.2f'),'¡ãC'],'Color',color_plot(2,:),'FontSize',FontSize,'FontName',FontName,'FontWeight','bold','Interpreter','None');
    %%
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8 3],'color',[1 1 1]);
    print('-djpeg','-r1000',[pathfig,'_',num2str(avr_nino34_djf,'%2.2f'),'¡ãC.jpg']);
    print('-dpdf','-r1000',[pathfig,'_',num2str(avr_nino34_djf,'%2.2f'),'¡ãC.pdf']);
end