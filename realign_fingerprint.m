% Returns the image of the fingerprint that has been realigned
function realigned_I = realign_fingerprint(I)
    [m, n] = size(I);
    x_b = 0.5 * n;
    y_b = 0.5 * m;
    
    % Finding the x value of the TFCP
    x_r = x_b;
    for i = x_b:n   % keep going right until border of fingerprint
        if I(i,y_b) == 1    % assuming value '1' represents a fingerprint mark
            x_r = i;
        end
    end
    
    x_l = x_b;
    for i = x_b:-1:1   % keep going left until border of fingerprint
        if I(i,y_b) == 1    % assuming value '1' represents a fingerprint mark
            x_l = i;
        end
    end
    x_f = round((x_r + x_l) / 2);
    
    % Finding the y value of the TFCP
    y_l = y_b;
    for j = y_b:m   % keep going down until border of fingerprint
        if I(j,x_b) == 1    % assuming value '1' represents a fingerprint mark
            y_l = j;
        end
    end
    
    y_u = y_b;
    for j = y_b:-1:1   % keep going up until border of fingerprint
        if I(j,x_b) == 1    % assuming value '1' represents a fingerprint mark
            y_u = j;
        end
    end
    
    y_f = round((y_u + y_l) / 2);
    
    figure; imshow(I, []);
    axis on; hold on;
    plot(x_f, y_f, 'r+', 'MarkerSize', 30, 'LineWidth', 2);
    
    % Determining the alignment direction
    x_u = x_f;
    for i = x_f: n  % getting upper right edge
        if I(y_u, i) == 1
            x_u = i;
        end
    end
    C1 = x_u - x_f;
    
    plot(x_u, y_u, 'r+', 'MarkerSize', 30, 'LineWidth', 2);
    
    x_u = x_f;
    for i = x_f: -1: 1  % getting upper left edge
        if I(y_u, i) == 1
            x_u = i;
        end
    end
    C2 = x_f - x_u;
    plot(x_u, y_u, 'r+', 'MarkerSize', 30, 'LineWidth', 2);
        
    if C1 < C2
        D = "clockwise";
    elseif C2 < C1
        D = "anti-clockwise";
    else
        D = "upright";
    end
    
    % Finding realignment angle
    if D ~= "upright"
        C4 = y_f - y_u;
        C3 = C1;
        
        plot(x_f, y_f - C4, 'r+', 'MarkerSize', 30, 'LineWidth', 2);
        plot(x_f +C2 +C3, y_f - C4, 'r+', 'MarkerSize', 30, 'LineWidth', 2);
    
        Q = atand((C2 + C3) / C4);
        
        if D == "clockwise"
            %J = imrotate(I, -Q);
            J = rotateAround(I,y_f, x_f, -Q);
        else  % D == anti-clockwise
            %J = imrotate(I, Q);
            %figure; imshow(J, []);
            J = rotateAround(I,y_f, x_f, Q);
        end
    end
    realigned_I = J;
end