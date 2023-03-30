a = imread('../datasets/graf/img1.ppm');

gray_a= double(rgb2gray(a))/255;

hc = HarrisCorner(gray_a, 0.5, 1,2, 7);

ys = hc(:,1);
xs=  hc(:,2);

kpoints = KeypointsDetection(gray_a, hc);

CornerPlot(gray_a, kpoints);

% imshow(a); hold on; plot(xs, ys, 'r+');
% kdet = KeypointsDetection(gray_a, hc);
% KeypointPlot(gray_a);
