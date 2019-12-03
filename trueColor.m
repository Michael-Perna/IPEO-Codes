function [true_color] = trueColor(bands)
% This function does a true color images from the B04, B03 and B02 bands

    % Loop for every date
    for t = 1:length(bands)
        
        true_color(t).date = bands(t).date;
        
        true_color(t).RGB(:,:,1) = bands(t).B04;
        true_color(t).RGB(:,:,2) = bands(t).B03;
        true_color(t).RGB(:,:,3) = bands(t).B02;
    end

end