function CornerPlot(img, keypoints)
    % temp.coordinates = Pts;
    % temp.orientation = orientation;
    % temp.scale = best_sigmas;
    coords = keypoints.coordinates;
    orientation = keypoints.orientation;
    scale = keypoints.scale;
    rot_matrix = @(angle) [cos(angle) -sin(angle) ; sin(angle) cos(angle)];
    
    offset_inf = 0.5;
    offset_sup = 0.5;
    initial_points = [-offset_inf -offset_inf; offset_sup -offset_inf; offset_sup offset_sup; -offset_inf offset_sup];
    sq_pts = initial_points';

    func_scale = @(sz) (2 * ceil(3 * 2 * sqrt(2) * sz) + 1) / 2;

    % figure;
    gray_a = img;
    % imshow(gray_a / (max(max(gray_a) * 255)));
    figure();
    % imshow(img); % hold on;
    imshow(uint8(img)); hold on;
    for pos = 1:size(coords,1)
        % x, y, width, height
        
        y = coords(pos,1);
        x = coords(pos,2);
        
        % use polylines
        % initial_points = []
        orient = orientation(pos);
        rotmat = rot_matrix(orient);
        sc = func_scale(scale(pos));
        new_pts = [rotmat * sq_pts(:,1), rotmat * sq_pts(:,2), rotmat * sq_pts(:,3), rotmat * sq_pts(:,4)];
        new_pts = sc * new_pts;
        for i = 1: size(new_pts, 2)
            new_pts(:,i) = new_pts(:,i) + [x;y];
        end
        
        sq = polyshape(new_pts');
        plot(sq, 'FaceAlpha', 0,'EdgeColor',[0 1 0]); hold on;
        % plot(x,y,'r*'); hold on;
        % r=rectangle('Position',[x-offset, y-offset, size_desc*scales1(pos), size_desc*scales1(pos)], 'Rotation', orientation * (180 / pi))
    end
    hold off;

end