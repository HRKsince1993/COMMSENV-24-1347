clc;clear;
aimpath = 'F:\ENSO_work\Data_ENSO\';
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end

one = 1;% 1:Lian et al.(2021);2:Ramkrushn S. Patel 2014
first_name = {[],'_RPm'};

load('F:\ENSO_Work\Data_ENSO\WindU10m_Global_Daily_ERA5_2023.mat')
load('F:\ENSO_Work\Data_ENSO\WindV10m_Global_Daily_ERA5_2023.mat')

switch one
    case 1
        [taux,tauy]=cal_windstrss(u10,v10);
    case 2
        clear taux tauy
        for i1 = 1:size(u10,3)
            [taux(:,:,i1),tauy(:,:,i1)]=ra_windstr(u10(:,:,i1),v10(:,:,i1));
        end
end
readme = 'unit is N/m2';
%%
contourf(lon,lat,taux(:,:,1)')
colorbar
caxis([-0.1,0.1]);
%%
save([aimpath,'Tauxy_Tropical_Daily_ERA5_Averaged_2023',first_name{one},'.mat'],'lon','lat','date','taux','tauy','readme');

