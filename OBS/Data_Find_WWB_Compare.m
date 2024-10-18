clc;clear
aimpath = ['F:\2023PMM_Work\Figure\Sec_Taux_ERA5_Daily\']
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end

two = 2 % 1:Method1;2:Method2
three = 1;% 1:Equator;2:Equator North;3:Equator South;4:South Equator
four = 1;% 1:Pacific;2:Global
five = 1;% 1:no colorbar;2:colorbar
second_name = {'Method1','Method2'};
third_name = {'Equ','Equ_N','Equ_S','Equ_S2'};
fourth_name = {'Pac','Global'};
fifth_name = {[],'_Colorbar'};

bar = 0.1;
lv_wind = 0.002;
lv_wind2 = 0.03;
switch four 
    case 1 % pacific
        lon_box = [120,360-80];
        PaperPosition = [0 0 5 8];
    case 2 % Global
        lon_box = [0,360];
        PaperPosition = [0 0 8 8];
end
switch three
    case 1
        lat_box = [-5,5];
    case 2
        lat_box = [5,10];
    case 3
        lat_box = [-10,-5];
    case 4
        lat_box = [-10,0];
end

switch two 
    case 1
        data1 = load('F:\2023PMM_Work\bin_data\TauxA_WWB_Input_Daily_ERA5.mat');
    case 2
        data1 = load('F:\2023PMM_Work\bin_data\Find_WWB_Method\TauxA_WWB_Input_Daily_ERA5.mat');
end
pathfig = [aimpath,'TauxA_Sec',fourth_name{four},third_name{three},'_Daily_input_',second_name{two},fifth_name{five}];

fig_date = data1.date;
a = fig_date(:,2) == 5 | fig_date(:,2) == 10 | fig_date(:,2) == 11;
taux_wwb_day_sstgrid = data1.taux_wwb_day_sstgrid(:,:,a);
taux_wwb_day_sstgrid(isnan(taux_wwb_day_sstgrid)) = 0;
fig1 = taux_wwb_day_sstgrid(:,:,15);
contourf(fig1)

a = sum(sum(sum(taux_wwb_day_sstgrid,1),2),3)
