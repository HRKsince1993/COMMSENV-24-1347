clc;clear

one = 0;% 1:PMM;2:SEP;3:TIO;4:NTA;5:NTAandTIOandPMMandSEPlg;6:NTAandTIOandPMMandSEPandWWBb
two = 1;% minus 1:TPCtrl;

first_name = {'PMM','SEP','TIOlg','NTAlg','NTAandTIOandPMMandSEPlg','NTAandTIOandPMMandSEPandWWBb'};
first_name2 = {'CESM-TP+NETP','CESM-TP+SETP','CESM-TP+TIO','CESM-TP+TA','CESM-TP+G','CESM-TP+G+WWBs'};
% first_name2 = {'NETP','SETP','TIO','TA','G','G+WWBs'};
second_name = {'TPCtrl'};

l_mon = (11:13)-2;

aimpath = ['F:\2023PMM_Work\Figures_for_Publish\Figure\FigS16_Nino34diff',second_name{two},'_Exp_NDJ_boxchart\'];
if exist(aimpath,'dir')~=7
    mkdir(aimpath);
end

pathfig = [aimpath,'FigS16_Nino34diff',second_name{two},'_Exp_NDJ_boxchart']

clear bin_fig1 bin_fig2
% Exp
for i1 = 1:5
    path1 = ['F:\2023PMM_Work\Data_Ensamble\Exp_',first_name{i1},'\SSTA_Casely\'];
    struct = dir([path1,'*.mat']);
    name1 = {struct(2:end).name}';
    for i2 = 1:length(name1)
        data = load([path1,name1{i2}]);
        bin_fig1(i2,i1) = mean(data.nino34(l_mon));
    end
end
% TPCtrl
path2 = ['F:\2023PMM_Work\Data_Ensamble\Exp_',second_name{two},'\SSTA_Casely\'];
struct = dir([path2,'*.mat']);name2 = {struct(2:end).name}';
for i2 = 1:length(name2)
    data = load([path2,name2{i2}]);
    bin_fig2(i2,:) = mean(data.nino34(l_mon));
end

clear bin_test_t bin_test_p
for i2 = 1:size(bin_fig1,2)
    pro = bin_fig1(:,i2) - bin_fig2;
    [h1,p1,ci1]=ttest(pro,0);
    bin_test_t(i2)=h1;
    bin_test_p(i2)=p1;
end
%%
FontSize = 15;
FontName = 'Arial';
LW = 2;% lines

text_letter = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n'};
% text_month = {'Jan/23','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','Jan/24','Feb'};
text_xtick = cat(2,'CESM-TP',first_name2);

color_plot = [215,0,15 ...% 中国红
    ;151,137,246 ...% 蓝紫色1
    ;75,0,192 ...% 2蓝紫色
    ;255,0,255 ... % 3紫红色
    ;1,132,127 ...;% 4马尔斯绿
    ;255,119,15]/255; % 5爱马仕橙

fig1 = cat(2,bin_fig2,bin_fig1);
%%
close all;
h = boxplot(fig1,'Symbol','','Colors',color_plot);

set(h,'LineWidth',LW)

% 修改每个箱线图的颜色
boxes = findobj(gca,'Tag','Box');
for j = 1:length(boxes)
    % 反向访问颜色数组
    patch(get(boxes(j),'XData'),get(boxes(j), 'YData'),color_plot(length(boxes)-j+1, :), ...
          'FaceAlpha',0.3,'EdgeColor',color_plot(length(boxes)-j+1, :));
end

% 修改离群值的颜色以匹配箱线图颜色
outliers = findobj(gca, 'Tag', 'Outliers');
for j = 1:length(outliers)
    % 反向访问颜色数组
    outliers(j).MarkerEdgeColor = color_plot(length(outliers)-j+1, :);
end

grid on;
ylim([0,3]);
xlim([0,7]);
xtick = 1:6;
xticklabel = text_xtick;

ytick = 0:0.5:3;
yticklabel = {0,[],1,[],2,[],3};

set(gca,'xtick',1:6,'xticklabel',xticklabel,'ytick',ytick,'yticklabel',yticklabel,'FontSize',FontSize,'FontName',FontName);
xtickangle(30)

% 获取当前坐标轴对象
ax = gca;

% 设置横坐标轴字体颜色为白色
ax.XAxis.TickLabelColor = 'white';

for i2 = 1:length(xtick)
    if i2 <= 3
        text(xtick(i2)+0.1,ytick(1)-(ytick(end)-ytick(1))/19, text_xtick{i2},'Rotation',30,'FontSize', FontSize,'FontName',FontName,'Color',[0,0,0],'HorizontalAlignment','right','VerticalAlignment','middle');
    else
        text(xtick(i2)+0.1,ytick(1)-(ytick(end)-ytick(1))/19, text_xtick{i2},'Rotation',30,'FontSize', FontSize,'FontName',FontName,'Color',[1,0,0],'HorizontalAlignment','right','VerticalAlignment','middle');
    end
end

ylabel('NDJ NINO3.4','FontSize',FontSize,'FontName',FontName);
%%
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8 4],'color',[1 1 1],'PaperOrientation','landscape');
print('-djpeg','-r1000',[pathfig,'.jpg']);
print('-dpdf','-r1000',[pathfig,'.pdf']);
