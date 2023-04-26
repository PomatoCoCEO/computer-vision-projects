function imageu = undistort(image, k, d)
% store image dimensions
[h, w] = size(image, 1:2);
% create undistorted index matrix
[x, y] = meshgrid(1:w, 1:h);
xyw = permute(cat(3, x, y, ones(h, w)), [3 1 2]);
% convert undistorted indices to milimetric coordinates
xywh = pagemtimes(k ^ -1, xyw);
n = vecnorm(xywh(1:2, :, :) ./ xywh(3, :, :));
l = 1 + sum(d .* n .^ ((2:2:2 * numel(d))'));
% apply distortion to milimetric coordinates
xywhd = [l .* xywh(1:2, :, :); xywh(3, :, :)];
% convert distorted milimetric coordinates to indices
xywd = pagemtimes(k, xywhd);
xyd = permute(xywd(1:2, :, :) ./ xywd(3, :, :), [2 3 1]);
% index distorted image with interpolation to obtain undistorted image
f = griddedInterpolant(y, x, double(image));
imageu = uint8(f(xyd(:, :, 2), xyd(:, :, 1)));
