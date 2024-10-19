clc;clear

for one = 1:10 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
              % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};
    
    path1 = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\Taux_Casely_Daily\'];
    struct = dir([path1,'*.mat']);
    name1 = {struct.name}';
    
    if length(name1) < 8
        'error'
        one
    end
    
    data1 = load('F:\2023PMM_Work\bin_data\Taux_March_Liu_Daily_SSTGrid.mat');
    taux_march = data1.taux_march;
    size(taux_march)
    
    lon_box = [160,360-150];% Nino4
    lat_box = [-5,5];
    %%
    for i1 = 1:length(name1)
        aimpath = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\TauxA_Casely_Daily\'];
        if exist(aimpath,'dir')~=7
            mkdir(aimpath);
        end
        
        load([path1,name1{i1}]);
        
        tauxa = nan(size(taux));
        for i2 = 1:size(taux,3)
            tauxa(:,:,i2) = taux(:,:,i2) - taux_march(:,:,i2);
        end
        
        clear nino4
        a = data1.lon >= lon_box(1) & data1.lon <= lon_box(2);
        b = data1.lat >= lat_box(1) & data1.lat <= lat_box(2);
        nino4 = nanmean(nanmean(tauxa(a,b,:),1),2);nino4 = nino4(:);
        
        % figure
        % plot(nino34)
        %%
        datapath = [aimpath,name1{i1}(1:3),'A',name1{i1}(4:end)];
        save(datapath,'date','lon','lat','tauxa','nino4','readme','time');
    end
end