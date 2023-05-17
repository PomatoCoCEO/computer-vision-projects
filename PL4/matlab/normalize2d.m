function [ptsn, tn] = normalize2d(pts)
%NORMALIZE2D Normalizes 2d points to
%   Detailed explanation goes here
    centroid = mean(pts, 1);
    avg_dist = sum(vecnorm(pts - centroid, 2,2)) / (size(pts ,1) * sqrt(2));
    tn = 1/avg_dist * [1 0 -centroid(1); 0 1 -centroid(2); 0 0 avg_dist];
    pts_w = [pts ones(size(pts, 1),1)];
    % transformed points: left
    ptsn = pts_w * tn';
    ptsn = ptsn ./ ptsn(:,3);

    % new_dist = sum(vecnorm(ptsn - [0 0 1], 2,2)) / (size(pts ,1) * sqrt(2));
    % fprintf("New average distance: %f\n", new_dist);
end

