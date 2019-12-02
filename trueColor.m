function [true_color] = trueColor(bands)


    for img = 1:length(bands)
        
        true_color(img).date = bands(img).date;
        
        true_color(img).RGB(:,:,1) = bands(img).B04;
        true_color(img).RGB(:,:,2) = bands(img).B03;
        true_color(img).RGB(:,:,3) = bands(img).B02;
    end

end