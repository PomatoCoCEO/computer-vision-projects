function ShowMatching(MatchList,img1,img2,Dscpt1,Dscpt2)
% Show all matches by ploting the line that connects both matched keypoints. 
% Create a composed image with the original and query image to plot the connected points.
% Allow also the possibility to visualise the 8x8 (or 5x5) feature patches
% per matching.

%Your implementation here.
% first: put the squares in the images

imshow(img1);
size_desc = size(Dscpt1.desc,2);
offset = floor(size_desc/2);

coordinates1 = Dscpt1.coordinates
orientation1 = Dscpt1.orientation
scales1 = Dscpt1.scale

for pos in 1:size(MatchList,1)
    % x, y, width, height
    [x, y] = coordinates[pos]
    rectangle('Position',[x-offset, y-offset, size_desc*scales1(pos), size_desc*scales1(pos)], 'Rotation', orientation * (180 / pi))
end

% second: put the images side by side, using a scale

lines_img1 = size(img1,1);
lines_img2 = size(img2,1);
if lines_img1 > lines_img2
    img2 = imresize(img2, [lines_img1, NaN]);
    Dscpt2 = int(lines_img1/lines_img2*Dscpt2);
else
    img1 = imresize(img1, [lines_img2, NaN]);
    Dscpt1 = int(lines_img2/lines_img1*Dscpt1)
end

% third: plot the lines between the squares


    
end
        