function db = buildDatabase(detector)
%BUILDDATABASE Build database of quarters

db = QuarterDatabase();
dbFolder = 'GoodLight';
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
    img = imsharpen(img, 'Threshold', 0.25, 'Amount', 2, 'Radius', 2);
    img = normalizeImg(img);
    
    fprintf('Loading image %s into database\n', imgFilename);
    
    % Detect features from the image
    points = detector.detectFeatures(img);
    [features, valid_points] = extractFeatures(img, points);
    
    % Instantiate the quarter object & add to database
    curQuarter = Quarter(stateName, img, features, valid_points);
    db = db.addQuarter(stateName, curQuarter);
end

fprintf('Added %d quarter(s) to the database\n', db.numQuarters());

end

