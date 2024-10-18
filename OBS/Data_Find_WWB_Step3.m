clc;clear;
aimpath = 'F:\2023PMM_Work\bin_data\Find_WWB_Method\';
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end

one = 1;% 1:连通域;2:不需要连通域
yu_taux = 0.05;% 西风爆发事件选取阈值，N/m2
yu_taux2 = 0;% 西风事件选取阈值，N/m2
load('F:\ENSO_Work\Data_ENSO\TauAx_Tropical_Daily_ERA5_2023.mat');
% data1 = load('F:\2023PMM_Work\bin_data\Find_WWB_Method\Step2_2023TauxA.mat');

path = 'E:\CESM\Output_Data\Control_Run\hu_test_20211215_8\ocean_daily\';
fext = '*.nc';
struct = dir([path fext]);
name = {struct.name}';
clear fext struct;

time = ncread([path,name{1}],'time');
tlon = ncread([path,name{1}],'TLONG');
tlat = ncread([path,name{1}],'TLAT');
[lon_grid,lat_grid] = meshgrid(lon,lat);

box_lon = [120,360-140];
box_lat = [-5,5];

l_lat = lat >= box_lat(1) & lat <= box_lat(2);
l_lon = lon >= box_lon(1) & lon <= box_lon(2);
region_lat = lat(l_lat);
region_lon = lon(l_lon);
bin_taux = tauxa(l_lon,l_lat,:);

readme = 'unit is N/m2';
%%
taux_wwb_day_sstgrid = zeros(length(lon),length(lat),size(date,1));
taux_wwb_day = zeros(size(tlon,1),size(tlon,2),size(date,1));
% i1 = 150;
for i1 = 1:size(date,1)
    region_taux = bin_taux(:,:,i1);
    
    uvel_wwb = region_taux;
    uvel_wwv = region_taux;
    uvel_wwb(uvel_wwb < yu_taux) = nan;
    uvel_wwv(uvel_wwv <= yu_taux2) = nan;
    
    [x_n,y_n] = find(~isnan(uvel_wwb));
    
    if isempty(x_n) || isempty(y_n)
        continue
    else
        switch one
            case 1
                bin4 = uvel_wwv;
                bin4(bin4>=0) = 1;
                bin4(isnan(bin4)) = 0;
                bin5 = bwlabel(bin4);
                
                clear bin_region_p
                for i2 = 1:length(x_n)
                    [x0,y0] = find(uvel_wwb == uvel_wwb(x_n(i2),y_n(i2)));
                    bin_region_p(:,:,i2) = double(bin5 == bin5(x0,y0));
                    bin_region_p2 = mean(bin_region_p,3);
                    bin_region_p2(bin_region_p2>0) = 1;
                    region_p = bin_region_p2;
                end
                
                taux_wwb = region_taux.*region_p;
                region_taux2 = zeros(size(tauxa,1),size(tauxa,2));
                region_taux2(l_lon,l_lat) = taux_wwb;
            case 2
                region_taux2 = zeros(size(tauxa,1),size(tauxa,2));
                region_taux2(l_lon,l_lat) = uvel_wwb;
        end
        taux_wwb_day_sstgrid(:,:,i1) = region_taux2;
        taux_wwb_day(:,:,i1) = griddata(lon_grid,lat_grid,region_taux2',tlon,tlat,'linear');
    end
end
%%
lon_sstgrid = lon;
lat_sstgrid = lat;
save([aimpath,'TauxA_WWB_Input_Daily_ERA5_SSTGrid.mat'],'readme','lon_sstgrid','lat_sstgrid','taux_wwb_day_sstgrid','date','yu_taux','yu_taux2');
save([aimpath,'TauxA_WWB_Input_Daily_ERA5.mat'],'taux_wwb_day','tlon','tlat','readme','lon_sstgrid','lat_sstgrid','taux_wwb_day_sstgrid','date','yu_taux','yu_taux2');
%%
close all
one = 1;
if one == 1
    subplot(5,1,1)
    contourf(region_lon,region_lat,region_taux','levelstep',0.01)
    colorbar
    caxis([-0.1,0.1]);
    hold on
    scatter(region_lon(x0),region_lat(y0),72,[1,0,0],'filled');
    xlabel('Longitude');
    ylabel('Latitude');
    title('10米纬向风应力异常[N/m2]');
    hold off
    
    subplot(5,1,2)
    contourf(region_lon,region_lat,uvel_wwb','levelstep',0.01);
    colorbar
    caxis([-0.1,0.1]);
    hold on
    scatter(region_lon(x0),region_lat(y0),72,[1,0,0],'filled');
    xlabel('Longitude');
    ylabel('Latitude');
    title('超过0.05 N/m2的10米纬向风应力异常[N/m2]');
    hold off
    
    subplot(5,1,3)
    contourf(region_lon,region_lat,uvel_wwv','levelstep',0.01);
    colorbar
    caxis([-0.1,0.1]);
    hold on
    scatter(region_lon(x0),region_lat(y0),72,[1,0,0],'filled');
    xlabel('Longitude');
    ylabel('Latitude');
    title('10米纬向西风风应力异常[N/m2]');
    hold off
    
    subplot(5,1,4)
    contourf(region_lon,region_lat,bin5');
    colorbar
    hold on
    scatter(region_lon(x0),region_lat(y0),72,[1,0,0],'filled');
    xlabel('Longitude');
    ylabel('Latitude');
    title('连通域判别');
    hold off
    
    subplot(5,1,5)
    contourf(region_lon,region_lat,taux_wwb','levelstep',0.01);
    colorbar
    caxis([-0.1,0.1]);
    hold on
    scatter(region_lon(x0),region_lat(y0),72,[1,0,0],'filled');
    xlabel('Longitude');
    ylabel('Latitude');
    title('西风爆发,风应力[N/m^{2}]');
    hold off
end
set(gcf,'PaperUnits','inches','PaperPosition',[0,0,10,10],'color',[1 1 1]);
print('-djpeg','-r1000',[aimpath,'Step3_2023WWB_EquaPac','.jpg']);
