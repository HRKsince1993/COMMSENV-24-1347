clc;clear
aimpath = ['F:\2023PMM_Work\Figures_for_Publish\Figure\Fig2_Var_Nino34_Exp\'];
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end

text_letter = 'd';
pathfig = [aimpath,'Fig2',text_letter,'_Var_Nino34_2023cases'];

% OBS、TP、NETP, SETP, TIO, TA，G, WWB1, WWB2, WWBs
data_obs = load('F:\2023PMM_Work\bin_data\Nino34_SSTA_ERA5_197901to202402.mat');
% data_hc = load(['F:\2023PMM_Work\Data_Ensemble\Exp_CESM_LP\Compose_SSTA_Global_Monthly_2023-03_to_2024-02_Exp_CESM_LP_1217.mat']);
data_tp = load(['F:\2023PMM_Work\Data_Ensemble\Exp_TPCtrl\Compose_SSTA_Global_Monthly_2023-03_to_2024-02_Exp_TPCtrl_1128.mat']);
data_netp = load(['F:\2023PMM_Work\Data_Ensemble\Exp_PMM\Compose_SSTA_Global_Monthly_2023-03_to_2024-02_Exp_PMM_1128.mat']);
data_setp = load(['F:\2023PMM_Work\Data_Ensemble\Exp_SEP\Compose_SSTA_Global_Monthly_2023-03_to_2024-02_Exp_SEP_1217.mat']);
data_tio = load(['F:\2023PMM_Work\Data_Ensemble\Exp_TIOlg\Compose_SSTA_Global_Monthly_2023-03_to_2024-02_Exp_TIOlg_0110.mat']);
data_nta = load(['F:\2023PMM_Work\Data_Ensemble\Exp_NTAlg\Compose_SSTA_Global_Monthly_2023-03_to_2024-02_Exp_NTAlg_0110.mat']);
data_global = load('F:\2023PMM_Work\Data_Ensemble\Exp_NTAandTIOandPMMandSEPlg\Compose_SSTA_Global_Monthly_2023-03_to_2024-02_Exp_NTAandTIOandPMMandSEPlg_0110.mat');
data_wwb1 = load(['F:\2023PMM_Work\Data_Ensemble\Exp_NTAandTIOandPMMandSEPandWWBbmay\Compose_SSTA_Global_Monthly_2023-03_to_2024-02_Exp_NTAandTIOandPMMandSEPandWWBbmay_0110.mat']);
data_wwb2 = load(['F:\2023PMM_Work\Data_Ensemble\Exp_NTAandTIOandPMMandSEPandWWBOctNov\Compose_SSTA_Global_Monthly_2023-03_to_2024-02_Exp_NTAandTIOandPMMandSEPandWWBOctNov_0110.mat']);
data_wwbs = load(['F:\2023PMM_Work\Data_Ensemble\Exp_NTAandTIOandPMMandSEPandWWBb\Compose_SSTA_Global_Monthly_2023-03_to_2024-02_Exp_NTAandTIOandPMMandSEPandWWBb_0110.mat']);
%% obs Nino34 index
a = data_obs.date(:,1) >= 2023;
nino34_obs = data_obs.area_ssta(a);

% Exp Nino34 index
lon_box = [360-170,360-120];% Nino34
lat_box = [-5,5];
a = data_setp.lon >= lon_box(1) & data_setp.lon <= lon_box(2);
b = data_setp.lat >= lat_box(1) & data_setp.lat <= lat_box(2);
% nino34_hc = squeeze(nanmean(nanmean(data_hc.ssta_ensemble(a,b,:))));
nino34_tp = squeeze(nanmean(nanmean(data_tp.ssta_ensemble(a,b,:))));
nino34_netp = squeeze(nanmean(nanmean(data_netp.ssta_ensemble(a,b,:))));
nino34_setp = squeeze(nanmean(nanmean(data_setp.ssta_ensemble(a,b,:))));
nino34_tio = squeeze(nanmean(nanmean(data_tio.ssta_ensemble(a,b,:))));
nino34_nta = squeeze(nanmean(nanmean(data_nta.ssta_ensemble(a,b,:))));
nino34_global = squeeze(nanmean(nanmean(data_global.ssta_ensemble(a,b,:))));
nino34_wwb1 = squeeze(nanmean(nanmean(data_wwb1.ssta_ensemble(a,b,:))));
nino34_wwb2 = squeeze(nanmean(nanmean(data_wwb2.ssta_ensemble(a,b,:))));
nino34_wwbs = squeeze(nanmean(nanmean(data_wwbs.ssta_ensemble(a,b,:))));

% bin_fig,NDJ
bin_fig(1,1) = mean(nino34_obs(11:13));
bin_fig(2,1) = mean(nino34_tp(9:11));
bin_fig(3,1) = mean(nino34_netp(9:11));
bin_fig(4,1) = mean(nino34_setp(9:11));
bin_fig(5,1) = mean(nino34_tio(9:11));
bin_fig(6,1) = mean(nino34_nta(9:11));
bin_fig(7,1) = mean(nino34_global(9:11));
bin_fig(8,1) = mean(nino34_wwb1(9:11));
bin_fig(9,1) = mean(nino34_wwb2(9:11));
bin_fig(10,1) = mean(nino34_wwbs(9:11));

% OBS、TP、NETP, SETP, TIO, TA，G, WWB1, WWB2, WWBs
legend_name = {'OBS','CESM-TP','CESM-TP+NETP','CESM-TP+SETP','CESM-TP+TIO','CESM-TP+TA','CESM-TP+G','CESM-TP+G+WWB1','CESM-TP+G+WWB2','CESM-TP+G+WWBs'};
text_name = {'Weak','Moderate','Strong','Extreme'};
%%
FontSize = 15;
FontSize2 = 16;
FontName = 'Arial';
LW = 2;% lines
LW2 = 5;% lines

color_plot = [0,0,0 ...% 1 黑色，OBS
    ;215,0,15 ...% 2 中国红, TP
    ;151,137,246 ...% 3 蓝紫色1, NETP
    ;75,0,192 ...% 4 蓝紫色, SETP
    ;255,0,255 ... % 5 紫红色, TIO
    ;1,132,127 ...;% 6 马尔斯绿, NTA
    ;255,119,15 ...% 7 爱马仕橙, All
%     ;129,56,188 ...% 8 播客紫 NTA_S
%     ;131,55,255 ...% 9 紫色 NTA_N
    ;234,92,129 ...% 10 bilibili红, WWB1
    ;129,56,188 ...% 11 播客色, WWB2
    ;76,168,248 ...% 12 蓝色,WWBs
%     ;227,173,82 ...% 备选色 微博黄
    ]/255; %
%%
close all
for i1 = 1:length(bin_fig)
    h1 = bar(i1,bin_fig(i1),'facecolor',color_plot(i1,:));
    hold on
end

grid on;
xlim([0,length(bin_fig)+1.5]);
ylim([0,2.5]);
xtick = 1:length(bin_fig);
ytick = 0:0.5:2.5;

for i2 = 1:4
    h5 = plot(xlim,[0.5,0.5]*i2,'LineWidth',LW,'color',[0.5,0.5,0.5],'LineStyle','--');
    text(length(bin_fig)+1,0.5*i2+0.05,text_name{i2},'rotation',90,'FontSize',FontSize,'FontName',FontName,'Interpreter','None');
end

for i1 = 1:length(bin_fig)
    text(i1,0.1,legend_name{i1},'color',[1,1,1],'rotation',90,'FontSize',FontSize2,'FontName',FontName,'FontWeight','bold')
end

set(gca,'xtick',xtick,'xticklabel',[],'ytick',ytick,'FontSize',FontSize,'FontName',FontName);
xtickangle(90)
ytickangle(90)
ylabel('NDJ NINO3.4','FontSize',FontSize,'FontName',FontName);
text(-0.7,0,['(',text_letter,')'],'rotation',90,'FontSize',FontSize,'FontName',FontName,'Interpreter','None');

set(gcf,'PaperUnits','inches','PaperPosition',[-0.5 0 9.6 6],'color',[1 1 1]);
print('-djpeg','-r1000',[pathfig,'.jpg']);
print('-dpdf','-r1000',[pathfig,'.pdf']);