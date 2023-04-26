function [Img_O] = image_undistort(Img_I, K, R, t, Kd)
    % Get image size
    Kd(1) = 0.5;
    Kd(2) = 0.5;
    [rows,cols,~] = size(Img_I);

    % Generate a grid of pixel coordinates
    [x,y] = meshgrid(1:cols,1:rows);

    % Convert pixel coordinates to normalized coordinates
    Xn = (x - K(1,3)) / K(1,1);
    Yn = (y - K(2,3)) / K(2,2);
    xcenter = (cols /2 - K(1,3)) / K(1,1);
    ycenter = (rows /2 - K(2,3)) / K(2,2);

    % Apply radial distortion correction
    r2 = (Xn - xcenter).^2 + (Yn-ycenter).^2;
    pol_diff = 1 + Kd(1)*r2 + Kd(2)* r2.^2;
    Xn = xcenter + (Xn - xcenter)./ pol_diff;
    Yn = ycenter + (Yn - ycenter)./ pol_diff;

    % Convert normalized coordinates to pixel coordinates
    x = Xn * K(1,1) + K(1,3);
    y = Yn * K(2,2) + K(2,3);

    % Apply extrinsic parameters to get final output image
    P = [R t];
    Img_O = zeros(size(Img_I));
    for i=1:size(Img_I,3)
        Img_O(:,:,i) = interp2(double(Img_I(:,:,i)),double(x),double(y));
    end

    imshow(Img_O)
end