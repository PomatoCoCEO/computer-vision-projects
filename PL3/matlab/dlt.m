function [P] = dlt(xy, XYZ)
%computes DLT, xy and XYZ should be normalized before calling this function
    A = [];
    ite = 1
    for i = 1 : size(xy, 2)
        A(ite, :) = [XYZ(:,i)', zeros(1, 4), -xy(1, i) * XYZ(:,i)'];
        A(ite + 1, :) = [zeros(1, 4), XYZ(:,i)', -xy(2, i) * XYZ(:,i)'];
        ite = ite + 2;
    end
    A
    size(A)
    [U, S, V] = svd(A)
    P = [V(1:4, end) V(5:8, end) V(9:12, end)]';
    disp(A*V(:,end))
    disp(A*P(:))
end