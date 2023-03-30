function ShowMatching(MatchList,img1,img2,Dscpt1,Dscpt2)
% Show all matches by ploting the line that connects both matched keypoints. 
% Create a composed image with the original and query image to plot the connected points.
% Allow also the possibility to visualise the 8x8 (or 5x5) feature patches
% per matching.

%Your implementation here.
% first: put the squares in the images

rot_matrix = @(angle) [cos(angle) -sin(angle); sin(angle) cos(angle)];
batch_size = @(sz) 2 * sqrt (2) * sz;
% imshow(img1);
size_desc = size(Dscpt1.desc,2);
offset_inf = floor((size_desc-1)/2);
offset_sup = floor((size_desc)/2);

initial_points = [-offset_inf -offset_inf; offset_sup -offset_inf; offset_sup offset_sup; -offset_inf offset_sup];
sq_pts = initial_points';

Descs = [Dscpt1 Dscpt2];
imgs = {img1, img2};% cat(3, img1, img2);

size(Descs(1).coordinates)

figure()
for img_no = 1:2
    subplot(2,2,img_no);
    img = imgs{img_no};
    disp("size of image ");
    size(img)
    width = size(img,2);
    imshow(img); hold on;
    txt = input('Boo');
    for pos = 1:size(Descs(img_no).coordinates, 1)
        % x, y, width, height
        
        y = Descs(img_no).coordinates(pos,1);
        x = Descs(img_no).coordinates(pos,2);
        
        % use polylines
        % initial_points = []
        orient = Descs(img_no).orientation(pos);
        rotmat = rot_matrix(orient);
        scale = Descs(img_no).scale(pos);
        new_pts = [rotmat * sq_pts(:,1), rotmat * sq_pts(:,2), rotmat * sq_pts(:,3), rotmat * sq_pts(:,4)];
        new_pts = scale * new_pts;
        for i = 1: size(new_pts, 2)
            new_pts(:,i) = new_pts(:,i) + [x;y];
        end
        
        sq = polyshape(new_pts');
        plot(sq, 'FaceAlpha', 0,'EdgeColor',[0 1 0]); hold on;
        plot(x,y,'r*'); hold on;
        % r=rectangle('Position',[x-offset, y-offset, size_desc*scales1(pos), size_desc*scales1(pos)], 'Rotation', orientation * (180 / pi))
    end
end
% resizing for the same height
lines_img1 = size(img1,1);
lines_img2 = size(img2,1);

coords1 = Dscpt1.coordinates;
coords2 = Dscpt2.coordinates;
factor1 = 1; factor2 = 1;

if lines_img1 > lines_img2
    img2 = imresize(img2, [lines_img1, NaN]);
    coords2 = floor(lines_img1/lines_img2*coords2);
    factor2 = lines_img1/lines_img2;
else
    img1 = imresize(img1, [lines_img2, NaN]);
    coords1 = floor(lines_img2/lines_img1*coords1);
    factor1 = lines_img2/lines_img1;
end
% second: put the images side by side, using a scale
subplot(2,1,2);
img_tot = [img1 img2];

% colormap('gray');
imagesc(img_tot); hold on;

for i = 1 : size(MatchList, 1)
    % plot the lines between the squares
    x1 = coords1(MatchList(i,1),2);
    y1 = coords1(MatchList(i,1),1);
    x2 = coords2(MatchList(i,2),2) + size(img1,2);
    y2 = coords2(MatchList(i,2),1);
    frac = i / size(MatchList,1);
    colorLine = hsv2rgb([frac, 1,1]);
    plot([x1 x2], [y1 y2], 'Color', colorLine, 'LineWidth', 1); hold on;
end
axis('off');
% third: plot the lines between the squares


    
end
        