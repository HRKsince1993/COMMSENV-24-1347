clc;clear

one = 2; % 1:PMM;2:SEP;3:TIO;4:NTA;5:NTAandTIOandPMMandSEPlg;6:NTAandTIOandPMMandSEPandWWBb
two = 1;% minus 1:TPCtrl;
first_name = {'PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb'};
second_name = {'TPCtrl'};

path1 = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\'];
struct = dir([path1,'*.mat']);
name1 = {struct.name}';

aimpath = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\'];
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end

% data = load([path1,'Compose_SSTdiff',second_name{two},'_Global_Monthly_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-8),'.mat']);% SSTdiff
data = load([path1,'Compose_Wind_diff',second_name{two},'_Global_Monthly_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-5),'_.mat']);% WindDiff

switch one
    case 2 % SETP
        path1 = [360-100,0];
        path2 = [360-80,-20];
        datapath = [aimpath,'Compose_zHovPath_WindDiff',second_name{two},name1{1}(21:end-7),'.mat']
end

uvela = data.uvela_ensemble;
vvela = data.vvela_ensemble;
t_uvela = data.t_uvela_ensemble;
t_vvela = data.t_vvela_ensemble;

lon = data.lon;
lat = data.lat;
date = data.date;
readme = data.readme;

len = 2.5;
lon_start = path1(1);
lon_end = path2(1);
lat_start = path1(2);
lat_end = path2(2);

bin_lon = find(lon >= lon_start -len & lon <= lon_end + len);
cyc_lon = lon(bin_lon);

a1 = (lat_end-lat_start)/(lon_end-lon_start);
b1 = lat_end - a1*lon_end;
cyc_lat = cyc_lon*a1 + b1;
%%
clear hpath_uvela hpath_vvela
for i1 = 1:length(cyc_lon)
    b2 = lat >= cyc_lat(i1)-len & lat <= cyc_lat(i1)+len;
    hpath_uvela(i1,:) = squeeze(mean(uvela(bin_lon(i1),b2,:),2));
    hpath_vvela(i1,:) = squeeze(mean(vvela(bin_lon(i1),b2,:),2));
end

clear hpath_uvela_t
for i1 = 1:length(cyc_lon)
    b2 = lat >= cyc_lat(i1)-len & lat <= cyc_lat(i1)+len;
    hpath_uvela_t(i1,:) = squeeze(mean(t_uvela(bin_lon(i1),b2,:),2));
    hpath_vvela_t(i1,:) = squeeze(mean(t_vvela(bin_lon(i1),b2,:),2));
end

hpath_vela_t = hpath_uvela_t + hpath_vvela_t;
hpath_vela_t( hpath_vela_t > 0 ) = 1;
hpath_vela_t( hpath_vela_t == 0) = nan;
%%
contourf(hpath_vvela','levelstep',0.1);
colorbar;
caxis([-1.5,1.5]);
% colormap(b2r(-1,1));
%%
save(datapath,'hpath_uvela','hpath_vvela','hpath_vela_t','cyc_lon','cyc_lat','date','readme');