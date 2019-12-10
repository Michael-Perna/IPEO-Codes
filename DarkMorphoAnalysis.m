function [dilation, closing] = DarkMorphoAnalysis(bands)

    % Extraction of all field names 
    fn = fieldnames(bands); 

    % Preallocation of memory

    % Loop for every "time"
    for t = 1:length(bands) 
        % Loop for bands (the first field is the date)
        dilation(t).(fn{1}) = bands(t).(fn{1});
        closing(t).(fn{1}) = bands(t).(fn{1});

        for b = 2:numel(fn)  

            SE = strel('diamond',2); % 'diamond' 'square'

            % Performing Erosion
            % erosion(t).(fn{b}) = imerode(bands(t).(fn{b}),SE);
            % Performing Dilation
            dilation(t).(fn{b}) = imdilate(bands(t).(fn{b}),SE);

            % Performing Opening
            % opening(t).(fn{b}) = imopen(bands(t).(fn{b}),SE);
            % Performing Closing
            closing(t).(fn{b}) = imclose(bands(t).(fn{b}),SE);

        end

    end 
    

    
end

