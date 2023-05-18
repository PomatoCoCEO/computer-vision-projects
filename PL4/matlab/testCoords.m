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
F = computeF(pts1, pts2)';
% essential matrix, which allows the conversion of 2d metric points between
% the 2 images
E = computeE(F, K1, K2);

displayEpipolar(im1, im2, F);

pts_epipolar = load('../data/coords.mat','pts1');
pts1_new = pts_epipolar.pts1;
pts2_new = findEpipolarMatches(im1, im2, F, pts1_new);

Proj1 = K1 * [eye(3) zeros(3,1)];
possible_cams = camera2(E);
Proj2 = choose_camera2(possible_cams, Proj1, K2, pts1_new, pts2_new);
size(Proj2)
pts3d = triangulation3D(Proj1, pts1_new, Proj2, pts2_new);
plot3(pts3d(:,1), pts3d(:,2), pts3d(:,3),'.');
xlabel('X'); ylabel('Y'); zlabel('Z');

R1= Proj1(:,1:3);
t1 = Proj1(:,4);
R2 = Proj2(:,1:3);
t2 = Proj2(:,4);


save('../data/extrinsics.mat', 'R1', 't1', 'R2', 't2');
