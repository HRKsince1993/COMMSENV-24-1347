clc;clear

for one = 1:10 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
              % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};
    
    path1 = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\Tauy_Casely\'];
    struct = dir([path1,'*.mat']);
    name1 = {struct.name}';
    
    if length(name1) < 8
        'error'
        one
    end
    
    data1 = load('F:\2023PMM_Work\bin_data\Tauy_March_Liu_SSTGrid.mat');
    tauy_march = data1.tauy_march;
    size(tauy_march)
    
    lon_box = [160,360-150];% Nino4
    lat_box = [-5,5];
    %%
    for i1 = 1:length(name1)
        aimpath = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\TauyA_Casely\'];
        if exist(aimpath,'dir')~=7
            mkdir(aimpath);
        end
        
        load([path1,name1{i1}]);
        
        tauya = nan(size(tauy));
        for i2 = 1:size(tauy,3)
            tauya(:,:,i2) = tauy(:,:,i2) - tauy_march(:,:,i2);
        end
        
        clear nino4
        a = data1.lon >= lon_box(1) & data1.lon <= lon_box(2);
        b = data1.lat >= lat_box(1) & data1.lat <= lat_box(2);
        nino4 = nanmean(nanmean(tauya(a,b,:),1),2);nino4 = nino4(:);
        
        % figure
        % plot(nino34)
        %%
        datapath = [aimpath,name1{i1}(1:3),'A',name1{i1}(4:end)];
        save(datapath,'date','lon','lat','tauya','nino4','readme');
    end
end