clc;clear

data_sst = load('G:\ENSO_work\Data_ENSO\SST_Global_Monthly_1940to2022.mat');
lon = data_sst.lon;
lat = data_sst.lat;
[lon_grid,lat_grid] = meshgrid(lon,lat);

for one = 39:40;% 1;Ctrl;2:NTA;3:PMM;4:TIO;5:TroPac:6£ºTPCtrl;7:NTA15;8:NTA30;9:AtlNino;10:NoWNP;11:NoPMM;12:NTAandTIO;13:TroPacNTA;14:PMMandNTA;15:TPCtrlG;16:SEP;
    % 17:NTAandTIOandSEP;18:NTAandTIOandPMMandSEP;19:NTAandTIOLgandPMMandSEP;20:TO;21:NTAandTIOandPMMandSEPandWNP;22:NTAandTIOandEP;23:NTAandTIOandPMMandSEP_New
    % 24:NTAandTIOandEPandWWB;25:NTAandTIOandPMMandSEPandWWB;26:NTAandTIOandSEPlg;27:NTAandTIOandSEPandWWB;28:NTAandTIOandSEPandWWBmay;29:TIOlg;30:NTAlg;
    % 31:NTAandTIOandSEPandWWBb;32:NTAandTIOandSEPandWWBbmay;33:PMMsmall;34:NTAandTIOandPMMandSEPlg;35:NETPCli;36:NTAandTIOandPMMandSEPandWWBb;
    % 37:NTAandTIOandPMMandSEPandWWBbmay;38:CESM_TP;39:NTAandTIOandPMMandSEPandWWBOctNov;40:TPCtrlNoWWB2
    first_name = {'Ctrl','NTA','PMM','TIO','TroPac','TPCtrl','NTA15','NTA30','AtlNino','NoWNP','NoPMM','NTAandTIO','TroPacNTA','PMMandNTA','TPCtrlG','SEP'...
        ,'NTAandTIOandSEP','NTAandTIOandPMMandSEP','NTAandTIOLgandPMMandSEP','TO','NTAandTIOandPMMandSEPandWNP','NTAandTIOandEP','NTAandTIOandPMMandSEP_New'...
        ,'NTAandTIOandEPandWWB','NTAandTIOandPMMandSEPandWWB','NTAandTIOandSEPlg','NTAandTIOandSEPandWWB','NTAandTIOandSEPandWWBmay','TIOlg','NTAlg'...
        ,'NTAandTIOandSEPandWWBb','NTAandTIOandSEPandWWBbmay','PMMsmall','NTAandTIOandPMMandSEPlg','NETPCli','NTAandTIOandPMMandSEPandWWBb'...
        ,'NTAandTIOandPMMandSEPandWWBbmay','CESM_TP','NTAandTIOandPMMandSEPandWWBOctNov','TPCtrlNoWWB2'};
    
    readme = 'unit is N/m2';
    path1 = ['H:\CESM\Output_Data\HRK_2023ENSO_Ensamble\Exp_',first_name{one},'\'];
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
        aimpath1 = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\Taux_Casely_Daily\'];
        aimpath2 = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\Tauy_Casely_Daily\'];
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