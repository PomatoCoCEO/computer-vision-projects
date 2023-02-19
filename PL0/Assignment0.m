% reading the image
image_raw = imread("data/banana_slug.tiff");
% size of the image:
disp(size(image_raw)); % 2856 lines, 4290 columns
disp(class(image_raw)); % uint16

image_raw_db = double(image_raw);

image_raw_db = max(2047, min(image_raw_db, 15000));
image_raw_db = (image_raw_db - 2047) / (15000 - 2047);

filter_strings = {'rgbr', 'rggb', 'bggr', 'gbrg'};
factor = 8;
for i = 1 : numel(filter_strings)
    filter = filter_from_string(filter_strings{i});
    new_image = apply_color_filter(filter, image_raw_db) * 8;
    figure(1)
    subplot(2,2,i)
    imshow(new_image)
    mos = mosaicise(new_image, 'gray');
    figure(2);
    subplot(2,2,i);
    imshow(mos);
end


