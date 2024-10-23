clc;clear

for one = 3:8 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
              % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};
    
    two = 3;% minus 1:Ctrl;2:TroPac;3:TPCtrl;4:PMM
    three = 2;% 1:200hPa;2:500hPa;
    second_name = {'Ctrl','TroPac','TPCtrl','PMM'};
    third_name = {'200','500'};% lev, hPa
    third_num1 = [13,19];% lev, hPa
    
    l_mon = (3:11)-2;% average from 1st month to last month
        
    aimpath = ['F:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\'];
    if exist(aimpath,'dir')~=7
        mkdir(aimpath);
    end
    
    path1 = ['J:\2023PMM_Work\Data_Ensemble\Exp_',first_name{one},'\Z3_Casely\'];
    path2 = ['J:\2023PMM_Work\Data_Ensemble\Exp_',second_name{two},'\Z3_Casely\'];
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
    savepath = [aimpath,'Compose_Pres',third_name{three},'diff',second_name{two},name1{1}(3:end-7),'Avr',num2str(l_mon(1)+2),'to',num2str(l_mon(end)+2),'Mon.mat']
    load([path1,name1{1}]);
    readme = ['lon*lat*time.Geopotential Height (above sea level). Height unit is m. lev unit is level, num ',num2str(third_num1(three)),' about ',num2str(floor(lev(third_num1(three))),'%2.3i'),'hPa']

    clear bin_sst bin_sst_tp
    for i1 = 1:length(name1)
        data1 = load([path1,name1{i1}]);
        data2 = load([path2,name2{i1}]);
        bin_sst(:,:,:,i1) = squeeze(data1.z3(:,:,third_num1(three),:));
        bin_sst_tp(:,:,:,i1) = squeeze(data2.z3(:,:,third_num1(three),:));
    end
    bin_ssta = bin_sst - bin_sst_tp;
    pres_ensemble = mean(mean(bin_ssta(:,:,l_mon,:),4),3);
    bin2_ssta = squeeze(mean(bin_ssta(:,:,l_mon,:),3));
    %%
    clear t_pres_ensemble p_pres_ensemble hh1 pp1 h1 p1
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
        t_pres_ensemble = hh1;
        p_pres_ensemble = pp1;
    %%
%     k = 1;
%     contourf(lon,lat,pres_ensemble(:,:,k)');
%     colorbar;
    %%
    save(savepath,'lon','lat','date','pres_ensemble','t_pres_ensemble','p_pres_ensemble','readme');
    clear pres_ensemble readme t_pres_ensemble p_pres_ensemble
end