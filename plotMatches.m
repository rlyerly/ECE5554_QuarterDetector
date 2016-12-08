testFolder = 'QuarterImages';
listing = dir(testFolder);
D = FASTDetector();
db = buildDatabase(D);
correct = 0;
for j = 1:numel(listing)
    if strcmp(listing(j).name, '.') || strcmp(listing(j).name, '..')
        continue;
    end
    
    imgName = strcat(testFolder, '/', listing(j).name);
    img = normalizeImg(rgb2gray(imread(imgName)));
    points = D.detectFeatures(img);
    [features, points] = extractFeatures(img, points);
    [state, index, d] = detectStateQuarter(imgName, db, D);
    fprintf('  -> %s was predicted as %s\n', imgName, state);
    
    name = imgName(15:end-5);
    state1 = lower(state);
    state1(state1 == ' ' ) = '';
    if (strcmp(name, state1))
        correct = correct + 1;
    end
    
    if(~strcmp(state, 'n/a'))
        im1 = imread(strcat('QuarterImages', '/', listing(j).name));
        im2 = imread(strcat('GoodLight', '/', state,'.JPG'));
        figure(1); subplot(1,2,1); imagesc( im1);
        hold on
        figure(1); subplot(1,2,2); imagesc(im2);
        hold on
        in = randi(length(d), 10,1);
        figure(1); subplot(1,2,1); plot( points.Location(index(in,1),2), points.Location(index(in,1),1),'r.', 'MarkerSize', 10);
        figure(1); subplot(1,2,2); plot(db.getQuarter(state).points.Location(index(in,2),2), db.getQuarter(state).points.Location(index(in,2),1),'r.', 'MarkerSize', 10);
    end
    
    
    
end
accuracy = correct/530;
