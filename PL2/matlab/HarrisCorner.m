function [pts] = HarrisCorner(img0,thresh,sigma_d,sigma_i,NMS_size)
%Your implemention
    gauss_size =  2 * ceil(3 * sigma_d) + 1; % according to the specification provided in the statement of the first project
    gauss_filter = fspecial('gaussian', gauss_size, sigma_d);
    hor_filter = [-1 0 1];
    gauss_der_hor = ImageFilter(gauss_filter, hor_filter);
    hor_derivative = ImageFilter(img0, gauss_der_hor);
    gauss_dev_vert = ImageFilter(gauss_filter, hor_filter');
    vert_derivative = ImageFilter(img0, gauss_dev_vert);
    Ix2 = hor_derivative .^ 2;
    Iy2 = vert_derivative .^ 2;
    Ixy = hor_derivative .* vert_derivative;

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
    padded_c = padarray(c_matrix, [floor(size_neighborhood/2) floor(size_neighborhood/2)], 0, 'both');
    half_size = floor(size_neighborhood/2);
    aid_filter = ones(size_neighborhood);
    aid_filter(floor(size_neighborhood/2)+1, floor(size_neighborhood/2) +1) = 0;
    offset = floor(size_neighborhood/2) - floor(window_size/2);
    for i = 4 : size(padded_c, 1) - 3
        for j = 4 : size(padded_c, 2)-3
            if padded_c(i,j) > c_threshold && padded_c(i,j) > max(max(padded_c(i-half_size:i+half_size, j-half_size:j+half_size) .* aid_filter))
                pts = [pts; [i - offset,j - offset]];
            end
        end
    end
end
