close all;
clear all;

HOGCellSize = [16 16];
if exist(trainingDataFile, 'file') == 2
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
id = info.DeviceIds{end};
c_info = imaqhwinfo(c,id);

snapshot = zeros(100, 720, 1280,3);
vidobj = videoinput(c, c_info.DeviceID, c_info.DeviceFormat);
set(vidobj, 'ReturnedColorSpace', 'RGB');
triggerconfig(vidobj, 'manual');
start(vidobj);
for ii = 1:100
    snap = getsnapshot(vidobj);
    snapshot(ii,:,:,:) = snap;
    figure(1); imagesc(snap); 
end
stop(vidobj);
delete(vidobj);

index = randi(10,1,[1,100]);
snapshot = snapshot(index);
class = zeros(10,1);
for ii = 1:10
   img = normalizeImg(snapshot(ii)); 
   features = extractHOGFeatures(img, 'CellSize', HOGCellSize);
   class(ii) = predict(SVMClassifier, features);
end
prediction = mode(class);

imagesc(snapshot(10));
title(states{prediction});
