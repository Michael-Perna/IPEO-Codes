function morphoAnalysis()

    % Loop for every date
    for t = 1:length(bands)
        SE = strel('disk',5); % 'diamond' 'square'

        % Performing Erosion
        Im_e = imerode(Im,SE);
        % Performing Dilation
        Im_d = imdilate(Im,SE);
        
    end

end 