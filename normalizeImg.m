function nImg = normalizeImg(img)
%NORMALIZEIMG Normalize image

if ~ismatrix(img)
    img = rgb2gray(img);
end
%scale = 800 / size(img, 1);
img = imresize(img, [800 800]);
nImg = imsharpen(img, 'Radius', 11, 'Amount', 1.7);

end

