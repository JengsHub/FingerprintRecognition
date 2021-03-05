function [score, best_image] = match(feature_coords, feature_types)
    fileID = fopen('Compiled Data.txt', 'r');
    
    dist_thresh = 15;
    angle_thresh = 45;
    
    score = 0;
    best_image = "";
    
    line_placeholder = 'a';
    file_line_count = 1;
    
    while ischar(line_placeholder)
       if (mod(file_line_count, 4) ==0)
          line_placeholder = fgetl(fileID);
          file_line_count = file_line_count + 1;
          
          matches = 0;
          previous_coordinates =  split(previous_coordinates, ',');
          corresponding_feature_type = split(corresponding_feature_type, ',');
          previous_coordinates = str2double(previous_coordinates);
          corresponding_feature_type = str2double(corresponding_feature_type);
          
          for i=1: 2: length(feature_coords)
              x_input = feature_coords(i);
              y_input = feature_coords(i+1);
              found = 0; 
              j = 1;
              while (found==0) && j <= length(previous_coordinates)
                  % Only try to match when they have similar features
                  if (feature_types((i+1)/2) == corresponding_feature_type((j+1)/2))
                      x_data = previous_coordinates(j);
                      y_data = previous_coordinates(j+1);
                      
                      % Euclidean distance
                      dist = sqrt((x_input -x_data)^2 + (y_input - y_data)^2);
                      angle = atan2d(y_input-y_data, x_input - x_data);
                      angle = min(angle, angle+360);
                      
                      if (dist < dist_thresh) && (angle < angle_thresh)
                          matches = matches + 1;
                          found = 1;
                      end
                  end
                  j = j + 2;
              end
          end
          
          current_score = sqrt(matches^2/(length(feature_types)* length(corresponding_feature_type)));
          if current_score > score
             score = current_score;
             best_image = image_name;
          end
          
       elseif (mod(file_line_count,4) == 1)
           image_name = fgetl(fileID);
           line_placeholder = image_name;
           file_line_count = file_line_count + 1;
       elseif (mod(file_line_count,4) == 2)
           previous_coordinates = fgetl(fileID);
           line_placeholder = previous_coordinates;
           file_line_count = file_line_count + 1;
       elseif (mod(file_line_count,4) == 3)
           corresponding_feature_type = fgetl(fileID);
           line_placeholder = corresponding_feature_type;
           file_line_count = file_line_count + 1;
       end
       
    end
    
end

