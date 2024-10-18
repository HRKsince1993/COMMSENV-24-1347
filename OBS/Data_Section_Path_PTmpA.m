clc;clear
aimpath = 'G:\ENSO_Work\Data_ENSO\';
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end

load(['G:\ENSO_Work\Data_ENSO\SecGloEqu_PTmp_GODAS_1980to2023.mat']);
savepath = [aimpath,'SecGloEqu_PTmpA_GODAS_',num2str(date(1,1)),'to',num2str(date(end,1))];

ptmp2 = reshape(sec_ptmp,size(sec_ptmp,1),size(sec_ptmp,2),12,size(sec_ptmp,3)/12);
ptmp_season = nanmean(ptmp2,4);
%%
sec_ptmpa = sec_ptmp;
for i = 1:size(date,1)
    sec_ptmpa(:,:,i) = sec_ptmp(:,:,i) - ptmp_season(:,:,date(i,2));
end
%%
save(savepath,'sec_ptmpa','sec_lon','sec_lat','sec_depth','date','path1','path2');


