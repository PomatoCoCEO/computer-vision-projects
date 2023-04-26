function [xy, XYZ]  = InputCorners(image, pts)
    XYZ = [];
    xy = [];
    for i = 1 : size(pts, 1)
        axis image
        imshow(image); hold on;
        plot([pts(i,2) pts(i,2)], [0, size(image,1)], 'g');
        plot([0, size(image,2)],[pts(i,1) pts(i,1)], 'g');
        plot(pts(i,2), pts(i,1), 'ro');
        input = inputdlg('[X Y Z](or s for skip)'); % show input dialog
        if strcmp(input{1}, 's') % if the user presses 's' then skip point
            continue;
        end
        XYZi = str2num(input{1}); % convert to number
        XYZ(:, i) = XYZi; % add a new column with the current values
        xy(:,i) = [pts(i,2); pts(i,1)];
    end
    inp = XYZ;
end