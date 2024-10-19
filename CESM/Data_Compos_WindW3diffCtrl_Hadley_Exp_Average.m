clc;clear

for one = 5:5 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
              % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};
    
    two = 3;% minus 1:Ctrl;2:TroPac;3:TPCtrl;4:PMM
    second_name = {'Ctrl','TroPac','TPCtrl','PMM'};
    
    first_box_lon = nan(length(first_name),2);
    first_box_lon(5,:) = [40,120];
    
    l_mon = (3:11)-2;% average from 1st month to last month
        
    aimpath = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\'];
    if exist(aimpath,'dir')~=7
        mkdir(aimpath);
    end
    
    path1 = ['J:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\WindW3_Casely\'];
    path2 = ['J:\2023PMM_Work\Data_Ensamble\Exp_',second_name{two},'\WindW3_Casely\'];
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
    savepath = [aimpath,'Compose_',name1{1}(1:6),'diff',second_name{two},'_Hadley',name1{1}(7:end-7)...
        ,'Avr',num2str(l_mon(1)+2),'to',num2str(l_mon(end)+2),'Mon_',num2str(first_box_lon(one,1)),'to',num2str(first_box_lon(one,2)),'Lon.mat']
    load([path1,name1{1}]);
    readme = 'Vertical velocity (pressure). Lon*Lev*Time. Velocity unit is Pa/s. Lev unit is level.';

    clear bin_sst bin_sst_tp
    lon_l = lon >= first_box_lon(one,1) & lon <= first_box_lon(one,2);
    for i1 = 1:length(name1)
        data1 = load([path1,name1{i1}]);
        data2 = load([path2,name2{i1}]);
        bin_sst(:,:,:,i1) = squeeze(nanmean(data1.wvel(lon_l,:,:,:),1));
        bin_sst_tp(:,:,:,i1) = squeeze(nanmean(data2.wvel(lon_l,:,:,:),1));
    end
    bin_ssta = bin_sst - bin_sst_tp;
    %%
    wvela_ensamble = mean(mean(bin_ssta(:,:,l_mon,:),4),3);
    bin2_ssta = squeeze(mean(bin_ssta(:,:,l_mon,:),3));
      
    clear t_wvela_ensamble p_wvela_ensamble hh1 pp1 h1 p1
        for i2 = 1:size(bin2_ssta,1)
            for i3 = 1:size(bin2_ssta,2)
                pro = bin2_ssta(i2,i3,:);
                pro = pro(:);
                if sum(isnan(pro)) == length(pro) || sum(pro==0) == length(pro)
                    hh1(i2,i3)=nan;
                    pp1(i2,i3)=nan;
                    continue
                end
                [h1,p1,ci1]=ttest(pro,0);
                hh1(i2,i3)=h1;
                pp1(i2,i3)=p1;
            end
        end
        t_wvela_ensamble = hh1;
        p_wvela_ensamble = pp1;
    %%
%     k = 1;
%     contourf(lon,lat,wvela_ensamble(:,:,k)');
%     colorbar;
    %%
    save(savepath,'lat','lev','date','wvela_ensamble','readme','t_wvela_ensamble','p_wvela_ensamble');
    clear wvela_ensamble readme t_wvela_ensamble p_wvela_ensamble
end