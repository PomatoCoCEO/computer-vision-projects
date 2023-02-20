function [img, filter_avg, img_filter_implemented, img_filter_matlab] = Assignment()
    img = double(rgb2gray(imread("../data/img00.jpg")));
    % test thing with sobel filter
    filter_avg = fspecial("sobel");
    disp('starting implemented filter passing...');
    img_filter_implemented = ImageFilter(img,filter_avg);
    disp('starting MATLAB filter passing...');
    img_filter_matlab = imfilter(img,filter_avg,'replicate','conv','same');
    fprintf("max difference detected: %d\n", max(max(abs(img_filter_matlab- img_filter_implemented))));
    fprintf("Example: first element of both: %f and %f\n",img_filter_implemented(1,1), img_filter_matlab(1,1));
end