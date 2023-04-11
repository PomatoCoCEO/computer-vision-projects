function [K, R, t, error] = runDLT(xy, XYZ)

%normalize data points

[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ)

%compute DLT
[P_normalized] = dlt(xy_normalized, XYZ_normalized)

%denormalize camera matrix

denormalized_camera = T \ P_normalized * U

%factorize camera matrix in to K, R and t

% To solve Pc = 0 we use SVD(M) and choose
% the singular vector corresponding to the 
% smallest singular value of V
[~, ~, v] = svd(denormalized_camera);
center = v(:, end);

s = denormalized_camera(:, 1:3);
[q, r] = qr(s);

%compute reprojection error

end