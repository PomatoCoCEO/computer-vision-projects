function [img1] = EdgeFilter(img0, sigma)
%Your implemention
    kernel_gaussian = fspecial("gaussian", 2*ceil(3*sigma)+1, sigma);
    smoothed_image = ImageFilter(img0, kernel_gaussian);
    horizontal_filter = fspecial('sobel');% 0.5 * [1,0,-1; 2,0,-2; 1,0,-1];
    vertical_filter = fspecial('sobel')';
    vertical_differential = ImageFilter(smoothed_image, vertical_filter);
    horizontal_differential = ImageFilter(smoothed_image, horizontal_filter);
    gradient_magnitude = sqrt(vertical_differential .^2 + horizontal_differential .^2);
    img1 = gradient_magnitude;
end
    
                
        
        
