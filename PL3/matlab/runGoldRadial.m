function [K, R, t, Kd, error] = runGoldRadial(xy, XYZ, Dec_type, center)

%normalize data points
[xy_normalized, XYZ_normalized, T, U] = normalization(xy(1:2,:), XYZ(1:3,:));

center_coords = T * center;

%compute DLT
[Pn] = dlt(xy_normalized, XYZ_normalized);

% Distortion Coeficient Initial Values
Kd= [0 0];

%minimize geometric error
pn = [Pn(1,:) Pn(2,:) Pn(3,:) Kd];
for i=1:20
    [pn] = fminsearch(@fminGoldRadial, pn, [], xy_normalized, XYZ_normalized, center_coords);
end

pn = [pn(1:4); pn(5:8); pn(9:12)];
Kd = pn(end-1:end);

% denormalize camera matrix
denormalized_camera = T \ pn * U;

%factorize camera matrix in to K, R and t
K = [];
R=[];
t=[];
if strcmp(Dec_type,'QR')
    [K,R,t] = decomposeQR(denormalized_camera);
elseif strcmp(Dec_type, 'EXP')
    [K,R,t] = decomposeEXP(denormalized_camera);
else
    throw(MException("Exception:InvalidArgument","Decomposition type must be QR or EXP"));
end

%compute reprojection error
rep_error = sqError(xy, XYZ, denormalized_camera);
error = rep_error;

end