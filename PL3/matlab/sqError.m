function sq_error = sqError(xy, XYZ, P)
    sq_error = 0;
    for i = 1 : size(xy, 1)
        p2d = xy(1:2,i);
        p3d = [XYZ(1:3,i); 1];
        p2d_reconstructed = P * p3d;
        p2d_reconstructed = p2d_reconstructed / p2d_reconstructed(3);
        sq_error = sq_error + sqrt((p2d_reconstructed(1) - p2d(1))^2 + (p2d_reconstructed(2) - p2d(2))^2);
    end
   
end