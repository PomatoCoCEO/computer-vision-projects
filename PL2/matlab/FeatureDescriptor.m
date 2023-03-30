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
            Descriptors(i,:,:) = normalize(Img(y-offset:y+offset, (x-offset): (x + offset)));
        end
    elseif strcmp(Dscpt_type, 'S-MOPS')
        rot_matrix = @(angle) [cos(angle) -sin(angle) 0; sin(angle) cos(angle) 0; 0 0 1];
        disp('Going through S-MOPS...');
        disp(size(Pts.coordinates))
        coords = Pts.coordinates;
        scales = Pts.scale;
        orient = Pts.orientation;
        feature_size = 8;
        Descriptors = zeros(size(coords, 1), feature_size, feature_size);
        disp(size(Descriptors))
        for i = 1 : size(coords,1)
            x = coords(i,2);
            y = coords(i,1);
            scale = scales(i);
            patch_size = max(9,Patch_size(scale));
            lim_inf = floor((patch_size-1)/2);
            lim_sup = floor((patch_size)/2);
            orientation = orient(i);
            offset_inf = floor((patch_size-1) / 2);
            offset_sup = floor((patch_size) / 2);
            region = Img(y-offset_inf: y + offset_sup, x-offset_inf: x+offset_sup);
            % transform = rigidtform2d(orientation * 180 / pi, [0 0]);
            transform = affine2d(rot_matrix(-orientation));
            disp(size(region));
            im_transformed= imwarp(region, transform);
            center_rot = floor(size(im_transformed,1) / 2);
            disp([center_rot lim_inf lim_sup])
            feature_extract = im_transformed((center_rot - lim_inf):(center_rot + lim_sup),(center_rot - lim_inf):(center_rot + lim_sup));
           
            factor = feature_size / size(feature_extract, 1);
            
            im_resized = imresize(feature_extract, factor);
            

            Descriptors(i, :,:) = normalize(im_resized);            
        end
    end
    temp.desc = Descriptors;
    temp.coordinates = Pts.coordinates;
    temp.scale = Pts.scale;
    temp.orientation = Pts.orientation;
    Descriptors = temp;
end
        
        