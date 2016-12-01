function db = buildDatabase(detector)
%BUILDDATABASE Build database of quarters

db = QuarterDatabase();
dbFolder = '../quarters/GoodLight';
listing = dir(dbFolder);
for i = 1:numel(listing)
    if strcmp(listing(i).name, '.') || strcmp(listing(i).name, '..')
        continue;
    end
    
    % Parse the state's name
    suffixIdx = strfind(listing(i).name, '.');
    stateName = listing(i).name(1:suffixIdx(end) - 1);
    
    % Generate the image filename & load image
    imgFilename = strcat(dbFolder, '/', listing(i).name);
    img = imread(imgFilename);
    
    if ~ismatrix(img)
        img = rgb2gray(img);
    end
    

    img = imsharpen(img, 'Threshold', 0.3, 'Amount', 2, 'Radius', 2);
    img = normalizeImg(img);
    %%
    %find the center
    %[centers, radii] = imfindcircles(img,[50 length(img)],'ObjectPolarity','bright', ...
    %'Sensitivity',0.92, 'EdgeThreshold',0.2);
    %if ~isempty(centers)
    %    yRange = floor(centers(1))-floor(radii(1)):floor(centers(1))+floor(radii(1));
    %    xRange = floor(centers(2))-floor(radii(1)):floor(centers(2))+floor(radii(1));
    %    img = img(xRange,yRange,:);
    %end
    %%
    %turn the image into a binary image
    %img = imbinarize(img, .7);
    %%
    fprintf('Loading image %s into database\n', imgFilename);
    
    % Detect features from the image
    points = detector.detectFeatures(img);
    [features, valid_points] = extractFeatures(img, points);
    
    % Instantiate the quarter object & add to database
    curQuarter = Quarter(stateName, img, features, valid_points);
    db = db.addQuarter(stateName, curQuarter);
    imshow(img)
    hold on; plot(points); hold off;
    
end


fprintf('Added %d quarter(s) to the database\n', db.numQuarters());

end

