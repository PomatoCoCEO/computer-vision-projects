function [ K, R, C ] = decomposeQR(P)
    %decompose P into K, R and t
    % To solve Pc = 0 we use SVD(M) and choose
    % the singular vector corresponding to the 
    % smallest singular value of V
    [~, ~, v] = svd(P');
    C = v(:, end); % 3-element column vector - matrix was transposed so that the vectors were of 3 elements
    
    s = P(:, 1:3);
    s_minus_1 = inv(s);
    [K_minus_1, R_minus_1] = qr(s_minus_1);
    K = inv(K_minus_1);
    R = inv(R_minus_1);
end