clc;clear

for one = 1:10 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
              % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};
    
    aimpath = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\'];
    if exist(aimpath,'dir')~=7
        mkdir(aimpath);
    end
    
    path1 = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\SSHA_Casely\'];
    struct = dir([path1,'*.mat']);
    if one == 0 % CESM-G
        name1 = {struct.name}';
        name1 = cat(1,name1(1:3),name1(5:10),name1(19));
    else
        name1 = {struct(2:end).name}';
    end
    
    load([path1,name1{1}]);
    savepath = [aimpath,'Compose_',name1{1}(1:end-7),'.mat'];
    
    clear bin_ssha t_ssha_ensemble p_ssha_ensemble hh1 pp1
    for i1 = 1:length(name1)
        data1 = load([path1,name1{i1}]);
        bin_ssha(:,:,:,i1) = data1.ssha;
    end
    ssha_ensemble = mean(bin_ssha,4);
    
    clear t_ssha_ensemble p_ssha_ensemble hh1 pp1 h1 p1
    for i1 = 1:size(bin_ssha,3)
        for i2 = 1:size(bin_ssha,1)
            for i3 = 1:size(bin_ssha,2)
                pro = bin_ssha(i2,i3,i1,:);
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
        t_ssha_ensemble(:,:,i1) = hh1;
        p_ssha_ensemble(:,:,i1) = pp1;
    end
    %%
    % k = 1;
    % contourf(lon,lat,ssta_ensemble(:,:,k)','levelstep',0.2);
    % hold on
    % % [x2,y2]=find(t_ssta_ensemble(:,:,k)==1);
    % % plot(lon(x2),lat(y2),'g.','markersize',5,'color',[0.3 0.3 0.3]);
    % colorbar;
    % caxis([-1.5,1.5]);
    % hold off
    %%
    readme2 = name1;
    save(savepath,'lon','lat','date','ssha_ensemble','t_ssha_ensemble','p_ssha_ensemble','readme2');
    clear ssha_ensemble t_ssha_ensemble p_ssha_ensemble
end