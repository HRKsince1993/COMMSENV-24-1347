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
    
    path1 = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\Temp_Casely\'];
    struct = dir([path1,'*.mat']);
    name1 = {struct.name}';
    
    if length(name1) < 8
        'error'
        one
    end
    
    data1 = load('F:\2023PMM_Work\bin_data\D20_March_Liu.mat');
    %%
    for i1 = 1:length(name1)
        aimpath = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{one},'\D20_Casely\'];
        if exist(aimpath,'dir')~=7
            mkdir(aimpath);
        end
        
        load([path1,name1{i1}]);
        
        sec_ptmp = sec_temp;
        sec_depth = depth;
        sec_lon = lon;
        
        iso_20 = nan(size(sec_ptmp,1),size(sec_ptmp,3));
        for i2 = 1:size(sec_ptmp,3)
            bin_sec = sec_ptmp(:,:,i2);
            for i3 = 1:size(sec_ptmp,1)
                pro = bin_sec(i3,:);
                
                if sum(isnan(pro)) >= length(pro)-5
                    continue
                end
                
                a = ~isnan(pro);
                pro2 = pro(a);
                sec_d = sec_depth(a);
                
                if min(pro2) > 20 || max(pro2) < 20
                    continue
                end
                
                for i4 = 1:length(pro2)
                    p_temp = pro2(i4);
                    if p_temp == 20
                        iso_20(i3,i2) = sec_d(i4);
                    elseif p_temp < 20
                        iso_20(i3,i2) = interp1([pro2(i4-1),pro2(i4)],[sec_d(i4-1),sec_d(i4)],20,'linear');
                        break
                    end
                end
            end
        end
            iso_20a = iso_20 - data1.iso_20;
        %%
        datapath = [aimpath,'D20',name1{i1}(5:end)];
        save(datapath,'date','sec_lon','iso_20','iso_20a','readme');
    end
end