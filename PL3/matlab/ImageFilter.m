function [img1] = ImageFilter(img0, h)
    
    [U,S,V] = svd(h);
    no_lines_filter = size(h,1);
    no_columns_filter = size(h,2);
    height = size(img0, 1);
    width = size(img0, 2);

    img_padded = padarray(img0, [(no_lines_filter - 1)/2, (no_columns_filter -1)/2], 'replicate', 'both');
    % it appears we can use the conv function
    
    filtered_image = zeros(height,width);
    
    if min(min(size(S))) >= 2 && abs(S(1,1)) > 1e-9 && abs(S(2,2)) < 1e-9
        % perform the convolution using two filters
        filtered_image_1 = zeros(height,size(img_padded, 2));
        
        vertical_kernel = sqrt(S(1,1)) * U(1:end,1); % second filter - column
        upside_down_vertical = vertical_kernel(end:-1:1);
        for i = 1:height
            for j = 1:size(img_padded,2)
                for k = 1:no_lines_filter
                    filtered_image_1(i,j) = filtered_image_1(i,j) + img_padded(i+k-1,j) * upside_down_vertical(k);
                    % faster than built-in element-wise multiplication
                end
                % filtered_image_1(i,j) = sum(upside_down_vertical .* img_padded(i:i+no_lines_filter-1, j));
            end
        end
        
        horizontal_kernel = sqrt(S(1,1)) * V(1:end,1)'; % first filter - line
        upside_down_horizontal = horizontal_kernel(1, end:-1:1);
        for i = 1:height
            for j = 1:width
                for k = 1:no_columns_filter
                    filtered_image(i,j) = filtered_image(i,j) + filtered_image_1(i,j+k-1) * upside_down_horizontal(k);
                    % faster than built-in element-wise multiplication
                end
                % filtered_image(i,j) = sum(upside_down_horizontal .* filtered_image_1(i, j:j+no_columns_filter-1));
            end
        end
        
    else
    
        upside_down = h(end:-1:1, end:-1:1); % if we reverse the matrix a convolution becomes a correlation, easy to represent in MATLAB
        for i =1 :height
            for j = 1:width
                for k = 1:no_lines_filter
                    for m = 1:no_columns_filter
                        filtered_image(i,j) = filtered_image(i,j) + upside_down(k,m) * img_padded(i+k-1,j+m-1);
                        % faster than built-in element-wise multiplication
                    end
                end
                % filtered_image(i,j) = sum(upside_down .* img_padded(i:i+no_lines_filter-1, j:j+no_columns_filter-1), [1,2] );
            end
        end
        % perform the convolution using the filter itself
    end
    img1 = filtered_image;
end
