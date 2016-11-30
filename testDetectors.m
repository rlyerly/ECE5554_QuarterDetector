testFolder = 'QuarterImages';
listing = dir(testFolder);

for i = 1:6
    switch i
        case 1
            D = BRISKDetector();
            fprintf('Testing BRISK detector\n');
        case 2
            D = FASTDetector();
            fprintf('Testing FAST detector\n');
        case 3
            D = HarrisDetector();
            fprintf('Testing Harris corner detector\n');
        case 4
            D = MinEigenDetector();
            fprintf('Testing MinEigen detector\n');
        case 5
            D = MSERDetector();
            fprintf('Testing MSER detector\n');
        case 6
            D = SURFDetector();
            fprintf('Testing SURF detector\n');
        otherwise
            assert(false, 'Invalid detector');
    end
    
    db = buildDatabase(D);
    
    for j = 1:numel(listing)
        if strcmp(listing(j).name, '.') || strcmp(listing(j).name, '..')
            continue;
        end
        
        imgName = strcat(testFolder, '/', listing(j).name);
        state = detectStateQuarter(imgName, db, D);
        fprintf('  -> %s was predicted as %s\n', imgName, state);
    end
end