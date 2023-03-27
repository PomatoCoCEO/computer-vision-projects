a = imread('../datasets/graf/img1.ppm');

gray_a= double(rgb2gray(a));

hc = HarrisCorner(gray_a, 0.5, 1,2, 7);

ys = hc(:,1);
xs=  hc(:,2);

imshow(a); hold on; plot(xs, ys, 'r+');
kdet = KeypointsDetection(gray_a, hc);

KeypointPlot(gray_a);
