function [ Img_O ] = image_undistort(Img_I,K,R,t,Kd)
%Remove distortion from Img_I, using the Camera Decomposition K,T,C and
%Distortion Coeffients Kd
    k1 = Kd(1);
    k2 = Kd(2);
    w = size(Img_I,2);
    h = size(Img_I,1);
    [x,y] = meshgrid(1:w,1:h);
    w = ones(h,w);
    X = cat(3,x,y,w);
    % Convert to normalized coordinates - divide by the intrinsic matrix
    X = K\X;
    % Remove distortion
    r2 = sum(X(1:2,:).^2,1);
    X = X ./ X(3,:);
    x = X(1,:).*(1+k1*r2+Kd(2)*r2.^2);
    y = X(2,:).*(1+k1*r2+Kd(2)*r2.^2);
    X = [x;y;w];
    % Convert back to pixel coordinates
    X = K*X;
    % Convert to image coordinates
    x = X(1,:);
    y = X(2,:);
    % Interpolate
    Img_O = interp2(Img_I,x,y);
end