clc;clear

for one = 39:40;% 1;Ctrl;2:NTA;3:PMM;4:TIO;5:TroPac:6£ºTPCtrl;7:NTA15;8:NTA30;9:AtlNino;10:NoWNP;11:NoPMM;12:NTAandTIO;13:TroPacNTA;14:PMMandNTA;15:TPCtrlG;16:SEP;
    % 17:NTAandTIOandSEP;18:NTAandTIOandPMMandSEP;19:NTAandTIOLgandPMMandSEP;20:TO;21:NTAandTIOandPMMandSEPandWNP;22:NTAandTIOandEP;23:NTAandTIOandPMMandSEP_New
    % 24:NTAandTIOandEPandWWB;25:NTAandTIOandPMMandSEPandWWB;26:NTAandTIOandSEPlg;27:NTAandTIOandSEPandWWB;28:NTAandTIOandSEPandWWBmay;29:TIOlg;30:NTAlg;
    % 31:NTAandTIOandSEPandWWBb;32:NTAandTIOandSEPandWWBbmay;33:PMMsmall;34:NTAandTIOandPMMandSEPlg;35:NETPCli;36:NTAandTIOandPMMandSEPandWWBb;
    % 37:NTAandTIOandPMMandSEPandWWBbmay;38:CESM_TP;39:NTAandTIOandPMMandSEPandWWBOctNov;40:TPCtrlNoWWB2
    first_name = {'Ctrl','NTA','PMM','TIO','TroPac','TPCtrl','NTA15','NTA30','AtlNino','NoWNP','NoPMM','NTAandTIO','TroPacNTA','PMMandNTA','TPCtrlG','SEP'...
        ,'NTAandTIOandSEP','NTAandTIOandPMMandSEP','NTAandTIOLgandPMMandSEP','TO','NTAandTIOandPMMandSEPandWNP','NTAandTIOandEP','NTAandTIOandPMMandSEP_New'...
        ,'NTAandTIOandEPandWWB','NTAandTIOandPMMandSEPandWWB','NTAandTIOandSEPlg','NTAandTIOandSEPandWWB','NTAandTIOandSEPandWWBmay','TIOlg','NTAlg'...
        ,'NTAandTIOandSEPandWWBb','NTAandTIOandSEPandWWBbmay','PMMsmall','NTAandTIOandPMMandSEPlg','NETPCli','NTAandTIOandPMMandSEPandWWBb'...
        ,'NTAandTIOandPMMandSEPandWWBbmay','CESM_TP','NTAandTIOandPMMandSEPandWWBOctNov','TPCtrlNoWWB2'};
    
    aimpath = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\'];
    if exist(aimpath,'dir')~=7
        mkdir(aimpath);
    end
    
    path1 = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\Tauy_Casely_Daily\'];
    struct = dir([path1,'*.mat']);
    if one == 0 % CESM-G
        name1 = {struct.name}';
        name1 = cat(1,name1(1:3),name1(5:10),name1(19));
    else
        name1 = {struct(2:end).name}';
    end
    
    load([path1,name1{1}]);
    savepath = [aimpath,'Compose_',name1{1}(1:end-7),'.mat']
    
    bin_uvel = 0;
    for i1 = 1:length(name1)
        data1 = load([path1,name1{i1}]);
        bin_uvel = data1.tauy + bin_uvel;
    end
    tauy_ensamble = bin_uvel/length(name1);
    %
    % clear t_uvel_ensamble p_uvel_ensamble t_vvel_ensamble p_vvel_ensamble hh1 pp1 hh2 pp2
    % for i1 = 1:size(bin_uvel,3)
    %     for i2 = 1:size(bin_uvel,1)
    %         for i3 = 1:size(bin_uvel,2)
    %             pro_u = bin_uvel(i2,i3,i1,:);
    %             pro_v = bin_vvel(i2,i3,i1,:);
    %             pro_u = pro_u(:);
    %             pro_v = pro_v(:);
    %             if sum(isnan(pro_u)) == length(pro_u) || sum(pro_u==0) == length(pro_u)
    %                 hh1(i2,i3)=nan;
    %                 pp1(i2,i3)=nan;
    %                 hh2(i2,i3)=nan;
    %                 pp2(i2,i3)=nan;
    %                 continue
    %             end
    %             [h1,p1,ci1]=ttest(pro_u,0);
    %             [h2,p2,ci2]=ttest(pro_v,0);
    %             hh1(i2,i3)=h1;
    %             pp1(i2,i3)=p1;
    %             hh2(i2,i3)=h2;
    %             pp2(i2,i3)=p2;
    %         end
    %     end
    %     t_uvel_ensamble(:,:,i1) = hh1;
    %     p_uvel_ensamble(:,:,i1) = pp1;
    %     t_vvel_ensamble(:,:,i1) = hh2;
    %     p_vvel_ensamble(:,:,i1) = pp2;
    % end
    %%
    % k = 1;
    % contourf(lon,lat,uvel_ensamble(:,:,k)');
    % colorbar;
    % caxis([-1.5,1.5]);
    %%
    readme2 = name1;
    % save(savepath,'lon','lat','date','uvel_ensamble','vvel_ensamble','readme','t_uvel_ensamble','t_vvel_ensamble','p_uvel_ensamble','p_vvel_ensamble','readme2');
    save(savepath,'lon','lat','date','tauy_ensamble','readme','time','readme2');
    clear  tauy_ensamble t_tauy_ensamble p_tauy_ensamble
end