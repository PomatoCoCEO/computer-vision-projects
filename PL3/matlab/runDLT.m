function [K, R, t, error] = runDLT(xy, XYZ)

%normalize data points
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ)

%compute DLT
[P_normalized] = dlt(xy_normalized, XYZ_normalized)

%denormalize camera matrix

denormalized_camera = T \ P_normalized * U

%factorize camera matrix in to K, R and t
% ??? are we supposed to put C or t here?
[K, R, t] = decomposeQR(denormalized_camera);

%compute reprojection error
sq_error = 0;

for i = 1 : size(xy_normalized, 2)
    p2d = xy(:,i)'
    p3d = [XYZ(:,i); 1];
    p2d_reconstructed = denormalized_camera * p3d
    sq_error = sq_error + sqrt((p2d_reconstructed(1) - p2d(1))^2 + (p2d_reconstructed(2) - p2d(2))^2);
end
error = sq_error;
end