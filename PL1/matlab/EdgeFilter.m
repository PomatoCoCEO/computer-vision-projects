function [Im] = EdgeFilter(img0, sigma)
    kernel_gaussian = fspecial("gaussian", 2*ceil(3*sigma)+1, sigma);
    % disp("smoothing image...")
    smoothed_image = ImageFilter(img0, kernel_gaussian);
    horizontal_filter = fspecial('sobel');% 0.5 * [1,0,-1; 2,0,-2; 1,0,-1];
    % horizontal_filter =  0.5 * [1,0,-1; -2 ,0,2 ; 1,0,-1];
    vertical_filter = horizontal_filter'; % they are the transposed of one another.
    % disp("calculating differential");
    vertical_differential = ImageFilter(smoothed_image, vertical_filter);
    horizontal_differential = ImageFilter(smoothed_image, horizontal_filter);
    gradient_magnitude = sqrt(vertical_differential .^2 + horizontal_differential .^2);

    % now for the non maximum supression: by definition the border pixels
    % would have zero gradient, the others would be calculated as shown

    % it is assumed that the sobel filter was convolved, which changes the
    % way the axes are aligned
    img_direction = atan(vertical_differential ./ horizontal_differential);
    grad_new = gradient_magnitude;
    disp("")
    grad_new(1:end,1) = 0;
    grad_new(1:end,end) = 0;
    grad_new(end,1:end) = 0;
    grad_new(end,1:end) = 0;

    aid_filter = ones(3,3);
    aid_filter(2,2) = 0;
    
    for i = 2:size(gradient_magnitude, 1)-1
        for j = 2 : size(gradient_magnitude, 2)-1
            angle = img_direction(i,j);
            magnitude = gradient_magnitude(i,j);
            pos_delta = []; % positions for comparison
            % mx_neighbor = max(max(gradient_magnitude(i-1:i+1, j-1:j+1) .* aid_filter));
            % if magnitude <= mx_neighbor
            %     grad_new(i,j) = 0;
            % end
            if abs(angle) < pi / 8
                pos_delta = [1,0];% [0,1]; % [1,0];
            elseif abs(angle) > 3*pi/8
                pos_delta = [0,1];
            elseif angle > pi / 8
                pos_delta = [1,1];
            else
                pos_delta = [1,-1];
            end
            if magnitude <= gradient_magnitude(i + pos_delta(1), j + pos_delta(2)) || ...
                    magnitude <= gradient_magnitude(i - pos_delta(1), j - pos_delta(2))
                grad_new(i,j)=0;

            % else the value is maintained
            end
            
        end
    end
    Im = grad_new;

    % compare with edge function for debugging
end
    
                
        
        
