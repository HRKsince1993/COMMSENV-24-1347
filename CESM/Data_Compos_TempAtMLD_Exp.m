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

    savepath = [aimpath,'Compose_TempAtMLD_Global_Monthly_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-5)]
    
    data1 = load(['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\Compose_zOcnTemp3D_Global_Monthly_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-8),'.mat']);% Temp
    data2 = load(['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\Compose_sMLD_Global_Monthly_2023-03_to_2024-02_Exp_',first_name{one},name1{1}(end-12:end-8),'.mat']);% MLD
    %%
    lon = data1.lon;
    lat = data1.lat;
    depth = data1.depth;
    date = data1.date;
    
    temp = data1.temp_ensamble;
    mld = data2.mld_ensamble;
    
%     fig1 = temp(:,:,1,1);
%     contourf(fig1)
    %%
    temp_mld = nan(size(temp,1),size(temp,2),size(temp,4));
    for i4 = 1:size(temp,4)
        for i1 = 1:size(temp,1)
            for i2 = 1:size(temp,2)
                pro1 = temp(i1,i2,:,i4);
                pro1 = pro1(:);
                
                if sum(isnan(pro1)) == size(temp,3)
                    continue
                end
                
                temp_mld(i1,i2,i4) = interp1(depth,pro1,mld(i1,i2,i4)+5,'linear');% NINO3.4 MLD STD is 11m
            end
        end
    end
    %%
    save([savepath,'.mat'],'lon','lat','date','temp_mld')
end

