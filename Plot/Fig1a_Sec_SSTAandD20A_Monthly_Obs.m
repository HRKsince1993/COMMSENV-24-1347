clc;clear

two = 1;% 1:ERA5;2:GODAS
three = 1;% 1:Equator;2:Equator North;3:Equator South;4:South Equator
four = 1;% 1:Pacific;2:Global
five = 1;% 1:no colorbar;2:colorbar
six = 6;% Colorbar 1 to 6

second_name = {'ERA5','GODAS'};
third_name = {'Equ','Equ_N','Equ_S','Equ_S2'};
fourth_name = {'Pac','Global'};
fifth_name = {[],'Colorbar_'};

switch four
    case 1 % pacific
        lon_box = [120,360-80];
        PaperPosition = [0.1 0 5 8];
    case 2 % Global
        lon_box = [0,360];
        PaperPosition = [0.1 0 8 8];
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

aimpath = ['F:\2023PMM_Work\Figures_for_Publish\Figure\Fig1_SecEquator_Monthly\ERA5JF_Color',num2str(six),'\']
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end
pathfig = [aimpath,fifth_name{five},'Fig1a_SSTA_Sec',fourth_name{four},third_name{three},'_Monthly_',second_name{two},'_Color',num2str(six)];

data1 = load('F:\2023PMM_Work\bin_data\SecGloEquISO20_Monthly_2023.mat');
data1b = load('F:\2023PMM_Work\bin_data\SecGloEquISO20_Monthly_202401to202401.mat');
data2 = load('G:\ENSO_Work\bin_data\SecGloEquISO20_MonthCli1980to2022.mat');

switch two
    case 1
        load('G:\ENSO_Work\Data_ENSO\SSTA_Global_Monthly_ERA5_1979to2023.mat');
        data3 = load('F:\ENSO_work\Data_ENSO\SSTA_Global_Monthly_ERA5_202401to202402.mat');
    case 2
        load('G:\ENSO_Work\Data_ENSO\SSTA_Global_Monthly_GODAS_1980to2023.mat');
        data3 = load('G:\ENSO_work\Data_ENSO\SSTA_Global_Monthly_GODAS_202401to202401.mat');
        data3.ssta = cat(3,data3.ssta,nan(size(data3.ssta,1),size(data3.ssta,2)));
end

a = find(lon >= lon_box(1) & lon <= lon_box(2));
b = find(lat >= lat_box(1) & lat <= lat_box(2));
c = date(:,1)>= 2023;
bin_ssta = squeeze(nanmean(ssta(a,b,c),2));
bin2_ssta = squeeze(nanmean(data3.ssta(a,b,:),2));

fig1_lon = lon(a);
fig1_date = date(c,:);
fig1 = cat(2,bin_ssta,bin2_ssta);

a = find(data1.sec_lon >= lon_box(1) & data1.sec_lon <= lon_box(2));
fig2 = data1.iso_20(a,:) - data2.iso_20_month_cli(a,:);
fig2add = data1b.iso_20(a,:) - data2.iso_20_month_cli(a,1);
fig2 = cat(2,fig2,fig2add);
fig2_lon = data1.sec_lon(a);
fig2_date = cat(1,data1.date,data1b.date);

fig2a = fig2;
fig2b = fig2;
fig2a( fig2a < 0 ) = nan;
fig2b( fig2b > 0 ) = nan;
%%
FontSize = 20;
FontSize2 = 20;
FontSize3 = 10;
FontName = 'Arial';
LW = 2;% lines
LW2 = 1;% contour
LW3 = 3;% contour

clear text_lon text_lat
for i = 1:length(lon_box)
    if lon_box(i)< 180
        text_lon{i} =[num2str(lon_box(i)),'буE'];
    elseif lon_box(i) == 180
        text_lon{i} =[num2str(lon_box(i)),'бу'];
    elseif lon_box(i) > 180 && lon_box(i) <= 360
        text_lon{i} =[num2str(360-lon_box(i)),'буW'];
    end
end
for i = 1:length(lat_box)
    if lat_box(i)< 0
        text_lat{i} =[num2str(-lat_box(i)),'буS'];
    elseif lat_box(i) == 0
        text_lat{i} =[num2str(lat_box(i)),'бу'];
    elseif lat_box(i) > 0
        text_lat{i} =[num2str(lat_box(i)),'буN'];
    end
end

text_letter = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n'};
% text_month = {'Jan(0)','Feb(0)','Mar(0)','Apr(0)','May(0)','Jun(0)','Jul(0)','Aug(0)','Sep(0)','Oct(0)','Nov(0)','Dec(0)','Jan(1)','Feb(1)'};
text_month = {'Jan/23','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','Jan/24','Feb'};

cbar = 3.55;
lv_sst = 0.1;
lv_d20 = 10;
if six == 1
    cb_RedBlue = input_colorbar_rgb('F:\PMM_For_Paper\colorbar\cb_RedBlue_SST.rgb')/255;
elseif six == 2
    cb_RedBlue = input_colorbar_rgb('F:\PMM_For_Paper\colorbar\cb_RedBlue_SST.rgb')/255;
    cb_RedBlue(13,:) = [1,1,1];
    cb_RedBlue(14,:) = [1,1,1];
    cb_RedBlue = cb_RedBlue(4:end-3,:);
    for i2 = 3:-1:0
        cb_RedBlue(end-i2,:) = cb_RedBlue(end-i2-1,:)*0.8+cb_RedBlue(end-i2,:)*0.2;
    end
elseif six == 3
    cb_RedBlue = input_colorbar_rgb('F:\PMM_For_Paper\colorbar\cb_RedBlue_SST52.rgb')/255;
    cb_RedBlue(26:27,:) = ones(2,3);
elseif six == 4
    cb_RedBlue = input_colorbar_rgb('F:\PMM_For_Paper\colorbar\cb_RedBlue_SST104.rgb')/255;
    cb_RedBlue(52:53,:) = ones(2,3);
elseif six == 5
    cb_RedBlue = input_colorbar_rgb('F:\PMM_For_Paper\colorbar\cb_RedBlue_SST.rgb')/255;
    cb_RedBlue(13:14,:) = ones(2:3);
    % cb_RedBlue(24,:) = cb_RedBlue(23,:)*0.6+cb_RedBlue(24,:)*0.4;
    cb_RedBlue = cb_RedBlue(1+1:end-1,:);
    for i2 = 4:-1:0
        cb_RedBlue(end-i2,:) = cb_RedBlue(end-i2-1,:)*0.8+cb_RedBlue(end-i2,:)*0.2;
    end
elseif six == 6
    cbar = 3.55;
    lv_ssta = 0.2;
    cb_RedBlue = input_colorbar_rgb('F:\PMM_For_Paper\colorbar\cb_RedBlue_SST.rgb')/255;
    cb_RedBlue(13:14,:) = ones(2:3);
    % cb_RedBlue(24,:) = cb_RedBlue(23,:)*0.6+cb_RedBlue(24,:)*0.4;
    cb_RedBlue = cb_RedBlue(1+1:end-1,:);
    for i2 = 4:-1:0
        cb_RedBlue(end-i2,:) = cb_RedBlue(end-i2-1,:)*0.8+cb_RedBlue(end-i2,:)*0.2;
    end
end
%%
close all
[cs,h] = contourf(fig1_lon,1:size(fig1,2),fig1','levelstep',lv_sst);
hold on
% [cs2,h2] = contour(fig2_lon,fig2_date(:,3),fig2','color',[0,0,0],'LineWidth',LW2,'LineStyle','-','levelstep',lv_d20);
% [cs2,h2] = contour(fig2_lon,1:size(fig2,2),fig2a','color',[0,0,0],'LineWidth',LW2,'LineStyle','-','levelstep',lv_d20);
% [cs3,h3] = contour(fig2_lon,1:size(fig2,2),fig2b','color',[0,0,1],'LineWidth',LW2,'LineStyle','--','levelstep',lv_d20);

ax = gca;
colormap(ax,cb_RedBlue)
% colormap(b2r(-bar,bar))
% colorbar
caxis([-cbar,cbar]);

set(h,'LineColor','none');
% set(h2,'ShowText','on','TextStep',get(h2,'LevelStep'));
% clabel(cs2,h2,'LabelSpacing',500,'FontName',FontName,'fontsize',FontSize3);
% set(h3,'ShowText','on','TextStep',get(h3,'LevelStep'));
% clabel(cs3,h3,'LabelSpacing',500,'FontName',FontName,'fontsize',FontSize3);

% xtick = get(gca,'xtick');
% ytick = get(gca,'ytick');
% str = get(gca,'xticklabel');
xtick = 140:40:360-100;
clear ytick xticklabel yticklabel
for i2 = 1:length(xtick)
    if xtick(i2) < 180 && xtick(i2) > 0
        xticklabel{i2} = [num2str(xtick(i2)),'буE'];
    elseif xtick(i2) == 180 || xtick(i2) == 0
        xticklabel{i2} = [num2str(xtick(i2)),'бу'];
    else
        xticklabel{i2} = [num2str(360-xtick(i2)),'буW'];
    end
end

ytick = 1:14;
% for i2 = 1:length(ytick)
%     yticklabel{i2} = [num2str(fig1_date(ytick(i2),1)),'.',num2str(fig1_date(ytick(i2),2),'%2.2i')];
% end
yticklabel = text_month;

if five == 2
    colorbar('horiz','FontName',FontName,'FontSize',FontSize);
    xticklabel = [];
end

a = find(fig1_date(:,1) == 2023 & fig1_date(:,2) == 1);
ylim([a,size(fig1,2)]);
set(gca,'xtick',xtick,'xticklabel',xticklabel,'ytick',ytick,'yticklabel',yticklabel,'Layer','top','FontSize',FontSize,'FontName',FontName,'ydir','reverse');
xtickangle(0)
% text(fig_lon(end)+40,180,'SSTA[буC]','rotation',90,'FontName',FontName,'FontSize',FontSize,'Interpreter','None');
% title('SST and D20','FontName',FontName,'FontSize',FontSize2,'Interpreter','None');
text(fig1_lon(1),ytick(1)-(ytick(end)-ytick(1))/30,'(a)','FontName',FontName,'FontSize',FontSize2,'Interpreter','None');
% text(190,ytick(1)-(ytick(end)-ytick(1))/30,['OBS from ',second_name{two}],'FontName',FontName,'FontSize',FontSize2,'Interpreter','None');
title(['OBS'],'FontName',FontName,'FontSize',FontSize2,'Interpreter','None');

% xlabel('Monthly ERA5','FontName',FontName,'FontSize',FontSize2,'Interpreter','None');
%%
% figure('Position', [left, bottom, width, height]);[560,527,560,420]
set(gcf,'PaperUnits','inches','Position', [550,527,560,420],'PaperPosition',PaperPosition,'color',[1 1 1]);
print('-djpeg','-r1000',[pathfig,'.jpg']);
print('-dpdf',[pathfig,'.pdf']);
% saveas(gcf,[pathfig,'.pdf']);
%%
colorbar('FontSize',FontSize,'FontName',FontName)
% ylabel(colorbar,'SST[буC]','FontSize',FontSize,'FontName',FontName)
% title([fourth_name{four},third_name{three},'[',text_lon{1},'-',text_lon{2},', ',text_lat{1},'-',text_lat{2},'] SSTA and D20A'],'FontName',FontName,'FontSize',FontSize2,'Interpreter','None');

pathfig2 = [aimpath,'Colorbar_Fig1a_SSTA_Sec',fourth_name{four},third_name{three},'_Monthly_ERA5'];
set(gcf,'PaperUnits','inches','Position',[560,527,560,420],'PaperPosition',PaperPosition,'color',[1 1 1]);
print('-djpeg','-r1000',[pathfig2,'.jpg']);
print('-dpdf','-r1000',[pathfig2,'.pdf']);
