
clc; clear all; close all;
addpath('functions');
%%
% Change to 'Sequence1' or 'Sequence2' or 'Sequence3'
imSeq = 'Sequence1';
threshDist = 200;

dataDir = 'output';
%noise sequence labels
noiseSeq = {'a','b', 'c', 'd'};
nn=1;
% compute percentages below threshold 
for nn =1:numel(noiseSeq)
    noiseLabel = noiseSeq{nn};
    
    % dist 448
    outType = '4_';
    nameDistFile = ['e_dist_', imSeq, '_', outType, noiseLabel,'.mat'];
    locPercent{nn, 1} = get_percent_frmdist(dataDir, nameDistFile, threshDist)*100;

    % dist 338
    outType = '5_';
    nameDistFile = ['e_dist_', imSeq, '_', outType, noiseLabel,'.mat'];
    locPercent{nn, 2} = get_percent_frmdist(dataDir, nameDistFile, threshDist)*100;

end


switch imSeq
    case 'Sequence1'
        xTicklabels = {'25 U','50 U','75 U','100 U', '25 D','50 D','75 D','100 D', '25 L','50 L','75 L','100 L', '25 R','50 R','75 R','100 R'};
        xLab = 'Offset type';
        xTicRotAngle =90;
    case 'Sequence2'
        xTicklabels = 110:5:150;
        xLab = 'Zoom Factor(%)';
        xTicRotAngle = 0;
    case 'Sequence3'
        xTicklabels = [-45:5:-5, 5:5:45];
        xLab = 'Rotation angles';
        xTicRotAngle = 0;
    otherwise
        disp('undefined sequence');
        xTicklabels ='';
        xLab = '';
        xTicRotAngle = 0;
end

descImp = {'VL 4x4', 'VL 5x5'};

%separate plots
for nn =1:numel(noiseSeq)
    figure(nn), cla,
    line(1:length(locPercent{nn, 1}), [locPercent{nn, :}], 'LineWidth', 2)
    grid on
    set(gca,'XTick',1:length(locPercent{nn, 1}) )
    set(gca,'XTickLabel',xTicklabels);
    legend(descImp)
    title([imSeq, ', Noise Sequence: ', noiseSeq{nn} ]);
    xlabel(xLab)
    ylabel('Correctly Matched (%)')
    % rotate X tick labels if needed
    if xTicRotAngle~=0
        xticklabel_rotate([], xTicRotAngle,[]);
    end
end
%%
% one plot
% legend entries
legmarks{1}={'Marker','*','LineStyle','-'}
legmarks{2}={'Marker','.','LineStyle','-'}

descImp = [strcat({'SIFT 4x4 '},noiseSeq), strcat({'SIFT 5x5 '},noiseSeq)];
nn=1;
figure, cla,
plotData = [locPercent{1:4, 1:2}];
plotPos = 1:length(plotData);
if strcmp(imSeq, 'Sequence1')
    plotData = [plotData(1:4,:); nan(1,size(plotData,2));
                plotData(5:8,:); nan(1,size(plotData,2));
                plotData(9:12,:); nan(1,size(plotData,2));
                plotData(13:16,:)];
    plotPos = 1:length(plotData);
    xTicklabels = [ xTicklabels(1:4), {' '}, xTicklabels(5:8), {' '}, xTicklabels(9:12), {' '}, xTicklabels(13:16)]
end
line(plotPos, plotData, 'LineWidth', 2)
grid on
set(gca,'XTick',plotPos )
set(gca,'XTickLabel',xTicklabels);
legend(descImp)
title(imSeq);
xlabel(xLab)
ylabel('Correctly Matched (%)')
% rotate X tick labels if needed
if xTicRotAngle~=0
    xticklabel_rotate([], xTicRotAngle,[]);
end