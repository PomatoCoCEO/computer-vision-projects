function [Pts] = KeypointsDetection(Img,Pts)
%Your implemention here
    % orientation
    gradient_filter = fspecial('sobel');
    filter = fspecial('gaussian',13, 2);
    im_filtered = ImageFilter(Img, filter);
    % im_gradient_x = ImageFilter(Img, gradient_filter);
    % im_gradient_y = ImageFilter(Img, gradient_filter);
    orientation = zeros(size(Pts, 1), 1);
    for i = 1 : size(Pts, 1)
        y = Pts(i,1);
        x = Pts(i,2);

        % the gradient filter is symmetric so we can use element-wise multiplication
        Iy = sum(im_filtered(y-1:y+1, x-1:x+1).* gradient_filter, [1 2]);
        Ix = sum(im_filtered(y-1:y+1, x-1:x+1).* gradient_filter', [1 2]);
        % calculate the orientation
        orientation(i) = atan2(Iy, Ix);
    end

    % scale
    sigma = [3,5,8,13,21,35,57,91]; % approximately fibonacci-like

    patch_size = @(sz) ceil(sz * 2 * sqrt(sz));

    best_sigmas = zeros(size(Pts, 1), 1);

    for i = 1 : size(Pts,1)
        max_act = -inf;
        best_sigma = -1;
        y = Pts(i,1);
        x = Pts(i,2);
        for j = 1 : size(sigma,2)
            filter_size = ceil(patch_size(sigma(j)));
            offset_inf = floor((filter_size-1) / 2);
            offset_sup = floor(filter_size/2);
            log_kernel = patch_size(sigma(j))^2 * fspecial('log', patch_size(sigma(j)), filter_size);

            % the log filter is symmetric, so element wise multiplication can be used
            try
                activation = sum(Img(y-offset_inf:y+offset_sup, x-offset_inf:x+offset_sup) .* log_kernel, [1,2]);
                if activation > max_act
                    max_act = activation;
                    best_sigma = sigma(j);
                end
            end
        end
        best_sigmas(i) = best_sigma;
    end
    temp.coordinates = Pts;
    temp.orientation = orientation;
    temp.scale = best_sigmas;
    disp(temp.scale);
    Pts = temp;
end
        