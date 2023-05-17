function F = computeF(pts1, pts2)
% computeF:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates

% Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from correspondence '../data/some_corresp.mat'
    [pnl, t_matrixl] = normalize2d(pts1);
    [pnr, t_matrixr] = normalize2d(pts2);
    F_normalized = estimateF(pnl, pnr);
    % force rank 2

    F_pixels = t_matrixr' * F_normalized * t_matrixl;
    F = F_pixels;
    % F = refineF(F_pixels, pts1, pts2);
end    
