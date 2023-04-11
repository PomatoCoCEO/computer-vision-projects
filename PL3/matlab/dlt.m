function [P] = dlt(xy, XYZ)
%computes DLT, xy and XYZ should be normalized before calling this function
    A = [];
    ite = 1
    for i = 1 : size(xy, 2)
        A(ite, :) = [0.5*XYZ(:,i)', zeros(1, 4), -xy(1, i) * XYZ(:,i)'];
        A(ite + 1, :) = [zeros(1, 4), 0.5*XYZ(:,i)', -xy(2, i) * XYZ(:,i)'];
        ite = ite + 2;
    end
    A
    [U, S, V] = svd(A);

    P = reshape(V(:,end), [4, 3])';
end