clc;clear

for one = 1:10 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
              % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};
    
    aimpath = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\'];
    if exist(aimpath,'dir')~=7
        mkdir(aimpath);
    end
    
    path1 = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\TauxA_Casely_Daily\'];
    struct = dir([path1,'*.mat']);
    if one == 0 % CESM-G
        name1 = {struct.name}';
        name1 = cat(1,name1(1:3),name1(5:10),name1(19));
    else
        name1 = {struct(2:end).name}';
    end
    
    load([path1,name1{1}]);
    savepath = [aimpath,'Compose_',name1{1}(1:end-7),'.mat']
    %%
    clear bin_uvel;
    for i1 = 1:length(name1)
        data1 = load([path1,name1{i1}]);
        bin_uvel(:,:,:,i1) = data1.tauxa;
    end
    tauxa_ensamble = mean(bin_uvel,4);
    %
    clear t_tauxa_ensamble p_tauxa_ensamble
    for i1 = 1:size(bin_uvel,3)
        for i2 = 1:size(bin_uvel,1)
            for i3 = 1:size(bin_uvel,2)
                pro_u = bin_uvel(i2,i3,i1,:);
                pro_u = pro_u(:);
                if sum(isnan(pro_u)) == length(pro_u) || sum(pro_u==0) == length(pro_u)
                    hh1(i2,i3)=nan;
                    pp1(i2,i3)=nan;
                    continue
                end
                [h1,p1,ci1]=ttest(pro_u,0);
                hh1(i2,i3)=h1;
                pp1(i2,i3)=p1;
            end
        end
        t_tauxa_ensamble(:,:,i1) = hh1;
        p_tauxa_ensamble(:,:,i1) = pp1;
    end
    %%
    % k = 1;
    % contourf(lon,lat,uvel_ensamble(:,:,k)');
    % colorbar;
    % caxis([-1.5,1.5]);
    %%
    readme2 = name1;
    % save(savepath,'lon','lat','date','uvel_ensamble','vvel_ensamble','readme','t_uvel_ensamble','t_vvel_ensamble','p_uvel_ensamble','p_vvel_ensamble','readme2');
    save(savepath,'lon','lat','date','tauxa_ensamble','t_tauxa_ensamble','p_tauxa_ensamble','readme','readme2');
    clear  tauxa_ensamble t_tauxa_ensamble p_tauxa_ensamble
end