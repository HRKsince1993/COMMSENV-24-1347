clc;clear

data_sst = load('G:\ENSO_work\Data_ENSO\SST_Global_Monthly_1940to2022.mat');
lon = data_sst.lon;
lat = data_sst.lat;
[lon_grid,lat_grid] = meshgrid(lon,lat);
clear data_sst

one = 3;
%%
for one = 2:10 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
              % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};
    
    % 1;Ctrl;2:NTA;3:PMM;4:TIO;5:TroPac:6£∫TPCtrl;7:NTA15;8:NTA30;9:AtlNino;10:NoWNP;11:NoPMM;12:NTAandTIO;13:TroPacNTA;14:PMMandNTA;15:TPCtrlG;16:SEP;
    % 17:NTAandTIOandSEP;18:NTAandTIOandPMMandSEP;19:NTAandTIOLgandPMMandSEP;20:TO;21:NTAandTIOandPMMandSEPandWNP;22:NTAandTIOandEP;23:NTAandTIOandPMMandSEP_New
    % 24:NTAandTIOandEPandWWB;25:NTAandTIOandPMMandSEPandWWB;26:NTAandTIOandSEPlg;27:NTAandTIOandSEPandWWB;28:NTAandTIOandSEPandWWBmay;29:TIOlg;30:NTAlg;
    % 31:NTAandTIOandSEPandWWBb;32:NTAandTIOandSEPandWWBbmay;33:PMMsmall;34:NTAandTIOandPMMandSEPlg;35:NETPCli;36:NTAandTIOandPMMandSEPandWWBb;
    % 37:NTAandTIOandPMMandSEPandWWBbmay;38:CESM_TP;39:NTAandTIOandPMMandSEPandWWBOctNov;40:TPCtrlNoWWB2
%     first_name = {'Ctrl','NTA','PMM','TIO','TroPac','TPCtrl','NTA15','NTA30','AtlNino','NoWNP','NoPMM','NTAandTIO','TroPacNTA','PMMandNTA','TPCtrlG','SEP'...
%         ,'NTAandTIOandSEP','NTAandTIOandPMMandSEP','NTAandTIOLgandPMMandSEP','TO','NTAandTIOandPMMandSEPandWNP','NTAandTIOandEP','NTAandTIOandPMMandSEP_New'...
%         ,'NTAandTIOandEPandWWB','NTAandTIOandPMMandSEPandWWB','NTAandTIOandSEPlg','NTAandTIOandSEPandWWB','NTAandTIOandSEPandWWBmay','TIOlg','NTAlg'...
%         ,'NTAandTIOandSEPandWWBb','NTAandTIOandSEPandWWBbmay','PMMsmall','NTAandTIOandPMMandSEPlg','NETPCli','NTAandTIOandPMMandSEPandWWBb'...
%         ,'NTAandTIOandPMMandSEPandWWBbmay','CESM_TP','NTAandTIOandPMMandSEPandWWBOctNov','TPCtrlNoWWB2'};
    
    path1 = ['J:\CESM\Output_Data\HRK_2023ENSO_Ensamble\Exp_',first_name{one},'\'];
    struct = dir(path1);
    name1 = {struct(3:end).name}';
    
    i1 = 1;
    i2 = 1;
    %%
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
        aimpath2 = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\OcnTemp3D_Global_Casely\'];
        if exist(aimpath2,'dir')~=7
            mkdir(aimpath2);
        end
        
        tlon = ncread([path2,name2{1}],'TLONG');
        tlat = ncread([path2,name2{1}],'TLAT');
        depth = double(ncread([path2,name2{1}],'z_t',1,16))/100;
        %%
        clear date
        time = [];temp = [];
        for i2 = 1:length(name2)
            bin_time = ncread([path2,name2{i2}],'time');
            bin_temp = ncread([path2,name2{i2}],'TEMP',[1,1,1,1],[inf,inf,16,1]);% Ctrl
            bin_temp(bin_temp == 0) = nan;
            
            clear bin_temp2
            for i3 = 1:size(bin_temp,3)
                bin_temp2(:,:,i3) = griddata(tlon,tlat,bin_temp(:,:,i3),lon_grid,lat_grid,'linear')';
            end
            
            time = [time;bin_time];
            temp(:,:,:,i2) = bin_temp2;
            date(i2,1) = str2double(name2{i2}(end-9:end-6));
            date(i2,2) = str2double(name2{i2}(end-4:end-3));
        end
        time = time - 365;
        %     bnd_time = etime([1949,1,1,0,0,0],[0,1,1,0,0,0])/3600/24;
        %     [date(:,1),date(:,2),date(:,3),~,~,~] = mjd19502date(time-bnd_time)
        %%
        readme = 'unit is °„C';
        datapath2 = [aimpath2,'OcnTemp3D_Global_Monthly_',num2str(date(1,1)),'-',num2str(date(1,2),'%2.2i'),'_to_'...
            ,num2str(date(end,1)),'-',num2str(date(end,2),'%2.2i'),'_',name1{i1},'.mat'];
        save(datapath2,'lon','lat','depth','temp','date','time','readme');
        clear date temp time
        one
        i1
    end
end