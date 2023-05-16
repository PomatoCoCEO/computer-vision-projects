function F = estimateF(pnl,pnr)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    A = [];
    for i = 1 : size(pnl, 1)
        xl = pnl(i,1);
        yl = pnl(i,2);
        xr = pnr(i,1);
        yr = pnr(i,2);
        A(i, :) = [xl* xr, yl * xr, xr, xl * yr, yl * yr, yr, xl, yl, 1];
    end

    [~, ~, V_A] = svd(A);
    f_vals = V_A(:,end);
    F_temp = reshape(f_vals, 3,3);
    [U, S,V] = svd(F_temp);
    S(end, end) = 0;
    F = U * S * V';
    tot_sq = 0;
    if true
        for i = 1 : size(pnl, 1)
            tot_sq = tot_sq + (pnl(i,:) * F * pnr(i,:)')^2;
        end
        fprintf("total squared error: %.4f", tot_sq);
    end

