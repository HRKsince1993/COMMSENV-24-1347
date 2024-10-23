clc;clear

for one = 1:10 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
              % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};
    
    aimpath = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\'];
    if exist(aimpath,'dir')~=7
        mkdir(aimpath);
    end
    
    path1 = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\D20_Casely\'];
    struct = dir([path1,'*.mat']);
    if one == 0 % CESM-G
        name1 = {struct.name}';
        name1 = cat(1,name1(1:3),name1(5:10),name1(19));
    else
        name1 = {struct(2:end).name}';
    end
    
    load([path1,name1{1}]);
    savepath = [aimpath,'Compose_SecIso20',name1{1}(4:end-7),'.mat']
    %%
    clear bin_sst
    for i1 = 1:length(name1)
        data1 = load([path1,name1{i1}]);
        bin_sst(:,:,i1) = data1.iso_20;
    end
    iso20_ensemble = mean(bin_sst,3);
    
    clear t_iso20_ensemble p_iso20_ensemble hh1 pp1 h1 p1
    for i1 = 1:size(bin_sst,1)
        for i2 = 1:size(bin_sst,2)
                pro = bin_sst(i1,i2,:);
                pro = pro(:);
                if sum(isnan(pro)) == length(pro) || sum(pro==0) == length(pro)
                    hh1(i1,i2)=nan;
                    pp1(i1,i2)=nan;
                    continue
                end
                [h1,p1,ci1]=ttest(pro,0);
                hh1(i1,i2)=h1;
                pp1(i1,i2)=p1;
        end
    end
    t_iso20_ensemble = hh1;
    p_iso20_ensemble = pp1;
    %%
    % k = 1;
    % contourf(lon,lat,sst_ensemble(:,:,k)','levelstep',2);
    % hold on
    % colorbar;
    % caxis([-5,35]);
    % hold off
    %%
    readme2 = name1;
    save(savepath,'sec_lon','date','iso20_ensemble','t_iso20_ensemble','p_iso20_ensemble','readme','readme2');
    clear iso20_ensemble t_iso20_ensemble p_iso20_ensemble
end