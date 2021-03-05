function minutiae = extract_minutiae(fingerprint)
    [m, n] = size(fingerprint);
    minutiae = zeros(m, n);
    
    for i = 2:m-1
        for j = 2:n-1
            if (fingerprint(i,j)==1)
                continue;
            end
            CN = 0;
            CN = CN + abs(fingerprint(i, j+1) - fingerprint(i-1, j+1));  %P1 - P2
            CN = CN + abs(fingerprint(i-1, j+1) - fingerprint(i-1, j));  %P2 - P3
            CN = CN + abs(fingerprint(i-1, j) - fingerprint(i-1, j-1));  %P3 - P4
            CN = CN + abs(fingerprint(i-1, j-1) - fingerprint(i, j-1));  %P4 - P5
            CN = CN + abs(fingerprint(i, j-1) - fingerprint(i+1, j-1));  %P5 - P6
            CN = CN + abs(fingerprint(i+1, j-1) - fingerprint(i+1, j));  %P6 - P7
            CN = CN + abs(fingerprint(i+1, j) - fingerprint(i+1, j+1));  %P7 - P8
            CN = CN + abs(fingerprint(i+1, j+1) - fingerprint(i, j+1));  %P8 - P1
            CN = CN*0.5;
            
            minutiae(i,j) = CN;
        end
    end
    
end
