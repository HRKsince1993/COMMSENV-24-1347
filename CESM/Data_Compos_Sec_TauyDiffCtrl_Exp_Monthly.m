clc;clear

for one = 3:7 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
              % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};
    
    two = 3;% minus 1:Ctrl;2:TroPac;3:TPCtrl;4:PMM
    three = 1;% minus 1:one by one case;2:ensamble cases
    second_name = {'Ctrl','TroPac','TPCtrl','PMM'};
    
    lon_box = [0,360];
    lat_box = [-5,5];
    
    aimpath = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\'];
    if exist(aimpath,'dir')~=7
        mkdir(aimpath);
    end
    
    path1 = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\Tauy_Casely\'];
    path2 = ['F:\2023PMM_Work\Data_Ensemble\Exp_',second_name{two},'\Tauy_Casely\'];
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
    savepath = [aimpath,'Compose_Sec',name1{1}(1:4),'Diff',second_name{two},'_SecEquator',name1{1}(12:end-7),'.mat']
    
    load([path1,name1{1}]);
    
    clear bin_sst bin_sst_tp
    for i1 = 1:length(name1)
        data1 = load([path1,name1{i1}]);
        data2 = load([path2,name2{i1}]);
        bin_sst(:,:,:,i1) = data1.tauy;
        bin_sst_tp(:,:,:,i1) = data2.tauy;
    end
    
    size(bin_sst)
    %%
    clear bin_ssta
    switch three
        case 1
            bin_ssta = bin_sst - bin_sst_tp;
            readme = 'minus one by one case';
        case 2
            bin_sst_tp_month = mean(bin_sst_tp,4);
            for i1 = 1:size(bin_sst,3)
                bin_ssta(:,:,i1) =  bin_sst(:,:,i1) - bin_sst_tp_month(:,:,i1);
            end
            readme = 'minus ensamble case';
    end
    
    b1 = lat >= lat_box(1) & lat <= lat_box(2);
    bin2_ssta = squeeze(nanmean(bin_ssta(:,b1,:,:),2));
    ssta_ensemble = squeeze(mean(bin2_ssta,3));
    
    size(bin2_ssta)
    size(ssta_ensemble)
    %%
    clear t_ssta_ensemble p_ssta_ensemble hh1 pp1
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
    t_ssta_ensemble = hh1;
    p_ssta_ensemble = pp1;
    %%
    % k = 1;
    % contourf(lon,lat,ssta_ensemble(:,:,k)','levelstep',2);
    % hold on
    % colorbar;
    % caxis([-5,35]);
    % hold off
    %%
    tauya_ensemble = ssta_ensemble;
    t_tauya_ensemble = t_ssta_ensemble;
    p_tauya_ensemble = p_ssta_ensemble;
    readme2 = name1;
    save(savepath,'lon','lat','date','tauya_ensemble','t_tauya_ensemble','p_tauya_ensemble','readme','readme2','lon_box','lat_box');
    clear ssta_ensemble t_ssta_ensemble p_ssta_ensemble
end