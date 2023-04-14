function [ K, R, C ] = decomposeQR(P)
    %decompose P into K, R and t
    % To solve Pc = 0 we use SVD(M) and choose
    % the singular vector corresponding to the 
    % smallest singular value of V
    [~, s_vals, v] = svd(P);
    C = v(:, end); 
    % the point has homogenous coordinates, we need to normalize it and take the first 3 coordinates
    C = C / C(4);
    C = C(1:3);
    % P' * C
    s = P(:, 1:3);
    s_minus_1 = inv(s);
    % C = - inv(s) * P(:,4);
    [ R_minus_1, K_minus_1] = qr(s_minus_1);

    K = inv(K_minus_1);
    R = inv(R_minus_1);
end