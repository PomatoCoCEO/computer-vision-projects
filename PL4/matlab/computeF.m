function F = computeF(pts1, pts2)
% computeF:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates

% Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from correspondence '../data/some_corresp.mat'
    centroid1 = mean(pts1, 1);
    avg_dist1 = sum(vecnorm(pts1 - centroid1, 2,2)) / (size(pts1 ,1) * sqrt(2));
    t_matrix1 = [1 0 -centroid1(1); 0 1 -centroid1(2); 0 0 avg_dist1];
    pts1_w = [pts1 ones(size(pts1, 1),1)];
    tp1 = pts1_w * t_matrix1';
    tp1 = tp1 ./ tp1(:,3);

    new_dist_1 = sum(vecnorm(tp1 - [0 0 1], 2,2)) / (size(pts1 ,1) * sqrt(2));
    fprintf("New average distance 1: %f\n", new_dist_1);
    
    centroid2 = mean(pts2, 1);
    avg_dist2 = sum(vecnorm(pts2 - centroid2, 2,2)) / (size(pts2 ,1) * sqrt(2));
    t_matrix2 = [1 0 -centroid2(1); 0 1 -centroid2(2); 0 0 avg_dist2];
    pts2_w = [pts2 ones(size(pts2, 1),1)];
    tp2 = pts2_w * t_matrix2';
    tp2 = tp2 ./ tp2(:,3);

    new_dist_2 = sum(vecnorm(tp2 - [0 0 1], 2,2)) / (size(pts2 ,1) * sqrt(2));
    fprintf("New average distance 2: %f\n", new_dist_2);

    A = [];
    for i = 1 : size(pts1, 1)
        x1 = tp1(i,1);
        y1 = tp1(i,2);
        x2 = tp2(i,1);
        y2 = tp2(i,2);
        A(i, :) = [x1* x2, y1 * x2, x2, x1 * y2, y1 * y2, y2, x1, y1, 1];
    end

    [~, ~, V_A] = svd(A);
    f_vals = V_A(:,end)
    F_temp = [f_vals(1:3)'; f_vals(4:6)'; f_vals(7:9)']
    [U, S,V] = svd(F_temp);
    % force rank 2
    S(end,end) = 0;
    F_normalized = U * S * V';
    size(F_normalized)
    F = t_matrix2' * F_normalized * t_matrix1;
    % F = inv(t_matrix2) * F_normalized * t_matrix1;