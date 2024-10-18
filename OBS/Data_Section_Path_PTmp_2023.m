clc;clear
aimpath = 'F:\2023PMM_Work\bin_data\';
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end

path = 'F:\Ocean_Data\Godas\pottmp\';
fext = '*.nc';
struct = dir([path fext]);
name = {struct.name}';
name = name(end);
clear fext struct;

one = 2;% 1:Pacific Equator;2:Global Equator
first_name = {'PacEqu','GloEqu'};

i1 = 1;
ncdisp([path,name{i1}]);
% date = double( ncread([path,name{i1}],'date'));
depth = double( ncread([path,name{i1}],'level'));
lon = double( ncread([path,name{i1}],'lon'));
lat = double( ncread([path,name{i1}],'lat'));
bnd_time = etime([1950,1,1,0,0,0],[1800,1,1,0,0,0])/3600/24;

switch one
    case 1
        path1 = [140,0];
        path2 = [360-80,0];
    case 2
        path1 = [0,0];
        path2 = [360,0];
end

l_d = sum(depth <= 500) + 1;
sec_depth = depth(1:l_d);

len = 2.5;
lon_start = path1(1);
lon_end = path2(1);
lat_start = path1(2);
lat_end = path2(2);

bin_lon = find(lon >= lon_start -len & lon <= lon_end + len);
sec_lon = lon(bin_lon);
sec_lat = (sec_lon-lon_start)/(lon_end-lon_start)*(lat_end-lat_start);
%%
clear date sec_ptmp
for i1 = 1:length(name)
    pottmp  = double( ncread([path,name{i1}],'pottmp',[1,1,1,1],[inf,inf,l_d,inf]))-273.15;% lon*lat*depth*date
    for i = 1:length(sec_lon)
        b = lat >= sec_lat(i)-len & lat <= sec_lat(i)+len;
        bin(i,:,:,:) = pottmp(bin_lon(i),b,:,:);
    end
    sec_ptmp = squeeze(nanmean(bin,2));
    
    bin_time = double( ncread([path,name{i1}],'time'));
    [bin_time(:,1),bin_time(:,2),~,~,~,~] = mjd19502date(bin_time - bnd_time);
    date = bin_time;
end
a = abs(sec_ptmp) >= 1e4;
sec_ptmp(a) = nan;
%%
datapath = [aimpath,'Sec',first_name{one},'_PTmp_',num2str(date(1,1)),'.mat'];
save(datapath,'sec_ptmp','sec_lon','sec_lat','sec_depth','date','path1','path2');