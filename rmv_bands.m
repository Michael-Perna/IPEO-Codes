function images = rmv_bands(images, bands)

    
%=========================================================================
%% remove specific Bands
%=========================================================================


    % Loop for every no-reference 
    for b = 1:numel(bands)  
        images = rmfield(images, (bands{b}));
    end 



end