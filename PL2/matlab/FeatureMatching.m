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

    if strcmp(Metric_TYPE,'SSD')
        disp('SSD test')
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
    
    elseif strcmp(Metric_TYPE,'RATIO')
        disp('RATIO test')
        for i = 1 : size(dscpt1, 1)
            best_matches = [-1 -1];
            best_scores = [-1 -1];
            for j = 1 : size(dscpt2, 1)
                if (dist(i, j) < best_scores(1) || best_scores(1) == -1)
                    best_scores(1) = dist(i, j);
                    best_matches(1) = j;
                elseif (dist(i, j) < best_scores(2) || best_scores(2) == -1)
                    best_scores(2) = dist(i, j);
                    best_matches(2) = j;
                end
            end
            if (best_scores(1) / best_scores(2) < Tresh) && (best_scores(1) ~= -1) && (best_scores(2) ~= -1)
                matches = [matches; i best_matches(1) dist(i, best_matches(1))];
            end
        end        

    end

    Match = matches;
end
        
        