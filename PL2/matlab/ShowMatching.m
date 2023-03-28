function ShowMatching(MatchList,img1,img2,Dscpt1,Dscpt2)
% Show all matches by ploting the line that connects both matched keypoints. 
% Create a composed image with the original and query image to plot the connected points.
% Allow also the possibility to visualise the 8x8 (or 5x5) feature patches
% per matching.

%Your implementation here.
% first: put the squares in the images

imshow(img1);
size_desc = size(Dscpt1.desc,2);
offset_inf = floor((size_desc-1)/2);
offset_sup = floor((size_desc)/2);

coordinates1 = Dscpt1.coordinates;
orientation1 = Dscpt1.orientation;
scales1 = Dscpt1.scale;
initial_points = [-offset_inf -offset_inf; offset_sup -offset_inf; offset_sup offset_sup; -offset_inf offset_sup];
sq_pts = initial_points';
rot_matrix = @(angle) [cos(angle) -sin(angle); sin(angle) cos(angle)];
batch_size = @(sz) 2 * sqrt (2) * sz;

for pos = 1:size(MatchList,1)
    % x, y, width, height
    [y, x] = coordinates1(pos);
    
    
    % use polylines
    % initial_points = []
    orient = orientation1(pos);
    rotmat = rot_matrix(orient);
    scale = batch_size(scale1(pos));
    new_pts = [rotmat * sq_pts(:,1), rotmat * sq_pts(:,2), rotmat * sq_pts(:,3), rotmat * sq_pts(:,4)];
    new_pts = scale * new_pts;
    for i = 1: size(new_pts, 2)
        new_pts(:,i) = new_pts(:,i) + [y;x];
    end
    
    sq = polyshape(new_pts);
    plot(sq, 'FaceAlpha', 0,'EdgeColor',[1 0.5 0]);
    % r=rectangle('Position',[x-offset, y-offset, size_desc*scales1(pos), size_desc*scales1(pos)], 'Rotation', orientation * (180 / pi))
   
end

% second: put the images side by side, using a scale

lines_img1 = size(img1,1);
lines_img2 = size(img2,1);

desc1 = Dscpt1.desc;
desc2 = Dscpt2.desc;

if lines_img1 > lines_img2
    img2 = imresize(img2, [lines_img1, NaN]);
    desc2 = int(lines_img1/lines_img2*desc2);
else
    img1 = imresize(img1, [lines_img2, NaN]);
    desc1 = int(lines_img2/lines_img1*desc1)
end

% third: plot the lines between the squares


    
end
        