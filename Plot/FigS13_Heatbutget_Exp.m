clc;clear

for one = 1:5 % 1:PMM;2:SEP;3:TIO;4:NTA;5:NTAandTIOandPMMandSEPlg;6:NTAandTIOandPMMandSEPandWWBb
    two = 1;% minus 1:TPCtrl;
    three = 1;% 1:only enter the MLD(w>0) are condisered;2:do not consider enter or out
    four = 2;% 1:two heat flux terms,LH,SH; 2:four heat flux terms, LH,SH,LW,SW;

    first_name = {'PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb'};
    first_name2 = {'CESM-TP+NETP','CESM-TP+SETP','CESM-TP+TIO','CESM-TP+TA','CESM-TP+G','CESM-TP+G+WWBs'};
    first_name3 = {'a','b','c','d','e','f'};
    second_name = {'TPCtrl'};
    second_name2 = {'CESM-TP'};
    third_name = {'_OnlyEnt',[]};
    third_name2 = {[],'NoConsiderEntOrOut'};
    fourth_name = {'_2','_4'};
    fourth_name2 = {'_2term1','_4term1'};
    fourth_name3 = {'_2term1',[]};

    len_m = (3:12)-2;% month
    
    aimpath = ['F:\2023PMM_Work\Figures_for_Publish\Figure\FigS13_HeatBudget\',third_name2{three},fourth_name3{four},'\'];
    if exist(aimpath,'dir')~=7
        mkdir(aimpath);
    end

    figpath = [aimpath,'FigS13',first_name3{one},'_HeatBudget_Exp_',first_name{one},third_name{three},fourth_name2{four},'_Mon',num2str(len_m(1)+2),'to',num2str(len_m(end)+2)];

    path1 = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\'];
    struct = dir([path1,'*.mat']);
    name1 = {struct.name}';

    data0 = load([path1,'zHeatBudget_Term0_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-8),'.mat']);
    data1 = load([path1,'zHeatBudget_Term1_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-8),fourth_name{four},'.mat']);
    data2 = load([path1,'zHeatBudget_Term2_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-8),'.mat']);
    data3 = load([path1,'zHeatBudget_Term3_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-8),third_name{three},'.mat']);

    date = data0.date;
    bin_term0 = data0.term0;
    bin_term1 = data1.term1(1:end-1,:);
    bin_term2_u = data2.term2_u(1:end-1,:);
    bin_term2_v = data2.term2_v(1:end-1,:);
    bin_term3 = data3.term3;
    %%
    term0 = mean(bin_term0(len_m,:),1);
    term1 = mean(bin_term1(len_m,:),1);
    term2_u = mean(bin_term2_u(len_m,:),1);
    term2_v = mean(bin_term2_v(len_m,:),1);
    term3 = mean(bin_term3(len_m,:),1);

    term_left = term0;
    term_right = term1 + term2_u + term2_v + term3;
    term_r = term_left - term_right;

    term0_avr = mean(term0);
    term1_avr = mean(term1);
    term2_u_avr = mean(term2_u);
    term2_v_avr = mean(term2_v);
    term3_avr = mean(term3);
    term_r_avr = mean(term_r);

    term0_std = std(term0);
    term1_std = std(term1);
    term2_u_std = std(term2_u);
    term2_v_std = std(term2_v);
    term3_std = std(term3);
    term_r_std = std(term_r);
    %%
    FontSize = 20;
    FontSize2 = 15;
    FontName = 'Arial';
    LW = 5;% lines
    LW2 = 1;% error bar
    Capsize = 5;

    bar_width = 0.8;

    color_plot = [0,0,0 ...% 1 黑色, black, OBS
        ;215,0,15 ...% 2 中国红, China red, TP
        %         ;151,137,246 ...% 3 蓝紫色1, blue and purple 1, NETP
        %         ;75,0,192 ...% 4 蓝紫色, blue and purple, SETP
        %         ;255,0,255 ... % 5 紫红色, purple and red, TIO
        %         ;1,132,127 ...;% 6 马尔斯绿, green, NTA
        ;255,119,15 ...% 7 爱马仕橙, orange, All
        %         ;129,56,188 ...% 8 播客紫, vlog purple, NTA_S
        %         ;131,55,255 ...% 9 紫色, purple, NTA_N
        ;234,92,129 ...% 10 bilibili红, bilibili red,WWB
        ;76,168,248 ...% 11 蓝色,blue2, WWBs
        ;227,173,82 ...% 备选色 微博黄, weibo yellow
        ]/255; %
    %%
    fig0 = term0_avr;
    fig1 = term1_avr;
    fig2u = term2_u_avr;
    fig2v = term2_v_avr;
    fig3 = term3_avr;
    fig4 = term_r_avr;

    fig0_std = term0_std;
    fig1_std = term1_std;
    fig2u_std = term2_u_std;
    fig2v_std = term2_v_std;
    fig3_std = term3_std;
    fig4_std = term_r_std;
    
    close all

    h0 = bar(1,fig0,bar_width,'facecolor',color_plot(1,:));
    hold on
    h1 = bar(2,fig1,bar_width,'facecolor',color_plot(2,:));
    h2 = bar(3,fig2u,bar_width,'facecolor',color_plot(3,:));
    h3 = bar(4,fig2v,bar_width,'facecolor',color_plot(4,:));
    h4 = bar(5,fig3,bar_width,'facecolor',color_plot(5,:));
    h5 = bar(6,fig4,bar_width,'facecolor',color_plot(6,:));

    h0b = errorbar(1,fig0,fig0_std,'Capsize',Capsize,'color',[0,0,1],'LineWidth',LW2);
    h1b = errorbar(2,fig1,fig1_std,'Capsize',Capsize,'color',[0,0,1],'LineWidth',LW2);
    h2b = errorbar(3,fig2u,fig2u_std,'Capsize',Capsize,'color',[0,0,1],'LineWidth',LW2);
    h3b = errorbar(4,fig2v,fig2v_std,'Capsize',Capsize,'color',[0,0,1],'LineWidth',LW2);
    h4b = errorbar(5,fig3,fig3_std,'Capsize',Capsize,'color',[0,0,1],'LineWidth',LW2);
    h5b = errorbar(6,fig4,fig4_std,'Capsize',Capsize,'color',[0,0,1],'LineWidth',LW2);
    
    box on
    grid on;

    xtick = 1:6;
    ytick = (-20:5:15)/100;

    if one >= 5
        xticklabel = {'dT/dt','Q_n_e_t','Adv-u','Adv-v','Adv-w','R'};
    else
        xticklabel = [];
    end

    if mod(one,2) == 1
        clear yticklabel
        for i2 = 1:length(ytick)
            if mod(i2,2) == 1
                yticklabel{i2} = num2str(ytick(i2));
            else
                yticklabel{i2} = ' ';
            end
        end
        ylabel('°C month^{-1}','FontSize',FontSize,'FontName',FontName);
    else
        yticklabel = ' ';
        ylabel(' ','FontSize',FontSize,'FontName',FontName);
    end

    ylim([ytick(1),ytick(end)]);
    xlim([0,7]);
    set(gca,'xtick',xtick,'xticklabel',xticklabel,'ytick',ytick,'yticklabel',yticklabel,'FontSize',FontSize,'FontName',FontName);
    xtickangle(0)
    % xlabel('2023','FontSize',FontSize,'FontName',FontName);
    title(first_name2{one},'FontSize',FontSize,'FontName',FontName);
    text(0,ytick(end)+(ytick(end)-ytick(1))/18,['(',first_name3{one},')'],'FontSize',FontSize,'FontName',FontName);
    %%
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8 4],'color',[1 1 1],'PaperOrientation','landscape');
    print('-djpeg','-r1000',[figpath,'.jpg']);
    print('-dpdf','-r1000',[figpath,'.pdf']);
end
