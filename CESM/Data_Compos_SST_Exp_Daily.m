clc;clear

for one = 1:10 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
    % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};

    aimpath = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\'];
    if exist(aimpath,'dir')~=7
        mkdir(aimpath);
    end

    path1 = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\SST_Casely_Daily\'];
    struct = dir([path1,'*.mat']);
    if one == 0 % CESM-G
        name1 = {struct.name}';
        name1 = cat(1,name1(1:3),name1(5:10),name1(19));
    else
        name1 = {struct(2:end).name}';
    end

    load([path1,name1{1}]);
    savepath = [aimpath,'Compose_',name1{1}(1:end-7),'.mat']

    bin_sst = 0;
    for i1 = 1:length(name1)
        data1 = load([path1,name1{i1}]);
        bin_sst = data1.sst + bin_sst;
    end
    sst_ensamble = bin_sst/length(name1);

    % clear t_sst_ensamble p_sst_ensamble hh1 pp1 h1 p1
    % for i1 = 1:size(bin_sst,3)
    %     for i2 = 1:size(bin_sst,1)
    %         for i3 = 1:size(bin_sst,2)
    %             pro = bin_sst(i2,i3,i1,:);
    %             pro = pro(:);
    %             if sum(isnan(pro)) == length(pro) || sum(pro==0) == length(pro)
    %                 hh1(i2,i3)=nan;
    %                 pp1(i2,i3)=nan;
    %                 continue
    %             end
    %             [h1,p1,ci1]=ttest(pro,0);
    %             hh1(i2,i3)=h1;
    %             pp1(i2,i3)=p1;
    %         end
    %     end
    %     t_sst_ensamble(:,:,i1) = hh1;
    %     p_sst_ensamble(:,:,i1) = pp1;
    % end
    %%
    % k = 1;
    % contourf(lon,lat,sst_ensamble(:,:,k)','levelstep',2);
    % hold on
    % colorbar;
    % caxis([-5,35]);
    % hold off
    %%
    readme2 = name1;
    % save(savepath,'lon','lat','date','sst_ensamble','t_sst_ensamble','p_sst_ensamble','readme2');
    save(savepath,'lon','lat','date','sst_ensamble','readme','time','readme2');
    clear sst_ensamble t_sst_ensamble p_sst_ensamble
end