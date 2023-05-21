function depthM = computeDepth(dispM, K1, K2, R1, R2, t1, t2, bits)
% computeDepth creates a depth map from a disparity map (DISPM).
    c1 = - (K1 * R1)\K1 * t1;
    c2 = - (K2 * R2)\K2 * t2;
    % baseline is the distance between optical centers
    b = norm(c1-c2);
    f = K1(1,1);
    depthM = (f*b)./dispM;
    depthM(dispM==0) = 0;
    precision = 2 ^ bits - 1;
    max_val = max(max(depthM));
    sampled_image = depthM / max_val * precision;
    sampled_image = floor(sampled_image);
    depthM = sampled_image;