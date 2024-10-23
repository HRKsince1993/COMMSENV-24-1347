clc;clear

for one = 3:10 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
              % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};
    
    two = 3;% minus 1:Ctrl;2:TroPac;3:TPCtrl;4:PMM
    second_name = {'Ctrl','TroPac','TPCtrl','PMM'};
    
    lon_box = [0,360];
    lat_box = [-5,5];
    
    aimpath = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\'];
    if exist(aimpath,'dir')~=7
        mkdir(aimpath);
    end
    
    path1 = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\OcnUvel3D_Global_Casely\'];
    path2 = ['F:\2023PMM_Work\Data_Ensemble\Exp_',second_name{two},'\OcnUvel3D_Global_Casely\'];
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
    savepath = [aimpath,'Compose_Sec',name1{1}(1:7),'Diff',second_name{two},'_SecEquator',name1{1}(17:end-7),'.mat']
    load([path1,name1{1}]);
    
    b1 = lat >= lat_box(1) & lat <= lat_box(2);
    
    clear bin_uvel bin_uvel_tp
    for i1 = 1:length(name1)
        data1 = load([path1,name1{i1}]);
        data2 = load([path2,name2{i1}]);
        bin_uvel(:,:,:,i1) = squeeze(nanmean(data1.uvel(:,b1,:,:),2));
        bin_uvel_tp(:,:,:,i1) = squeeze(nanmean(data2.uvel(:,b1,:,:),2));
    end
 
    size(bin_uvel)
    
    bin_uvela = bin_uvel - bin_uvel_tp;
    uvela_ensemble = mean(bin_uvela,4);
    %%
    clear t_uvela_ensemble p_uvela_ensemble hh1 pp1 h1 p1
    for i1 = 1:size(bin_uvela,3)
        for i2 = 1:size(bin_uvela,1)
            for i3 = 1:size(bin_uvela,2)
                pro = bin_uvela(i2,i3,i1,:);
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
        t_uvela_ensemble(:,:,i1) = hh1;
        p_uvela_ensemble(:,:,i1) = pp1;
    end
    %%
%     k = 1;
%     contourf(lon,lat,temp_ensemble(:,:,k)');
%     colorbar;
    %%
    save(savepath,'lon','lat','depth','date','uvela_ensemble','t_uvela_ensemble','p_uvela_ensemble','lon_box','lat_box','readme');
    clear uvela_ensemble t_uvela_ensemble p_uvela_ensemble readme
end
