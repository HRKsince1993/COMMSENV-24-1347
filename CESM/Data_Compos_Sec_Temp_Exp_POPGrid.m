clc;clear

for one = 1:10 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
              % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};
    
    aimpath = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\'];
    if exist(aimpath,'dir')~=7
        mkdir(aimpath);
    end
    
    path1 = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\Temp_Casely\'];
    struct = dir([path1,'*.mat']);
    name1 = {struct(2:end).name}';
    
    load([path1,name1{1}]);
    savepath = [aimpath,'Compose_',name1{1}(1:end-7),'.mat']
    %%
    clear bin_temp
    for i1 = 1:length(name1)
        data1 = load([path1,name1{i1}]);
        bin_temp(:,:,:,i1) = data1.sec_temp;
    end
    sec_temp_ensemble = mean(bin_temp,4);
    %%
    clear t_sec_temp_ensemble p_sec_temp_ensemble hh1 pp1 h1 p1
    for i1 = 1:size(bin_temp,3)
        for i2 = 1:size(bin_temp,1)
            for i3 = 1:size(bin_temp,2)
                pro = bin_temp(i2,i3,i1,:);
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
        t_sec_temp_ensemble(:,:,i1) = hh1;
        p_sec_temp_ensemble(:,:,i1) = pp1;
    end
    %%
    % k = 1;
    % contourf(lon,depth,sec_temp_ensemble(:,:,k)','levelstep',2);
    % hold on
    % colorbar;
    % caxis([-5,35]);
    % hold off
    %%
    readme2 = name1;
    save(savepath,'lon','lat','depth','date','sec_temp_ensemble','t_sec_temp_ensemble','p_sec_temp_ensemble','readme','readme2');
end