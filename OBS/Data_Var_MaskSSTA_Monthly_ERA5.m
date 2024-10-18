clc;clear;
aimpath = 'F:\2023PMM_Work\bin_data\';
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end

one = 1;% 1:NETP;
time_start = 1979; time_end = 2023;
switch one
    case 1
        lon_box = [200,250];% NETP
        lat_box = [10,30];
        load('F:\2023PMM_Work\bin_data\Mask_NETP_New.mat');
        text_name = 'NETP_New';
end

load(['G:\ENSO_work\Data_ENSO\SSTA_Global_Monthly_ERA5_',num2str(time_start),'to',num2str(time_end),'.mat']);
text_name2 = [];

mask_region(mask_region < 1) = nan;

clear bin_ssta
for i1 = 1:size(ssta,3)
    bin_ssta(:,:,i1) = ssta(:,:,i1).*mask_region;
end
contourf(lon,lat,bin_ssta(:,:,1)')
area_ssta = nanmean(nanmean(bin_ssta,1),2);
area_ssta = area_ssta(:);
%%
savepath = [aimpath,'Mask_',text_name,'_SSTA',text_name2,'_ERA5_',num2str(time_start),'to',num2str(time_end),'.mat']
save(savepath,'area_ssta','date','mask_region','lon_box','lat_box');
%%
a = date(:,1) == 2023 & date(:,2)==3;
area_ssta(a)
