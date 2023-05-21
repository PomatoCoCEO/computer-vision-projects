function dispM = computeDisparity(im1, im2, maxDisp, windowSize,criterion)
% computeDisparity creates a disparity map from a pair of rectified images im1 and
%   im2, given the maximum disparity MAXDISP and the window size WINDOWSIZE.
    sz = floor(windowSize / 2);
    pd1 = padarray(im1, [sz sz] , 'replicate','both');
    pd2 = padarray(im2, [sz sz] , 'replicate','both');
    dispM = zeros(size(im1));
    for y = 1 : height(im1)
        for x = maxDisp+1:width(im1)
            opt = 0;
            opt_dist = inf;
            w1 = pd1(y:y+windowSize-1, x:x+windowSize-1);
            for k = 0 : maxDisp
                w2 = pd2(y:y+windowSize-1, x-k:x-k+windowSize-1);
                curr_dist = dist_window(w1,w2,criterion);
                if curr_dist < opt_dist
                    opt_dist = curr_dist;
                    opt = k;
                end
            end
            dispM(y,x)=opt;
        end
    end
end

function dist = dist_window(w1, w2, criterion)
    if strcmp(criterion,'ssd')
        dist = sum((w1 - w2).^2,[1 2]);
    elseif strcmp(criterion,'ncc')
        dist = 1-normxcorr2(w1,w2);
    else
        error("Only 'ssd' and 'nnc' criteria acceptable");
    end
end