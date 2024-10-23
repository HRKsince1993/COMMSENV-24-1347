clc;clear

data_sst = load('G:\ENSO_work\Data_ENSO\SST_Global_Monthly_1940to2022.mat');
lon = data_sst.lon;
lat = data_sst.lat;
[lon_grid,lat_grid] = meshgrid(lon,lat);

lat = 0;
for one = 1:10 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
              % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};
    
    path1 = ['H:\CESM\Output_Data\HRK_2023ENSO_Ensemble\Exp_',first_name{one},'\'];
    struct = dir(path1);
    name1 = {struct(3:end).name}';
    
    i1 = 1;
    i2 = 1;
    for i1 = 1:length(name1)
        path2 = [path1,name1{i1},'\ocean_monthly\'];
        
        fext = '*.nc';
        struct = dir([path2 fext]);
        name2 = {struct.name}';
        clear fext struct;
        
        if length(name2) ~= 12
            'error'
            break
        end
        
%         ncdisp([path2,name2{1}])
        aimpath2 = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\OcnVvel50m_Global_Casely\'];
        if exist(aimpath2,'dir')~=7
            mkdir(aimpath2);
        end
        
        tlon = ncread([path2,name2{1}],'TLONG');
        tlat = ncread([path2,name2{1}],'TLAT');
        depth = double(ncread([path2,name2{1}],'z_t',1,6))/100;
        %%
        clear date
        time = [];vvel = [];
        for i2 = 1:length(name2)
            bin_time = ncread([path2,name2{i2}],'time');
            bin_vvel = ncread([path2,name2{i2}],'VVEL',[1,1,1,1],[inf,inf,6,1])/100;% Ctrl, cm/s to m/s
%             bin_temp(bin_temp == 0) = nan;
            bin_vvel2 = squeeze(mean(bin_vvel,3));
            bin_vvel3 = griddata(tlon,tlat,bin_vvel2,lon_grid,lat_grid,'linear')';
            
            time = [time;bin_time];
            vvel(:,:,end+1) = bin_vvel3;
            date(i2,1) = str2double(name2{i2}(end-9:end-6));
            date(i2,2) = str2double(name2{i2}(end-4:end-3));
        end
        vvel = vvel(:,:,2:end);
        time = time - 365;
        %     bnd_time = etime([1949,1,1,0,0,0],[0,1,1,0,0,0])/3600/24;
        %     [date(:,1),date(:,2),date(:,3),~,~,~] = mjd19502date(time-bnd_time)
        %%
        readme = 'unit is m/s';
        datapath2 = [aimpath2,'OcnVvel50m_Global_Monthly_',num2str(date(1,1)),'-',num2str(date(1,2),'%2.2i'),'_to_'...
            ,num2str(date(end,1)),'-',num2str(date(end,2),'%2.2i'),'_',name1{i1},'.mat'];
        save(datapath2,'lon','lat','depth','vvel','date','time','readme');
        clear date vvel time
        one
        i1
    end
end