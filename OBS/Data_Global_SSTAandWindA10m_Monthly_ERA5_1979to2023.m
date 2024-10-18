clc;clear;
aimpath = 'F:\ENSO_work\Data_ENSO\';
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end

data_sst1 = load('F:\ENSO_Work\Data_ENSO\SST_Global_Monthly_ERA5_1979to2020.mat');
data_sst2 = load('F:\ENSO_Work\Data_ENSO\SST_Global_Monthly_ERA5_2021to2022.mat');
data_sst3 = load('F:\ENSO_Work\Data_ENSO\SST_Global_Monthly_ERA5_2023.mat');
data_wind1 = load('F:\ENSO_Work\Data_ENSO\Wind10m_Global_Monthly_ERA5_Averaged_1940to2022.mat');
data_wind2 = load('F:\ENSO_Work\Data_ENSO\Wind10m_Global_Monthly_ERA5_Averaged_2023.mat');

lon = data_sst1.lon;
lat = data_sst1.lat;
date_sst = cat(1,data_sst1.date,data_sst2.date,data_sst3.date);
sst = cat(3,data_sst1.sst,data_sst2.sst,data_sst3.sst);
a = date_sst(:,1) >= 1979;
date_sst = date_sst(a,:);
sst = sst(:,:,a);

date_wind = cat(1,data_wind1.date,data_wind2.date);
u10m = cat(3,data_wind1.u10m,data_wind2.u10m);
v10m = cat(3,data_wind1.v10m,data_wind2.v10m);
a = date_wind(:,1) >= 1979;
date_wind = date_wind(a,:);
u10m = u10m(:,:,a);
v10m = v10m(:,:,a);

date = date_sst;
%%
a = date(:,1) >= 1979 & date(:,1) <= 2019;
sst2 = reshape(sst(:,:,a),size(sst,1),size(sst,2),12,sum(a)/12);
u10m2 = reshape(u10m(:,:,a),size(u10m,1),size(u10m,2),12,sum(a)/12);
v10m2 = reshape(v10m(:,:,a),size(v10m,1),size(v10m,2),12,sum(a)/12);
sst_season = mean(sst2,4);
u10m_season = mean(u10m2,4);
v10m_season = mean(v10m2,4);

ssta = sst;u10a = u10m;v10a = v10m;
for i = 1:size(date,1)
    ssta(:,:,i) = sst(:,:,i) - sst_season(:,:,date(i,2));
    u10a(:,:,i) = u10m(:,:,i) - u10m_season(:,:,date(i,2));
    v10a(:,:,i) = v10m(:,:,i) - v10m_season(:,:,date(i,2));
end

clear ssta_detrend u10a_detrend v10a_detrend
for i1 = 1:size(ssta,1)
   for i2 = 1:size(ssta,2)
       pro = ssta(i1,i2,:);pro = pro(:);
       ssta_detrend(i1,i2,:) = detrend(pro);
       
       pro = u10a(i1,i2,:);pro = pro(:);
       u10a_detrend(i1,i2,:) = detrend(pro);
       
       pro = v10a(i1,i2,:);pro = pro(:);
       v10a_detrend(i1,i2,:) = detrend(pro);
   end
end
%%
save([aimpath,'SSTA_Global_Monthly_ERA5_1979to2023.mat'],'lon','lat','date','ssta','ssta_detrend');
save([aimpath,'WindA10m_Global_Monthly_ERA5_Averaged_1979to2023.mat'],'lon','lat','date','u10a','v10a','u10a_detrend','v10a_detrend');