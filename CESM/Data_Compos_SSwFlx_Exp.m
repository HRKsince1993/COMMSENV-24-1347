clc;clear

for one = 1:10 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
              % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};
    
    % 1;Ctrl;2:NTA;3:PMM;4:TIO;5:TroPac:6��TPCtrl;7:NTA15;8:NTA30;9:AtlNino;10:NoWNP;11:NoPMM;12:NTAandTIO;13:TroPacNTA;14:PMMandNTA;15:TPCtrlG;16:SEP;
    % 17:NTAandTIOandSEP;18:NTAandTIOandPMMandSEP;19:NTAandTIOLgandPMMandSEP;20:TO;21:NTAandTIOandPMMandSEPandWNP;22:NTAandTIOandEP;23:NTAandTIOandPMMandSEP_New
    % 24:NTAandTIOandEPandWWB;25:NTAandTIOandPMMandSEPandWWB;26:NTAandTIOandSEPlg;27:NTAandTIOandSEPandWWB;28:NTAandTIOandSEPandWWBmay;29:TIOlg;30:NTAlg;
    % 31:NTAandTIOandSEPandWWBb;32:NTAandTIOandSEPandWWBbmay;33:PMMsmall;34:NTAandTIOandPMMandSEPlg;35:NETPCli;36:NTAandTIOandPMMandSEPandWWBb;
    % 37:NTAandTIOandPMMandSEPandWWBbmay;38:CESM_TP;39:NTAandTIOandPMMandSEPandWWBOctNov;40:TPCtrlNoWWB2
%     first_name = {'Ctrl','NTA','PMM','TIO','TroPac','TPCtrl','NTA15','NTA30','AtlNino','NoWNP','NoPMM','NTAandTIO','TroPacNTA','PMMandNTA','TPCtrlG','SEP'...
%         ,'NTAandTIOandSEP','NTAandTIOandPMMandSEP','NTAandTIOLgandPMMandSEP','TO','NTAandTIOandPMMandSEPandWNP','NTAandTIOandEP','NTAandTIOandPMMandSEP_New'...
%         ,'NTAandTIOandEPandWWB','NTAandTIOandPMMandSEPandWWB','NTAandTIOandSEPlg','NTAandTIOandSEPandWWB','NTAandTIOandSEPandWWBmay','TIOlg','NTAlg'...
%         ,'NTAandTIOandSEPandWWBb','NTAandTIOandSEPandWWBbmay','PMMsmall','NTAandTIOandPMMandSEPlg','NETPCli','NTAandTIOandPMMandSEPandWWBb'...
%         ,'NTAandTIOandPMMandSEPandWWBbmay','CESM_TP','NTAandTIOandPMMandSEPandWWBOctNov','TPCtrlNoWWB2'};
    
%     two = 3;% minus 1:Ctrl;2:TroPac;3:TPCtrl;4:PMM
%     second_name = {'Ctrl','TroPac','TPCtrl','PMM'};
    
    aimpath = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\'];
    if exist(aimpath,'dir')~=7
        mkdir(aimpath);
    end
    
    path1 = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\SSwFlx_Casely\']
%     path2 = ['F:\2023PMM_Work\Data_Ensamble\Exp_',second_name{two},'\SSwFlx_Casely\']
    struct = dir([path1,'*.mat']);
    if one == 0 % CESM-G
        name1 = {struct.name}';
        name1 = cat(1,name1(1:3),name1(5:10),name1(19));
    else
        name1 = {struct(2:end).name}';
    end
%     struct2 = dir([path2,'*.mat']);
%     name2 = {struct2(2:end).name}';
    if length(name1) ~= 10
        'error'
    end
    savepath = [aimpath,'Compose_',name1{1}(1:6),name1{1}(7:end-7),'.mat']
    load([path1,name1{1}]);
    %%
    clear bin_sst bin_sst_tp
    for i1 = 1:length(name1)
        data1 = load([path1,name1{i1}]);
%         data2 = load([path2,name2{i1}]);
        bin_sst(:,:,:,i1) = data1.sswflx;
%         bin_sst_tp(:,:,:,i1) = data2.sswflx;
    end
%     bin_ssta = bin_sst - bin_sst_tp;
    sswflx_ensamble = mean(bin_sst,4);
    
%     clear t_sswflxa_ensamble p_sswflxa_ensamble hh1 pp1 h1 p1
%     for i1 = 1:size(bin_ssta,3)
%         for i2 = 1:size(bin_ssta,1)
%             for i3 = 1:size(bin_ssta,2)
%                 pro = bin_ssta(i2,i3,i1,:);
%                 pro = pro(:);
%                 if sum(isnan(pro)) == length(pro) || sum(pro==0) == length(pro)
%                     hh1(i2,i3)=nan;
%                     pp1(i2,i3)=nan;
%                     continue
%                 end
%                 [h1,p1,ci1]=ttest(pro,0);
%                 hh1(i2,i3)=h1;
%                 pp1(i2,i3)=p1;
%             end
%         end
%         t_sswflxa_ensamble(:,:,i1) = hh1;
%         p_sswflxa_ensamble(:,:,i1) = pp1;
%     end
    %%
%     k = 1;
%     contourf(lon,lat,slflxa_ensamble(:,:,k)');
%     colorbar;
    %%
%     save(savepath,'lon','lat','date','sswflxa_ensamble','readme','t_sswflxa_ensamble','p_sswflxa_ensamble');
    save(savepath,'lon','lat','date','sswflx_ensamble','readme');
    clear sswflx_ensamble readme t_sswflx_ensamble p_sswflx_ensamble
end