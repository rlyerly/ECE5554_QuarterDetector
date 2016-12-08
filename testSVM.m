training = 'QuarterImages';
testing = 'GoodLight';
trainingDataFile = 'svmTrainingData.mat';
svmClassifierFile = 'svmClassifier.mat';
HOGCellSize = [16 16];
HOGFeatureSize = 86436; % Hardcoded for cell size = 16x16

if exist(trainingDataFile, 'file') == 2
    load(trainingDataFile);
    assert(exist('trainingFeatures', 'var') == 1, 'No training features');
    assert(exist('trainingLabels', 'var') == 1, 'No training labels');
    assert(exist('stateClasses', 'var') == 1, 'No state -> class map');
    fprintf('Loaded training data (found %d images)\n', ...
        numel(trainingLabels));
else
    %% Map states to classes
    states = {'alabama', 'alaska', 'arizona', 'arkansas', 'california', ...
        'colorado', 'connecticut', 'delaware', 'florida', 'georgia', ...
        'hawaii', 'idaho', 'illinois', 'indiana', 'iowa', 'kansas', ...
        'kentucky', 'louisiana', 'maine', 'maryland', 'massachusetts', ...
        'michigan', 'minnesota', 'mississippi', 'missouri', 'montana', ...
        'nebraska', 'nevada', 'newhampshire', 'newjersey', 'newmexico', ...
        'newyork', 'normalback', 'normalfront', 'northcarolina', ...
        'northdakota', 'ohio', 'oklahoma', 'oregon', 'pennsylvania', ...
        'rhodeisland', 'southcarolina', 'southdakota', 'tennessee', ...
        'texas', 'utah', 'vermont', 'virginia', 'washington', ...
        'westvirginia', 'wisconsin', 'wyoming'};
    classes = {};
    for i = 1:numel(states) classes{i} = i; end
    stateClasses = containers.Map(states, classes);

    %% Build database of training images
    listing = dir(training);
    numImgs = numel(listing) - 2; % Skip '.' and '..'
    trainingFeatures = zeros(numImgs, HOGFeatureSize, 'single');
    trainingLabels = zeros([numImgs 1], 'uint8');
    fprintf('Generating training features from %d images...\n', numImgs);
    for i = 1:numel(listing)
        if strcmp(listing(i).name, '.') || strcmp(listing(i).name, '..')
            continue;
        end
    
        fprintf('  -> %s\n', listing(i).name);
    
        % Parse the state's name
        suffixIdx = strfind(listing(i).name, '.');
        state = listing(i).name(1:suffixIdx(end) - 2);
        if strcmp(state, 'head') state = 'normalfront'; end
        if strcmp(state, 'ordinaryhead') state = 'normalfront'; end
        if strcmp(state, 'ordinarytail') state = 'normalback'; end
        class = stateClasses(lower(state));
    
        % Generate the image filename & load image
        imgFile = strcat(training, '/', listing(i).name);
        img = normalizeImg(imread(imgFile));
    
        % Generate & save HOG features
        trainingFeatures(i,:) = extractHOGFeatures(img, 'CellSize', HOGCellSize);
        trainingLabels(i) = stateClasses(state);
    end
    
    %% Save training data so we don't have to do this again
    save(trainingDataFile, 'trainingFeatures', ...
         'trainingLabels', 'stateClasses');
end

%% Train the SVM
if exist(svmClassifierFile, 'file') == 2
    % Load the classifier
    load(svmClassifierFile);
    assert(exist('SVMClassifier', 'var') == 1, 'No classifier');
    fprintf('Loaded pre-trained SVM classifier\n');
else
    % Train & save classifier so we don't have to do this again
    fprintf('Training the classifier on %d images...\n', ...
        numel(trainingLabels));
    SVMClassifier = fitcecoc(trainingFeatures, trainingLabels);
    save(svmClassifierFile, 'SVMClassifier');
end

%% Test the classifier
listing = dir(testing);
numImgs = numel(listing) - 2;
fprintf('Testing classifier on %d images\n', numImgs);
numCorrect = 0;
for i = 1:numel(listing)
    if strcmp(listing(i).name, '.') || strcmp(listing(i).name, '..')
        continue;
    end

    % Parse the state's name
    suffixIdx = strfind(listing(i).name, '.');
    state = listing(i).name(1:suffixIdx(end) - 1);
    class = stateClasses(lower(strrep(state, ' ', '')));

    % Generate the image filename & load image
    imgFile = strcat(testing, '/', listing(i).name);
    img = normalizeImg(imread(imgFile));

    % Generate HOG features & predict state using classifier
    features = extractHOGFeatures(img, 'CellSize', HOGCellSize);
    predictedClass = predict(SVMClassifier, features);
    if predictedClass == class numCorrect = numCorrect + 1; end
    fprintf('  -> %s: predicted %d, actual is %d\n', ...
        state, predictedClass, class);
end

fprintf('Overall accuracy: %f\n', numCorrect / numImgs);