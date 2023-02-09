function filter = filter_from_string(str)
    filter = zeros(2,2,3);
    comp = 'rgb';
    for i=1:3
        for j=1:2
            for k=1:2
                if comp(i) == str(2*(j-1)+k)
                    filter(j,k,i) = 1;
                end
            end
        end
    end
end