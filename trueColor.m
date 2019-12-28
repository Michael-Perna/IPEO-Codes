function [images] = trueColor(images)
% This function does a true color images from the B04, B03 and B02 bands

    % Loop for every date
    for t = 1:length(images)
        
      
        images(t).RGB(:,:,1) = images(t).B04;
        images(t).RGB(:,:,2) = images(t).B03;
        images(t).RGB(:,:,3) = images(t).B02;
    end

end