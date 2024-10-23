clc;clear
aimpath = ['F:\2023PMM_Work\Figures_for_Publish\Figure\FigS22_ENSO_package_feedback\'];
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end

aimpath2 = ['F:\2023PMM_Work\Figures_for_Publish\bin_data_CMIP_Chen\'];
if exist(aimpath2,'dir')~=7
    mkdir(aimpath2);
end

figpath = [aimpath,'Chen_FigS22a_ENSO_package_feedback_reg'];

% load Nino3.4 SSTA index
data1  = load('G:\ENSO_Work\bin_data\Var_AreaSSTA_Nino34_Monthly_ERA5_1979to2023.mat'); % Obs SSTA
data2  = load('F:\CESM_Work\Data_CESM\Control_Run\Nino34_SSTA_Ctrl_1to100yr.mat'); % CESM SSTA

path1 = 'G:\CMIP\Data_CMIP_Chen\Nino34_SSTA_Monthly\';
load('F:\2023PMM_Work\Figures_for_Response\Chen_List_CMIP_Name37.mat')

nino_ssta_obs = data1.area_ssta_detrend;
nino_ssta_cesm = detrend(data2.nino34_ssta(1:end-9));

clear nino_ssta_cmip_group
for i1 = 1:length(list_name)
    data3 = load(['G:\CMIP\Data_CMIP_Chen\Nino34_SSTA_Monthly\Var_AreaSSTA_Nino34_Monthly_',list_name{i1},'_1900to2014.mat']);% CMIP SSTA
    nino_ssta_cmip_group(:,i1) = data3.area_ssta_detrend;
end
date_cmip = data3.date;

% load Nino4 Taux index
data1_wind = load('G:\ENSO_Work\bin_data\Var_AreaTauxA_Nino4_Monthly_ERA5_1979to2023.mat');% Obs TauxA
data2_wind  = load('F:\CESM_Work\Data_CESM\Control_Run\Nino4_TauxA_Ctrl_1to99yr.mat'); % CESM TauxA

nino_u10a_obs = data1_wind.area_tauxa_detrend;
nino_u10a_cesm = data2_wind.area_tauxa_detrend*0.1;% 1 dyn/cm2 = 0.1 N/m2

clear nino_u10a_cmip_group
for i1 = 1:length(list_name)
    data3_wind = load(['G:\CMIP\Data_CMIP_Chen\Nino4_TauxA_Monthly\Var_AreaTauxA_Nino4_Monthly_',list_name{i1},'_1900to2014.mat']);
    nino_u10a_cmip_group(:,i1) = data3_wind.area_tauxa_detrend;
end

% Obs
fig1_ssta_obs = nino_ssta_obs;
fig1_u10a_obs = nino_u10a_obs;
p1_obs = polyfit(fig1_ssta_obs,fig1_u10a_obs,1);
reg1_obs_a = p1_obs(1);reg1_obs_b = p1_obs(2);
fig1a_ssta_obs = linspace(min(fig1_ssta_obs),max(fig1_ssta_obs),1000);
fig1b_u10a_obs = fig1a_ssta_obs*reg1_obs_a+reg1_obs_b;

% CESM
fig2_ssta_cesm = nino_ssta_cesm;
fig2_u10a_cesm = nino_u10a_cesm;
p2_cesm = polyfit(fig2_ssta_cesm,fig2_u10a_cesm,1);
reg2_cesm_a = p2_cesm(1);reg2_cesm_b = p2_cesm(2);
fig2a_ssta_cesm = linspace(min(fig2_ssta_cesm),max(fig2_ssta_cesm),1000);
fig2b_u10a_cesm = fig2a_ssta_cesm*reg2_cesm_a+reg2_cesm_b;

% CMIP
bin_fig3_ssta = nino_ssta_cmip_group;
bin_fig3_u10a = nino_u10a_cmip_group;
clear reg3_cmip_a reg3_cmip_b bin_fig3a_ssta bin_fig3b_u10a
for i1 = 1:size(bin_fig3_ssta,2)
    p3_cmip = polyfit(bin_fig3_ssta(:,i1),bin_fig3_u10a(:,i1),1);
    
    if p3_cmip(1) >= 0
        reg3_cmip_a(i1) = p3_cmip(1);reg3_cmip_b(i1) = p3_cmip(2);
    else
        reg3_cmip_a(i1) = -p3_cmip(1);reg3_cmip_b(i1) = -p3_cmip(2);% correct the taux direction
    end 
    
    bin_fig3a_ssta(:,i1) = linspace(min(bin_fig3_ssta(:,i1)),max(bin_fig3_ssta(:,i1)),1000);
    bin_fig3b_u10a(:,i1) = bin_fig3a_ssta(:,i1)*reg3_cmip_a(i1)+reg3_cmip_b(i1);
end
    
reg3_cmip_avr = mean(reg3_cmip_a);
reg3_cmip_std = std(reg3_cmip_a);

legend_name = {'OBS','CESM','CMIP6'};
save([aimpath2,'Chen_ENSO_package_SSTandTaux_Feedback.mat'],'reg1_obs_a','reg2_cesm_a','reg3_cmip_a','list_name');
%%
FontSize = 25;% tick and tile
FontSize2 = 25;% legend
FontSize3 = 15;% text label unit
FontName = 'Arial';
LW = 4;% lines
LW2 = 2;% lines

bar_width = 0.8;

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
    ;255,205,206 ...% 2Ãµ¹åºì, TP
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
k_scale = 100;

close all
plot(fig1a_ssta_obs,fig1b_u10a_obs*k_scale,'color',color_plot(1,:),'LineWidth',LW,'LineStyle','-')
hold on
plot(fig2a_ssta_cesm,fig2b_u10a_cesm*k_scale,'color',color_plot(2,:),'LineWidth',LW,'LineStyle','-')
plot(bin_fig3a_ssta(:,i1),bin_fig3b_u10a(:,i1)*k_scale,'color',color_plot2(1,:),'LineWidth',LW2,'LineStyle','-')
    
scatter(fig1_ssta_obs,fig1_u10a_obs*k_scale,12,color_plot(1,:),'filled')
scatter(fig2_ssta_cesm,fig2_u10a_cesm*k_scale,12,color_plot2(2,:),'filled')

for i1 = 2:size(bin_fig3a_ssta,2);
    plot(bin_fig3a_ssta(:,i1),bin_fig3b_u10a(:,i1)*k_scale,'color',color_plot2(1,:),'LineWidth',LW2,'LineStyle','-')
end

plot(fig2a_ssta_cesm,fig2b_u10a_cesm*k_scale,'color',color_plot(2,:),'LineWidth',LW,'LineStyle','-')
plot(fig1a_ssta_obs,fig1b_u10a_obs*k_scale,'color',color_plot(1,:),'LineWidth',LW,'LineStyle','-')

box on
grid on;
xtick = -4:2:4;
ytick = -6:2:6;
xticklabel = xtick;
yticklabel = ytick;
xlim([xtick(1)-1,xtick(end)+1]);
ylim([ytick(1),ytick(end)])

set(gca,'xtick',xtick,'xticklabel',xticklabel,'ytick',ytick,'yticklabel',yticklabel,'FontSize',FontSize,'FontName',FontName);
% xtickangle(45)

legend(legend_name,'Location','NorthWest','Interpreter','None');
xlabel('NINO3.4 index','FontSize',FontSize,'FontName',FontName);
ylabel(['NINO4 wind stress'],'FontSize',FontSize,'FontName',FontName);

% text(xtick(1),ytick(end)+(ytick(end)-ytick(1))/20,['¡Á10^{-',num2str(log10(k_scale)),'}'],'FontSize',FontSize3,'FontName',FontName);

rectangle('Position',[xtick(end)-(xtick(end)-xtick(1))/2+2,ytick(1)+(ytick(end)-ytick(1))/20,(xtick(end)-xtick(1))/2.85,(ytick(end)-ytick(1))/3.2],'Curvature',[0,0],'FaceColor',[1,1,1]);
text(xtick(end)-(xtick(end)-xtick(1))/2+2.1,0.8+ytick(1)+1*(ytick(end)-ytick(1))/20,['Reg =',num2str(reg3_cmip_avr*k_scale,'%2.2f'),'¡À',num2str(reg3_cmip_std*k_scale,'%2.2f')],'color',color_plot2(1,:),'FontName',FontName,'FontSize',FontSize2);
text(xtick(end)-(xtick(end)-xtick(1))/2+2.1,0.8+ytick(1)+3*(ytick(end)-ytick(1))/20,['Reg =',num2str(reg2_cesm_a*k_scale,'%2.2f')],'color',color_plot(2,:),'FontName',FontName,'FontSize',FontSize2);
text(xtick(end)-(xtick(end)-xtick(1))/2+2.1,0.8+ytick(1)+5*(ytick(end)-ytick(1))/20,['Reg =',num2str(reg1_obs_a*k_scale,'%2.2f')],'color',color_plot(1,:),'FontName',FontName,'FontSize',FontSize2);

title('SST-Zonal wind feedback','FontSize',FontSize,'FontName',FontName);
text(xtick(1)-1,ytick(end)+(ytick(end)-ytick(1))/16,'(a)','FontSize',FontSize,'FontName',FontName);
%%
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 12 5],'color',[1 1 1],'PaperOrientation','landscape');
print('-djpeg','-r1000',[figpath,'.jpg']);
print('-dpdf','-r1000',[figpath,'.pdf']);
