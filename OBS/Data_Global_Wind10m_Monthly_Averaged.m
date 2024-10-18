clc;clear;
path = 'F:\Atmosphere_Data\ERA5\';
data_sst = load('F:\ENSO_work\Data_ENSO\SST_Global_Monthly.mat');
aimpath = 'F:\ENSO_work\Data_ENSO\';
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end

fext = '*.nc';
struct = dir([path fext]);
name = {struct.name}';
clear fext struct;

one = 35;
ncdisp([path,name{one}]);
lon = double( ncread([path,name{one}],'longitude'));
lat = double( ncread([path,name{one}],'latitude'));
time = double( ncread([path,name{one}],'time'))/24;
[time(:,1),time(:,2),~,~,~,~] = mjd19002date(time);
lon_sst = data_sst.lon;
lat_sst = data_sst.lat;
len_lon = 0.5;
len_lat = 0.5;
%% 2020-2022
len = find(time(:,1) >= 2020 & time(:,1) <= 2022);
date = time(len,:);
u10m = nan(length(lon_sst),length(lat_sst),size(date,1));
v10m = nan(length(lon_sst),length(lat_sst),size(date,1));
for i1 = 1:size(date,1)
    bin_wind_u10m = double( ncread([path,name{one}],'u10',[1,1,len(i1)],[inf,inf,1]));
    bin_wind_v10m = double( ncread([path,name{one}],'v10',[1,1,len(i1)],[inf,inf,1]));
    for i2 = 1:length(lon_sst) % lon
        for i3 = 1:length(lat_sst) % lat
            a1 = lon >= lon_sst(i2)-len_lon & lon < lon_sst(i2)+len_lon;
            a2 = lat >= lat_sst(i3)-len_lat & lat < lat_sst(i3)+len_lat;
            u10m(i2,i3,i1) = mean(mean(bin_wind_u10m(a1,a2),1));
            v10m(i2,i3,i1) = mean(mean(bin_wind_v10m(a1,a2),1));
        end
     end
end
lon = lon_sst;
lat = lat_sst;
%%
% figure
% contourf(lon1,lat1,bin_wind_u10m(:,:,1));
% contourf(lon2,lat2,u10m(:,:,1));
% colorbar;
%%
save([aimpath,'Wind10m_Global_Monthly_Averaged_2020to2022.mat'],'lon','lat','u10m','v10m','date');