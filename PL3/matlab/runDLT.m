function [K, R, t, error] = runDLT(xy, XYZ)

%normalize data points

[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ)

%compute DLT
[P_normalized] = dlt(xy_normalized, XYZ_normalized)

%denormalize camera matrix

denormalized_camera = T \ P_normalized * U

%factorize camera matrix in to K, R and t

[K, R, C] = decomposeQR(denormalized_camera)

%compute reprojection error

end