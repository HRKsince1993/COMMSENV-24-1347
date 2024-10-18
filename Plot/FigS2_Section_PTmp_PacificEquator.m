clc;clear
aimpath = 'F:\2023PMM_Work\Figures_for_Publish\Figure\FigS2_Sec_PTmpA_PacEqu_2023\';
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end

five = 2;% 1:no colorbar;2:colorbar
fifth_name = {[],'Colorbar_'};

load('F:\2023PMM_Work\bin_data\SecGloEqu_PTmpA_2023.mat');
data = load('G:\ENSO_Work\bin_data\SecGloEquISO20_MonthCli1980to2022.mat');
ptmpa = sec_ptmpa;

lon_box = [125,360-85];
a = sec_lon >= lon_box(1) & sec_lon <= lon_box(2);
fig_lon = sec_lon(a);
bin_ptmpa = ptmpa(a,:,:);

a1 = bin_ptmpa(:,1,1);
a2 = ~isnan(a1);
fig_lon = fig_lon(a2);
fig_depth = sec_depth;
bin_fig1 = bin_ptmpa(a2,:,:);

a = data.sec_lon >= lon_box(1) & data.sec_lon <= lon_box(2);
fig2_lon = data.sec_lon(a);
bin_iso20 = data.iso_20_month_cli(a,:);
a1 = bin_iso20(:,1);
a2 = ~isnan(a1);
fig2_lon = fig2_lon(a2);
bin_fig2 = bin_iso20(a2,:);
%%
% a = (lon_end-lon_start)/(lat_end-lat_start);
% a = ceil(a*10)/10;
% PaperPosition = [0 0 a 1]*5;
PaperPosition = [0 0 8 4];

FontSize = 20;% 
FontSize2 = 20;% title
FontName = 'Arial';
LW = 1;
LW2 = 2;

bar = 6;
text_letter = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n'};
text_month = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','Jan (1)','Feb (1)'};
% cb_RedBlue = input_colorbar_rgb('F:\PMM_For_Paper\colorbar\cb_RedBlue_subtemp.rgb')/255;
load('F:\PMM_For_Paper\colorbar\cb_subtemp.mat');cb_RedBlue = cb_RedBlue/255;
%%
k2 = 1;
if five == 1
    k_select = 1:2:11;
elseif five == 2
    k_select = 1;
end
set(0,'DefaultFigureVisible', 'off');
for i1 = 1:length(k_select)
    k1 = k_select(i1);
    close all
    
    fig1 = bin_fig1(:,:,k1)';
    [cs,h] = contourf(fig_lon,fig_depth,fig1,'levelstep',0.05);
    hold on
    plot(fig2_lon,bin_fig2(:,k1),'color',[0,0,0],'LineWidth',LW2);
    
    hold off
    set(h,'LineColor','none');
    ax = gca;
    colormap(ax,cb_RedBlue)
    caxis([-bar,bar]);
    if five == 1
%         hc = colorbar('FontName',FontName,'FontSize',FontSize);
%         set(hc,'Tickdir','in','YTick',-bar:2:bar,'YTickLabel',-bar:2:bar)  % 朝外
%         %         set(c,'YTick',-bar:1:bar); %色标值范围及显示间隔
%         %         set(c,'YTickLabel',{'-0.6','-0.3','0.0','0.3','0.6'}) %具体刻度赋值
%         text(300,180,'Temp[℃]','rotation',90,'FontName',FontName,'FontSize',FontSize);
    elseif five == 2
            c1 = colorbar('horiz','FontName',FontName,'FontSize',FontSize);
%             c_pos = get(c1,'pos');
%         colorbar('horiz','position',[0.13,0.127,0.78,0.02],'FontName',FontName,'FontSize',FontSize);
%         text(279,328,'Temp[℃]','FontName',FontName,'FontSize',FontSize);
         PaperPosition = [-1 0 10 4];
    end
    
    clear xticklabel
%     xtick = get(gca,'xtick');
    %     str = get(gca,'xticklabel');
    %     xticklabel = strcat(str,'°');
    xtick = 140:40:360-100;
    for i2 = 1:length(xtick)
        if xtick(i2) < 180
            xticklabel{i2} = [num2str(xtick(i2)),'°E'];
        elseif xtick(i2) == 180
            xticklabel{i2} = [num2str(xtick(i2)),'°'];
        else
            xticklabel{i2} = [num2str(360-xtick(i2)),'°W'];
        end
    end
    xlabelname = 'Longitude';
    ytick = 0:50:300;
    yticklabel = ytick;
    ylabel_name = 'Depth[m]';
    
    if k2 <= 4 || five == 2
        xticklabel = [];
    end
    if mod(k2,2) ==0
        ylabel_name = [];
        yticklabel = [];
    end
    
    set(gca,'xtick',xtick,'xticklabel',xticklabel,'ytick',ytick,'yticklabel',yticklabel,'xlim',[lon_box(1),lon_box(2)],'Ylim',[0,300],'Ydir','reverse','FontName',FontName,'FontSize',FontSize);
    %     xlabel(xlabelname,'FontName',FontName,'FontSize',FontSize);
    ylabel(ylabel_name,'FontName',FontName,'FontSize',FontSize);
%     text(140,-15,['(',text_letter{k2},') ',num2str(date(k1,1),'%4i'),'.',num2str(date(k1,2),'%2.2i'),' Equatorial Pacific temperature anomaly'],'FontName',FontName,'FontSize',FontSize2);
    title(text_month{k1},'FontName',FontName,'FontSize',FontSize2)
    text(fig_lon(1),-(fig_depth(end)-fig_depth(1))/30,['(',text_letter{i1},')'],'FontName',FontName,'FontSize',FontSize2)
    %%
    pathfig = [aimpath,fifth_name{five},'FigS1',text_letter{k2},'_SecPacEqu_',num2str(date(k1,1),'%4i'),'.',num2str(date(k1,2),'%2.2i')];
    set(gcf,'PaperUnits','inches','PaperPosition',PaperPosition,'color',[1 1 1],'PaperOrientation','landscape');
    print('-djpeg','-r1000',[pathfig,'.jpg'])
    print('-dpdf','-r1000',[pathfig,'.pdf'])
    k2 = k2+1;
end