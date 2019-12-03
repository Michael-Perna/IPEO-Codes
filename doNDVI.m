function img = doNDVI(bands, img)

% This function perform and NDVI for each date in stored in bands

    % Loop for every date
    for t = 1:length(bands)
               
        % NDVI formula
        img(t).NDVI = ...
            (bands(t).B08 - bands(t).B04 + eps)./...
            (bands(t).B08 + bands(t).B08 + eps)    ;
    end

end