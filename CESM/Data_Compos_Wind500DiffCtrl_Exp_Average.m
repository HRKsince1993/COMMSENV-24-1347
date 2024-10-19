clc;clear

for one = 3:8 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
              % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};
    
    two = 3;% minus 1:Ctrl;2:TroPac;3:TPCtrl;4:PMM
    three = 2;% 1:200hPa;2:500hPa;
    second_name = {'Ctrl','TroPac','TPCtrl','PMM'};
    third_name = {'200','500'};% lev, hPa
    third_num1 = [13,19];% lev, hPa
    
    l_mon = (3:11)-2;% average from 1st month to last month
        
    aimpath = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\'];
    if exist(aimpath,'dir')~=7
        mkdir(aimpath);
    end
    
    path1a = ['J:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\WindU3_Casely\'];
    path1b = ['J:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\WindV3_Casely\'];
    path1c = ['J:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\WindW3_Casely\'];
    path2a = ['J:\2023PMM_Work\Data_Ensamble\Exp_',second_name{two},'\WindU3_Casely\'];
    path2b = ['J:\2023PMM_Work\Data_Ensamble\Exp_',second_name{two},'\WindV3_Casely\'];
    path2c = ['J:\2023PMM_Work\Data_Ensamble\Exp_',second_name{two},'\WindW3_Casely\'];
    
    struct = dir([path1a,'*.mat']);
    if one == 0 % CESM-G
        name1a = {struct.name}';
        name1a = cat(1,name1a(1:3),name1a(5:10),name1a(19));
    else
        name1a = {struct(2:end).name}';
    end
    
    struct = dir([path1b,'*.mat']);
    if one == 0 % CESM-G
        name1b = {struct.name}';
        name1b = cat(1,name1b(1:3),name1b(5:10),name1b(19));
    else
        name1b = {struct(2:end).name}';
    end
    
    struct = dir([path1c,'*.mat']);
    if one == 0 % CESM-G
        name1c = {struct.name}';
        name1c = cat(1,name1c(1:3),name1c(5:10),name1c(19));
    else
        name1c = {struct(2:end).name}';
    end
    
    struct2 = dir([path2a,'*.mat']);name2a = {struct2(2:end).name}';
    struct2 = dir([path2b,'*.mat']);name2b = {struct2(2:end).name}';
    struct2 = dir([path2c,'*.mat']);name2c = {struct2(2:end).name}';
    if length(name1a) ~= 10 || length(name2a) ~= 10
        'error'
    end
    
    savepath = [aimpath,'Compose_',name1a{1}(1:4),third_name{three},'hPa_diff',second_name{two},name1a{1}(7:end-7),'Avr',num2str(l_mon(1)+2),'to',num2str(l_mon(end)+2),'Mon.mat']
    load([path1a,name1a{1}]);
    readme = [third_name{three},'hPa wind speed. Lon*Lat*Time. U and V velocity unit are m/s. W velocity unit is Pa/s. Lev unit is level, num ',num2str(third_num1(three)),' about ',num2str(floor(lev(third_num1(three))),'%2.3i'),'hPa']
    %%
    clear bin_uvel bin_vvel bin_wvel bin_uvel_tp bin_vvel_tp bin_wvel_tp
    for i1 = 1:length(name1a)
        data1a = load([path1a,name1a{i1}]);
        data1b = load([path1b,name1b{i1}]);
        data1c = load([path1c,name1c{i1}]);
        data2a = load([path2a,name2a{i1}]);
        data2b = load([path2b,name2b{i1}]);
        data2c = load([path2c,name2c{i1}]);
        bin_uvel(:,:,:,i1) = squeeze(data1a.uvel(:,:,third_num1(three),:));% 192hPa
        bin_vvel(:,:,:,i1) = squeeze(data1b.vvel(:,:,third_num1(three),:));
        bin_wvel(:,:,:,i1) = squeeze(data1c.wvel(:,:,third_num1(three),:));
        bin_uvel_tp(:,:,:,i1) = squeeze(data2a.uvel(:,:,third_num1(three),:));
        bin_vvel_tp(:,:,:,i1) = squeeze(data2b.vvel(:,:,third_num1(three),:));
        bin_wvel_tp(:,:,:,i1) = squeeze(data2c.wvel(:,:,third_num1(three),:));
    end
    bin_uvela = bin_uvel - bin_uvel_tp;
    bin_vvela = bin_vvel - bin_vvel_tp;
    bin_wvela = bin_wvel - bin_wvel_tp;
    uvela_ensamble = mean(mean(bin_uvela(:,:,l_mon,:),4),3);
    vvela_ensamble = mean(mean(bin_vvela(:,:,l_mon,:),4),3);
    wvela_ensamble = mean(mean(bin_wvela(:,:,l_mon,:),4),3);
    bin2_uvela = squeeze(mean(bin_uvela(:,:,l_mon,:),3));
    bin2_vvela = squeeze(mean(bin_vvela(:,:,l_mon,:),3));
    bin2_wvela = squeeze(mean(bin_wvela(:,:,l_mon,:),3));
    %%
    clear t_uvela_ensamble p_uvela_ensamble t_vvela_ensamble p_vvela_ensamble t_wvela_ensamble p_wvela_ensamble hh1 hh2 hh3 pp1 pp2 pp3
        for i2 = 1:size(bin2_uvela,1)
            for i3 = 1:size(bin2_uvela,2)
                pro_u = bin2_uvela(i2,i3,:);
                pro_v = bin2_vvela(i2,i3,:);
                pro_w = bin2_wvela(i2,i3,:);
                pro_u = pro_u(:);
                pro_v = pro_v(:);
                pro_w = pro_w(:);
                if sum(isnan(pro_u)) == length(pro_u) || sum(pro_u==0) == length(pro_u)
                    hh1(i2,i3)=nan;
                    pp1(i2,i3)=nan;
                    hh2(i2,i3)=nan;
                    pp2(i2,i3)=nan;
                    hh3(i2,i3)=nan;
                    pp3(i2,i3)=nan;
                    continue
                end
                [h1,p1,ci1]=ttest(pro_u,0);
                [h2,p2,ci2]=ttest(pro_v,0);
                [h3,p3,ci3]=ttest(pro_w,0);
                hh1(i2,i3)=h1;
                pp1(i2,i3)=p1;
                hh2(i2,i3)=h2;
                pp2(i2,i3)=p2;
                hh3(i2,i3)=h3;
                pp3(i2,i3)=p3;
            end
        end
        t_uvela_ensamble = hh1;
        p_uvela_ensamble = pp1;
        t_vvela_ensamble = hh2;
        p_vvela_ensamble = pp2;
        t_wvela_ensamble = hh3;
        p_wvela_ensamble = pp3;
    %%
    % k = 1;
    % contourf(lon,lat,uvela_ensamble(:,:,k)');
    % colorbar;
    % % caxis([-1.5,1.5]);
    %%
    readme2 = name1a;
    save(savepath,'lon','lat','date','uvela_ensamble','vvela_ensamble','wvela_ensamble','t_uvela_ensamble','t_vvela_ensamble','t_wvela_ensamble','p_uvela_ensamble','p_vvela_ensamble','p_wvela_ensamble','readme','readme2');
    clear uvela_ensamble vvela_ensamble wvela_ensamble t_uvela_ensamble t_vvela_ensamble t_wvela_ensamble p_uvela_ensamble p_vvela_ensamble p_wvela_ensamble readme
end