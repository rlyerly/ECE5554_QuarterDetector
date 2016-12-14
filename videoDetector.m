%close all;
%clear all;
trainingDataFile = 'svmTrainingData.mat';
SVMClassifierFile = 'svmClassifier.mat';
%SVMClassifier = load(SVMClassifierFile);
%SVMClassifier = SVMClassifier.SVMClassifier
HOGCellSize = [16 16];
%if exist(trainingDataFile, 'file') == 2
    load(trainingDataFile);
    assert(exist('trainingFeatures', 'var') == 1, 'No training features');
    assert(exist('trainingLabels', 'var') == 1, 'No training labels');
    assert(exist('stateClasses', 'var') == 1, 'No state -> class map');
    fprintf('Loaded training data (found %d images)\n', ...
        numel(trainingLabels));
   
states = {'alabama', 'alaska', 'arizona', 'arkansas', 'california', ...
        'colorado', 'connecticut', 'delaware', 'florida', 'georgia', ...
        'hawaii', 'idaho', 'illinois', 'indiana', 'iowa', 'kansas', ...
        'kentucky', 'louisiana', 'maine', 'maryland', 'massachusetts', ...
        'michigan', 'minnesota', 'mississippi', 'missouri', 'montana', ...
        'nebraska', 'nevada', 'newhampshire', 'newjersey', 'newmexico', ...
        'newyork', 'normalback', 'normalfront', 'northcarolina', ...
        'northdakota', 'ohio', 'oklahoma', 'oregon', 'pennsylvania', ...
        'rhodeisland', 'southcarolina', 'southdakota', 'statefront', 'tennessee', ...
        'texas', 'utah', 'vermont', 'virginia', 'washington', ...
        'westvirginia', 'wisconsin', 'wyoming'};

cameras = imaqhwinfo;
c = cameras.InstalledAdaptors{end};
info = imaqhwinfo(c);
id = info.DeviceIDs{end};
c_info = imaqhwinfo(c,id);

snapshot = zeros(720, 1280,3, 100);
vidobj = videoinput(c, c_info.DeviceID, c_info.SupportedFormats{1});
set(vidobj, 'ReturnedColorSpace', 'RGB');
triggerconfig(vidobj, 'manual');
start(vidobj);
while true
    snap = getsnapshot(vidobj);
    %snapshot(:,:,:, ii) = snap;
    figure(1); imagesc(snap);
    img = normalizeImg(rgb2gray(snap)); 
    features = extractHOGFeatures(img, 'CellSize', HOGCellSize);
    class = predict(SVMClassifier, features);
    if class > 0
        title(states{class});
    end
    drawnow
end
stop(vidobj);
delete(vidobj);

index = randi(100,1);
mysnapshot = snapshot(:, :, :, index);
class = zeros(10,1);
for ii = 1:10
   img = normalizeImg(rgb2gray(mysnapshot)); 
   features = extractHOGFeatures(img, 'CellSize', HOGCellSize);
   class(ii) = predict(SVMClassifier, features);
end
prediction = mode(class);

imagesc(mysnapshot);
title(states{prediction});
