clc;clear

for one = 1:8 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
              % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};
    
    l_mon = (3:11)-2;% average from 1st month to last month
    
    aimpath = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\'];
    if exist(aimpath,'dir')~=7
        mkdir(aimpath);
    end
    
    path1 = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\SSTA_Casely\'];
    struct = dir([path1,'*.mat']);
    if one == 0 % CESM-G
        name1 = {struct.name}';
        name1 = cat(1,name1(1:3),name1(5:10),name1(19));
    else
        name1 = {struct(2:end).name}';
    end
    
    load([path1,name1{1}]);
    savepath = [aimpath,'Compose_',name1{1}(1:end-7),'_Avr',num2str(l_mon(1)+2),'to',num2str(l_mon(end)+2),'Mon.mat']
    
    clear bin_ssta t_ssta_ensamble p_ssta_ensamble hh1 pp1
    for i1 = 1:length(name1)
        data1 = load([path1,name1{i1}]);
        bin_ssta(:,:,:,i1) = data1.ssta;
    end
    ssta_ensamble = mean(mean(bin_ssta(:,:,l_mon,:),4),3);
    bin2_ssta = squeeze(mean(bin_ssta(:,:,l_mon,:),3));
    
    contourf(ssta_ensamble)
    colorbar
    %%
    clear t_ssta_ensamble p_ssta_ensamble hh1 pp1 h1 p1
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
        t_ssta_ensamble = hh1;
        p_ssta_ensamble = pp1;
    %%
    % k = 1;
    % contourf(lon,lat,ssta_ensamble(:,:,k)','levelstep',0.2);
    % hold on
    % % [x2,y2]=find(t_ssta_ensamble(:,:,k)==1);
    % % plot(lon(x2),lat(y2),'g.','markersize',5,'color',[0.3 0.3 0.3]);
    % colorbar;
    % caxis([-1.5,1.5]);
    % hold off
    %%
    readme2 = name1;
    save(savepath,'lon','lat','date','ssta_ensamble','t_ssta_ensamble','p_ssta_ensamble','readme2');
    % save(savepath,'lon','lat','date','ssta_ensamble');
    clear ssta_ensamble t_ssta_ensamble p_ssta_ensamble
end

