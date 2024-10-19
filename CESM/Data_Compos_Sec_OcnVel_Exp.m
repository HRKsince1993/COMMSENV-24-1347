clc;clear

for one = 1:10 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
              % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};
    
    aimpath = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\'];
    if exist(aimpath,'dir')~=7
        mkdir(aimpath);
    end
    
    path1 = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\OcnVel_Casely\'];
    struct = dir([path1,'*.mat']);
    name1 = {struct(2:end).name}';
    
    load([path1,name1{1}]);
    savepath = [aimpath,'Compose_',name1{1}(1:end-7),'.mat']
    %%
    clear bin_uvel bin_wvel
    for i1 = 1:length(name1)
        data1 = load([path1,name1{i1}]);
        bin_uvel(:,:,:,i1) = data1.sec_uvel;
        bin_wvel(:,:,:,i1) = data1.sec_wvel;
    end
    sec_uvel_ensamble = mean(bin_uvel,4);
    sec_wvel_ensamble = mean(bin_wvel,4);
    %%
    % k = 1;
    % contourf(lon,depth,sec_uvel_ensamble(:,:,k)','levelstep',0.1);
    % hold on
    % colorbar;
    % caxis([-1,1]);
    % hold off
    %%
    readme2 = name1;
    save(savepath,'lon','lat','depth','date','sec_uvel_ensamble','sec_wvel_ensamble','readme','readme2');
end