function [M1, M2, K1n, K2n, R1n, R2n, t1n, t2n] = ...
                        rectifyMatrices(K1, K2, R1, R2, t1, t2)
%  rectifyMatrices takes left and right camera paramters (K, R, T) and returns left
%   and right rectification matrices (M1, M2) and updated camera parameters. You
%   can test your function using the provided script q4rectify.m
    c1 = - (K1 * R1)\K1 * t1;
    c2 = - (K2 * R2)\K2 * t2;

    r1 = (c2 - c1) / norm(c2-c1,2);
    % the y axis must be perpendicular to both the x axis, r1, and the old
    % z axis, given by the third column of each rotation matrix
    r2_1 = cross(r1, R1(:,3));
    r2_2 = cross(r1, R2(:,3));
    % the new z axis is orthogonal to both axes
    r3_1 = cross(r1, r2_1);
    r3_2 = cross(r1, r2_2);

    R1n = [r1 r2_1 r3_1];
    R2n = [r1 r2_2 r3_2];

    % new intrinsic parameters: K2
    K2n = K2;
    K1n = K2;

    % new translation vectors
    t1n = - R1n * c1;
    t2n = - R2n * c2;

    % rectification matrices
    M1 = K1n * R1n /(K1 * R1n);
    M2 = K2n * R2n /(K2 * R2n);