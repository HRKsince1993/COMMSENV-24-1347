clc;clear

for one = 3:4 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
              % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};
    
    if one == 38
        continue
    end
    
    two = 3;% minus 1:Ctrl;2:TroPac;3:TPCtrl;4:PMM;5:NTAandTIOandSEPlg;6:NTAandTIOandPMMandSEPlg
    three = 1;% minus 1:one by one case;2:ensamble cases
    second_name = {'Ctrl','TroPac','TPCtrl','PMM','NTAandTIOandSEPlg','NTAandTIOandPMMandSEPlg'};
    
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
    
    path2 = ['F:\2023PMM_Work\Data_Ensamble\Exp_',second_name{two},'\SST_Casely_Daily\'];
    struct = dir([path2,'*.mat']);
    name2 = {struct(2:end).name}';
    
    load([path1,name1{1}]);
    savepath = [aimpath,'Compose_',name1{1}(1:3),'diff',second_name{two},name1{1}(4:end-7),'.mat']
    %%
    clear bin_sst bin_sst_tp
    for i1 = 1:length(name1)
        data1 = load([path1,name1{i1}]);
        data2 = load([path2,name2{i1}]);
        bin_sst(:,:,:,i1) = data1.sst;
        bin_sst_tp(:,:,:,i1) = data2.sst;
    end
    
    clear bin_ssta
    switch three
        case 1
            bin_ssta = bin_sst - bin_sst_tp;
            readme = 'minus one by one case';
        case 2
            bin_sst_tp_day = mean(bin_sst_tp,4);
            for i1 = 1:size(bin_sst,3)
                bin_ssta(:,:,i1) =  bin_sst(:,:,i1) - bin_sst_tp_day(:,:,i1);
            end
            readme = 'minus ensamble case';
    end
    ssta_ensamble = mean(bin_ssta,4);
    %%
    clear t_ssta_ensamble p_ssta_ensamble hh1 pp1
    for i1 = 1:size(bin_ssta,3)
        for i2 = 1:size(bin_ssta,1)
            for i3 = 1:size(bin_ssta,2)
                pro = bin_ssta(i2,i3,i1,:);
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
        t_ssta_ensamble(:,:,i1) = hh1;
        p_ssta_ensamble(:,:,i1) = pp1;
    end
    %%
    readme2 = name1;
    save(savepath,'lon','lat','date','ssta_ensamble','t_ssta_ensamble','p_ssta_ensamble','time','readme2');
    clear ssta_ensamble t_ssta_ensamble p_ssta_ensamble
end