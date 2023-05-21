clear all ;
% Load image and paramters
im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');
im1 = rgb2gray(im1);
im2 = rgb2gray(im2);
load('rectify.mat', 'M1', 'M2', 'K1n', 'K2n', 'R1n', 'R2n', 't1n', 't2n');

maxDisp = 20;
windowSize = 3;
dispM = computeDisparity(im1, im2, maxDisp, windowSize,'ssd');

% --------------------  get depth map
figure; imagesc(dispM.*(im1>40)); colormap(gray); title('Disparity Map');axis image;
saveas(gcf, '../results/disparity.png');

bit_vals = [4 6 8 16];
for i = 1:length(bit_vals)
    bit_val = bit_vals(i);
    depthM = computeDepth(dispM, K1n, K2n, R1n, R2n, t1n, t2n, bit_val);
    figure; imagesc(depthM.*(im1>40)); colormap(gray); title(sprintf('Depth Map for %d bits',bit_val)); axis image;
    file_name = sprintf("../results/depth_%d_bits.png", bit_val);
    saveas(gcf, file_name);
end
% --------------------  Display


