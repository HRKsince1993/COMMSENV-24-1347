clc;clear
aimpath = 'F:\2023PMM_Work\Data_Ensemble\Exp_CESM_LP\D20_Casely\';
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end

data = load('F:\2023PMM_Work\Data_Ensemble\Exp_TPCtrl\D20_Casely\D20_SecEqutor_Monthly_2023-03_to_2024-02_Exp_TPCtrl_1128_01.mat');
data2 = load('F:\2023PMM_Work\Data_Ensemble\Exp_CESM_LP\Temp_Climate_LP\D20_March_CliForLP.mat');

path1 = 'F:\2023PMM_Work\Data_Ensemble\Exp_CESM_LP\Temp_Casely\';
struct = dir([path1,'*.mat']);
name1 = {struct.name}';

date = data.date;
readme = 'unit is m';

for i1 = 1:11
    load([path1,name1{i1}]);
    
    sec_ptmp = sec_temp;
    sec_depth = depth;
    sec_lon = data.sec_lon;
    
    iso_20 = nan(size(sec_ptmp,1),size(sec_ptmp,2));
    for i2 = 1:size(sec_ptmp,2)
        bin_sec = squeeze(sec_ptmp(:,i2,:));
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
    
    clear bin_iso20
    for i2 = 1:12
        bin_iso20(:,i2) = interp1(lon,iso_20(:,i2),sec_lon,'linear');
    end
    iso_20 = bin_iso20;
    iso_20a = iso_20 - data2.iso_20;
    save([aimpath,'D20_SecEqutor_Monthly_2023-03_to_2024-02_Exp_CESM_LP_1217_',name1{i1}(end-5:end-4),'.mat'],'date','sec_lon','iso_20','iso_20a','readme');
end

