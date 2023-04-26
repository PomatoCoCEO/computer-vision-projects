function [pts] = HarrisCorner(img0,thresh,sigma_d,sigma_i,NMS_size)
%Your implemention
    gauss_size =  2 * ceil(3 * sigma_d) + 1; % according to the specification provided in the statement of the first project
    gauss_filter = fspecial('gaussian', gauss_size, sigma_d);
    [gauss_der_hor, gauss_der_vert] = gradient(gauss_filter); % ImageFilter(gauss_filter, hor_filter);
    hor_derivative = ImageFilter(img0, gauss_der_hor);
    vert_derivative = ImageFilter(img0, gauss_der_vert);
    max(max(vert_derivative))
    Ix2 = hor_derivative .^ 2;
    Iy2 = vert_derivative .^ 2;
    Ixy = hor_derivative .* vert_derivative;
    % fprintf('IX2 sum: %f', sum(sum(Ix2)))

    window_size = 2*ceil(3*sigma_i) + 1;
    window = fspecial('gaussian', window_size, sigma_i);

    harris_matrix = zeros(size(img0,1)-window_size+1, size(img0,2)-window_size+1, 2,2);
    c_matrix = zeros(size(img0,1)-window_size+1, size(img0,2)-window_size+1);
    disp(size(c_matrix))
    pts = [];
    for i = 1 : size(harris_matrix, 1)
        for j = 1 : size(harris_matrix, 2)
            harris_matrix(i,j,1,1) = sum(sum(Ix2(i:i+window_size-1, j:j+window_size-1) .* window));
            harris_matrix(i,j,1,2) = sum(sum(Ixy(i:i+window_size-1, j:j+window_size-1) .* window));
            harris_matrix(i,j,2,1) = harris_matrix(i,j,1,2);
            harris_matrix(i,j,2,2) = sum(sum(Iy2(i:i+window_size-1, j:j+window_size-1) .* window));
            s = reshape(harris_matrix(i,j,:,:),[2,2]); % two by two matrix
            c_matrix(i,j) = det(s) - 0.1 * (trace(s))^2;
        end
    end
    
    c_threshold = max(max(c_matrix)) * thresh;

    size_neighborhood = NMS_size;
    half_size_sup = floor((size_neighborhood)/2);
    half_size_inf = floor((size_neighborhood-1)/2);
    padded_c = padarray(c_matrix, [half_size_inf half_size_sup], 0, 'both');
    
    aid_filter = ones(size_neighborhood);
    % aid_filter(half_size_inf, half_size_inf) = 0
    offset = half_size_inf - floor(window_size/2);
    for i = half_size_inf : size(padded_c, 1) - half_size_sup
        for j = half_size_inf : size(padded_c, 2)-half_size_sup
            if padded_c(i,j) > c_threshold
                disp(padded_c(i,j))
                if padded_c(i,j) >= max(padded_c(i-half_size_inf:i+half_size_sup, j-half_size_inf:j+half_size_sup) .* aid_filter,[], [1 2])
                    pts = [pts; [i - offset,j - offset]];
                end
            end
        end
    end
end
