clc;clear

for one = 1:8 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
              % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};
    
    % 1;Ctrl;2:NTA;3:PMM;4:TIO;5:TroPac:6£ºTPCtrl;7:NTA15;8:NTA30;9:AtlNino;10:NoWNP;11:NoPMM;12:NTAandTIO;13:TroPacNTA;14:PMMandNTA;15:TPCtrlG;16:SEP;
    % 17:NTAandTIOandSEP;18:NTAandTIOandPMMandSEP;19:NTAandTIOLgandPMMandSEP;20:TO;21:NTAandTIOandPMMandSEPandWNP;22:NTAandTIOandEP;23:NTAandTIOandPMMandSEP_New
    % 24:NTAandTIOandEPandWWB;25:NTAandTIOandPMMandSEPandWWB;26:NTAandTIOandSEPlg;27:NTAandTIOandSEPandWWB;28:NTAandTIOandSEPandWWBmay;29:TIOlg;30:NTAlg;
    % 31:NTAandTIOandSEPandWWBb;32:NTAandTIOandSEPandWWBbmay;33:PMMsmall;34:NTAandTIOandPMMandSEPlg;35:NETPCli;36:NTAandTIOandPMMandSEPandWWBb;
    % 37:NTAandTIOandPMMandSEPandWWBbmay;38:CESM_TP;39:CESM_LP;40:NTAandTIOandPMMandSEPandWWBOctNov;41:TPCtrlNoWWB2
%     first_name = {'Ctrl','NTA','PMM','TIO','TroPac','TPCtrl','NTA15','NTA30','AtlNino','NoWNP','NoPMM','NTAandTIO','TroPacNTA','PMMandNTA','TPCtrlG','SEP'...
%         ,'NTAandTIOandSEP','NTAandTIOandPMMandSEP','NTAandTIOLgandPMMandSEP','TO','NTAandTIOandPMMandSEPandWNP','NTAandTIOandEP','NTAandTIOandPMMandSEP_New'...
%         ,'NTAandTIOandEPandWWB','NTAandTIOandPMMandSEPandWWB','NTAandTIOandSEPlg','NTAandTIOandSEPandWWB','NTAandTIOandSEPandWWBmay','TIOlg','NTAlg'...
%         ,'NTAandTIOandSEPandWWBb','NTAandTIOandSEPandWWBbmay','PMMsmall','NTAandTIOandPMMandSEPlg','NETPCli','NTAandTIOandPMMandSEPandWWBb'...
%         ,'NTAandTIOandPMMandSEPandWWBbmay','CESM_TP','CESM_LP','NTAandTIOandPMMandSEPandWWBOctNov','TPCtrlNoWWB2'};
    
    l_mon = (3:11)-2;% average from 1st month to last month
    
    aimpath = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\'];
    if exist(aimpath,'dir')~=7
        mkdir(aimpath);
    end
    
    path1 = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\TauxA_Casely\'];
    struct = dir([path1,'*.mat']);
    if one == 0 % CESM-G
        name1 = {struct.name}';
        name1 = cat(1,name1(1:3),name1(5:10),name1(19));
    else
        name1 = {struct(2:end).name}';
    end
    
    load([path1,name1{1}]);
    savepath = [aimpath,'Compose_',name1{1}(1:end-7),'_Avr',num2str(l_mon(1)+2),'to',num2str(l_mon(end)+2),'Mon.mat']
    
    clear bin_ssta
    for i1 = 1:length(name1)
        data1 = load([path1,name1{i1}]);
        bin_ssta(:,:,:,i1) = data1.tauxa;
    end
    tauxa_ensamble = mean(mean(bin_ssta(:,:,l_mon,:),4),3);
    bin2_ssta = squeeze(mean(bin_ssta(:,:,l_mon,:),3));
    %%
    clear t_tauxa_ensamble p_tauxa_ensamble hh1 pp1 h1 p1
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
    t_tauxa_ensamble = hh1;
    p_tauxa_ensamble = pp1;
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
    save(savepath,'lon','lat','date','tauxa_ensamble','t_tauxa_ensamble','p_tauxa_ensamble','readme2');
    % save(savepath,'lon','lat','date','ssta_ensamble');
    clear tauxa_ensamble t_tauxa_ensamble p_tauxa_ensamble
end