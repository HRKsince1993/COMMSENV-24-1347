clc;clear;

for one = 41:41 % 1;Ctrl;2:NTA;3:PMM;4:TIO;5:TroPac:6£ºTPCtrl;7:NTA15;8:NTA30;9:AtlNino;10:NoWNP;11:NoPMM;12:NTAandTIO;13:TroPacNTA;14:PMMandNTA;15:TPCtrlG;16:SEP
    % 17:NTAandTIOandSEP;18:NTAandTIOandPMMandSEP;19:NTAandTIOLgandPMMandSEP;20:CESM-TP;21:TO;22:NTAandTIOandPMMandSEPandWNP;23:NTAandTIOandEP;24:NTAandTIOandPMMandSEP
    % 25:NTAandTIOandEPandWWB;26:NTAandTIOandPMMandSEPandWWB;27:NTAandTIOandSEPlg;28:NTAandTIOandSEPandWWB;29:NTAandTIOandSEPandWWBmay;30:TIOlg;31:NTAlg
    % 32:NTAandTIOandSEPandWWBb;33:NTAandTIOandSEPandWWBbmay;34:PMMsmall;35:NTAandTIOandPMMandSEPlg;36:NETPCli;37:NTAandTIOandPMMandSEPandWWBb;
    % 38:NTAandTIOandPMMandSEPandWWBbmay;39:NTAandTIOandSEPandWWBOctNov;40:TPCtrlnoWWB2;41:TPCtrlNoWWBolar
    first_name = {'Ctrl','NTA','PMM','TIO','TroPac','TPCtrl','NTA15','NTA30','AtlNino','NoWNP','NoPMM','NTAandTIO','TroPacNTA','PMMandNTA','TPCtrlG','SEP'...
        ,'NTAandTIOandSEP','NTAandTIOandPMMandSEP','NTAandTIOLgandPMMandSEP','CESM_TP','TO','NTAandTIOandPMMandSEPandWNP','NTAandTIOandEP','NTAandTIOandPMMandSEP_New'...
        ,'NTAandTIOandEPandWWB','NTAandTIOandPMMandSEPandWWB','NTAandTIOandSEPlg','NTAandTIOandSEPandWWB','NTAandTIOandSEPandWWBmay','TIOlg','NTAlg'...
        ,'NTAandTIOandSEPandWWBb','NTAandTIOandSEPandWWBbmay','PMMsmall','NTAandTIOandPMMandSEPlg','NETPCli','NTAandTIOandPMMandSEPandWWBb'...
        ,'NTAandTIOandPMMandSEPandWWBbmay','NTAandTIOandSEPandWWBOctNov','TPCtrlNoWWB2','TPCtrlNoWWBolar'};
    if one >= 3 && one <= 22
        path = ['H:\CESM\Output_Data\HRK_2023ENSO_Ensemble\Exp_',first_name{one},'\Exp_',first_name{one},'_1217_']
    elseif one >= 23 && one <= 39
        path = ['H:\CESM\Output_Data\HRK_2023ENSO_Ensemble\Exp_',first_name{one},'\Exp_',first_name{one},'_0110_']
    elseif one >= 40
        path = ['H:\CESM\Output_Data\HRK_2023ENSO_Ensemble\Exp_',first_name{one},'\Exp_',first_name{one},'_0318_']
    end
    for i1 = 0:10
        aimpath1 = [path,num2str(i1,'%2.2i'),'\atm\'];
        aimpath2 = [path,num2str(i1,'%2.2i'),'\ocean_daily\'];
        aimpath3 = [path,num2str(i1,'%2.2i'),'\ocean_monthly\'];
        if exist(aimpath1,'dir')~=7
            mkdir(aimpath1);
            mkdir(aimpath2);
            mkdir(aimpath3);
        end
    end
end
