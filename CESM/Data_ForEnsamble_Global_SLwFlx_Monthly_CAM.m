clc;clear

data_sst = load('G:\ENSO_work\Data_ENSO\SST_Global_Monthly_1940to2022.mat');
lon = data_sst.lon;
lat = data_sst.lat;
[lon_grid,lat_grid] = meshgrid(lon,lat);
clear data_sst

one = 2;
%%
for one = 1:10 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
              % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};
        
    % 1;Ctrl;2:NTA;3:PMM;4:TIO;5:TroPac:6£ºTPCtrl;7:NTA15;8:NTA30;9:AtlNino;10:NoWNP;11:NoPMM;12:NTAandTIO;13:TroPacNTA;14:PMMandNTA;15:TPCtrlG;16:SEP;
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
    readme = 'Net longwave flux at surface,unit:W/m2';
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
        aimpath = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\SLwFlx_Casely\'];
        if exist(aimpath,'dir')~=7
            mkdir(aimpath);
        end
        
        tlon = ncread([path2,name2{1}],'lon');
        tlat = ncread([path2,name2{1}],'lat');
        %%
        date = [];  uvel = [];
        for i2 = 1:length(name2)
            bin_wind = double(ncread([path2,name2{i2}],'FLNS'));
            bin_uvel = griddata(tlon,tlat,bin_wind',lon_grid,lat_grid,'linear')';
            uvel(:,:,i2) = bin_uvel;
            
            date(i2,1) = str2double(name2{i2}(end-9:end-6));
            date(i2,2) = str2double(name2{i2}(end-4:end-3));
        end
        slwflx = uvel;
        %%
        datapath = [aimpath,'SLwFlx_Global_Monthly_',num2str(date(1,1)),'-',num2str(date(1,2),'%2.2i'),'_to_'...
            ,num2str(date(end,1)),'-',num2str(date(end,2),'%2.2i'),'_',name1{i1},'_CAM.mat'];
        save(datapath,'lon','lat','slwflx','date','readme');
        i1
    end
end