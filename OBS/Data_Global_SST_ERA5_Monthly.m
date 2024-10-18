% Figure of pressure and wind
clc;clear;
path = 'F:\Atmosphere_Data\ERA5\';
data_sst = load('F:\ENSO_work\Data_ENSO\SST_Global_Monthly_1940to2022.mat');
aimpath = 'F:\ENSO_work\Data_ENSO\';
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end

fext = '*.nc';
struct = dir([path fext]);
name = {struct.name}';
clear fext struct;

one = 18;
ncdisp([path,name{one}]);
lon = double( ncread([path,name{one}],'longitude'));
lat = double( ncread([path,name{one}],'latitude'));
time = double( ncread([path,name{one}],'time'))/24;
[time(:,1),time(:,2),~,~,~,~] = mjd19002date(time);
lon_sst = data_sst.lon;
lat_sst = data_sst.lat;
%% 2023-2023 mean
len = find(time(:,1) >= 2021 & time(:,1) <= 2022);
date = time(len,:);
[lat1,lon1] = meshgrid(lat,lon);
[lat2,lon2] = meshgrid(lat_sst,lon_sst);
clear sst;
for i = 1:size(date,1)
    bin_sst = double( ncread([path,name{one}],'sst',[1,1,i],[inf,inf,1]))-273.15;
    sst(:,:,i) = griddata(lat1,lon1,bin_sst,lat2,lon2,'linear');
end
lon = lon_sst;
lat = lat_sst;
%%
figure
contourf(lon,lat,sst(:,:,2)');
colorbar;
%%
save([aimpath,'SST_Global_Monthly_ERA5_2021to2022.mat'],'lon','lat','sst','date');



