clc;clear;
aimpath = 'F:\ENSO_Work\Data_ENSO\';
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end

one = 2;% 1:taux ;2:tauy
first_name = {'x','y'};
load('F:\ENSO_Work\Data_ENSO\Tauxy_Tropical_Monthly_ERA5_Averaged_1940to2022.mat');
data_days = load('F:\2023PMM_Work\bin_data\OneYearDays.mat');

switch one
    case 1
        sst = taux;
        data2 = load('F:\ENSO_Work\Data_ENSO\Tauxy_Tropical_Daily_ERA5_Averaged_2023.mat');
        sst_2023 = data2.taux;
    case 2
        sst = tauy;
        data2 = load('F:\ENSO_Work\Data_ENSO\Tauxy_Tropical_Daily_ERA5_Averaged_2023.mat');
        sst_2023 = data2.tauy;
end

a = date(:,1) >= 1979 & date(:,1) <= 2019;
sst2 = reshape(sst(:,:,a),size(sst,1),size(sst,2),12,sum(a)/12);
sst_season = mean(sst2,4);
sst_season2 = cat(3,sst_season(:,:,12),sst_season,sst_season(:,:,1));
%%
a_day = 1:30*13;
b_day = data_days.pro_days(:,3);
sst_day_cli = nan(size(sst_season,1),size(sst_season,2),length(a_day));
for i1 = 1:size(sst_season,1)
    for i2 = 1:size(sst_season,2)
        pro = sst_season2(i1,i2,:);
        pro = pro(:);
        if sum(pro == 0) == length(pro)
            continue
        end
        sst_day_cli(i1,i2,:) = interp1(b_day,pro,a_day,'linear');
    end
end
sst_day_cli = sst_day_cli(:,:,16:end);% 第1个数对应1月1日
%%
date = data2.date;
ssta = sst_2023 - sst_day_cli(:,:,1:size(sst_2023,3));
%%
a = lat >= -10 & lat <= 10;
contourf(lon,lat(a),ssta(:,a,135)','levelstep',0.01)
colorbar;
caxis([-0.1,0.1])
%%
switch one
    case 1
        tauxa = ssta;
        save([aimpath,'TauA',first_name{one},'_Tropical_Daily_ERA5_2023.mat'],'tauxa','date','lon','lat','readme')
    case 2
        tauya = ssta;
        save([aimpath,'TauA',first_name{one},'_Tropical_Daily_ERA5_2023.mat'],'tauya','date','lon','lat','readme')
end