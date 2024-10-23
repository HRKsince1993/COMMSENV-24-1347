clc;clear

data_sst = load('G:\ENSO_work\Data_ENSO\SST_Global_Monthly_1940to2022.mat');
lon = data_sst.lon;
lat = data_sst.lat;
[lon_grid,lat_grid] = meshgrid(lon,lat);

for one = 1:10 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
              % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};
    
    path1 = ['H:\CESM\Output_Data\HRK_2023ENSO_Ensemble\Exp_',first_name{one},'\'];
    struct = dir(path1);
    name1 = {struct(3:end).name}';
    
    i1 = 1;
    i2 = 1;
    readme = 'unit:m/s';
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
        
%         ncdisp([path2,name2{1}])
        aimpath = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\Wind_Casely\'];
        if exist(aimpath,'dir')~=7
            mkdir(aimpath);
        end
        
        tlon = ncread([path2,name2{1}],'lon');
        tlat = ncread([path2,name2{1}],'lat');
        %%
        date = []; uvel = [];vvel = [];
        for i2 = 1:length(name2)
            bin_windu = double(ncread([path2,name2{i2}],'U',[1,1,26,1],[inf,inf,1,inf]));
            bin_windv = double(ncread([path2,name2{i2}],'V',[1,1,26,1],[inf,inf,1,inf]));
            
            bin_uvel = griddata(tlon,tlat,bin_windu',lon_grid,lat_grid,'linear')';
            bin_vvel = griddata(tlon,tlat,bin_windv',lon_grid,lat_grid,'linear')';
            uvel(:,:,i2) = bin_uvel;
            vvel(:,:,i2) = bin_vvel;
            
            date(i2,1) = str2double(name2{i2}(end-9:end-6));
            date(i2,2) = str2double(name2{i2}(end-4:end-3));
        end
        %%
        datapath = [aimpath,'Wind_Global_Monthly_',num2str(date(1,1)),'-',num2str(date(1,2),'%2.2i'),'_to_'...
            ,num2str(date(end,1)),'-',num2str(date(end,2),'%2.2i'),'_',name1{i1},'_CAM.mat'];
        save(datapath,'lon','lat','uvel','vvel','date','readme');
        i1
    end
end