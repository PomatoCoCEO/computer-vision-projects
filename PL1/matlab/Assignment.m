function Assignment()
 % this part can be turned into a cycle for the testing of multiple kinds
 % of filters. Still it appears to be working for both cases.
    img = double(rgb2gray(imread("../data/img00.jpg")));
    % test thing with sobel filter
    filter_sobel = fspecial("sobel");
    disp('sobel - starting implemented filter passing...');
    img_sobel_implemented = ImageFilter(img,filter_sobel);
    disp('sobel - starting MATLAB filter passing...');
    img_sobel_matlab = imfilter(img,filter_sobel,'replicate','conv','same');
    
    fprintf("sobel - max difference detected: %d\n", max(max(abs(img_sobel_matlab- img_sobel_implemented))));
    fprintf("sobel - Example: first element of both: %f and %f\n",img_sobel_implemented(1,1), img_sobel_matlab(1,1));

    filter_avg = fspecial("average",7);
    disp('average - starting implemented filter passing...');
    img_avg_implemented = ImageFilter(img,filter_avg);
    disp('average - starting MATLAB filter passing...');
    img_avg_matlab = imfilter(img,filter_avg,'replicate','conv','same');


    fprintf("average - max difference detected: %d\n", max(max(abs(img_avg_matlab- img_avg_implemented))));
    fprintf("average - Example: first element of both: %f and %f\n",img_avg_implemented(1,1), img_avg_matlab(1,1));

    % now for the edge detection pipeline
    [img_edges, img_gradient_magnitude, img_gradient_orientation] = EdgeFilter(img, 0.5);
    std_threshold = 2; % only the magnitudes with a distance of (std_threshold = 2) 
    % standard deviations from the mean will be considered for the hough filter.
    hough_threshold = mean2(img_edges) + std_threshold* std2(img_edges);
    [H, rhoScale, thetaScale] = HoughTransform(img_edges, hough_threshold, 1, pi/180);
    imshow(H);
end