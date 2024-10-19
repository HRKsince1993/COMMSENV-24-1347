clc;clear

for one = 1:10 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
              % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};
    
    two = 3;% minus 1:Ctrl;2:TroPac;3:TPCtrl;4:PMM
    second_name = {'Ctrl','TroPac','TPCtrl','PMM'};
    
    aimpath = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\'];
    if exist(aimpath,'dir')~=7
        mkdir(aimpath);
    end
    
    path1 = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\Wind_Casely\'];
    path2 = ['F:\2023PMM_Work\Data_Ensamble\Exp_',second_name{two},'\Wind_Casely\'];
    struct = dir([path1,'*.mat']);
    if one == 0 % CESM-G
        name1 = {struct.name}';
        name1 = cat(1,name1(1:3),name1(5:10),name1(19));
    else
        name1 = {struct(2:end).name}';
    end
    struct2 = dir([path2,'*.mat']);
    name2 = {struct2(2:end).name}';
    if length(name1) ~= 10 || length(name2) ~= 10
        'error'
    end
    
    savepath = [aimpath,'Compose_',name1{1}(1:4),'_diff',second_name{two},name1{1}(5:end-7),'.mat']
    load([path1,name1{1}]);
    
    clear bin_uvel bin_vvel bin_uvel_tp bin_vvel_tp
    for i1 = 1:length(name1)
        data1 = load([path1,name1{i1}]);
        data2 = load([path2,name2{i1}]);
        bin_uvel(:,:,:,i1) = data1.uvel;
        bin_vvel(:,:,:,i1) = data1.vvel;
        bin_uvel_tp(:,:,:,i1) = data2.uvel;
        bin_vvel_tp(:,:,:,i1) = data2.vvel;
    end
    bin_uvela = bin_uvel - bin_uvel_tp;
    bin_vvela = bin_vvel - bin_vvel_tp;
    uvela_ensamble = mean(bin_uvela,4);
    vvela_ensamble = mean(bin_vvela,4);
    
    clear t_uvela_ensamble p_uvela_ensamble  t_vvela_ensamble p_vvela_ensamble hh1 hh2 pp1 pp2
    for i1 = 1:size(bin_uvela,3)
        for i2 = 1:size(bin_uvela,1)
            for i3 = 1:size(bin_uvela,2)
                pro_u = bin_uvela(i2,i3,i1,:);
                pro_v = bin_vvela(i2,i3,i1,:);
                pro_u = pro_u(:);
                pro_v = pro_v(:);
                if sum(isnan(pro_u)) == length(pro_u) || sum(pro_u==0) == length(pro_u)
                    hh1(i2,i3)=nan;
                    pp1(i2,i3)=nan;
                    hh2(i2,i3)=nan;
                    pp2(i2,i3)=nan;
                    continue
                end
                [h1,p1,ci1]=ttest(pro_u,0);
                [h2,p2,ci2]=ttest(pro_v,0);
                hh1(i2,i3)=h1;
                pp1(i2,i3)=p1;
                hh2(i2,i3)=h2;
                pp2(i2,i3)=p2;
            end
        end
        t_uvela_ensamble(:,:,i1) = hh1;
        p_uvela_ensamble(:,:,i1) = pp1;
        t_vvela_ensamble(:,:,i1) = hh2;
        p_vvela_ensamble(:,:,i1) = pp2;
    end
    %%
    % k = 1;
    % contourf(lon,lat,uvela_ensamble(:,:,k)');
    % colorbar;
    % % caxis([-1.5,1.5]);
    %%
    readme2 = name1;
    save(savepath,'lon','lat','date','uvela_ensamble','vvela_ensamble','t_uvela_ensamble','t_vvela_ensamble','p_uvela_ensamble','p_vvela_ensamble','readme2');
    clear uvela_ensamble vvela_ensamble t_uvela_ensamble t_vvela_ensamble p_uvela_ensamble p_vvela_ensamble readme
end