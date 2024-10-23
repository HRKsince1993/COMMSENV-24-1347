clc;clear

path = 'F:\2023PMM_Work\Input_TauxA_WWB_2023Daily\';
fext = '*.dat';
struct = dir([path fext]);
name = {struct.name}';

path1 = 'I:\CESM\Output_Data\HRK_2023ENSO_Ensemble\Exp_NTAandTIOandPMMandSEPandWWB\Exp_NTAandTIOandPMMandSEPandWWB_0110_00\ocean_daily\';
fext = '*.nc';
struct = dir([path1 fext]);
name1 = {struct.name}';
clear fext struct;

tlon = ncread([path1,name1{1}],'TLONG');
tlat = ncread([path1,name1{1}],'TLAT');
%%
i1 = 314;
bin = importtauday([path,'taux_day_',num2str(i1),'.dat']);

contourf(tlon,tlat,bin')
colorbar
caxis([0,0.1])
%%
clear bin
for i1 = 1:length(name)
    bin(:,:,i1) = importtauday([path,'taux_day_',num2str(i1),'.dat']);
end

bin(bin == 0) = nan;
%%
fig1 = squeeze(nanmean(bin(:,166:210,:),2));
fig_lon = mean(tlon(166:210,:),1);
fig_lat = mean(tlat(166:210,:),1);
%%
% contourf(fig_lon,1:size(fig1,2),fig1')
contourf(fig1')


