function [xyn, XYZn, T, U] = normalization(xy, XYZ)

%data normalization
%first compute centroid
xy_centroid = mean(xy')';
XYZ_centroid = mean(XYZ')';

%then, compute scale
mean_distance_2d = mean(vecnorm(xy - xy_centroid,2,1));
mean_distance_3d = mean(vecnorm(XYZ - XYZ_centroid, 2,1));
factor2d = mean_distance_2d / sqrt(2);
factor3d = mean_distance_3d / sqrt(3);

%create T and U transformation matrices
T = [factor2d 0 xy_centroid(1); 0  factor2d xy_centroid(2); 0 0 1];
U = [factor3d 0 0 XYZ_centroid(1); 0 factor3d 0 XYZ_centroid(2); 0 0 factor3d XYZ_centroid(3); 0 0 0 1];


%and normalize the points according to the transformations
xyn = ones([3, size(xy,2)]);
xyn(1:2,:) = xy;
XYZn = ones([4, size(XYZ,2)]);
XYZn(1:3,:) = XYZ;
disp('--------- Points -----------')
xy
disp('----------------------------')
for i = 1:size(xy, 2)
    xyn(:,i) = T \ xyn(:,i);
    XYZn(:,i) = U \ XYZn(:,i);
end

end