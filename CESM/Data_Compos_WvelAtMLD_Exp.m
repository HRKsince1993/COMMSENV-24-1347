clc;clear

for one = 2:8 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
    % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};

    path1 = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\'];
    struct = dir([path1,'*.mat']);
    name1 = {struct.name}';

    aimpath = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\'];
    if exist(aimpath,'dir')~=7
        mkdir(aimpath);
    end

    savepath = [aimpath,'Compose_WvelAtMLD_Global_Monthly_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-5)]
    
    data1 = load(['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\Compose_zOcnWvel3D_Global_Monthly_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-8),'.mat']);% Temp
    data2 = load(['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\Compose_sMLD_Global_Monthly_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-8),'.mat']);% MLD
    %%
    lon = data1.lon;
    lat = data1.lat;
    depth = data1.depth;
    date = data1.date;
    
    wvel = data1.wvel_ensamble;
    mld = data2.mld_ensamble;
    
%     fig1 = wvel(:,:,1,1);
%     contourf(fig1)
    %%
    wvel_mld = nan(size(wvel,1),size(wvel,2),size(wvel,4));
    for i4 = 1:size(wvel,4)
        for i1 = 1:size(wvel,1)
            for i2 = 1:size(wvel,2)
                pro1 = wvel(i1,i2,:,i4);
                pro1 = pro1(:);
                
                if sum(isnan(pro1)) == size(wvel,3)
                    continue
                end
                
                wvel_mld(i1,i2,i4) = interp1(depth,pro1,mld(i1,i2,i4),'linear');
            end
        end
    end
    %%
    readme = data1.readme;
    save([savepath,'.mat'],'lon','lat','date','wvel_mld','readme')
end

