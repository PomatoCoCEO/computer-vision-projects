% A test script using coords.mat
%
% Write your code here
%

% save extrinsic parameters for dense reconstruction

im1 = im2double(imread("../data/im1.png"));
im2 = im2double(imread("../data/im2.png"));
load("../data/correspondences.mat", 'pts1', 'pts2');
load("../data/intrinsics.mat", 'K1', 'K2');

% fundamental matrix, calculated from the various points imported
F = computeF(pts1, pts2);
% essential matrix, which allows the conversion of 2d metric points between
% the 2 images

displayEpipolar(im1, im2, F);

load()






save('../data/extrinsics.mat', 'R1', 't1', 'R2', 't2');
