clc;clear
aimpath = 'F:\2023PMM_Work\Data_Ensemble\Exp_CESM_LP\Temp_Casely\';
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end

data = load('F:\2023PMM_Work\Data_Ensemble\Exp_CESM_LP\Temp_Climate_LP\Temp_CliForLP.mat');
depth = data.depth;

i1 = 1;% case
i2 = 1;% depth
path1 = ['F:\2023PMM_Work\Data_Ensemble\Exp_CESM_LP\LP_ctrl\2023_LP_',num2str(i1),'\ocn\TEMP',num2str(depth(i2)*100),'.pop.nc']
ncdisp(path1)
time = ncread(path1,'time');
lon = ncread(path1,'lon');
lat = ncread(path1,'lat');
%%
for i1 = 0:10
    clear bin_temp
    for i2 = 1:length(depth)
        path1 = ['F:\2023PMM_Work\Data_Ensemble\Exp_CESM_LP\LP_ctrl\2023_LP_',num2str(i1),'\ocn\TEMP',num2str(depth(i2)*100),'.pop.nc'];
        bin_temp(:,:,:,i2) = ncread(path1,'TEMP');
    end
    temp = bin_temp;
    
    a = lat >= -5 & lat <= 5;
    sec_temp = squeeze(mean(temp(:,a,:,:),2));
    
    save([aimpath,'Temp_LP_Case',num2str(i1,'%2.2i'),'.mat'],'lon','lat','depth','time','temp','sec_temp');
end
