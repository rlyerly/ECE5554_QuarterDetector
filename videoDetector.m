close all;
clear all;

% this will have to be altered to run on someone elses computer
snapshot = zeros(100, 720, 1280,3);
vidobj = videoinput('macvideo', 1, 'YCbCr422_1280x720');
%

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

%perform transformations on snapshots

%do classification
