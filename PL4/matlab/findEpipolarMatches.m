function [pts2] = findEpipolarMatches(im1, im2, F, pts1)
% findEpipolarMatches:
%   Args:
%       im1:    Image 1
%       im2:    Image 2
%       F:      Fundamental Matrix from im1 to im2
%       pts1:   coordinates of points in image 1
%   Returns:
%       pts2:   coordinates of points in image 2
%
    
    neigh_size=5;
    pts1_w = [pts1 ones(size(pts1, 1),1)];
    line_coords = pts1_w * F;
    xs = 1:size(im2, 2);

    padded1 = padarray(im1, [neigh_size neigh_size], 'replicate', 'both');
    padded2 = padarray(im2, [neigh_size neigh_size], 'replicate', 'both');
    pts2 = [];

    for i = 1 :size(line_coords)
        a = line_coords(i, 1);
        b = line_coords(i, 2);
        c = line_coords(i, 3);
        % ax + by + c = 0; y = -(ax + c)/b
        ys = round(-(a.*xs+c)/b);
        size(ys)
        %{
        subplot(121);
        imshow(im1); hold on;
        plot(pts1(i,1), pts1(i,2), 'Marker','*');
        hold off;
        subplot(122);
        imshow(im2); hold on;
        plot(xs, ys); hold on;
        %}
        best_pos = 1;
        best_val = inf;
        y1=pts1(i,2);
        x1= pts1(i,1);
        filter1 = padded1(y1:y1+2*neigh_size, x1:x1+2*neigh_size);
        for j = 1:size(xs,2)
            if ys(j) < 1 || ys(j) > size(im2,1)
                continue
            end
            x2 = xs(j);
            y2 = ys(j);
            filter2 = padded2(y2:y2+2*neigh_size, x2:x2+2*neigh_size);
            test_sum = sum((filter1 - filter2).^2,[1 2]);
            if best_pos == -1 || best_val > test_sum
                best_val = test_sum;
                best_pos = j;
            end
        end

        %{
        plot(xs(best_pos), ys(best_pos),'Marker', '*'); hold off;
        input("Check these stuff");
        %}
        pts2 = [pts2; xs(best_pos) ys(best_pos)];
    end
    


