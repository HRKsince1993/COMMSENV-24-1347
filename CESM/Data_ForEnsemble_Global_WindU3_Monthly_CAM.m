clc;clear

data_sst = load('G:\ENSO_work\Data_ENSO\SST_Global_Monthly_1940to2022.mat');
lon = data_sst.lon;
lat = data_sst.lat;
[lon_grid,lat_grid] = meshgrid(lon,lat);

one = 2;
%%
for one = 2:2 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
              % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};

    path1 = ['J:\CESM\Output_Data\HRK_2023ENSO_Ensemble\Exp_',first_name{one},'\'];
    struct = dir(path1);
    name1 = {struct(3:end).name}';
    
    i1 = 1;
    i2 = 1;
    readme = 'Zonal wind. Lon*Lat*Lev*Time. Velocity unit is m/s. Lev unit is level';
    %%
    for i1 = 1:length(name1)
        path2 = [path1,name1{i1},'\atm\'];
        struct = dir([path2,'*.nc']);
        name2 = {struct.name}';
        clear fext struct;
        
        if length(name2) ~= 12
            'error'
            break
        end
        
        %     ncdisp([path2,name2{1}])
        aimpath = ['J:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\WindU3_Casely\'];
        if exist(aimpath,'dir')~=7
            mkdir(aimpath);
        end
        
        tlon = ncread([path2,name2{1}],'lon');
        tlat = ncread([path2,name2{1}],'lat');
        lev = ncread([path2,name2{1}],'lev');
        %%
        date = [];uvel = [];
        for i2 = 1:length(name2)
            bin_wind = double(ncread([path2,name2{i2}],'U'));
            
            clear bin_uvel
            for i3 = 1:size(bin_wind,3)
                bin_uvel(:,:,i3) = griddata(tlon,tlat,bin_wind(:,:,i3)',lon_grid,lat_grid,'linear')';
            end
            uvel(:,:,:,i2) = bin_uvel;% lon,lat,heigh,time
            
            date(i2,1) = str2double(name2{i2}(end-9:end-6));
            date(i2,2) = str2double(name2{i2}(end-4:end-3));
        end
        %%
        datapath = [aimpath,'WindU3_Global_Monthly_',num2str(date(1,1)),'-',num2str(date(1,2),'%2.2i'),'_to_'...
            ,num2str(date(end,1)),'-',num2str(date(end,2),'%2.2i'),'_',name1{i1},'_CAM.mat'];
        save(datapath,'lon','lat','lev','uvel','date','readme');
        i1
    end
end