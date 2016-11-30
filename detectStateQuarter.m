function state = detectStateQuarter(fn, db, detector)
%DETECTSTATEQUARTER Detect & report the state of a quarter

% Get features from the current image
img = rgb2gray(normalizeImg(imread(fn)));
points = detector.detectFeatures(img);
%[features, valid_points] = extractFeatures(img, points);
[features, ~] = extractFeatures(img, points);

% Compare image to those in the database to see how well they match
keys = db.getKeys();
minDistance = Inf;
state = 'n/a';
for i = 1:numel(keys)
    curQuarter = db.getQuarter(keys{i});
    [indexPairs, distances] = matchFeatures(features, ...
        curQuarter.features);
    
    if size(indexPairs, 1) > 0
        avgDistance = mean(abs(distances));
        if avgDistance < minDistance
            minDistance = avgDistance;
            state = keys{i};
        end
        
        % Display matched keypoints
        %matchedPoints1 = valid_points(indexPairs(:,1),:);
        %matchedPoints2 = curQuarter.points(indexPairs(:,2),:);
        %figure;
        %showMatchedFeatures(img, curQuarter.img, matchedPoints1, matchedPoints2);
    end
end

end

