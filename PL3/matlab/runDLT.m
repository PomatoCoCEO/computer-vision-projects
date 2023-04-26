function [K, R, t, error] = runDLT(xy, XYZ, D_type)

%normalize data points
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);

%compute DLT
[P_normalized] = dlt(xy_normalized, XYZ_normalized);

%denormalize camera matrix
denormalized_camera = T \ P_normalized * U;

%factorize camera matrix in to K, R and t
% ??? are we supposed to put C or t here?
if strcmp(D_type, 'QR')
    [K, R, t] = decomposeQR(denormalized_camera);
elseif strcmp(D_type, 'EXP')
    [K, R, t] = decomposeEXP(denormalized_camera);
else
    error('Unknown decomposition method. Must be EXP or QR.')
end
%compute reprojection error

error = sqError(xy, XYZ, denormalized_camera);
end