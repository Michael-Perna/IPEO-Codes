function images =  enhancement(images)

    % Extraction of all field names 
    fn = fieldnames(images); 

    % Loop for every "time"
for t = 1:length(images) 
    % Loop for bands (the first field is the date)

    for b = 2:numel(fn)  
        %==================================================================
        % use of imadjust()
        %==================================================================
%         % Use stretchlim and imadjust Display the image rescaled to the
%         % lower 1% and upper 99% CDF limits.
            images(t).(fn{b}) = imadjust(images(t).(fn{b}), ...
                     stretchlim(images(t).(fn{b}), 0.01), [0,1]); 
        
        %==================================================================
        % Histogram equalization
        %==================================================================
%         images(t).(fn{b}) = histeq(images(t).(fn{b}));
    end

end 
%=========================================================================
%% Remotion of the black borders
%=========================================================================

fn = fieldnames(images); 

% Loop for every no-reference images
for t = 1:length(images) 
    % Loop for every no-reference 
    for b = 2:numel(fn) 
        show = 0;
        images(t).(fn{b}) = remove_borders(images(t).(fn{b}), show);
    end
end
end