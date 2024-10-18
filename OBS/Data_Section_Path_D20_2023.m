clc;clear
aimpath = 'F:\2023PMM_Work\bin_data\';
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end

load('F:\2023PMM_Work\bin_data\SecGloEqu_PTmp_2023.mat')

savepath = [aimpath,'SecGloEquISO20_Monthly_2023.mat'];
%%
iso_20 = nan(size(sec_ptmp,1),size(sec_ptmp,3));
for i1 = 1:size(sec_ptmp,3)
    bin_sec = sec_ptmp(:,:,i1);
    for i2 = 1:size(sec_ptmp,1)
        pro = bin_sec(i2,:);
        
        if sum(isnan(pro)) >= length(pro)-5
            continue
        end
        
        a = ~isnan(pro);
        pro2 = pro(a);
        sec_d = sec_depth(a);
        
        if min(pro2) > 20 || max(pro2) < 20
            continue
        end
        
        for i3 = 1:length(pro2)
            p_temp = pro2(i3);
            if p_temp == 20
                iso_20(i2,i1) = sec_d(i3);
            elseif p_temp < 20
                iso_20(i2,i1) = interp1([pro2(i3-1),pro2(i3)],[sec_d(i3-1),sec_d(i3)],20,'linear');
                break
            end
        end
    end
end
%%
contourf(iso_20)
%%
save(savepath,'iso_20','date','sec_lon');