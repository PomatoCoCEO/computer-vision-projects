function [Descriptors] = FeatureDescriptor(Img,Pts,Dscpt_type,Patch_size)
%Your implementation here
    if strcmp(Dscpt_type,'Simple')
        % get a 5 by 5 window for each feature
        coords = Pts.coordinates;
        size_window = 5;
        offset = floor(size_window / 2);
        Descriptors = zeros(size(coords, 1), size_window, size_window);
        for i = 1 : size(coords, 1)
            x = coords(i,2);
            y = coords(i,1);
            Descriptors(i,:,:) = Img(y-offset:y+offset, x-offset, x + offset);
        end
    elseif strcmp(Dscpt_type, 'S-MOPS')
        coords = Pts.coordinates;
        scales = Pts.scale;
        orient = Pts.orientation;
        feature_size = 8;
        Descriptors = zeros(size(coords, 1), feature_size, feature_size);
        for i = 1 : size(coords,1)
            x = coords(i,2);
            y = coords(i,1);
            scale = scales(i);
            patch_size = Patch_size(scale);
            orientation = orient(i);
            offset = floor(patch_size / 2);
            region = Im(y-offset: y + offset, x-offset, x+offset);
            transform = rigidtform2d(-orientation * 180 / pi, [0 0]);
            im_transformed= imwarp(region, transform);
            factor = feature_size / patch_size;
            im_resized = imresize(im_transformed, factor);
            Descriptors(i, :,:) = im_resized;            
        end
    end
    temp.desc = Descriptors;
    temp.coordinates = Pts.coordinates;
    temp.scale = Pts.scale;
    temp.orientation = Pts.orientation;
    Descriptors = temp;
end
        
        