function locPercent = get_percent_frmdist(dataDir, filename, threshold)
% this function calculates how many distances matches particular threshold
% distances should be load form output folder
% returns for each image array

% load and extract variable
s = load( fullfile(dataDir, filename) );
varName= fieldnames(s);
estDistAll = eval(['s.',varName{1}]);
clear 's', 'varName';

% for each image distance compute matches within threshold
locPercent= zeros(1, length(estDistAll));
for ii=1:length(estDistAll)
    estDist= estDistAll{ii};
    numberOfMatches= numel(estDist);
    checkDist = (estDist < threshold);
    % save in array
    locPercent(ii) = sum(checkDist)/numberOfMatches; 
end
    locPercent = locPercent';
end