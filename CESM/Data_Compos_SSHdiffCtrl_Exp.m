clc;clear

for one = 3:3 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
              % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};
    
    two = 3;% minus 1:Ctrl;2:TroPac;3:TPCtrl;4:PMM;5:NTAandTIOandSEPlg
    three = 1;% minus 1:one by one case;2:ensamble cases
    second_name = {'Ctrl','TroPac','TPCtrl','PMM','NTAandTIOandSEPlg'};
    
    aimpath = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\'];
    if exist(aimpath,'dir')~=7
        mkdir(aimpath);
    end
    
    path1 = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\SSH_Casely\'];
    path2 = ['F:\2023PMM_Work\Data_Ensemble\Exp_',second_name{two},'\SSH_Casely\'];
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
    savepath = [aimpath,'Compose_',name1{1}(1:3),'diff',second_name{two},name1{1}(4:end-7),'.mat']
    
    load([path1,name1{1}]);
    
    clear bin_sst bin_sst_tp
    for i1 = 1:length(name1)
        data1 = load([path1,name1{i1}]);
        data2 = load([path2,name2{i1}]);
        bin_ssh(:,:,:,i1) = data1.ssh;
        bin_ssh_tp(:,:,:,i1) = data2.ssh;
    end
    %%
    bin_ssh_tp_month = mean(bin_ssh_tp,4);
    
    clear bin_ssha
    switch three
        case 1
            bin_ssha = bin_ssh - bin_ssh_tp;
            readme = 'minus one by one case';
        case 2
            for i1 = 1:size(bin_ssh,3)
                bin_ssha(:,:,i1) =  bin_ssh(:,:,i1) - bin_ssh_tp_month(:,:,i1);
            end
            readme = 'minus ensamble case';
    end
    ssha_ensemble = mean(bin_ssha,4);
    
    size(bin_ssha)
    %%
    clear t_ssha_ensemble p_ssha_ensemble hh1 pp1
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
    % contourf(lon,lat,ssta_ensemble(:,:,k)','levelstep',2);
    % hold on
    % colorbar;
    % caxis([-5,35]);
    % hold off
    %%
    readme2 = name1;
    save(savepath,'lon','lat','date','ssha_ensemble','t_ssha_ensemble','p_ssha_ensemble','readme','readme2');
    clear ssha_ensemble t_ssha_ensemble p_ssha_ensemble readme
end