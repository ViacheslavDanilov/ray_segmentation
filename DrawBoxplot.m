figure1 = figure;
axes1 = axes('Parent',figure1);
h = boxplot(acc_brain,'Notch','off','Labels',{'?/4', '?/8', '?/16', '?/32', 'Best'},... 
            'MedianStyle', 'line', 'FullFactors', 'on');
set(h,{'linew'},{1.5})
xlim(axes1,[0.5 5.5]);
ylim(axes1,[0.5 1.0]);
xlabel('\Delta\phi')
ylabel('Accuracy');
box(axes1,'on');
set(axes1,'FontName','Times New Roman','FontSize', 36,'TickLabelInterpreter',...
    'none','XTick',[1 2 3 4 5],'XTickLabel',{'?/4','?/8','?/16','?/32','Best'},'YGrid',...
    'on');
hold on
% plot(mean(acc(:,1)), 'dg')
% plot(mean(acc(:,2)), '*',...
%     'LineWidth', 1, ... 
%     'MarkerEdgeColor', 'g', ...
%     'MarkerSize', 10)
hold off
%%
figure1 = figure;
axes1 = axes('Parent',figure1);
h = boxplot(pTime*1000,'Notch','off','Labels',{'?/4', '?/8', '?/16', '?/32'});
set(h,{'linew'},{1.5})
xlim(axes1,[0.5 4.5]);
ylim(axes1,[0.0 30]);
xlabel('\Delta\phi')
% ylabel('Processing time');
box(axes1,'on');
set(axes1,'FontName','Times New Roman','FontSize', 36,'TickLabelInterpreter',...
    'none','XTick',[1 2 3 4],'XTickLabel',{'?/4','?/8','?/16','?/32'},'YGrid',...
    'on');