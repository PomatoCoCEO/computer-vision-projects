function f = fminGoldRadial(p, xyn, XYZn, center_coords)
% this assumes xy, XYZ and center_coords are normalized
%reassemble P
P = [p(1:4);p(5:8);p(9:12)];
k = p(13:14);
sq_error = 0;
polinome = @(x) 1 + k(1) * x .^ 2 + k(2) * x .^ 4;
%compute squared geometric error with radial distortion
for i = 1 : size(xyn, 1)
        p2d = xyn(1:2,i);
        p3d = [XYZn(1:3,i); 1];
        p2d_rec_no_dist = P * p3d;
        p2d_rec_no_dist = p2d_rec_no_dist / p2d_rec_no_dist(3);
        diff = p2d_rec_no_dist - center_coords;
        p2d_reconstructed = center_coords + diff.* polinome(diff);
        sq_error = sq_error + sqrt((p2d_reconstructed(1) - p2d(1))^2 + (p2d_reconstructed(2) - p2d(2))^2);
end

%compute cost function value
f = sq_error;
end