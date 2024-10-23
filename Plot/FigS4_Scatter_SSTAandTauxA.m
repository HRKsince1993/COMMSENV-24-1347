clc;clear

one = 1;% 1:TPCtrl;2:PMM;3:SEP;4:TIOlg;5:NTAlg;6:NTAandTIOandPMMandSEPlg;7:NTAandTIOandPMMandSEPandWWBb'
first_name = {'TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb'};
first_name2 = {'CESM-TP','CESM-TP+NETP','CESM-TP+SETP','CESM-TP+TIO','CESM-TP+TA','CESM-TP+G','CESM-TP+G+WWBs'};

legend_name = {'OBS',first_name2{1},first_name2{6}};

aimpath = ['F:\2023PMM_Work\Figures_for_Publish\Figure\FigS4_Scatter_SSTAandTauxA\'];
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end
pathfig = [aimpath,'FigS4_Nino34andNino4_',first_name2{one}];

path_ctrl = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{1},'\'];
struct = dir([path_ctrl,'*.mat']);name_ctrl = {struct.name}';
path_g = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{6},'\'];
struct = dir([path_g,'*.mat']);name_g = {struct.name}';

data_ssta_obs = load('F:\2023PMM_Work\bin_data\Nino34_SSTA_ERA5_1979to2023.mat');
data_taua_obs = load('F:\2023PMM_Work\bin_data\Nino4_TauAx_ERA5_1979to2023.mat');

data_ssta_tpctrl = load([path_ctrl,'Compose_SSTA_Global_Monthly_2023-03_to_2024-02_Exp_',first_name{1},name_ctrl{1}(end-12:end-8),'.mat']);% SSTA
data_taux_tpctrl = load([path_ctrl,'Compose_TauAx_Global_Monthly_2023-03_to_2024-02_Exp_',first_name{1},name_ctrl{1}(end-12:end-8),'.mat']);% TauxA
data_ssta_g = load([path_g,'Compose_SSTA_Global_Monthly_2023-03_to_2024-02_Exp_',first_name{6},name_g{1}(end-12:end-8),'.mat']);% SSTA
data_taux_g = load([path_g,'Compose_TauAx_Global_Monthly_2023-03_to_2024-02_Exp_',first_name{6},name_g{1}(end-12:end-8),'.mat']);% TauxA

date = data_ssta_obs.date;
nino34_ssta_obs = data_ssta_obs.area_ssta;
nino4_ua_obs = data_taua_obs.area_tauxa*100;% N/m2

a = date(:,1) >= 2023;
nino34_ssta_obs = nino34_ssta_obs(a);
nino4_ua_obs = nino4_ua_obs(a);
fig1_date = date(a,:);

lon_box_nino34 = [360-170,360-120];% Nino34
lon_box_nino4 = [160,360-150];% Nino4
% tpctrl
a = data_ssta_tpctrl.lon >= lon_box_nino34(1) & data_ssta_tpctrl.lon <= lon_box_nino34(2);
b = data_ssta_tpctrl.lat >= -5 & data_ssta_tpctrl.lat <= 5;
nino34_ssta_tpctrl = squeeze(mean(mean(data_ssta_tpctrl.ssta_ensemble(a,b,:),1),2));
a = data_taux_tpctrl.lon >= lon_box_nino4(1) & data_taux_tpctrl.lon <= lon_box_nino4(2);
b = data_taux_tpctrl.lat >= -5 & data_taux_tpctrl.lat <= 5;
nino4_ua_tpctrl = squeeze(mean(mean(data_taux_tpctrl.tauxa_ensemble(a,b,:),1),2))*100;
% g
a = data_ssta_g.lon >= lon_box_nino34(1) & data_ssta_g.lon <= lon_box_nino34(2);
b = data_ssta_g.lat >= -5 & data_ssta_g.lat <= 5;
nino34_ssta_g = squeeze(mean(mean(data_ssta_g.ssta_ensemble(a,b,:),1),2));
a = data_taux_g.lon >= lon_box_nino4(1) & data_taux_g.lon <= lon_box_nino4(2);
b = data_taux_g.lat >= -5 & data_taux_g.lat <= 5;
nino4_ua_g = squeeze(mean(mean(data_taux_g.tauxa_ensemble(a,b,:),1),2))*100;

% fig1_ssta = diff(nino34_ssta_obs);
% fig1_ua = diff(nino4_ua_obs);
fig1_ssta = nino34_ssta_obs;
fig1_ua = nino4_ua_obs;
p1 = polyfit(fig1_ssta,fig1_ua,1);
reg1_a = p1(1);
reg1_b = p1(2);
fig1a = linspace(min(fig1_ssta),max(fig1_ssta),1000);
fig1b = fig1a*reg1_a+reg1_b;
r1 = corrcoef(fig1_ssta,fig1_ua);
% r1 = corrcoef(nino34_ssta_obs,nino4_ua_obs);
r1 = r1(1,2);

% fig2_ssta = diff(nino34_ssta_exp);
% fig2_ua = diff(nino4_ua_exp);
% nino34_ssta_tpctrl_diff = diff(nino34_ssta_tpctrl);
% a_tpctrl = find(nino34_ssta_tpctrl_diff <= 0, 1);
fig2_ssta = nino34_ssta_tpctrl;
fig2_ua = nino4_ua_tpctrl;
fig2_date = data_ssta_tpctrl.date;
p2 = polyfit(fig2_ssta,fig2_ua,1);
reg2_a = p2(1);
reg2_b = p2(2);
fig2a = linspace(min(fig2_ssta),max(fig2_ssta),1000);
fig2b = fig2a*reg2_a+reg2_b;
r2 = corrcoef(fig2_ssta,fig2_ua);
% r2 = corrcoef(nino34_ssta_exp,nino4_ua_exp);
r2 = r2(1,2);

% fig3_ssta = diff(nino34_ssta_exp);
% fig3_ua = diff(nino4_ua_exp);
% nino34_ssta_g_diff = diff(nino34_ssta_g);
% a_g = find(nino34_ssta_g_diff <= 0, 1);
fig3_ssta = nino34_ssta_g;
fig3_ua = nino4_ua_g;
fig3_date = data_ssta_g.date;
p3 = polyfit(fig3_ssta,fig3_ua,1);
reg3_a = p3(1);
reg3_b = p3(2);
fig3a = linspace(min(fig3_ssta),max(fig3_ssta),1000);
fig3b = fig3a*reg3_a+reg3_b;
r3 = corrcoef(fig3_ssta,fig3_ua);
% r2 = corrcoef(nino34_ssta_exp,nino4_ua_exp);
r3 = r3(1,2);
%%
FontSize = 20;
FontSize2 = 10;
FontSize3 = 20;
FontName = 'Arial';
LW = 2;% lines
LW2 = 1;% contour
LW3 = 3;% contour

color_plot = [0,0,0 ...% 1 ºÚÉ«£¬OBS
    ;215,0,15 ...% 2 ÖÐ¹úºì, TP
    ;151,137,246 ...% 3 À¶×ÏÉ«1, NETP
    ;75,0,192 ...% 4 À¶×ÏÉ«, SETP
    ;255,0,255 ... % 5 ×ÏºìÉ«, TIO
    ;1,132,127 ...;% 6 Âí¶ûË¹ÂÌ, NTA
    ;255,119,15 ...% 7 °®ÂíÊË³È, All
    ;129,56,188 ...% 8 ²¥¿Í×Ï NTA_S
    ;131,55,255 ...% 9 ×ÏÉ« NTA_N
    ;234,92,129 ...% 10 bilibiliºì, WWB
    ;76,168,248 ...% 11 À¶É«,WWBs
    ;227,173,82 ...% ±¸Ñ¡É« Î¢²©»Æ
    ]/255; %

color_plot2 = [100,100,100 ... % 1 »ÒÉ«£¬OBS
    ;255,225,216 ...% 2Ãµ¹åºì, TP
    ;224,220,252 ...% 3 µ­À¶×ÏÉ«1, NETP
    ;208,179,255 ...% 4 µ­À¶×ÏÉ«, SETP
    ;255,200,255 ... % 5 µ­×ÏºìÉ«, TIO
    ;180,255,255 ...;% 6 µ­Âí¶ûË¹ÂÌ, NTA
    ;255,226,205 ...% 7 µ­°®ÂíÊË³È, All
    ;199,164,228 ...% 8 µ­²¥¿Í×Ï NTA_S
    ;227,209,255 ...% 9 µ­À¶×ÏÉ« NTA_N
    ;247,197,210 ...% 10 µ­bilibiliºì,WWB
    ;182,219,252 ...%  11 µ­À¶É«,WWBs
    ;249,234,185 ...% ±¸Ñ¡É« µ­Î¢²©»Æ
    ]/255;
%%
close all

plot(fig1a,fig1b,'color',color_plot(1,:),'LineWidth',LW,'LineStyle','-')
hold on
plot(fig2a,fig2b,'color',color_plot(2,:),'LineWidth',LW,'LineStyle','-')
plot(fig3a,fig3b,'color',color_plot(7,:),'LineWidth',LW,'LineStyle','-')

a1 = 10;b1 = 10;
for i1 = 1:length(fig1_ssta)
    scatter(fig1_ssta(i1),fig1_ua(i1),a1*(i1-1)+b1,color_plot(1,:),'filled')
    scatter(fig2_ssta(i1),fig2_ua(i1),a1*(i1+1)+b1,color_plot(2,:),'filled')
    scatter(fig3_ssta(i1),fig3_ua(i1),a1*(i1+1)+b1,color_plot(7,:),'filled')
end

a1 = fig1_date(:,1) == 2023 &  fig1_date(:,2) == 8;
text(fig1_ssta(a1)+0.05,fig1_ua(a1),num2str(fig1_date(a1,2)),'color',color_plot(1,:),'FontSize',FontSize2,'FontName',FontName);
a1 = fig2_date(:,1) == 2023 &  fig2_date(:,2) == 8;
text(fig2_ssta(a1)+0.05,fig2_ua(a1),num2str(fig2_date(a1,2)),'color',color_plot(2,:),'FontSize',FontSize2,'FontName',FontName);
a1 = fig3_date(:,1) == 2023 &  fig3_date(:,2) == 8;
text(fig3_ssta(a1)+0.05,fig3_ua(a1)+0.05,num2str(fig3_date(a1,2)),'color',color_plot(7,:),'FontSize',FontSize2,'FontName',FontName);

grid on

xtick = -1:1:3;
ytick = -3:1:3;
xticklabel = xtick;
yticklabel = ytick;
xlim([xtick(1),2.5]);
ylim([ytick(1),ytick(end)])
set(gca,'xtick',xtick,'xticklabel',xticklabel,'ytick',ytick,'yticklabel',yticklabel,'FontSize',FontSize,'FontName',FontName);
legend(legend_name,'Location','NorthWest','Interpreter','None');
% title( 'Tendency','FontName',FontName,'FontSize',FontSize2);
xlabel('NINO3.4 SST','FontName',FontName,'FontSize',FontSize,'Interpreter','None');% [¡ãC]
ylabel('NINO4 zonal wind stress','FontName',FontName,'FontSize',FontSize);% [¡Á10^{-3} N/m^{2}]
text(xtick(1)-(xtick(end)-xtick(1))/40,ytick(end)+(ytick(end)-ytick(1))/15,'¡Á10^{-2}','FontName',FontName,'FontSize',FontSize2);

rectangle('Position',[xtick(end)-(xtick(end)-xtick(1))/2.4+0.2,ytick(1)+(ytick(end)-ytick(1))/20,0.9,2],'Curvature',[0,0],'FaceColor',[1,1,1]);
text(xtick(end)-(xtick(end)-xtick(1))/2.4+0.25,0.5+ytick(1)+(ytick(end)-ytick(1))/20,['Reg =',num2str(reg3_a*0.01,'%2.3f')],'color',color_plot(7,:),'FontName',FontName,'FontSize',FontSize3);
text(xtick(end)-(xtick(end)-xtick(1))/2.4+0.25,0.5+ytick(1)+3*(ytick(end)-ytick(1))/20,['Reg =',num2str(reg2_a*0.01,'%2.3f')],'color',color_plot(2,:),'FontName',FontName,'FontSize',FontSize3);
text(xtick(end)-(xtick(end)-xtick(1))/2.4+0.25,0.5+ytick(1)+5*(ytick(end)-ytick(1))/20,['Reg =',num2str(reg1_a*0.01,'%2.3f')],'color',color_plot(1,:),'FontName',FontName,'FontSize',FontSize3);

% text(xtick(1)+(xtick(end)-xtick(1))/5,ytick(end)+(ytick(end)-ytick(1))/30,'(c)','FontName',FontName,'FontSize',FontSize2,'Interpreter','None');
% text(xtick(1)+(xtick(end)-xtick(1))/3,ytick(end)+(ytick(end)-ytick(1))/30,'Coupling strength','FontName',FontName,'FontSize',FontSize2,'Interpreter','None');
title('Coupling strength','FontName',FontName,'FontSize',FontSize,'Interpreter','None');
%%
PaperPosition = [0 0 8 4];
set(gcf,'PaperUnits','inches','PaperPosition',PaperPosition,'color',[1 1 1],'PaperOrientation','landscape');
print('-dpdf','-r1000',[pathfig,'.pdf']);
print('-djpeg','-r1000',[pathfig,'.jpg']);

