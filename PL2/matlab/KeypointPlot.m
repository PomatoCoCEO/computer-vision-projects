function KeypointPlot(Img)
    sigma = [5,13,21,35,57,91];
    for j = 1 : size(sigma,2)
        filter_size = ceil(sigma(j));
        offset = floor(filter_size / 2);
        log_kernel = fspecial('log', sigma(j), filter_size);
        filtered = ImageFilter(Img, log_kernel);
        min_interval = min(filtered,[], [1,2]);
        max_interval = max(filtered,[], [1,2]);
        % hue
        filtered_color =  2/3 * (1-exp(-3*((filtered - min_interval) / (max_interval - min_interval))));
        % saturation
        saturation_value = 0.5 * ones(size(filtered_color));
        % value
        value = 0.5 * Img / max(max(Img)) + 0.25;
        hsv_image = cat(3, filtered_color, saturation_value, value);
        colors = hsv2rgb(hsv_image);
        subplot(2,3,j);
        imshow(colors); 
    end
end