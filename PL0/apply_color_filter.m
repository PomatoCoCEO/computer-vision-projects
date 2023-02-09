function im = apply_color_filter(filter, image)
    image_channels = repmat(image, [1 1 3]);
    sz = size(image_channels);
    filt_mat = repmat(filter,[ sz(1)/2, sz(2)/2, 1]);
    im = filt_mat .* image;
end