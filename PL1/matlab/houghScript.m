clear;

datadir     = '../data';    %the directory containing the images


%parameters
sigma     = 2.5;
threshold = 0.03;
rhoRes    = 5;
thetaRes  = pi/180;
nLines    = 50;
% percentile_value = 98;
image_threshold = 0.1;
test_no = sprintf('sigma-%.1f-edge-threshold-%.2f-rho-res-%d-theta-res-%.2fdeg-lines-%d', sigma, image_threshold, rhoRes,thetaRes * 180 / pi, nLines);

resultsdir  = sprintf('../results/test%s',test_no); %the directory for dumping results
mkdir(resultsdir);
%end of parameters

imglist = dir(sprintf('%s/*.jpg', datadir));

for i = 1:numel(imglist)
    
    %read in images%
    [path, imgname, dummy] = fileparts(imglist(i).name);
    img = imread(sprintf('%s/%s', datadir, imglist(i).name));
    
    if (ndims(img) == 3)
        img = rgb2gray(img);
    end
    
    img = double(img) / 255;
   
    %actual Hough line code function calls%  
    [Im] = EdgeFilter(img, sigma);
    % prctile(Im, percentile_value,[1,2]);
    [H,rhoScale,thetaScale] = HoughTransform(Im, image_threshold, rhoRes, thetaRes);
    [rhos, thetas] = HoughLines(H, nLines);
    lines = houghlines(Im>image_threshold, 180*(thetaScale/pi), rhoScale, [rhos,thetas],'FillGap',5,'MinLength',10);
    
    % everything below here just saves the outputs to files%
    fname = sprintf('%s/%s_01edge.png', resultsdir, imgname);
    imwrite(sqrt(Im/max(Im(:))), fname);
    fname = sprintf('%s/%s_02threshold.png',resultsdir, imgname);
    imwrite(Im > threshold, fname);
    fname = sprintf('%s/%s_03hough.png', resultsdir, imgname);
    imwrite(H/max(H(:)), fname);
    fname = sprintf('%s/%s_04lines.png', resultsdir, imgname);
    
    img2 = img;
    for j=1:numel(lines)
       img2 = drawLine(img2, lines(j).point1, lines(j).point2); 
    end     
    imwrite(img2, fname);
end
    
