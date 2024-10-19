clc;clear

for one = 2:8 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
    % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};
    
    path1 = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\OcnUvel3D_Global_Casely\'];
    struct = dir([path1,'*.mat']);
    name1 = {struct.name}';
    
    path2 = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\sMLD_Casely\'];
    struct = dir([path2,'*.mat']);
    name2 = {struct.name}';
    
    aimpath = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\UvelAtMLD_Casely\'];
    if exist(aimpath,'dir')~=7
        mkdir(aimpath);
    end
    %%
    data1 = load([path1,name1{1}]);
    lon = data1.lon;
    lat = data1.lat;
    depth = data1.depth;
    date = data1.date;
    readme = data1.readme;
    %%
    for i5 = 1:length(name1)
        data1 = load([path1,name1{i5}]);% wvel
        data2 = load([path2,name2{i5}]);% MLD
        
        uvel = data1.uvel;
        mld = data2.mld;
        
%         fig1 = temp(:,:,1,1);
%         contourf(fig1)
        %%
        uvel_mld = nan(size(uvel,1),size(uvel,2),size(uvel,4));
        for i4 = 1:size(uvel,4)
            for i1 = 1:size(uvel,1)
                for i2 = 1:size(uvel,2)
                    pro1 = uvel(i1,i2,:,i4);
                    pro1 = pro1(:);
                    
                    if sum(isnan(pro1)) == size(uvel,3)
                        continue
                    end
                    
                    uvel_mld(i1,i2,i4) = interp1(depth,pro1,mld(i1,i2,i4),'linear');
                end
            end
        end
        %%
        savepath = [aimpath,'UvelAtMLD',name1{i5}(10:end)];
        save(savepath,'lon','lat','date','uvel_mld','readme')
        clear uvel_mld
    end
end

