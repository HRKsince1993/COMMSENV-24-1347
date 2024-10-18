clc;clear;
aimpath = 'F:\2023PMM_Work\bin_data\';
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end

one = 2;% 1:TIO_lg;2:NTA_lg;3:NTA_N;4:NTA_S
two = 1;% 1:Raw;2:remove Nino3.4
time_start = 1979; time_end = 2023;

load('F:\2023PMM_Work\bin_data\Mask_Tropics_Turn.mat');
bin_mask = nan(size(mask_region));
switch one
    case 1
        lon_box = [30,120];
        lat_box = [-30,30];
        text_name = 'TIO_lg';
        
        a = lon >= lon_box(1) & lon <= lon_box(2);
        b = lat >= lat_box(1) & lat <= lat_box(2);
        bin_mask(a,b) = mask_region(a,b);
    case 2
        lon_box = [360-100,360;0,20];
        lat_box = [-30,30];
        text_name = 'NTA_lg';
        
        a = lon >= lon_box(1,1) & lon <= lon_box(1,2);
        b = lat >= lat_box(1) & lat <= lat_box(2);
        bin_mask(a,b) = mask_region(a,b);
        
        a = lon >= lon_box(2,1) & lon <= lon_box(2,2);
        b = lat >= lat_box(1) & lat <= lat_box(2);
        bin_mask(a,b) = mask_region(a,b);
    case 3
        lon_box = [360-100,360;0,20];
        lat_box = [15,30];
        text_name = 'NTA_N';
        
        a = lon >= lon_box(1,1) & lon <= lon_box(1,2);
        b = lat >= lat_box(1) & lat <= lat_box(2);
        bin_mask(a,b) = mask_region(a,b);
        
        a = lon >= lon_box(2,1) & lon <= lon_box(2,2);
        b = lat >= lat_box(1) & lat <= lat_box(2);
        bin_mask(a,b) = mask_region(a,b);
    case 4
        lon_box = [360-100,360;0,20];
        lat_box = [0,15];
        text_name = 'NTA_S';
        
        a = lon >= lon_box(1,1) & lon <= lon_box(1,2);
        b = lat >= lat_box(1) & lat <= lat_box(2);
        bin_mask(a,b) = mask_region(a,b);
        
        a = lon >= lon_box(2,1) & lon <= lon_box(2,2);
        b = lat >= lat_box(1) & lat <= lat_box(2);
        bin_mask(a,b) = mask_region(a,b);
end
contourf(lon,lat,bin_mask')
colorbar
%%
bin_mask(bin_mask < 1) = nan;

switch two 
    case 1
        load(['G:\ENSO_work\Data_ENSO\SSTA_Global_Monthly_ERA5_',num2str(time_start),'to',num2str(time_end),'.mat']);
        text_name2 = [];
    case 2
        load(['G:\ENSO_work\Data_ENSO\SSTA_Nino34_Ind_ERA5_',num2str(time_start),'to',num2str(time_end),'.mat']);
        ssta = ssta_ind;
        text_name2 = '_Nino34_Ind';
end

clear bin_ssta
for i1 = 1:size(ssta,3)
    bin_ssta(:,:,i1) = ssta(:,:,i1).*bin_mask;
end
%%
contourf(lon,lat,bin_ssta(:,:,10)')
colorbar
%%
area_ssta = nanmean(nanmean(bin_ssta,1),2);
area_ssta = area_ssta(:);
%%
savepath = [aimpath,'Mask_',text_name,'_SSTA',text_name2,'_ERA5_',num2str(time_start),'to',num2str(time_end),'.mat']
% save(savepath,'area_ssta','date','mask_region','lon_box','lat_box');
%%
a = date(:,1) == 2023 & date(:,2)==3;
area_ssta(a)
