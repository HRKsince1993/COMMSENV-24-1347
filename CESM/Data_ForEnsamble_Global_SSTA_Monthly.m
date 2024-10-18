clc;clear

for one = 41:41;% 1;Ctrl;2:NTA;3:PMM;4:TIO;5:TroPac:6£ºTPCtrl;7:NTA15;8:NTA30;9:AtlNino;10:NoWNP;11:NoPMM;12:NTAandTIO;13:TroPacNTA;14:PMMandNTA;15:TPCtrlG;16:SEP;
    % 17:NTAandTIOandSEP;18:NTAandTIOandPMMandSEP;19:NTAandTIOLgandPMMandSEP;20:TO;21:NTAandTIOandPMMandSEPandWNP;22:NTAandTIOandEP;23:NTAandTIOandPMMandSEP_New
    % 24:NTAandTIOandEPandWWB;25:NTAandTIOandPMMandSEPandWWB;26:NTAandTIOandSEPlg;27:NTAandTIOandSEPandWWB;28:NTAandTIOandSEPandWWBmay;29:TIOlg;30:NTAlg;
    % 31:NTAandTIOandSEPandWWBb;32:NTAandTIOandSEPandWWBbmay;33:PMMsmall;34:NTAandTIOandPMMandSEPlg;35:NETPCli;36:NTAandTIOandPMMandSEPandWWBb;
    % 37:NTAandTIOandPMMandSEPandWWBbmay;38:CESM_TP;39:NTAandTIOandPMMandSEPandWWBOctNov;40:TPCtrlNoWWB2;41:TPCtrlNoWWBolar
    first_name = {'Ctrl','NTA','PMM','TIO','TroPac','TPCtrl','NTA15','NTA30','AtlNino','NoWNP','NoPMM','NTAandTIO','TroPacNTA','PMMandNTA','TPCtrlG','SEP'...
        ,'NTAandTIOandSEP','NTAandTIOandPMMandSEP','NTAandTIOLgandPMMandSEP','TO','NTAandTIOandPMMandSEPandWNP','NTAandTIOandEP','NTAandTIOandPMMandSEP_New'...
        ,'NTAandTIOandEPandWWB','NTAandTIOandPMMandSEPandWWB','NTAandTIOandSEPlg','NTAandTIOandSEPandWWB','NTAandTIOandSEPandWWBmay','TIOlg','NTAlg'...
        ,'NTAandTIOandSEPandWWBb','NTAandTIOandSEPandWWBbmay','PMMsmall','NTAandTIOandPMMandSEPlg','NETPCli','NTAandTIOandPMMandSEPandWWBb'...
        ,'NTAandTIOandPMMandSEPandWWBbmay','CESM_TP','NTAandTIOandPMMandSEPandWWBOctNov','TPCtrlNoWWB2','TPCtrlNoWWBolar'};
    
    path1 = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\SST_Casely\'];
    struct = dir([path1,'*.mat']);
    name1 = {struct.name}';
    
    if length(name1) < 8
        'error'
        one
    end
    
    data1 = load('F:\2023PMM_Work\bin_data\SST_March_Liu.mat');
    sst_march = data1.sst_march;
    size(sst_march)
    
    lon_box = [360-170,360-120];% Nino34
    lat_box = [-5,5];
    %%
    for i1 = 1:length(name1)
        aimpath = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\SSTA_Casely\'];
        if exist(aimpath,'dir')~=7
            mkdir(aimpath);
        end
        
        load([path1,name1{i1}]);
        
        ssta = nan(size(sst));
        for i2 = 1:size(sst,3)
            ssta(:,:,i2) = sst(:,:,i2) - sst_march(:,:,i2);
        end
        
        clear nino34
        a = data1.lon >= lon_box(1) & data1.lon <= lon_box(2);
        b = data1.lat >= lat_box(1) & data1.lat <= lat_box(2);
        nino34 = nanmean(nanmean(ssta(a,b,:),1),2);nino34 = nino34(:);
        
        % figure
        % plot(nino34)
        %%
        datapath = [aimpath,name1{i1}(1:3),'A',name1{i1}(4:end)];
        save(datapath,'date','lon','lat','ssta','nino34','readme');
    end
end