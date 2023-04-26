% Exervice 3
%
close all;

IMG_NAME = '../images/barrel.jpg';
img_I = double(imread(IMG_NAME)) / 255;
% input("Enter to continue");
image(img_I);
%axis off
axis image

% Decomposition Approach
D_type = 'EXP';
% D_type = 'EXP';

%This function displays the calibration image and allows the user to click
%in the image to get the input points. Left click on the chessboard corners
%and type the 3D coordinates of the clicked points in to the input box that
%appears after the click. You can also zoom in to the image to get more
%precise coordinates. To finish use the right mouse button for the last
%point.
%You don't have to do this all the time, just store the resulting xy and
%XYZ matrices and use them as input for your algorithms.
%[xy XYZ] = getpoints(IMG_NAME);
try 
    % tries to load the prerecorded points. if not present will ask for
    % input after corner determination
    load("../data/distorted.mat","XYZ", "xy");

catch ME
    disp("Choosing points")
    sigma_d = 1;
    sigma_i = 2;
    NMS_size = 10;
    thresh = 0.8;
    gray_img = rgb2gray(img_I);
    pts = HarrisCorner(gray_img, thresh, sigma_d, sigma_i, NMS_size);
    [xy, XYZ] = InputCorners(img_I, pts);
    save("../data/pts.mat","XYZ","xy");
end   


% load("distorted.mat");

% === Task 2 DLT algorithm ===

[K, R, t, error] = runDLT(xy, XYZ, D_type);
disp('')
fprintf('DLT error : %d\n', error);
disp('')

% === Task 3 Gold algorithm ===

[K, R, t, error] = runGold(xy, XYZ, D_type);
disp('')
fprintf('Gold error : %d\n', error);
disp('')
% === Task 4 Gold algorithm with radial distortion estimation ===

w = size(img_I, 2);
h = size(img_I, 1);

[K, R, t, Kd, error] = runGoldRadial(xy, XYZ, D_type, [w/2; h/2; 1]);
fprintf("Gold radial error: %f\n",error);

% === Bonus: Undistort input Image ===

[UImage] = image_undistort(img_I, K, R, t, Kd);
