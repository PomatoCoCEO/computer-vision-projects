function sqError = sqErrorDistort(P,k, xy, XYZ, center_coords)
    sq_error = 0;
    polinome = @(x) 1 + k(1) * x .^ 2 + k(2) * x .^ 4;
    %compute squared geometric error with radial distortion
    for i = 1 : size(xy, 1)
            p2d = xyn(1:2,i);
            p3d = [XYZn(1:3,i); 1];
            % computing projected point
            p2d_rec_no_dist = P * p3d;
            % normalization
            p2d_rec_no_dist = p2d_rec_no_dist / p2d_rec_no_dist(3);
            % computing radius
            diff = p2d_rec_no_dist - center_coords;
            r = norm(diff,2);
            p2d_reconstructed = center_coords + diff.* polinome(r);
            sq_error = sq_error + sqrt((p2d_reconstructed(1) - p2d(1))^2 + (p2d_reconstructed(2) - p2d(2))^2);
    end
end