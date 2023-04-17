function [K, R, t, error] = runGold(xy, XYZ, Dec_type)

%normalize data points
[xy_normalized, XYZ_normalized, T, U] = normalization(xy(1:2,:), XYZ(1:3,:));

%compute DLT
[Pn] = dlt(xy_normalized, XYZ_normalized);

%minimize geometric error
pn = [Pn(1,:) Pn(2,:) Pn(3,:)];
for i=1:20
    [pn] = fminsearch(@fminGold, pn, [], xy_normalized, XYZ_normalized);
end

%denormalize camera matrix
pn = [pn(1:4); pn(5:8); pn(9:12)];

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