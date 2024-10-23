clc;clear
aimpath = ['/Users/Shared/Previously Relocated Items/Security/F/2023PMM_Work/Figures_for_Publish/Figure/FigS6_VarBar_WWB_Intensity_ERA5andExp_RemoveDaysAver_Middle_LTY_LT/']
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end

one = 34;% 1;Ctrl;2:NTA;3:PMM;4:TIO;5:TroPac:6:TPCtrl;7:NTA15;8:NTA30;9:AtlNino;10:NoWNP;11:NoPMM;12:NTAandTIO;13:TroPacNTA;14:PMMandNTA;15:TPCtrlG;16:SEP;
% 17:NTAandTIOandSEP;18:NTAandTIOandPMMandSEP;19:NTAandTIOLgandPMMandSEP;20:TO;21:NTAandTIOandPMMandSEPandWNP;22:NTAandTIOandEP;23:NTAandTIOandPMMandSEP_New
% 24:NTAandTIOandEPandWWB;25:NTAandTIOandPMMandSEPandWWB;26:NTAandTIOandSEPlg;27:NTAandTIOandSEPandWWB;28:NTAandTIOandSEPandWWBmay;29:TIOlg;30:NTAlg;
% 31:NTAandTIOandSEPandWWBb;32:NTAandTIOandSEPandWWBbmay;33:PMMsmall;34:NTAandTIOandPMMandSEPlg;35:NETPCli;36:NTAandTIOandPMMandSEPandWWBb;
% 37:NTAandTIOandPMMandSEPandWWBbmay
first_name = {'Ctrl','NTA','PMM','TIO','TroPac','TPCtrl','NTA15','NTA30','AtlNino','NoWNP','NoPMM','NTAandTIO','TroPacNTA','PMMandNTA','TPCtrlG','SEP'...
    ,'NTAandTIOandSEP','NTAandTIOandPMMandSEP','NTAandTIOLgandPMMandSEP','TO','NTAandTIOandPMMandSEPandWNP','NTAandTIOandEP','NTAandTIOandPMMandSEP_New'...
    ,'NTAandTIOandEPandWWB','NTAandTIOandPMMandSEPandWWB','NTAandTIOandSEPlg','NTAandTIOandSEPandWWB','NTAandTIOandSEPandWWBmay','TIOlg','NTAlg'...
    ,'NTAandTIOandSEPandWWBb','NTAandTIOandSEPandWWBbmay','PMMsmall','NTAandTIOandPMMandSEPlg','NETPCli','NTAandTIOandPMMandSEPandWWBb'...
    ,'NTAandTIOandPMMandSEPandWWBbmay'};
