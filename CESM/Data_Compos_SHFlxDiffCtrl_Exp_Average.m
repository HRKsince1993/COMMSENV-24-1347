clc;clear

for one = 3:7 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
              % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};
    
    % 1;Ctrl;2:NTA;3:PMM;4:TIO;5:TroPac:6£ºTPCtrl;7:NTA15;8:NTA30;9:AtlNino;10:NoWNP;11:NoPMM;12:NTAandTIO;13:TroPacNTA;14:PMMandNTA;15:TPCtrlG;16:SEP;
    % 17:NTAandTIOandSEP;18:NTAandTIOandPMMandSEP;19:NTAandTIOLgandPMMandSEP;20:TO;21:NTAandTIOandPMMandSEPandWNP;22:NTAandTIOandEP;23:NTAandTIOandPMMandSEP_New
    % 24:NTAandTIOandEPandWWB;25:NTAandTIOandPMMandSEPandWWB;26:NTAandTIOandSEPlg;27:NTAandTIOandSEPandWWB;28:NTAandTIOandSEPandWWBmay;29:TIOlg;30:NTAlg;
    % 31:NTAandTIOandSEPandWWBb;32:NTAandTIOandSEPandWWBbmay;33:PMMsmall;34:NTAandTIOandPMMandSEPlg;35:NETPCli;36:NTAandTIOandPMMandSEPandWWBb;
    % 37:NTAandTIOandPMMandSEPandWWBbmay;38:CESM_TP;39:NTAandTIOandPMMandSEPandWWBOctNov;40:TPCtrlNoWWB2
%     first_name = {'Ctrl','NTA','PMM','TIO','TroPac','TPCtrl','NTA15','NTA30','AtlNino','NoWNP','NoPMM','NTAandTIO','TroPacNTA','PMMandNTA','TPCtrlG','SEP'...
%         ,'NTAandTIOandSEP','NTAandTIOandPMMandSEP','NTAandTIOLgandPMMandSEP','TO','NTAandTIOandPMMandSEPandWNP','NTAandTIOandEP','NTAandTIOandPMMandSEP_New'...
%         ,'NTAandTIOandEPandWWB','NTAandTIOandPMMandSEPandWWB','NTAandTIOandSEPlg','NTAandTIOandSEPandWWB','NTAandTIOandSEPandWWBmay','TIOlg','NTAlg'...
%         ,'NTAandTIOandSEPandWWBb','NTAandTIOandSEPandWWBbmay','PMMsmall','NTAandTIOandPMMandSEPlg','NETPCli','NTAandTIOandPMMandSEPandWWBb'...
%         ,'NTAandTIOandPMMandSEPandWWBbmay','CESM_TP','NTAandTIOandPMMandSEPandWWBOctNov','TPCtrlNoWWB2'};
    
    l_mon = (3:11)-2;% average from 1st month to last month
    
    two = 3;% minus 1:Ctrl;2:TroPac;3:TPCtrl;4:PMM
    second_name = {'Ctrl','TroPac','TPCtrl','PMM'};
    
    aimpath = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\'];
    if exist(aimpath,'dir')~=7
        mkdir(aimpath);
    end
    
    path1a = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\SLHFlx_Casely\'];
    path1b = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\SSHFlx_Casely\'];
    path1c = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\SLwFlx_Casely\'];
    path1d = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\SSwFlx_Casely\'];
    path2a = ['F:\2023PMM_Work\Data_Ensamble\Exp_',second_name{two},'\SLHFlx_Casely\'];
    path2b = ['F:\2023PMM_Work\Data_Ensamble\Exp_',second_name{two},'\SSHFlx_Casely\'];
    path2c = ['F:\2023PMM_Work\Data_Ensamble\Exp_',second_name{two},'\SLwFlx_Casely\'];
    path2d = ['F:\2023PMM_Work\Data_Ensamble\Exp_',second_name{two},'\SSwFlx_Casely\'];
    struct = dir([path1a,'*.mat']);name1a = {struct(2:end).name}';
    struct = dir([path1b,'*.mat']);name1b = {struct(2:end).name}';
    struct = dir([path1c,'*.mat']);name1c = {struct(2:end).name}';
    struct = dir([path1d,'*.mat']);name1d = {struct(2:end).name}';
   
    struct = dir([path2a,'*.mat']);name2a = {struct(2:end).name}';
    struct = dir([path2b,'*.mat']);name2b = {struct(2:end).name}';
    struct = dir([path2c,'*.mat']);name2c = {struct(2:end).name}';
    struct = dir([path2d,'*.mat']);name2d = {struct(2:end).name}';
                
    if length(name1a) ~= 10 || length(name2a) ~= 10
        'error'
    end
    savepath = [aimpath,'Compose_SHFlxDiff',second_name{two},name1a{1}(7:end-7),'Avr',num2str(l_mon(1)+2),'to',num2str(l_mon(end)+2),'Mon.mat']
    load([path1a,name1a{1}]);
    %%
    clear bin_sst bin_sst_tp
    for i1 = 1:length(name1a)
        data1a = load([path1a,name1a{i1}]);
        data1b = load([path1b,name1b{i1}]);
        data1c = load([path1c,name1c{i1}]);
        data1d = load([path1d,name1d{i1}]);
        data2a = load([path2a,name2a{i1}]);
        data2b = load([path2b,name2b{i1}]);
        data2c = load([path2c,name2c{i1}]);
        data2d = load([path2d,name2d{i1}]);
        bin_sst(:,:,:,i1) = -data1a.slflx - data1b.ssflx - data1c.slwflx + data1d.sswflx;
        bin_sst_tp(:,:,:,i1) = -data2a.slflx - data2b.ssflx - data2c.slwflx + data2d.sswflx;
    end
    bin_ssta = bin_sst - bin_sst_tp;
    sflxa_ensamble = mean(mean(bin_ssta(:,:,l_mon,:),4),3);
    bin2_ssta = squeeze(mean(bin_ssta(:,:,l_mon,:),3));
    %%
    clear t_sflxa_ensamble p_sflxa_ensamble hh1 pp1 h1 p1
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
        t_sflxa_ensamble = hh1;
        p_sflxa_ensamble = pp1;
    %%
%     k = 1;
%     contourf(lon,lat,slflxa_ensamble(:,:,k)');
%     colorbar;
    %%
    save(savepath,'lon','lat','date','sflxa_ensamble','readme','t_sflxa_ensamble','p_sflxa_ensamble');
    clear sflxa_ensamble readme t_sflxa_ensamble p_sflxa_ensamble
end