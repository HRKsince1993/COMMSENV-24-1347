clc;clear

for one = 1:10 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
              % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};
    
    aimpath = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\'];
    if exist(aimpath,'dir')~=7
        mkdir(aimpath);
    end
    
    path1 = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\OcnVvel3D_Global_Casely\'];
    struct = dir([path1,'*.mat']);
    if one == 0 % CESM-G
        name1 = {struct.name}';
        name1 = cat(1,name1(1:3),name1(5:10),name1(19));
    else
        name1 = {struct(2:end).name}';
    end
    
    load([path1,name1{1}]);
    savepath = [aimpath,'Compose_z',name1{1}(1:end-7),'.mat']
    %%
    clear bin_sst
    for i1 = 1:length(name1)
        data1 = load([path1,name1{i1}]);
        bin_sst(:,:,:,:,i1) = data1.vvel;
    end
    vvel_ensemble = mean(bin_sst,5);
    
%     k = 1;
%     contourf(lon,lat,mld_ensemble(:,:,k)');
%     colorbar;
    %%
    readme2 = name1;
    save(savepath,'lon','lat','depth','date','vvel_ensemble','readme','readme2');
    clear vvel_ensemble readme
end

