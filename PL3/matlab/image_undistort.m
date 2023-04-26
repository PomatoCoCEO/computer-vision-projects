function [Img_O] = image_undistort(Img_I, K, R, t, Kd)
    % Get image size
    % Kd(1) = 0;
    % Kd(2) = 0;
    [rows,cols,~] = size(Img_I);

    % Generate a grid of pixel coordinates
    [x,y] = meshgrid(1:cols,1:rows);
    x = double(x);
    y = double(y);

    center_coords = [cols/2; rows/2; 1];
    % Convert pixel coordinates to normalized coordinates
    tot_matrix = cat(3, x, y, ones(rows, cols));
    
    matrix = permute(tot_matrix, [3 1 2]);% (x - K(1,3)) / K(1,1);
    matrix_normalized = pagemtimes(K ^ -1, matrix);
    center_normalized = K \ center_coords;
    matrix_normalized = matrix_normalized ./ matrix_normalized(3,:,:);
    center_normalized = center_normalized ./ center_normalized(3);

    r2 = matrix_normalized - center_normalized;
    norm_r2 = vecnorm(r2, 2, 1);
    % Apply radial distortion correction
    % r2 = (Xn - xcenter).^2 + (Yn-ycenter).^2;
    pol_diff =  (1 + Kd(1) * norm_r2.^2 + Kd(2) * norm_r2.^4);
    new_matrix = center_normalized + r2 .*pol_diff;
    % Convert normalized coordinates to pixel coordinates
    new_coords = pagemtimes(K, new_matrix);
    new_coords = new_coords ./ new_coords(3,:,:);

    new_coords = permute(new_coords, [2 3 1]);

    x = new_coords(:,:,1);
    y = new_coords(:,:,2);

    % Apply extrinsic parameters to get final output image
    P = [R t];
    Img_O = zeros(size(Img_I));
    for i=1:size(Img_I,3)
        Img_O(:,:,i) = interp2(double(Img_I(:,:,i)),double(x),double(y));
    end
    subplot(1,2,2);
    imshow(uint8(Img_O*255));
    subplot(1,2,1);
    imshow(uint8(Img_I*255));
    saveas(gcf, "../images/distorted_undistorted.png", 'png');

end