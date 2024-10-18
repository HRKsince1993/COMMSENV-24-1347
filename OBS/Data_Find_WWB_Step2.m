clc;clear
aimpath = ['F:\2023PMM_Work\bin_data\Find_WWB_Method\'];
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end
pathfig = [aimpath,'Step2_2023TauxA'];
savepath = [aimpath,'Step2_2023TauxA'];

yu_wwb = 0.05;
bar = 0.1;
lv_wind = 0.002;
lv_wind2 = 0.03;
lon_box = [120,360-80];
PaperPosition = [0 0 5 8];
lat_box = [-5,5];

load('F:\ENSO_Work\Data_ENSO\TauAx_Tropical_Daily_ERA5_2023.mat');

a = find(lon >= lon_box(1) & lon <= lon_box(2));
b = find(lat >= lat_box(1) & lat <= lat_box(2));

fig_lon = lon(a);
fig_date = date;
fig1 = squeeze(mean(tauxa(a,b,:),2));
fig1(fig1 < yu_wwb) = nan;

wwb_year = zeros(size(fig1))+2023;bin2 = zeros(size(fig1));
wwb_month = [];
wwb_day = [];
wwb_lon = [];
for i1 = 1:size(fig1,1)
    wwb_month = cat(1,wwb_month,date(:,2)');
end
for i1 = 1:size(fig1,1)
    wwb_day = cat(1,wwb_day,date(:,2)');
end
for i1 = 1:size(fig1,2)
    wwb_lon = cat(2,wwb_lon,fig_lon);
end
for i1 = 1:size(fig1,2)
    bin2(:,i1) = i1;
end

wwb_year(isnan(fig1)) = nan;
wwb_month(isnan(fig1)) = nan;
wwb_day(isnan(fig1)) = nan;
wwb_lon(isnan(fig1)) = nan;
wwb = fig1;
save([savepath,'.mat'],'wwb_year','wwb_month','wwb_day','wwb_lon','date','yu_wwb','wwb','fig_lon');
%%
FontSize = 15;
FontSize2 = 15;
FontSize3 = 10;
FontName = 'Times New Roman';
LW = 2;% lines
LW2 = 3;% contour
LW3 = 1;% contour

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
text_month = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','Jan(1)','Feb(1)'};
%%
close all
% [cs,h] = contourf(bin_lon,1:size(fig1,2),fig1','levelstep',lv_wind);
[cs,h] = contourf(wwb_lon,bin2,fig1,'levelstep',lv_wind);
hold on
% [cs2,h2] = contour(bin_lon,1:size(fig1,2),fig1','color',[0,0,0],'levelstep',lv_wind2);
[cs2,h2] = contour(wwb_lon,bin2,fig1,'color',[0,0,0],'levelstep',lv_wind2);

colormap(b2r(-bar,bar))
caxis([-bar,bar]);

set(h,'LineColor','none');

xtick = get(gca,'xtick');
% ytick = get(gca,'ytick');
% str = get(gca,'xticklabel');
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

ytick = find(fig_date(:,3) == 1);
for i2 = 1:length(ytick)
    yticklabel{i2} = [num2str(fig_date(ytick(i2),1)),'.',num2str(fig_date(ytick(i2),2),'%2.2i')];
end
yticklabel = text_month;
% set(h2,'ShowText','on','TextStep',get(h2,'LevelStep')*2);
% clabel(cs2,h2,'FontName',FontName,'fontsize',FontSize3);

colorbar('FontName',FontName,'FontSize',FontSize);
set(gca,'xtick',xtick(1:2:end),'xticklabel',xticklabel(1:2:end),'ytick',ytick,'yticklabel',yticklabel,'Layer','top','FontSize',FontSize,'FontName',FontName,'ydir','reverse');
title('2023 TauxA','FontSize',FontSize,'FontName',FontName);
%%
set(gcf,'PaperUnits','inches','PaperPosition',PaperPosition,'color',[1 1 1]);
% print('-djpeg','-r1000',[pathfig,'.jpg']);