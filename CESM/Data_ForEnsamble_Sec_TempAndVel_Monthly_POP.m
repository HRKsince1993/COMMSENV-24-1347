clc;clear

% data_sst = load('F:\ENSO_work\Data_ENSO\SST_Global_Monthly_1940to2022.mat');
% lon = data_sst.lon;
% lat = data_sst.lat;
% [lon_grid,lat_grid] = meshgrid(lon,lat);

lat = 0;
for one = 1:10 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
              % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};
    
    path1 = ['H:\CESM\Output_Data\HRK_2023ENSO_Ensamble\Exp_',first_name{one},'\'];
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
        aimpath1 = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\Temp_Casely\'];
        if exist(aimpath1,'dir')~=7
            mkdir(aimpath1);
        end
        
        aimpath2 = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\OcnVel_Casely\'];
        if exist(aimpath2,'dir')~=7
            mkdir(aimpath2);
        end
        
        tlon = ncread([path2,name2{1}],'TLONG',[1,179],[inf,18]);
%         tlat = ncread([path2,name2{1}],'TLAT',[1,179],[inf,18]);
        depth = double(ncread([path2,name2{1}],'z_t',1,36))/100;
        %%
        clear date
        time = [];temp = [];uvel = [];wvel = [];
        for i2 = 1:length(name2)
            bin_time = ncread([path2,name2{i2}],'time');
            bin_temp = ncread([path2,name2{i2}],'TEMP',[1,179,1,1],[inf,18,36,1]);% Ctrl
            bin_uvel = ncread([path2,name2{i2}],'UVEL',[1,179,1,1],[inf,18,36,1])/100;% Ctrl
            bin_wvel = ncread([path2,name2{i2}],'WVEL',[1,179,1,1],[inf,18,36,1])/100;% Ctrl
%             bin_temp(bin_temp == 0) = nan;
            
            bin_temp2 = squeeze(mean(bin_temp,2));
            bin_uvel2 = squeeze(mean(bin_uvel,2));
            bin_wvel2 = squeeze(mean(bin_wvel,2));
                       
            time = [time;bin_time];
            temp(:,:,end+1) = bin_temp2;
            uvel(:,:,end+1) = bin_uvel2;
            wvel(:,:,end+1) = bin_wvel2;
            date(i2,1) = str2double(name2{i2}(end-9:end-6));
            date(i2,2) = str2double(name2{i2}(end-4:end-3));
        end
        temp = temp(:,:,2:end);
        uvel = uvel(:,:,2:end);
        wvel = wvel(:,:,2:end);
        time = time - 365;
        %     bnd_time = etime([1949,1,1,0,0,0],[0,1,1,0,0,0])/3600/24;
        %     [date(:,1),date(:,2),date(:,3),~,~,~] = mjd19502date(time-bnd_time);
        
        lon = mean(tlon,2);
        [lon,b] = sort(lon);
        clear sec_temp sec_uvel sec_wvel
        for i = 1:size(temp,2)
            for j = 1:size(temp,3)
                sec_temp(:,i,j) = temp(b,i,j);
                sec_uvel(:,i,j) = uvel(b,i,j);
                sec_wvel(:,i,j) = wvel(b,i,j);
            end
        end
        %%
        readme = 'unit is ¡æ';
        datapath1 = [aimpath1,'Temp_SecEqutor_Monthly_',num2str(date(1,1)),'-',num2str(date(1,2),'%2.2i'),'_to_'...
            ,num2str(date(end,1)),'-',num2str(date(end,2),'%2.2i'),'_',name1{i1},'.mat'];
        save(datapath1,'lon','lat','depth','sec_temp','date','time','readme');
        
        readme = 'unit is m/s';
        datapath2 = [aimpath2,'Vel_SecEqutor_Monthly_',num2str(date(1,1)),'-',num2str(date(1,2),'%2.2i'),'_to_'...
            ,num2str(date(end,1)),'-',num2str(date(end,2),'%2.2i'),'_',name1{i1},'.mat'];
        save(datapath2,'lon','lat','depth','sec_uvel','sec_wvel','date','time','readme');
        i1
    end
    one
end