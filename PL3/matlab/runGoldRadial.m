function [K, R, t, Kd, error] = runGoldRadial(xy, XYZ, Dec_type)

%normalize data points
xy_normalized = [];
XYZ_normalized = [];

%compute DLT
[Pn] = dlt(xy_normalized, XYZ_normalized);

% Distortion Coeficient Initial Values
Kd= [0 0];

%minimize geometric error
pn = [Pn(1,:) Pn(2,:) Pn(3,:) Kd];
for i=1:20
    [pn] = fminsearch(@fminGoldRadial, pn, [], xy_normalized, XYZ_normalized);
end

%denormalize camera matrix

%factorize camera matrix in to K, R and t

%compute reprojection error

end