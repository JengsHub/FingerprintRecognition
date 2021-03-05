function [feature_coordinates,feature_type] = coordinate_type_extraction(CN_table)
    feature_coordinates = [];
    feature_type = [];
    count = 1;
    type_count = 1;

    [y,x] = size(CN_table);
    for j=1: x
        for i=1: y
            if (CN_table(i,j) == 1)
                feature_coordinates(count) = j;
                feature_coordinates(count+1) = i;
                feature_type(type_count) = 1;
                type_count = type_count +1;
                count = count + 2;
            elseif (CN_table(i,j) == 3)
                feature_coordinates(count) = j;
                feature_coordinates(count+1) = i;
                feature_type(type_count) = 3;
                type_count = type_count +1;
                count = count + 2;
            elseif (CN_table(i,j) == 4)
                feature_coordinates(count) = j;
                feature_coordinates(count+1) = i;
                feature_type(type_count) = 4;
                type_count = type_count +1;
                count = count + 2;
            end
        end
    end
end

