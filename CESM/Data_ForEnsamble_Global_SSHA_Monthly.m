clc;clear

for one = 1:10 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
              % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};
    
    path1 = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\SSH_Casely\'];
    struct = dir([path1,'*.mat']);
    name1 = {struct.name}';
    
    if length(name1) < 8
        'error'
        one
    end
    
    data1 = load('F:\2023PMM_Work\bin_data\SSH_March_Liu_SSTGrid.mat');
    ssh_march = data1.ssh_march;
    size(ssh_march)
    %%
    for i1 = 1:length(name1)
        aimpath = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\SSHA_Casely\'];
        if exist(aimpath,'dir')~=7
            mkdir(aimpath);
        end
        
        load([path1,name1{i1}]);
        
        ssha = nan(size(ssh));
        for i2 = 1:size(ssh,3)
            ssha(:,:,i2) = ssh(:,:,i2) - ssh_march(:,:,i2);
        end
        
        % figure
        % plot(nino34)
        %%
        datapath = [aimpath,name1{i1}(1:3),'A',name1{i1}(4:end)];
        save(datapath,'date','lon','lat','ssha','readme');
    end
    one
end