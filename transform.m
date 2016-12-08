function [ img_t ] = transform( img )
% takes in grayscale img

[~, threshold] = edge(img, 'sobel');
BWs = edge(img, 'sobel', threshold*0.5);
se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);
BWsdil = imdilate(BWs, [se90, se0]);
BWdfill = imfill(BWsdil, 'holes');
BWnobord = imclearborder(BWdfill, 4);
seD = strel('diamond', 1);
BWfinal = imerode(BWnobord, seD);
BWfinal = imerode(BWfinal, seD);
BWoutline = bwperim(BWfinal);

[row, col] = find(double(BWoutline) > 0);

[M, I] = min(col);
r2 = row(I);
c2 = col(I);
[M, I] = max(col);
r3 = row(I);
c3 = col(I);

%this one runs, but is not helpful at all
movingPoints = [r2 c2; r3 c3];
fixedPoints = [100 0; 200 100];
tform = fitgeotrans(fixedPoints, movingPoints, 'nonreflectivesimilarity');

%me trying to set up an affine transformation. trying to find two more
%points

% line = real(cross([r2 c2 1]',[r3 c3 1]'));
% R = [0 -1 0; 1 0 0; 0 0 1];
% r_line = line'*R;

% movingPoints = [r1 c1; r2 c2; r3 c3; r4 c4];
% fixedPoints = [0 100; 100 0; 200 100; 100 200];
% tform = fitgeotrans(fixedPoints, movingPoints, 'affine');

img_t = imwarp(img, tform);


end

