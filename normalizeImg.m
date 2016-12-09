function nImg = normalizeImg(img)
%NORMALIZEIMG Normalize image

if ~ismatrix(img)
    img = rgb2gray(img);
end
%scale = 800 / size(img, 1);
img = imsharpen(img, 'Radius', 11, 'Amount', 1.7);

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
if (~eq(length(row),0) )
    [rmin, I] = min(row);
    [rmax, I] = max(row);
    [cmin, I] = min(col);
    [cmax, I] = max(col);
    rRange = rmin:rmax;
    cRange = cmin:cmax;
    img = img(rRange,cRange,:);
end

nImg = imresize(img, [800 800]);


end

