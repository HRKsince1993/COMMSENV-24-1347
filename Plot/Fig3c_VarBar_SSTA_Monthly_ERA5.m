clc;clear
aimpath = 'F:\2023PMM_Work\Figures_for_Publish\Figure\Fig3_Map_SSTAandWindA_2023\';
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end

one = 4;% 1:SEP;2:TIO_lg;3:NTA_lg;4:NETP
first_name = {'SETP','TIO','TA','NETP'};
first_name2 = {'d','e','f','c'};
first_name3 = {'Southeastern tropical Pacific','Tropical Indian Ocean','Tropical Atlantic','Northeastern tropical Pacific'};
pathfig = [aimpath,'Fig3',first_name2{one},'_VarBar_',first_name{one},'_SSTA_Monthly'];

el_yr_ref = [1979,1982,1986,1987,1991,1994,1997,2002,2004,2006,2009,2014,2015,2018,2019,2023];
la_yr_ref = [1984,1988,1995,1998,1999,2000,2007,2010,2011,2017,2020,2021,2022];

y_text = 1.11;
box_ylim = [-1,1];
switch one
    case 1
        load('F:\2023PMM_Work\bin_data\SEP_SSTA_ERA5_1979to2023.mat');% SETP
    case 2
        load('F:\2023PMM_Work\bin_data\Mask_TIO_lg_SSTA_ERA5_1979to2023.mat');% TIO_lg
    case 3
        load('F:\2023PMM_Work\bin_data\Mask_NTA_lg_SSTA_ERA5_1979to2023.mat');% NTA_lg
    case 4
        load('F:\2023PMM_Work\bin_data\Mask_NETP_New_SSTA_ERA5_1979to2023.mat');% PMM
        y_text = 1.65;
        box_ylim = [-1,1.5];
end
%%
date2 = reshape(date(:,1),12,length(area_ssta)/12);
area_ssta2 = reshape(area_ssta,12,length(area_ssta)/12);

fig1_date = date2(1,:);
fig1 = mean(area_ssta2(3:11,:),1);

fig2_date = el_yr_ref;
fig3_date = la_yr_ref;
clear fig2 fig3
for i1 = 1:length(fig2_date)
    a = fig1_date == fig2_date(i1);
    fig2(i1) = fig1(a);
end

for i1 = 1:length(fig3_date)
    a = fig1_date == fig3_date(i1);
    fig3(i1) = fig1(a);
end
%%
if fig1(end) > 0
    fig1_r = 1;
    bin = fig1(fig1>0);
    [bin1,bin2]= sort(bin,'descend');
    fig1_num = find(bin1 == fig1(end));
else
    fig1_r = 2;
    bin = fig1(fig1<=0);
    [bin1,bin2]= sort(bin,'ascend');
    fig1_num = find(bin1 == fig1(end));
end
if fig1_num == 1
    fig1_text = '1st';
elseif fig1_num == 2
    fig1_text = '2nd';
elseif fig1_num == 3
    fig1_text = '3rd';
else
    fig1_text = [num2str(fig1_num),'th'];
end
%%
legend_name = {'El Nino','La Nina','Neutral years'};
%%
FontSize = 15;
FontSize2 = 20;
FontName = 'Arial';
LW = 5;% lines
bar_width = 0.9;

clear text_lon text_lat
for i = 1:length(lon_box)
    if lon_box(i)< 180
        text_lon{i} =[num2str(lon_box(i)),'°E'];
    elseif lon_box(i) == 180
        text_lon{i} =[num2str(lon_box(i)),'°'];
    elseif lon_box(i) > 180 && lon_box(i) < 360
        text_lon{i} =[num2str(360-lon_box(i)),'°W'];
    elseif lon_box(i) == 360
        text_lon{i} =[num2str(360-lon_box(i)),'°'];
    end
end
for i = 1:length(lat_box)
    if lat_box(i)< 0
        text_lat{i} =[num2str(-lat_box(i)),'°S'];
    elseif lat_box(i) == 0
        text_lat{i} =[num2str(lat_box(i)),'°'];
    elseif lat_box(i) > 0
        text_lat{i} =[num2str(lat_box(i)),'°N'];
    end
end

color_plot = [75,0,192 ...% 1蓝紫色
             ;255,0,255 ...
             ;1,132,127 ...% 5马尔斯绿 
             ;151,137,246 ...% 蓝紫色1
             ]/255;
%%
close all;
% h1 = bar(fig1_date,fig1,'facecolor',[0,0,0]);
h2 = bar(fig1_date,fig1,bar_width,'facecolor',color_plot(one,:));
hold on
% h2 = bar(fig2_date,fig2,bar_width,'facecolor',color_plot(one,:));
% h3 = bar(fig3_date,fig3,'facecolor',[132,60,112]/255);

if fig1_r == 1
    if fig1_num == 1
        text(fig1_date(end)+1,fig1(end)-fig1(end)/4,fig1_text,'FontSize',FontSize2,'FontName',FontName);
    else
        text(fig1_date(end)+1,fig1(end)-fig1(end)/4,fig1_text,'FontSize',FontSize2,'FontName',FontName);
    end
elseif fig1_r == 2
    text(fig1_date(end),fig1(end)-0.2,fig1_text,'FontSize',FontSize2,'FontName',FontName);
end

% if one == 1
%     l_start = fig1_date(2)-0.5;l_space = 10;l_line = 2;l_y = 0.5;
%     rectangle('Position',[l_start-0.2,1.25-l_y,31.7,0.5],'Curvature',[0,0],'FaceColor',[1,1,1]);
%     for i1 = 1:length(legend_name)
%         %     plot([l_space*(i1-1)+l_start,l_space*(i1-1)+l_line+l_start],[1.5,1.5],'LineWidth',LW,'color',color_plot(i1+1,:),'LineStyle','-');
%         rectangle('Position',[l_space*(i1-1)+l_start,1.45-l_y,l_line,0.1],'Curvature',[0,0],'FaceColor',color_plot(i1,:));
%         text(l_space*(i1-1)+l_line+l_start+0.05,1.5-l_y,legend_name{i1},'FontSize',FontSize,'FontName',FontName,'Interpreter','None');
%     end
% end

box on
grid on;
ylim(box_ylim);
xlim([fig1_date(1)-1,fig1_date(end)+4.5]);

xtick = [fig1_date(4):4:2018,fig1_date(end)];
ytick = -3:0.5:3;
% if one == 1 || one == 3
    ylabel('SSTA','FontSize',FontSize,'FontName',FontName);
    yticklabel = ytick;
% else 
%     ylabel([],'FontSize',FontSize,'FontName',FontName);
%     yticklabel = [];
% end

if one == 2 || one == 3
    xticklabel = xtick;
else 
    xticklabel = [];
end
set(gca,'xtick',xtick,'xticklabel',xticklabel,'ytick',-3:0.5:3,'yticklabel',yticklabel,'FontSize',FontSize,'FontName',FontName);
% legend(legend_name,'Location','NorthWest');
%%
text(fig1_date(1)-1,y_text,['(',first_name2{one},')'],'FontSize',FontSize,'FontName',FontName);
title(first_name3{one},'FontSize',FontSize,'FontName',FontName,'Interpreter','None');

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 9 3],'color',[1 1 1],'PaperOrientation','landscape');
print('-djpeg','-r1000',[pathfig,'.jpg']);
print('-dpdf','-r1000',[pathfig,'.pdf']);