%%
for two = 1:1 % define WWB,1:0.05 N/m2;2:ref STD;3:0.05 and ref STD
    for four = 1:1 % 1:Obs SSTA ref cli;2:Obs SSTA ref middel 30days
        three = 30;% days window
        jd_degree = 10;% WWB longitude degree
        jd_days = 2;
        l_mon_box = [3,11];% months from 2023 Jan, e.g.,3 means 2023 March

        three2 = three/2;
        second_name = {'abs','relateve','abs and relative'};
        fourth_name = {'ObsSSTArefCli',['ObsSSTArefMid',num2str(three),'days']};

        cbar = 0.1;
        lon_box = [120,360-140];
        lat_box = [-5,5];
        switch two
            case 1
                yu_wwb1 = 0.05;% obs
                yu_wwb2 = 0.05;% cesm
            case 2
                yu_wwb1 = 0.0246*2.5;% obs
                yu_wwb2 = 0.0257*2.5;% cesm
            case 3
                yu_wwb1 = 0.05;% obs
                yu_wwb2 = 0.05/0.0246*0.0257;% cesm
        end

        PaperPosition = [0 0 5 8];

        data1 = load('/Users/Shared/Previously Relocated Items/Security/F/ENSO_Work/Data_ENSO/Taux_Global_Daily_ERA5_Yearly/Taux_Global_Daily_ERA5_2023.mat');
        data1b = load('/Users/Shared/Previously Relocated Items/Security/F/ENSO_Work/Data_ENSO/New_Year/Taux_Global_Daily_ERA5_Monthly/Taux_Global_Daily_ERA5_202401to202401.mat');
        data1c = load('/Users/Shared/Previously Relocated Items/Security/F/ENSO_Work/Data_ENSO/New_Year/Taux_Global_Daily_ERA5_Monthly/Taux_Global_Daily_ERA5_202402to202402.mat');
        lon = data1.lon;lat = data1.lat;date_obs = cat(1,data1.date,data1b.date,data1c.date); 
        taux_obs_read = cat(3,data1.taux,data1b.taux,data1c.taux);
        switch four
            case 1
                data0 = load('/Users/Shared/Previously Relocated Items/Security/F/ENSO_Work/Data_ENSO/TauxA_Global_Daily_ERA5_Yearly/TauxA_Global_Daily_ERA5_2023.mat');
                data0b = load('/Users/Shared/Previously Relocated Items/Security/F/ENSO_Work/Data_ENSO/New_Year/TauxA_Global_Daily_ERA5_Monthly/TauxA_Global_Daily_ERA5_202401to202401.mat');
                data0c = load('/Users/Shared/Previously Relocated Items/Security/F/ENSO_Work/Data_ENSO/New_Year/TauxA_Global_Daily_ERA5_Monthly/TauxA_Global_Daily_ERA5_202402to202402.mat');
                tauxa_obs = cat(3,data0.tauxa,data0b.tauxa,data0c.tauxa);
            case 2
                for i1 = three-three2+1:size(taux_obs_read,3)-three2
                    tauxa_obs(:,:,i1) = taux_obs_read(:,:,i1) - mean(taux_obs_read(:,:,i1-three2:i1+three2),3);
                end
        end

        path1 = ['/Users/Shared/Previously Relocated Items/Security/F/2023PMM_Work/Data_Ensemble/Exp_',first_name{6},'/Taux_Casely_Daily/'];% TPCtrl
        struct = dir([path1,'*.mat']);name1 = {struct(2:end).name}';
        path2 = ['/Users/Shared/Previously Relocated Items/Security/F/2023PMM_Work/Data_Ensemble/Exp_',first_name{one},'/Taux_Casely_Daily/'];%
        struct = dir([path2,'*.mat']);name2 = {struct(2:end).name}';

        fig1_date = date_obs;
        l_lon = lon >= lon_box(1) & lon <= lon_box(2);
        l_lat = lat >= lat_box(1) & lat <= lat_box(2);

        bin_tauxa_obs = tauxa_obs(l_lon,l_lat,:);
        bin_wwb_obs = liantongyu_wwb(bin_tauxa_obs,yu_wwb1,0.001);
        bin_wwb_obs_equator_lty = LonTimeWWB(bin_tauxa_obs,yu_wwb1,jd_degree,jd_days);

        bin_wwb_obs_int = squeeze(sum(bin_wwb_obs,2)); 
        bin2_wwb_obs_int = bin_wwb_obs_int.*bin_wwb_obs_equator_lty;
        %%
        k1 = 1;
        clear wwb_int_obs
        for i1 = l_mon_box(1):l_mon_box(2) % month
            if i1 <= 12
                c = date_obs(:,1) == 2023 & date_obs(:,2) == i1;
            else
                c = date_obs(:,1) == 2024 & date_obs(:,2) == i1-12;
            end
            bin3_wwb_obs = bin2_wwb_obs_int(:,c);
            wwb_int_obs(k1) = sum(sum(bin3_wwb_obs,1),2);
            k1 = k1 + 1;
        end
        bin1_fig1 = wwb_int_obs;

        data2 = load([path1,name1{1}]);
        fig2_date = data2.date;
        fig2_time = data2.time;
        %%
        clear wwb_int_exp1 wwb_int_exp2
        for i1 = 1:length(name1) % tpctrl
            data2 = load([path1,name1{i1}]);

            a = find(fig1_date(:,1) == 2023 & fig1_date(:,2) == 2 & fig1_date(:,3) == 28);% 加的
            read1_taux = cat(3,data1.taux(:,:,a-three2+1:a),data2.taux);

            bin_taux_exp1 = zeros(sum(l_lon),sum(l_lat),size(data2.taux,3));
            for i2 = 1:size(data2.taux,3)-three
                bin_taux_exp1(:,:,i2) = data2.taux(l_lon,l_lat,i2) - mean(read1_taux(l_lon,l_lat,i2:i2+three),3);
            end

            bin_taux_exp1(isnan(bin_taux_exp1)) = 0;
            bin_wwb_exp1 = liantongyu_wwb(bin_taux_exp1,yu_wwb2,0.001);
            bin_wwb_exp1_equator_lty = LonTimeWWB(bin_taux_exp1,yu_wwb2,jd_degree,jd_days);
            bin_wwb_exp1_int = squeeze(sum(bin_wwb_exp1,2));
            bin2_wwb_exp1_int = bin_wwb_exp1_int.*bin_wwb_exp1_equator_lty;

            for i2 = 1:length(bin1_fig1)
                l_month = fig2_time <= fig2_date(i2,5) & fig2_time >= fig2_date(i2,4);
                wwb_int_exp1(i1,i2) = sum(sum(bin2_wwb_exp1_int(:,l_month),1),2);
            end
        end

        for i1 = 1:length(name2) % NTAandTIOandSEPlg
            data3 = load([path2,name2{i1}]);

            a = find(fig1_date(:,1) == 2023 & fig1_date(:,2) == 2 & fig1_date(:,3) == 28);% 加的
            read2_taux = cat(3,data1.taux(:,:,a-three2+1:a),data3.taux);

            bin_taux_exp2 = zeros(sum(l_lon),sum(l_lat),size(data3.taux,3));
            for i2 = 1:size(data3.taux,3)-three
                bin_taux_exp2(:,:,i2) = data3.taux(l_lon,l_lat,i2) - mean(read2_taux(l_lon,l_lat,i2:i2+three),3);
            end

            bin_taux_exp2(isnan(bin_taux_exp2)) = 0;
            bin_wwb_exp2 = liantongyu_wwb(bin_taux_exp2,yu_wwb2,0.001);
            bin_wwb_exp2_equator_lty = LonTimeWWB(bin_taux_exp2,yu_wwb2,jd_degree,jd_days);
            bin_wwb_exp2_int = squeeze(sum(bin_wwb_exp2,2));
            bin2_wwb_exp2_int = bin_wwb_exp2_int.*bin_wwb_exp2_equator_lty;

            for i2 = 1:length(bin1_fig1)
                l_month = fig2_time <= fig2_date(i2,5) & fig2_time >= fig2_date(i2,4);
                wwb_int_exp2(i1,i2) = sum(sum(bin2_wwb_exp2_int(:,l_month),1),2);
            end
        end

        bin1_fig2 = mean(wwb_int_exp1,1);
        bin1_fig2_std = std(wwb_int_exp1,0,1);
        bin1_fig3 = mean(wwb_int_exp2,1);
        bin1_fig3_std = std(wwb_int_exp2,0,1);

        fig1 = [bin1_fig1;bin1_fig2;bin1_fig3]';

        wwb_int = sum(fig1,1);
        pathfig = [aimpath,'FigS6_VarBar_WWB_Intensity_ERA5andExp',first_name{one},'_',second_name{two},'_Obs',num2str(yu_wwb1)...
            ,'_Exp',num2str(yu_wwb2),'_Lon',num2str(lon_box(1)),'to',num2str(lon_box(2)),'_Month',num2str(l_mon_box(1))...
            'to',num2str(l_mon_box(2)),'_Monthly_RmMid'...
            ,num2str(three),'DaysAver_',fourth_name{four},'_ObsSum',num2str(wwb_int(1)),'_ExpSumTP',num2str(wwb_int(2)),'_G'...
            ,num2str(wwb_int(3)),'_jgDeg',num2str(jd_degree),'jgDay',num2str(jd_days),'_LTY_LT']
        %%
        FontSize = 15;
        % FontName = 'Arial';
        FontName = 'Arial';
        LW = 5;% lines
        LW2 = 2;% errorbar

        text_month = {'Mar/23','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','Jan/24','Feb'};

        color_plot = [0,0,0 ...%
                ;215,0,15 ...% 中国红
            ;255,119,15 ...% 5爱马仕橙, All
            ]/255;

        legend_name = {'OBS','CESM-TP','CESM-TP+G'};
        %%
        close all
        h1 = bar(l_mon_box(1):l_mon_box(2),fig1);
        hold on
        set(h1(1),'facecolor',color_plot(1,:))
        set(h1(2),'facecolor',color_plot(2,:))
        set(h1(3),'facecolor',color_plot(3,:))

        for i2 = 1:length(bin1_fig2)
            h2b = errorbar(i2+2,bin1_fig2(i2),bin1_fig2_std(i2),'CapSize',5,'color',[0,0,1],'LineWidth',LW2);
            h3b = errorbar(i2+2.22,bin1_fig3(i2),bin1_fig3_std(i2),'CapSize',5,'color',[0,0,1],'LineWidth',LW2);
        end

        grid on;
        xlim([fig1_date(three+1,2)+1.5,l_mon_box(2)+0.5]);

        if two == 1 && four == 1
            ylim([-50,450]);
            ytick = -100:100:450;
        elseif two == 1 && four == 2
            ylim([-50,200]);
            ytick = -100:50:250;
        elseif two == 2 && four == 1
            ylim([-50,150]);
            ytick = -100:50:250;
        elseif two == 2 && four == 2
            ylim([-50,110]);
            ytick = -50:50:200;
        elseif two == 3 && four == 1
            ylim([-50,180]);
            ytick = -100:50:350;
        elseif two == 3 && four == 2
            ylim([-50,110]);
            ytick = -100:50:150;
        end

        % l_start = 5;l_space = -60;l_line = 0.7;l_y = 220;
        % rectangle('Position',[l_start-0.15,l_y,3.5,180],'Curvature',[0,0],'FaceColor',[1,1,1]);
        % for i1 = 1:length(legend_name)
        %     rectangle('Position',[l_start,l_y+l_space*(i1-1)+145-5,l_line,15],'Curvature',[0,0],'FaceColor',color_plot(i1,:));
        %     text(l_start+l_line+0.1,l_y+l_space*(i1-1)+145,legend_name{i1},'FontSize',FontSize,'FontName',FontName,'Interpreter','None');
        % end
        legend(legend_name,'Location','North','FontSize',FontSize,'FontName',FontName);

        xtick = l_mon_box(1):l_mon_box(2);
        xticklabel = text_month;
        set(gca,'xtick',xtick,'xticklabel',xticklabel,'ytick',ytick,'FontSize',FontSize,'FontName',FontName);
        xtickangle(0)
        %         xlabel('2023','FontSize',FontSize,'FontName',FontName);
        ylabel('WWB','FontSize',FontSize,'FontName',FontName);
        % text(0.5,1.35+0.5,['(b) Monthly evolution'],'FontSize',FontSize,'FontName',FontName);
        title(['Integrated WWB intensity'],'FontSize',FontSize,'FontName',FontName);
        % text(0.5,2,'(b)','FontSize',FontSize,'FontName',FontName);

        set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8 4],'color',[1 1 1],'PaperOrientation','landscape');
        print('-dpdf','-r1000',[pathfig,'.pdf']);
        print('-djpeg','-r1000',[pathfig,'.jpg']);
    end
end