function img = doNDMI(bands, img)

% This function perform and NDMI for each date in stored in bands

    % Loop for every date
    for t = 1:length(bands)
               
        % NDMI formula
        img(t).NDMI = ...
            (bands(t).B08 - bands(t).B011 + eps)./...
            (bands(t).B08 + bands(t).B011 + eps)    ;
    end

end