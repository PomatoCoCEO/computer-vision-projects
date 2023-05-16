function main()
im1 = im2double(imread("../data/im1.png"));
im2 = im2double(imread("../data/im2.png"));
load("../data/correspondences.mat");
load("../data/intrinsics.mat");

% fundamental matrix, calculated from the various points imported
F = computeF(pts1, pts2);
% essential matrix, which allows the conversion of 2d metric points between
% the 2 images
E= K2' * F * K1;
displayEpipolar(im1, im2, F);




end