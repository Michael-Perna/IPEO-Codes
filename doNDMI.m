function images = doNDMI(images)

% This function perform and NDMI for each date in stored in bands

    % Loop for every date
    for t = 1:length(images)
               
        % NDMI formula
        images(t).NDMI = ...
            (images(t).B08 - images(t).B11 + eps)./...
            (images(t).B08 + images(t).B11 + eps)    ;
    end

end