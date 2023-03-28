function [Match] = FeatureMatching(Dscpt1,Dscpt2,Tresh,Metric_TYPE)
%Your implementation here
    % dist = % ...;
    matches = [];
    dscpt1 = Dscpt1.desc;
    dscpt2 = Dscpt2.desc;
    for i = 1 : size(dscpt1, 1)
        dist = zeros(1, size(dscpt2, 1));
        for j = 1 : size(dscpt2, 1)
            dist(j) = sum((dscpt1(i) - dscpt2(j)) .^ 2, 1:ndims(dscpt1(i)));
        end
        if strcmp(Metric_TYPE,'SSD')
            [D,I] = min(dist);

            matches = [matches; i I D];
        elseif strcmp(Metric_TYPE, 'RATIO')
            [D,I] = mink(dist, 2);
            ratio = D(1) / D(2);
            if ratio < Tresh
                matches = [matches; i I(1) D(1)];
            end
        else
            throw(MException('Function:InvalidArgument',"Only SSD and RATIO Metric_TYPE allowed"));

    end
    Match = matches;
    disp("size of match")
    size(Match)
end
        
        