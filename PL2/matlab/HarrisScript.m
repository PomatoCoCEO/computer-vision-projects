clear;

datadir     = '../datasets/yosemite';    %the directory containing the images
resultsdir  = '../results'; %the directory for dumping results
image_format = 'jpg';

%parameters
sigma_d  = 10;                  % Recommended. Adjust if needed.
sigma_i  = 2;                  % Recommended. Adjust if needed.
Tresh_R = 0.05;                   % Set as example. Adjust if needed.
NMS_size = 7;                 % Recommended. Adjust if needed.
Patchsize  = @(sz) 2 * sqrt(2) * sz;               % Set as example. Will depends on the scale.
Tresh_Metric = 2.5;            % Set as example. Minimum distance metric error for matching
Descriptor_type  = 'Simple';   % SIMPLE -> Simple 5x5 patch ; S-MOPS -> Simplified MOPS
Metric_type = 'RATIO';           % RATIO -> Ratio test ; SSD -> Sum Square Distance

Min_Query_features = 0;  % minimum number of 50 Harris points in Query image
%end of parameters

%----------------------------------------------------------------------------

 % Read list of Files with Homography matrices
list = dir(sprintf('%s/*.%s',datadir, image_format));

% Read QUERY Image - IMAGE 1
imglist = dir(sprintf('%s/*.%s', datadir, image_format));
[path1, imgname1, dummy1] = fileparts(imglist(1).name);
img1 = imread(sprintf('%s/%s', datadir, imglist(1).name));


if (ndims(img1) == 3)
    img1 = rgb2gray(img1);
end
    
img1 = double(img1) / 255;
   
% Detect Harris Corners %  

Pts_1 = HarrisCorner(img1,Tresh_R,sigma_d,sigma_i,NMS_size);
% Detect Keypoints 
Pts_N1 = KeypointsDetection(img1,Pts_1);
% Extract keypoints descriptors 
Dscrpt1 = FeatureDescriptor(img1,Pts_N1,Descriptor_type,Patchsize);

%---------------------------------------------------------------
% PERFORM FEATURE MATCHING between QUERY and TEST images

% Check Minumum number of Query features

if size(Dscrpt1.desc,1) > Min_Query_features

% Performs Feature Matching between MASTER image and a set of SLAVE images
    
  for i = 2:2% numel(imglist)
    
    % Read TEST images %
    [path2, imgname2, dummy2] = fileparts(imglist(i).name);
    img2 = imread(sprintf('%s/%s', datadir, imglist(i).name));
    
    % rot_matrix = @(angle) [cos(angle) -sin(angle) 0; sin(angle) cos(angle) 0; 0 0 1];
    % t_matrix = @(dx, dy) [1 0 dx; 0 1 dy; 0 0 1];
    % transform = affine2d(rot_matrix(pi/4));
    % img2= imwarp(img2, transform);

    if (ndims(img2) == 3)
        img2 = rgb2gray(img2);
    end
    
    img2 = double(img2) / 255;
   
    %actual Harris Conners code function calls%  
    Pts_2 = HarrisCorner(img2,Tresh_R,sigma_d,sigma_i,NMS_size);   
    Pts_N2 = KeypointsDetection(img2,Pts_2);
    
    [Dscrpt2] = FeatureDescriptor(img2,Pts_N2,Descriptor_type,Patchsize);
    
    disp('......')
    % disp(size(Dscrpt2.desc))
    
    %actual feature matching
    
    MatchList = FeatureMatching(Dscrpt1,Dscrpt2,Tresh_Metric,Metric_type);
    
    %Show matched keypoints and keypoint's feature patches
    
    ShowMatching(MatchList,img1,img2,Dscrpt1,Dscrpt2)
    
  end
end
    
