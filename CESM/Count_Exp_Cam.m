clc;clear;

for one = 41:41;% 1;Ctrl;2:NTA;3:PMM;4:TIO;5:TroPac:6£ºTPCtrl;7:NTA15;8:NTA30;9:AtlNino;10:NoWNP;11:NoPMM;12:NTAandTIO;13:TroPacNTA;14:PMMandNTA;15:TPCtrlG;16:SEP;
    % 17:NTAandTIOandSEP;18:NTAandTIOandPMMandSEP;19:NTAandTIOLgandPMMandSEP;20:TO;21:NTAandTIOandPMMandSEPandWNP;22:NTAandTIOandEP;23:NTAandTIOandPMMandSEP_New
    % 24:NTAandTIOandEPandWWB;25:NTAandTIOandPMMandSEPandWWB;26:NTAandTIOandSEPlg;27:NTAandTIOandSEPandWWB;28:NTAandTIOandSEPandWWBmay;29:TIOlg;30:NTAlg;
    % 31:NTAandTIOandSEPandWWBb;32:NTAandTIOandSEPandWWBbmay;33:PMMsmall;34:NTAandTIOandPMMandSEPlg;35:NETPCli;36:NTAandTIOandPMMandSEPandWWBb;
    % 37:NTAandTIOandPMMandSEPandWWBbmay;38:CESM_TP;39:NTAandTIOandPMMandSEPandWWBOctNov;40:TPCtrlNoWWB2;41:TPCtrlNoWWBolar
    first_name = {'Ctrl','NTA','PMM','TIO','TroPac','TPCtrl','NTA15','NTA30','AtlNino','NoWNP','NoPMM','NTAandTIO','TroPacNTA','PMMandNTA','TPCtrlG','SEP'...
        ,'NTAandTIOandSEP','NTAandTIOandPMMandSEP','NTAandTIOLgandPMMandSEP','TO','NTAandTIOandPMMandSEPandWNP','NTAandTIOandEP','NTAandTIOandPMMandSEP_New'...
        ,'NTAandTIOandEPandWWB','NTAandTIOandPMMandSEPandWWB','NTAandTIOandSEPlg','NTAandTIOandSEPandWWB','NTAandTIOandSEPandWWBmay','TIOlg','NTAlg'...
        ,'NTAandTIOandSEPandWWBb','NTAandTIOandSEPandWWBbmay','PMMsmall','NTAandTIOandPMMandSEPlg','NETPCli','NTAandTIOandPMMandSEPandWWBb'...
        ,'NTAandTIOandPMMandSEPandWWBbmay','CESM_TP','NTAandTIOandPMMandSEPandWWBOctNov','TPCtrlNoWWB2','TPCtrlNoWWBolar'};
    second_name = {'1128','1129','1217','0110','0318'};
    if one == 1
        first_name2 = '2023';
    else
        first_name2 = [];
    end
    
    if one == 5 || one == 10 || one == 11
        first_name3 = '_';
    else
        first_name3 = [];
    end
    
    if one == 23
        first_name4 = 'NTAandTIOandPMMandSEP';
    else
        first_name4 = first_name{one};
    end
        
    two = [];% 1:1128;2:1129
    if one <= 6
        two = 1;
    elseif one == 7 || one == 8
        two = 2;
    elseif one >= 9 && one <= 21
        two = 3;
    elseif one >= 22 && one <= 39
        two = 4;
    elseif one >= 40
        two = 5;
    end
    i1 = 3;
    i2 = 1;
    %%
    for i1 = 1:11 % Case
        path2a = ['H:\CESM\Output_Data\HRK_2023ENSO_Ensamble\Exp_',first_name{one}...
            ,'\Exp_',first_name{one},'_',second_name{two},'_',num2str(i1-1,'%2.2i'),'\atm\'];
        
        fext = '*.nc';
        struct = dir([path2a fext]);
        name2a = {struct.name}';
        clear fext struct;
        
        if length(name2a) ~= 12 % number of nc files
            ['i1=',num2str(i1),', error 1, ',path2a]
            continue
        end
        
        if i1 == 1
            k = 0;
        else
            k = 1;
        end
        
        for i2 = 1:length(name2a)
            if i2 <= 10
                a1 = ['test_HRK_',first_name4,first_name3,'case',first_name2,second_name{two},'_',num2str(k,'%2.2i')...
                    ,'_code_',num2str(i1-k),'.cam.h0.2023-',num2str(i2+2,'%2.2i'),'.nc'];
            else
                a1 = ['test_HRK_',first_name4,first_name3,'case',first_name2,second_name{two},'_',num2str(k,'%2.2i')...
                    ,'_code_',num2str(i1-k),'.cam.h0.2024-',num2str(i2-10,'%2.2i'),'.nc'];
            end
            a2 = name2a{i2};
            
            if strcmp(a1,a2) == 0
                ['i1=',num2str(i1),', i2=',num2str(i2),', error 2, ',path2a]
                continue
            end
        end
    end
    ['one=',num2str(one),', check cam ',first_name{one},' done']
end