clc;clear

for one = 1:10 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
              % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};
    
    aimpath = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\'];
    if exist(aimpath,'dir')~=7
        mkdir(aimpath);
    end
    
    path1 = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\SSH_Casely\'];
    struct = dir([path1,'*.mat']);
    if one == 0 % CESM-G
        name1 = {struct.name}';
        name1 = cat(1,name1(1:3),name1(5:10),name1(19));
    else
        name1 = {struct(2:end).name}';
    end
    
    load([path1,name1{1}]);
    savepath = [aimpath,'Compose_',name1{1}(1:end-7),'.mat']
    
    clear bin_ssh
    for i1 = 1:length(name1)
        data1 = load([path1,name1{i1}]);
        bin_ssh(:,:,:,i1) = data1.ssh;
    end
    ssh_ensamble = mean(bin_ssh,4);
    
    clear t_ssh_ensamble p_ssh_ensamble hh1 pp1 h1 p1
    for i1 = 1:size(bin_ssh,3)
        for i2 = 1:size(bin_ssh,1)
            for i3 = 1:size(bin_ssh,2)
                pro = bin_ssh(i2,i3,i1,:);
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
        t_ssh_ensamble(:,:,i1) = hh1;
        p_ssh_ensamble(:,:,i1) = pp1;
    end
    %%
    % k = 1;
    % contourf(lon,lat,ssh_ensamble(:,:,k)','levelstep',2);
    % hold on
    % colorbar;
    % caxis([-5,35]);
    % hold off
    %%
    readme2 = name1;
    save(savepath,'lon','lat','date','ssh_ensamble','t_ssh_ensamble','p_ssh_ensamble','readme2');
    clear ssh_ensamble t_ssh_ensamble p_ssh_ensamble
end