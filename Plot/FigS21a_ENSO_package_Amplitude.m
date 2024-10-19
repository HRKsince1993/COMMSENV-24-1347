clc;clear

one = 2;% From 1:Han;2:Chen
first_name = {'Han','Chen'};

aimpath = ['F:\2023PMM_Work\Figures_for_Publish\Figure\FigS21_ENSO_package_Amplitude\'];
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end

aimpath2 = ['F:\2023PMM_Work\Figures_for_Publish\bin_data_CMIP_',first_name{one},'\'];
if exist(aimpath2,'dir')~=7
    mkdir(aimpath2);
end

% load Nino3.4 index
data1  = load('G:\ENSO_Work\bin_data\Var_AreaSSTA_Nino34_Monthly_ERA5_1979to2023.mat'); % obs
data2  = load('F:\CESM_Work\Data_CESM\Control_Run\Nino34_SSTA_Ctrl_1to100yr.mat'); % CESM

switch one
    case 1
        load('F:\2023PMM_Work\Figures_for_Response\Han_List_CMIP_Name29.mat');
    case 2
        load('F:\2023PMM_Work\Figures_for_Response\Chen_List_CMIP_Name37.mat');
end

nino_obs = data1.area_ssta_detrend;
nino_cesm = detrend(data2.nino34_ssta(1:end-9));

clear nino_cmip_group
for i1 = 1:length(list_name)
    data3 = load(['G:\CMIP\Data_CMIP_',first_name{one},'\Nino34_SSTA_Monthly\Var_AreaSSTA_Nino34_Monthly_',list_name{i1},'_1900to2014.mat']);
    nino_cmip_group(:,i1) = data3.area_ssta_detrend;
end
date_cmip = data3.date;

% NDJ Nino3.4 index
bin_nino_obs = reshape(nino_obs,12,length(nino_obs)/12);
nino_obs_ndj = (bin_nino_obs(11,1:end-1) + bin_nino_obs(12,1:end-1) + bin_nino_obs(1,2:end))/3;

bin_nino_cesm = reshape(nino_cesm,12,length(nino_cesm)/12);
nino_cesm_ndj = (bin_nino_cesm(11,1:end-1) + bin_nino_cesm(12,1:end-1) + bin_nino_cesm(1,2:end))/3;

clear nino_cmip_ndj_group
for i1 = 1:size(nino_cmip_group,2)
    pro1 = nino_cmip_group(:,i1);
    bin_nino_pro1 = reshape(pro1,12,length(pro1)/12);
    nino_cmip_ndj_group(i1,:) = (bin_nino_pro1(11,1:end-1) + bin_nino_pro1(12,1:end-1) + bin_nino_pro1(1,2:end))/3;
end

% STD of NDJ Nino3.4 index
clear bin_std_nino34_ndj
bin_std_nino34_ndj(1) = std(nino_obs_ndj);
bin_std_nino34_ndj(2) = std(nino_cesm_ndj);

for i1 = 1:size(nino_cmip_group,2)
    bin_std_nino34_ndj(i1+2) = std(nino_cmip_ndj_group(i1,:));
end

xtick_name = ['OBS';'CESM';list_name];

save([aimpath2,first_name{one},'_ENSO_package_amplitude_total',num2str(length(bin_std_nino34_ndj)),'.mat'],'bin_std_nino34_ndj','xtick_name');
figpath = [aimpath,first_name{one},'_FigS21a_ENSO_package_amp_distribution_total',num2str(length(bin_std_nino34_ndj))];
%%
FontSize = 18; 
FontSize2 = 15;
FontName = 'Arial';
LW = 5;% lines

bar_width = 0.8;
%%
close all
fig1 = bin_std_nino34_ndj;

h1 = bar(1,fig1(1),bar_width,'facecolor',[0,0,0]);
hold on
h2 = bar(2,fig1(2),bar_width,'facecolor',[1,0,0]);
h3 = bar(3:length(fig1),fig1(3:end),bar_width,'facecolor',[0.8,0.8,0.8]);
plot(xlim,[fig1(1),fig1(1)],'color',[0.7,0.7,0.7],'LineStyle','--')

box on
grid on;
ylim([0,2.3]);
xlim([0,length(fig1)+1]);
set(gca,'xtick',1:length(fig1),'xticklabel',xtick_name,'ytick',-1+0.5:0.5:2+0.5,'FontSize',FontSize,'FontName',FontName);
xtickangle(45)
% xlabel('2023','FontSize',FontSize,'FontName',FontName);
ylabel('NINO3.4[°„C]','FontSize',FontSize,'FontName',FontName);
title('STD in NDJ','FontSize',FontSize,'FontName',FontName);
text(0,2.45,'(a)','FontSize',FontSize,'FontName',FontName);
%%
set(gcf,'PaperUnits','inches','PaperPosition',[-1 0 15 5],'color',[1 1 1],'PaperOrientation','landscape');
print('-djpeg','-r1000',[figpath,'.jpg']);
print('-dpdf','-r1000',[figpath,'_left.pdf']);

set(gcf,'PaperUnits','inches','PaperPosition',[-3 0 15 5],'color',[1 1 1],'PaperOrientation','landscape');
print('-dpdf','-r1000',[figpath,'_right.pdf']);
