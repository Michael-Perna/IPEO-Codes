function [] = morphoAnalysis(bands, REFMAT, coord)

    % Extraction of all field names 
    fn = fieldnames(bands); 

    % Preallocation of memory

    % Loop for every "time"
    for t = 1:length(bands) 
        % Loop for bands (the first field is the date)
        for b = 2:numel(fn)  

            SE = strel('disk',5); % 'diamond' 'square'

            % Performing Erosion
            erosion(t).(fn{b}) = imerode(bands(t).(fn{b}),SE);
            % Performing Dilation
            dilation(t).(fn{b}) = imdilate(bands(t).(fn{b}),SE);

            % Performing Opening
            opening(t).(fn{b}) = imopen(bands(t).(fn{b}),SE);
            % Performing Closing
            closing(t).(fn{b}) = imclose(bands(t).(fn{b}),SE);

        end

    end 
    
    % =====================================================================
    %   Plot of different graphic
    % =====================================================================
    % Loop for every "time"
    for t = 1:length(bands) 
        % Loop for bands (the first field is the date)
        for b = 2:numel(fn) 
            figure
            H = mapshow(erosion(t).(fn{b}), REFMAT(t).(fn{b}));
            ax = get(H, 'Parent');
            set(ax, 'XLim', coord.ZoomPalm(1,:), 'YLim', coord.ZoomPalm(2,:))
            xlabel('easting [m]')
            ylabel('northing [m]')
            title(['Morphological erosion', fn{b}]);
        
        end
    end
    
end

