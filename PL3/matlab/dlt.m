function [P] = dlt(xy, XYZ)
%computes DLT, xy and XYZ should be normalized before calling this function
    A = [];
    for i = 1 : size(xy, 1)
        A(i, :) = [XYZ(:,i)', zeros(1, 4), -xy(1, i) * XYZ(:,i)'];
        A(i + 1, :) = [zeros(1, 4), XYZ(:,i)', -xy(2, i) * XYZ(:,i)'];
    end

    [U, S, V] = svd(A);

    P = reshape(V(:,end), [4, 3])';
end