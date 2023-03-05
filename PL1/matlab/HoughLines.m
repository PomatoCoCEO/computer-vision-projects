function [rhos, thetas] = HoughLines(H, nLines)
%Your implemention here
    % firstly for the non maximum supression
    H_copy= H;
    aid_filter = ones(3,3);
    aid_filter(2,2) = 0; % this is a 3-by-3 filter with a 0 in the middle to suppress the element itself.
    for i = 2:size(H,1)-1
        for j = 2:size(H,2)-1
            interest_region = H(i-1:i+1, j-1:j+1) .* aid_filter;
            if H(i,j) <= max(interest_region, [], [1,2])
                H_copy(i,j) = 0;
            end
        end
    end

    % we can use maxk with indices to help
    [~,I] = maxk(H_copy(:), nLines);
    % no_cols = size(H_copy, 2);
    no_lines = size(H_copy,1);
    rhos = mod(I, no_lines);
    thetas = floor(I / no_lines) +1;
end
        