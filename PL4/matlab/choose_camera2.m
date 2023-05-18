function [c2] = choose_camera2(cam2, P1, K2, pts1, pts2)
    c2 = [];

    for i = 1 : 4
        cam = K2 * cam2(:,:,i);
        pts3d = triangulation3D(P1, pts1, cam, pts2);
        coord_zs = sum(pts3d(:,3) > 0);
        fprintf("coord_zs: %d vs %d\n",coord_zs,size(pts3d,1) );
        if coord_zs == size(pts3d,1)
            c2 = cam;
        end
    end
end