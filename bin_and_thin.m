function [resultantImg] = bin_and_thin(image)
    % Will take an unbinarized input image and execute the following:
    % 1) Binarize the input image, according to the max and min weightage 
    %    of input image
    % 2) Perform a bwmorph thin to thin the ridges to a width of 1 pixel 
    %    wide
    % 3) Perform a bwmorph spur to try and remove spurs from image.
    % Will return the result of the 4 steps processed onto the input image
    
    % This is to find the adaptive threshold of the input image as the
    % weightage of input image is in 1s and 2s. A sensitivity of 0.5 is
    % currently specified, but this can be modified to suit the program.
    multi = adaptthresh(image, 0.5);
    % binarize image according to threshold found
    binarizedImage = imbinarize(image, multi);
  
    % Thinning performed onto image. Inf is specified to ensure that the
    % binarized image is thinned until no longer possible.
    thinned = bwmorph(~binarizedImage, 'thin', Inf);
    
    resultantImg = bwmorph(thinned, 'spur', 0);
    resultantImg = ~resultantImg;
end

