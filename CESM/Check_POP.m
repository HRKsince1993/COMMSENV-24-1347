clc;clear

path1 = 'I:\CESM\Output_Data\HRK_2023ENSO_Ensamble\';
struct1 = dir(path1);
name1 = {struct1(3:end).name}';
readme = 'unit is ¡æ';

i1 = 3;
path2a = [path1,name1{4},'\'];
path2b = [path1,name1{i1},'\'];

struct1 = dir(path2a);
name2a = {struct1(3:end).name}';
struct1 = dir(path2b);
name2b = {struct1(3:end).name}';

i2 = 2;
path3a = [path2a,name2a{i2},'\ocean_daily\'];
struct = dir([path3a '*.nc']);
name3a = {struct.name}';

path3b = [path2b,name2b{i2},'\ocean_daily\'];
struct = dir([path3b '*.nc']);
name3b = {struct.name}';
clear fext struct;

i3 = 1;
ncdisp([path3a,name3a{i1}])
tlon = ncread([path3a,name3a{i1}],'TLONG');
tlat = ncread([path3a,name3a{i1}],'TLAT');
sst_a = ncread([path3a,name3a{i1}],'SST');
sst_b = ncread([path3b,name3b{i1}],'SST');
taux_a = ncread([path3a,name3a{i1}],'TAUX')*0.1;% N/m2
taux_b = ncread([path3b,name3b{i1}],'TAUX')*0.1;% N/m2
time = ncread([path3a,name3a{i1}],'time');

k = 3;
fig1 = taux_b(:,:,k) - taux_a(:,:,k);
contourf(tlon,tlat,fig1,'levelstep',0.02)
colorbar
caxis([-0.1,0.1]);
