%close all;
%clear all;
trainingDataFile = 'svmTrainingData.mat';
SVMClassifierFile = 'svmClassifier.mat';


trainingData = load('svmTrainingData.mat');
states = keys(trainingData.stateClasses);
clear trainingData;
SVMClassifier = load(SVMClassifierFile);
SVMClassifier = SVMClassifier.SVMClassifier
HOGCellSize = [16 16];
  

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
