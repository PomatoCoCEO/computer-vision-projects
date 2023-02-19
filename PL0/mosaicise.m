function image_mosaic = mosaicise(image_matrix, assumption)
    if assumption == 'gray' || assumption == 'grey' % language-inclusive :)
        image_mosaic = image_matrix;
        r_avg = mean(image_mosaic(1:end,1:end,1));
        g_avg = mean(image_mosaic(1:end,1:end,2));
        b_avg = mean(image_mosaic(1:end,1:end,3));
        image_mosaic(1:end, 1:end, 1) = image_mosaic(1:end, 1:end, 1) * (g_avg / r_avg);
        image_mosaic(1:end, 1:end, 3) = image_mosaic(1:end, 1:end, 3) * (g_avg / b_avg);
    elseif assumption == 'white'
        image_mosaic = image_matrix;
        r_max = max(image_mosaic(1:end,1:end,1));
        g_max = max(image_mosaic(1:end,1:end,2));
        b_max = max(image_mosaic(1:end,1:end,3));
        image_mosaic(1:end, 1:end, 1) = image_mosaic(1:end, 1:end, 1) * (g_max / r_max);
        image_mosaic(1:end, 1:end, 3) = image_mosaic(1:end, 1:end, 3) * (g_max / b_max);
    end
end