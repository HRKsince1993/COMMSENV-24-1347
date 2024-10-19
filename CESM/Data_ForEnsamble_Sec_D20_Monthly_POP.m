clc;clear

for one = 1:10 % 1:Ctrl;2:TPCtrl;3:PMM;4:SEP;5:TIOlg;6:NTAlg;7:NTAandTIOandPMMandSEPlg;8:NTAandTIOandPMMandSEPandWWBb;9:NTAandTIOandPMMandSEPandWWBbmay;
              % 10:NTAandTIOandPMMandSEPandWWBOctNov
    first_name = {'Ctrl','TPCtrl','PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb','NTAandTIOandPMMandSEPandWWBbmay'...
        ,'NTAandTIOandPMMandSEPandWWBOctNov'};
    
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