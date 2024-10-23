clc;clear

data_sst = load('G:\ENSO_work\Data_ENSO\SST_Global_Monthly_1940to2022.mat');
lon = data_sst.lon;
lat = data_sst.lat;
[lon_grid,lat_grid] = meshgrid(lon,lat);

for one = 1:10 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
              % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};
    
    readme = 'unit is N/m2';
    path1 = ['H:\CESM\Output_Data\HRK_2023ENSO_Ensemble\Exp_',first_name{one},'\'];
    struct = dir(path1);
    name1 = {struct(3:end).name}';
    
    i1 = 1;
    i2 = 1;
    %%
    for i1 = 1:length(name1)
        path2 = [path1,name1{i1},'\ocean_daily\'];
        
        fext = '*.nc';
        struct = dir([path2 fext]);
        name2 = {struct.name}';
        clear fext struct;
        
        if length(name2) ~= 12
            'error'
            break
        end
%         ncdisp([path2,name2{1}])
        aimpath1 = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\Taux_Casely_Daily\'];
        aimpath2 = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\Tauy_Casely_Daily\'];
        if exist(aimpath1,'dir')~=7
            mkdir(aimpath1);
        end
        if exist(aimpath2,'dir')~=7
            mkdir(aimpath2);
        end
        
        tlon = ncread([path2,name2{1}],'TLONG');
        tlat = ncread([path2,name2{1}],'TLAT');
        %%
        clear taux tauy date
        time = [];taux = [];tauy = [];
        for i2 = 1:length(name2)
            bin_time = ncread([path2,name2{i2}],'time');
            bin_taux = ncread([path2,name2{i2}],'TAUX')*0.1;
            bin_tauy = ncread([path2,name2{i2}],'TAUY')*0.1;
            bin_taux(bin_taux == 0) = nan;
            bin_tauy(bin_tauy == 0) = nan;
%             bin_temp2 = mean(bin_temp,3);
            clear taux2 tauy2
            for i3 = 1:size(bin_taux,3)
                taux2(:,:,i3) = griddata(tlon,tlat,bin_taux(:,:,i3),lon_grid,lat_grid,'linear')';
                tauy2(:,:,i3) = griddata(tlon,tlat,bin_tauy(:,:,i3),lon_grid,lat_grid,'linear')';
            end
            
            time = [time;bin_time];
            taux = cat(3,taux,taux2);
            tauy = cat(3,tauy,tauy2);
            date(i2,1) = str2double(name2{i2}(end-12:end-9));
            date(i2,2) = str2double(name2{i2}(end-7:end-6));
            date(i2,3) = str2double(name2{i2}(end-4:end-3));
            date(i2,4) = bin_time(1)-365;
            date(i2,5) = bin_time(end)-365;
        end
%         sst = sst(:,:,2:end);
        time = time - 365;
        %     bnd_time = etime([1949,1,1,0,0,0],[0,1,1,0,0,0])/3600/24;
        %     [date(:,1),date(:,2),date(:,3),~,~,~] = mjd19502date(time-bnd_time);
        %%
        datapath1 = [aimpath1,'Taux_Global_Daily_',num2str(date(1,1)),'-',num2str(date(1,2),'%2.2i'),'_to_'...
            ,num2str(date(end,1)),'-',num2str(date(end,2),'%2.2i'),'_',name1{i1},'.mat'];
        datapath2 = [aimpath2,'Tauy_Global_Daily_',num2str(date(1,1)),'-',num2str(date(1,2),'%2.2i'),'_to_'...
            ,num2str(date(end,1)),'-',num2str(date(end,2),'%2.2i'),'_',name1{i1},'.mat'];
        save(datapath1,'lon','lat','taux','date','time','readme');
        save(datapath2,'lon','lat','tauy','date','time','readme');
        i1
    end
    one
end