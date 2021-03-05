% normalization function
function [N] = normalize(I, M0, V0)
    [m,n] = size(I);
    M = (1/(m*n))*sum(I(:));

    tmp = (I-M).^2;
    variance = (1/(m*n))*sum(tmp(:));
    
    N = zeros(m,n);
    for i=1:m
        for j=1:n
            if I(i,j)>M
                N(i,j) = M0 + sqrt((V0*(I(i,j)-M)^2)/variance);
            else
                N(i,j) = M0 - sqrt((V0*(I(i,j)-M)^2)/variance);
            end
        end
    end
end