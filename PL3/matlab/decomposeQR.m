function [ K, R, C ] = decomposeQR(P)
    %decompose P into K, R and t
    % To solve Pc = 0 we use SVD(M) and choose
    % the singular vector corresponding to the 
    % smallest singular value of V
    [~, ~, v] = svd(P);
    C = v(:, end);
    
    s = P(:, 1:3);
    [K, R] = qr(s);
end