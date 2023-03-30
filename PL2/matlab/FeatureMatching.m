function [Match] = FeatureMatching(Dscpt1,Dscpt2,Tresh,Metric_TYPE)
%Your implementation here
    % dist = % ...;
    
    matches = [];
    dscpt1 = Dscpt1.desc;
    dscpt2 = Dscpt2.desc;
    dist = zeros(size(dscpt1, 1), size(dscpt2, 1));

    for i = 1 : size(dscpt1, 1)
        for j = 1 : size(dscpt2, 1)
            d1 = dscpt1(i,:,:);
            d2 = dscpt2(j,:,:);
            for x = 1 : size(dscpt1(i,:,:), 2)
                for y = 1 : size(dscpt1(i,:,:), 2)
                    dist(i, j) = dist(i, j) + ((dscpt1(i,y,x) - dscpt2(j,y,x)) ^ 2);
                end
            end
        end
    end
    

    for i = 1 : size(dscpt1, 1)
        best_match = -1;
        min_score = -1;
        for j = 1 : size(dscpt2, 1)
            if (dist(i, j) < min_score || min_score == -1) && dist(i, j) < Tresh
                min_score = dist(i, j);
                best_match = j;
            end
        end
        if best_match ~= -1
            matches = [matches; i best_match dist(i, best_match)];
        end
    end

    %{
    for i = 1 : size(dscpt1, 1)
        for j = 1 : size(dscpt2, 1)
            dist(i,j) = sum((dscpt1(i) - dscpt2(j)) .^ 2, 1:ndims(dscpt1(i)));
        end
        if strcmp(Metric_TYPE,'SSD')
            [D,I] = min(dist(i,:));
            if D < Tresh 
                matches = [matches; i I D];
            end 
        elseif strcmp(Metric_TYPE, 'RATIO')
            [D,I] = mink(dist(i,:), 2);
            ratio = D(1) / D(2);
            if ratio < Tresh
                matches = [matches; i I(1) D(1)];
            end
        else
            throw(MException('Function:InvalidArgument',"Only SSD and RATIO Metric_TYPE allowed"));
    end
    % now ensuring one to one mapping
    
    mapping_array = - ones(size(dscpt2, 1), 1); % all to -1
    size(matches)
    for i = 1 : size(matches, 1)
        el2 = matches(i, 2);
        if mapping_array(el2) == -1 % there is no match, assign it
            mapping_array(el2) = i;
        else
            if matches(mapping_array(el2), 3) < matches(i, 3)
                mapping_array(el2) = i;
            end
        end
    end
    matches = matches(mapping_array(mapping_array ~= -1), :);
    %}
    Match = matches;
end
        
        