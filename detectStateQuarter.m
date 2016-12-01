function [state, in, d] = detectStateQuarter(fn, db, detector)
%DETECTSTATEQUARTER Detect & report the state of a quarter

% Get features from the current image
img = imread(fn);
if ~ismatrix(img)
    img = rgb2gray(img);
end
img = normalizeImg(img);
%img = imbinarize(img, .85);
%[centers, radii] = imfindcircles(img,[25 length(img)],'ObjectPolarity','bright', ...
%    'Sensitivity',0.92, 'EdgeThreshold',0.2);
%    if ~isempty(centers)
%        yRange = floor(centers(1))-floor(radii(1)):floor(centers(1))+floor(radii(1));
%        xRange = floor(centers(2))-floor(radii(1)):floor(centers(2))+floor(radii(1));
%        img = img(xRange,yRange,:);
%    end
points = detector.detectFeatures(img);
[features, points] = extractFeatures(img, points);
imshow(img)
hold on; plot(points); hold off;

% Compare image to those in the database to see how well they match
keys = db.getKeys();
minDistance = Inf;
state = 'n/a';
for i = 1:numel(keys)
    curQuarter = db.getQuarter(keys{i});
    cqFeatures = curQuarter.features;
    %[indexPairs, distances] = matchFeatures(features, qFeatures, 'Method', 'Exhaustive', 'MaxRatio', .4);
    [indexPairs, distances] = matchFeatures(features, cqFeatures);    
    if size(indexPairs, 1) > 0
        avgDistance = mean(abs(distances));
        if avgDistance < minDistance
            minDistance = avgDistance;
            in = indexPairs;
            d = distaces;
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

