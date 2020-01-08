function images = doNDVI(images)

% This function perform and NDVI for each date in stored in bands

    % Loop for every date
    for t = 1:length(images)
               
        % NDVI formula
        images(t).NDVI = ...
            (images(t).B08 - images(t).B04 + eps)./...
            (images(t).B08 + images(t).B04 + eps)    ;
    end

end