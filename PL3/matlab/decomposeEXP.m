function [ K, R, t ] = decomposeEXP(P)
%decompose P into K, R and t
    % size of P is 3 lines by 4 columns
    % to get the center we do
    A = P(1:3, 1:3);
    b = P(:,4);
    C = -A\b;
    epsilon =1;
    third_col = A(:,3);
    rho = epsilon / norm(third_col);
    r3 = rho * A(:,3);
    u0 = rho ^ 2 * (a1' * a3);
    v0 = rho ^2 * (a2' * a3);
    % sin theta is always greater than 0 , since it is in the neighborhood
    % of pi/2
    epsilon_u = 1;
    epsilon_v = 1;
    cross_1_3 = cross(A(:,1), A(:,3));
    cross_2_3 = cross(A(:,2), A(:,3));
    cos_theta = - epsilon_u * epsilon_v * dot(cross_1_3,cross_2_3) / (norm(cross_1_3) * norm(cross_2_3)); 
    % fundamental formula of trigonometry :), sin(theta) > 0
    sin_theta = sqrt(1- cos_theta ^ 2);
    alpha = epsilon_u * rho ^ 2 *norm(cross_1_3) * sin_theta;
    beta = epsilon_v * rho ^ 2 *norm(cross_2_3) * sin_theta;
    r1 = cross_1_3 / norm(cross_1_3);
    r2 = cross(r3, r1);
    R = [r1 r2 r3];

    t_z = b(3);
    t_y = (b(2) - v0*t_z) * sin_theta / beta;
    t_x = (b(1) + alpha * (cos_theta / sin_theta) * t_y - u0 * t_z) / alpha;
    t = [t_x; t_y, t_z];

    K = M * pinv([R t]);
end