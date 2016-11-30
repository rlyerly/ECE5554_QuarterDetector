function nImg = normalizeImg(img)
%NORMALIZEIMG Normalize image

scale = 800 / size(img, 1);
nImg = mat2gray(imresize(img, scale));

end

