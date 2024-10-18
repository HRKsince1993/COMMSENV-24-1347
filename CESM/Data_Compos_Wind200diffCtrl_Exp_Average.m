clc;clear

for one = 3:8 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
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
    
    two = 3;% minus 1:Ctrl;2:TroPac;3:TPCtrl;4:PMM
    second_name = {'Ctrl','TroPac','TPCtrl','PMM'};
    
    l_mon = (3:11)-2;% average from 1st month to last month
        
    aimpath = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\'];
    if exist(aimpath,'dir')~=7
        mkdir(aimpath);
    end
    
    path1a = ['J:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\WindU3_Casely\'];
    path1b = ['J:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\WindV3_Casely\'];
    path2a = ['J:\2023PMM_Work\Data_Ensamble\Exp_',second_name{two},'\WindU3_Casely\'];
    path2b = ['J:\2023PMM_Work\Data_Ensamble\Exp_',second_name{two},'\WindV3_Casely\'];
    struct = dir([path1a,'*.mat']);
    if one == 0 % CESM-G
        name1a = {struct.name}';
        name1a = cat(1,name1a(1:3),name1a(5:10),name1a(19));
    else
        name1a = {struct(2:end).name}';
    end
    
    struct = dir([path1b,'*.mat']);
    if one == 0 % CESM-G
        name1b = {struct.name}';
        name1b = cat(1,name1b(1:3),name1b(5:10),name1b(19));
    else
        name1b = {struct(2:end).name}';
    end
    
    struct2 = dir([path2a,'*.mat']);
    name2a = {struct2(2:end).name}';
    struct2 = dir([path2b,'*.mat']);
    name2b = {struct2(2:end).name}';
    if length(name1a) ~= 10 || length(name2a) ~= 10
        'error'
    end
    
    savepath = [aimpath,'Compose_',name1a{1}(1:4),'200hPa_diff',second_name{two},name1a{1}(7:end-7),'Avr',num2str(l_mon(1)+2),'to',num2str(l_mon(end)+2),'Mon.mat']
    load([path1a,name1a{1}]);
    readme = '200hPa wind speed. Lon*Lat*Time. Velocity unit is m/s. Lev unit is level';
    %%
    clear bin_uvel bin_vvel bin_uvel_tp bin_vvel_tp
    for i1 = 1:length(name1a)
        data1a = load([path1a,name1a{i1}]);
        data1b = load([path1b,name1b{i1}]);
        data2a = load([path2a,name2a{i1}]);
        data2b = load([path2b,name2b{i1}]);
        bin_uvel(:,:,:,i1) = squeeze(data1a.uvel(:,:,13,:));% 192hPa
        bin_vvel(:,:,:,i1) = squeeze(data1b.vvel(:,:,13,:));
        bin_uvel_tp(:,:,:,i1) = squeeze(data2a.uvel(:,:,13,:));
        bin_vvel_tp(:,:,:,i1) = squeeze(data2b.vvel(:,:,13,:));
    end
    bin_uvela = bin_uvel - bin_uvel_tp;
    bin_vvela = bin_vvel - bin_vvel_tp;
    uvela_ensamble = mean(mean(bin_uvela(:,:,l_mon,:),4),3);
    vvela_ensamble = mean(mean(bin_vvela(:,:,l_mon,:),4),3);
    bin2_uvela = squeeze(mean(bin_uvela(:,:,l_mon,:),3));
    bin2_vvela = squeeze(mean(bin_vvela(:,:,l_mon,:),3));
    %%
    clear t_uvela_ensamble p_uvela_ensamble  t_vvela_ensamble p_vvela_ensamble hh1 hh2 pp1 pp2
        for i2 = 1:size(bin2_uvela,1)
            for i3 = 1:size(bin2_uvela,2)
                pro_u = bin2_uvela(i2,i3,:);
                pro_v = bin2_vvela(i2,i3,:);
                pro_u = pro_u(:);
                pro_v = pro_v(:);
                if sum(isnan(pro_u)) == length(pro_u) || sum(pro_u==0) == length(pro_u)
                    hh1(i2,i3)=nan;
                    pp1(i2,i3)=nan;
                    hh2(i2,i3)=nan;
                    pp2(i2,i3)=nan;
                    continue
                end
                [h1,p1,ci1]=ttest(pro_u,0);
                [h2,p2,ci2]=ttest(pro_v,0);
                hh1(i2,i3)=h1;
                pp1(i2,i3)=p1;
                hh2(i2,i3)=h2;
                pp2(i2,i3)=p2;
            end
        end
        t_uvela_ensamble = hh1;
        p_uvela_ensamble = pp1;
        t_vvela_ensamble = hh2;
        p_vvela_ensamble = pp2;
    %%
    % k = 1;
    % contourf(lon,lat,uvela_ensamble(:,:,k)');
    % colorbar;
    % % caxis([-1.5,1.5]);
    %%
    readme2 = name1a;
    save(savepath,'lon','lat','date','uvela_ensamble','vvela_ensamble','t_uvela_ensamble','t_vvela_ensamble','p_uvela_ensamble','p_vvela_ensamble','readme2');
    clear uvela_ensamble vvela_ensamble t_uvela_ensamble t_vvela_ensamble p_uvela_ensamble p_vvela_ensamble readme
end