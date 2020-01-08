function images = imagesCut(images, limits)

fn = fieldnames(images); 

    
%=========================================================================
%% cut images
%=========================================================================

    % Loop for every no-reference images
    for t = 1:length(images) 
        % Loop for every no-reference 
        for b = 2:numel(fn)  
            img = images(t).(fn{b});
            images(t).(fn{b}) = img(limits.x(1):limits.x(2),limits.y(1):limits.y(2));    
                        
        end 
    end
end