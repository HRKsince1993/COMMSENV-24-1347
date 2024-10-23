clc;clear

for one = 1:10 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
              % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};
    
    path1 = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\SST_Casely\'];
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
        aimpath = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\SSTA_Casely\'];
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