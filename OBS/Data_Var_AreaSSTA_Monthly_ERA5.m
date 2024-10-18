clc;clear;
aimpath = 'F:\2023PMM_Work\bin_data\';
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end

one = 1;% 1:Nino34;2:Nino3;3:NETP;4:NTA;5:SEP;6:TIO;7:SEP_m;8:WTIO;9:SETIO;10:NTA15;11:NTA30;12:IOBM;13:TIO_lg;14:NTA_lg;15:Nino4
two = 1;% 1:Raw;2:remove Nino3.4
time_start = 1979; time_end = 2023;
switch one
    case 1
        % enso_year = [1982,1986,1991,1994,1997,2002,2009,2015];
        lon_box = [360-170,360-120];% Nino34
        lat_box = [-5,5];% Equator
        text_name = 'Nino34';
    case 2
        lon_box = [360-150,360-90];% Nino3
        lat_box = [-5,5];
        text_name = 'Nino3';
    case 3
        lon_box = [200,250];% NETP
        lat_box = [10,30];
        text_name = 'NETP';
    case 4
        lon_box = [360-70,360];% NTA
        lat_box = [0,30];
        text_name = 'NTA_both';
    case 5
        lon_box = [360-120,360-60];% SEP
        lat_box = [-30,-10];
        text_name = 'SEP';
    case 6
        lon_box = [40,100];% TIO
        lat_box = [-10,10];
        text_name = 'TIO';
    case 7
        lon_box = [360-130,360-90];% SEP_m
        lat_box = [-20,-10];
        text_name = 'SEP_m';
    case 8
        lon_box = [50,70];% WTIO
        lat_box = [-10,10];
        text_name = 'WTIO';
    case 9
        lon_box = [90,110];% SETIO
        lat_box = [-10,0];
        text_name = 'SETIO';
    case 10
        lon_box = [360-70,360];% NTA15
        lat_box = [0,15];
        text_name = 'NTA15';
    case 11
        lon_box = [360-90,360];% NTA
        lat_box = [15,30];
        text_name = 'NTA30';
    case 12
        lon_box = [40,110];% IOBM
        lat_box = [-20,20];
        text_name = 'IOBM';
%     case 13
%         lon_box = [35,100];% TIO
%         lat_box = [-10,10];
%         text_name = 'TIO_lg';
%     case 14
%         lon_box = [360-70,360];% NTA
%         lat_box = [0,30];
%         text_name = 'NTA_lg';
    case 15
        % enso_year = [1982,1986,1991,1994,1997,2002,2009,2015];
        lon_box = [160,360-150];% Nino4
        lat_box = [-5,5];% Equator
        text_name = 'Nino4';
end

switch two 
    case 1
        load(['G:\ENSO_work\Data_ENSO\SSTA_Global_Monthly_ERA5_',num2str(time_start),'to',num2str(time_end),'.mat']);
        data2 = load('F:\ENSO_work\Data_ENSO\SSTA_Global_Monthly_ERA5_202401to202405.mat');
        date = cat(1,date,data2.date);
        ssta = cat(3,ssta,data2.ssta);
        text_name2 = [];
    case 2
        load(['F:\ENSO_work\Data_ENSO\SSTA_Nino34_Ind_ERA5_',num2str(time_start),'to',num2str(time_end),'.mat']);
        ssta = ssta_ind;
        text_name2 = '_Nino34_Ind';
end
%% Tropical
a = lon >= lon_box(1) & lon <= lon_box(2);
b = lat >= lat_box(1) & lat <= lat_box(2);
area_ssta = nanmean(nanmean(ssta(a,b,:)));
area_ssta = area_ssta(:);
%%
save([aimpath,text_name,'_SSTA',text_name2,'_ERA5_',num2str(date(1,1)),num2str(date(1,2),'%2.2i'),'to',num2str(date(end,1)),num2str(date(end,2),'%2.2i'),'.mat'],'area_ssta','date','lon_box','lat_box');
%%
a = date(:,1) == 2023 & date(:,2)==3;
area_ssta(a)
